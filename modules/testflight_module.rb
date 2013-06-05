
class TestflightModule < BaseModule
  config_key 'testflight'
  check_enabled!
  
  def self.run config
    url = "http://testflightapp.com/api/builds.json"
    params = {
      :api_token  => config.testflight.api_token,
      :team_token => config.testflight.team_token,
      :notify     => config.testflight.notify? ? 1 : 0
    }

    notes = ENV['TESTFLIGHT_NOTES'] || '<empty>'
    params[:notes] = notes

    case config.platform
      when 'ios'
        files = {
          :file => config.runtime.ipa_file
        }

        if config.pack_dsym && config.pack_dsym.enabled?
          files[:dsym] = config.runtime.dsym_file
        end

      when 'android'
        files = {
          :file => config.runtime.apk_file
        }
    end

    result = post(url, params, files)
    if result.code != 200
      obj = JSON.parse(result)
      fail obj
    else
      info result
    end
  end
end
