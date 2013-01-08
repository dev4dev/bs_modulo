
module DummyModule
  extend self
  
  # required run function with runner parameter
  def run runner
    puts 'Dummy module...'
    
    puts runner.config
    puts runner.queue
    
    true
  end
  
end
