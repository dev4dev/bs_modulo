

class XcodeModule < BaseModule
  config_key 'xcode'
  check_enabled!
  defaults :enabled => true
  
  def self.run config
    version = config.xcode.version
    version_path = sysconf.xcode[config.xcode.version]
    default_path = sysconf.xcode.def
    do_switch = version_path != default_path
    
    unless version_path
      fail "Didn't find Xcode version #{version}"
    end
    
    if do_switch
      unless File.exists? version_path
        fail "Xcode doesn't exist at #{version_path}"
      end
      info "Switching Xcode version to #{version}"
      result = system %Q{sudo xcode-select -switch #{version_path}}
      fail "Switching Xcode to version #{version} failed" unless result
    else
      info "Xcode is already at required version"
    end
    
    hook :complete, proc {
      if do_switch
        info "Switching Xcode back to default version"
        result = system %Q{sudo xcode-select -switch #{default_path}}
        fail "Switching Xcode to default version failed" unless result
      end
    }
  end
end
