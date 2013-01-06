class Runner
  
  def initialize queue, config
    @queue = queue
    @config = config
    load_modules
    run_queue
  end
  
  def load_modules
    @modules = []
    modules_dir = File.expand_path(WORKSPACE) + '/modules/'
    for module_file in Dir.glob "#{modules_dir}/*_module.rb"
      require module_file
      module_name = File.basename(module_file, '.rb').gsub('_', ' ').ucwords.gsub(' ', '')
      @modules << module_name
    end
  end
  
  def run_queue
    @queue.each_pair do |id, module_name|
      if @modules.include? module_name
        puts %Q{\n ===> Running module #{id}...}
        eval(module_name).public_send(:run, @config)
      end
    end
  end
  
end
