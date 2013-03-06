
class BaseModule
  
  class << self
    def check config_full
      ## config direct access
      config = config_full[config_key]
      
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
  end
end
