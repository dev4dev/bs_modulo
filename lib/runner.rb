require "hashr"
require "hook"

class Runner
  attr_reader :queue
  attr_accessor :config
  
  def initialize params
    @queue = params[:queue] || []
    @config = Hashr.new params[:config] || {}
    @sysconf = Hashr.new params[:sysconf] || {}
    @modules_dir = params[:modules_dir] || {}
    @hooks = Hook.new
    
    prepare
    load_modules
    run_queue
  end
  
  protected
  def prepare
    @hooks.add :start, proc {
      FileUtils.mkdir_p PROJECT_DIR unless File.exists? PROJECT_DIR
      FileUtils.cd PROJECT_DIR
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
          if mod.check @config, @sysconf, @hooks
            puts " OK."
          else
            fail " Ooopss..."
          end
        rescue => ex
          fail "#{mod} exception: #{ex.message}"
        end
      else
        fail %Q{module not found "#{id} => #{module_name}"}
      end
    end
    @hooks.fire :complete, :config => @config
    puts "\n SUCCESS!"
  end
  
end
