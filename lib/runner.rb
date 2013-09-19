require "hashr"
require "hook"

module Runner
  class Runner
    attr_reader :queue
    attr_accessor :config
    attr_reader :hooks

    def initialize params
      @queue = params[:queue] || []
      @config = params[:config] || {}
      @sysconf = params[:sysconf] || {}
      @modules_dir = params[:modules_dir] || {}
      @hooks = Hook.new

      prepare
      load_modules
      run_queue
    end

    protected
    def project_dir
      @config['runtime']['project_dir']
    end
    
    def prepare
      @hooks.add :start, proc {
        FileUtils.mkdir_p project_dir unless File.exists? project_dir
        FileUtils.cd project_dir
      }
    end

    def load_modules
      @modules = []
      for module_file in Dir.glob "#{@modules_dir}*_module.rb"
        require module_file
        module_name = module_name_from_id File.basename(module_file, '.rb')
        @modules << module_name
      end
    end

    def run_queue
      @hooks.fire :start, :config => @config
      @queue.each do |id|
        module_name = module_name_from_id(id + '_module')
        if @modules.include? module_name
          begin
            mod = eval(module_name)
            puts %Q{\n ===> Running: #{mod}...}
            if mod.check self, @sysconf
              puts " OK."
            else
              fail " Ooopss..."
            end
          rescue => ex
            fail %Q{#{mod} exception: #{ex.message} \nBacktrace:\n\t#{ex.backtrace.join("\n\t")}}
          end
        else
          fail %Q{module not found "#{id} => #{module_name}"}
        end
      end
      @hooks.fire :complete, :config => @config
      puts "\n SUCCESS!"
    end
    
    def failed
      @hooks.fire :failed, :config => @config
    end
  end

  def self.run args
    require "loader.rb"
    require "android_version.rb"
    require "base_module.rb"
    require "properties.rb"

    ## check input parameters
    if ENV['CONFIGURATION']
      configuration = ENV['CONFIGURATION']
    else
      configuration = 'default'
    end

    if ENV['WORKSPACE']
      workspace = real_dir ENV['WORKSPACE']
    else
      workspace = real_dir Dir::pwd
    end

    config_file_name = unless args.empty? then File.basename args[0] else 'builder.yml' end
    config_file_path = workspace + config_file_name
    modules_dir      = BUILDER_DIR + 'modules/'

    fail "config #{config_file_name} file not found" unless File.exists? config_file_path

    queue, config = load_config config_file_path, configuration
    project_dir = real_dir(workspace + config['project_dir'])

    config['runtime'] = {
      'workspace'     => workspace,
      'project_dir'   => project_dir,
      'configuration' => configuration
    }

    platform_runtime = {}
    case config['platform']
      when 'ios', 'osx'
        if config['build']
          platform_runtime = {
            :build_dir => "#{project_dir}build/#{config['build']['configuration']}-#{config['build']['sdk']}/"
          }
        end

      when 'android'
        platform_runtime = {

        }
    end
    config['runtime'].merge! platform_runtime

    info_string = %Q{Starting build in "#{workspace}" with configuration "#{configuration}"}
    delimiter = "*" * (info_string.length + 4)
    puts delimiter
    puts "* #{info_string} *"
    puts delimiter
    
    Runner.new :queue => queue, :config => config, :sysconf => Settings::System.get, :modules_dir => modules_dir
  end

end
