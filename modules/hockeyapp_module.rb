
module HockeyappModule
  extend self
  
  def run runner
    unless runner.config.hockeyapp.enabled?
      puts 'skipping...'
      return true
    end
    
    url = "https://rink.hockeyapp.net/api/2/apps/#{runner.config.hockeyapp.app_id}/app_versions"
    
    headers = {
      "X-HockeyAppToken" => runner.config.hockeyapp.token
    }
    
    params = {
      :notify => runner.config.hockeyapp.notify? ? 1 : 0,
      :status => runner.config.hockeyapp.download? ? 2 : 1
    }
    
    notes = ENV['HOCKEYAPP_NOTES'] || ''
    unless notes.empty?
      params[:notes] = notes
      params[:notes_type] = 1
    end
    
    case runner.config.platform
      when 'ios'
        files = {
          :ipa => runner.config.runtime.ipa_file
        }
        
        if runner.config.pack_dsym && runner.config.pack_dsym.enabled?
          files[:dsym] = runner.config.runtime.dsym_file
        end
        
      when 'android'
        files = {
          :ipa => runner.config.runtime.apk_file
        }
    end
    
    result = post(url, params, files, headers)
    if result.code != 201
      obj = JSON.parse(result)
      errors = obj['errors']
      message = ["Errors:\n"]
      obj['errors'].each_pair do |k, v|
        message << "#{k}: #{v}"
      end
      puts message.join "\n"
      return false
    else
      puts result
    end
    
    true
  end
  
end
