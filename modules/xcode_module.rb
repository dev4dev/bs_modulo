

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
      switch version, version_path
    elsif default_path != current_path
      switch "default", default_path
    else
      info "Xcode is already at required version"
    end
    
    hook :complete, proc {
      if do_switch
        switch "default", default_path
      end
    }
  end
  
  private
  def self.switch name, path
    info "Switching Xcode back to #{name} version"
    result = system %Q{sudo xcode-select -switch "#{path}"}
    fail "Switching Xcode to #{name} version failed" unless result
  end
end
