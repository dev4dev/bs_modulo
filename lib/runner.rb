class Runner
  attr_reader :queue, :config
  
  def initialize queue, config, modules_dir
    @queue = queue
    @config = config
    @modules_dir = modules_dir
    self.load_modules
    self.run_queue
  end
  
  protected
  def load_modules
    @modules = []
    for module_file in Dir.glob "#{@modules_dir}*_module.rb"
      require module_file
      module_name = File.basename(module_file, '.rb').gsub('_', ' ').ucwords.gsub(' ', '')
      @modules << module_name
    end
  end
  
  def run_queue
    @queue.each_pair do |id, module_name|
      if @modules.include? module_name
        puts %Q{\n ===> Running module #{id}...}
        begin
          if eval(module_name).public_send(:run, self)
            puts " OK."
          else
            fail " Ooopss..."
          end
        rescue => ex
          fail "ERROR: #{ex.message}"
        end
      else
        fail %Q{\n\tERROR: module not found "#{id} => #{module_name}"}
      end
    end
    puts "\n SUCCESS!"
  end
  
end
