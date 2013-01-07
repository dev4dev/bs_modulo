
module CleanModule
  extend self
  
  def run runner
    puts "Cleaning build dir..."

    rm_rf "#{runner.config['run']['project_dir']}/build/"
    
    true
  end
end
