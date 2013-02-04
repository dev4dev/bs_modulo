
module CleanModule
  extend self
  
  def run config
    puts "Cleaning build dir..."

    rm_rf "#{config.runtime.project_dir}/build/"
    
    true
  end
end
