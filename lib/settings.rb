require "yaml"
require "hashr"

module Settings
  class System
    
    def self.get
      unless @sysconf
        @sysconf ||= {}
        sysconf_file = File.expand_path GLOBAL_CONFIG_FILE
        @sysconf = Hashr.new(YAML.load_file(sysconf_file)) if File.exists? sysconf_file
      end
      @sysconf
    end
    
    def self.reload
      @sysconf = nil
      self.get
    end
    
  end
end
