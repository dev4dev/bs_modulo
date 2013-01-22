
module HockeyappModule
  extend self
  
  def run runner
    unless runner.config.hockeyapp.enabled?
      puts 'skipping...'
      return true
    end
    
    url = "https://rink.hockeyapp.net/api/2/apps/#{runner.config.apphockey.app_id}/app_versions"
    
    headers = {
      "X-HockeyAppToken" => runner.config.apphockey.token
    }
    
    params = {
      # nothing for now
    }
    
    files = {
      :ipa => runner.config.runtime.ipa_file
    }
    
    if runner.config.pack_dsym.enabled?
      files << {:dsym => runner.config.runtime.dsym_file}
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
    end
    
    true
  end
  
end
