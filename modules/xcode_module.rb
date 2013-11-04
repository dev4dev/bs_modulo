require "xcode"

class XcodeModule < BaseModule
  config_key 'xcode'
  check_enabled!
  defaults :enabled => true
  
  def self.run config
    version = config.xcode.version
    version_path = sysconf.xcode[config.xcode.version]
    default_path = sysconf.xcode.def
    current_path = `xcode-select -print-path`.chomp
    do_switch = version_path != default_path
    
    unless version_path
      fail "Didn't find Xcode version #{version}"
    end
    
    if do_switch
      unless File.exists? version_path
        fail "Xcode doesn't exist at #{version_path}"
      end
      Xcode::switch_to_version version, version_path
    elsif default_path != current_path
      Xcode::switch_to_version "default", default_path
    else
      info "Xcode is already at required version"
    end
    
    rollback = proc {
      if do_switch
        Xcode::switch_to_version "default", default_path
      end
    }
    hook :failed, rollback
    hook :complete, rollback
  end
end
