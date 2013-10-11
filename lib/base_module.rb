
class BaseModule
  
  class << self
    def check runner, sysconf
      ## hooks
      @runner = runner
      config_full = @runner.config
      ## merge defaults
      config_full[config_key] = {} if config_full[config_key].nil?
      config_full[config_key] = @defaults.merge! config_full[config_key] if defined? @defaults
      
      ## config direct access
      config = config_full[config_key]
      sysconf sysconf
      
      ## check enabled
      if check_enabled?
        unless config.enabled?
          puts 'DISABLED: skipping...'
          return true
        end
      end
      
      res = run config_full
      return res != false
    end
    
    def param key, value=nil
      @params ||= {}
      if value
        @params[key] = value
      else
        @params[key]
      end
    end
    
    def defaults value
      @defaults ||= {}
      if value.is_a? Hash
        @defaults.merge! value
      elsif value.is_a? String or value.is_a? Symbol
        return @defaults[value]
      end
    end
    
    def method_missing method, *args, &block
      if args.count > 0
        k, v = method, args.first
      else
        if method[-1] == '!'
          k, v = method[0..-2], true
        elsif method[-1] == '?'
          k, v = method[0..-2]
        else
          k, v = method
        end
      end
      return param k, v
    end
    
    ## helpers methods
    def fail message
      puts "> #{self} ERROR: #{message}"
      @runner.failed
      exit(-1)
    end
    
    def info message
      puts "> #{self}: #{message}"
    end
    
    ## hooks
    def hook name, code
      @runner.hooks.add name, code
    end
    
    def hook! name
      @runner.hooks.fire name, :config => @runner.config
    end
    
  end
end
