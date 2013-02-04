
module DummyModule
  extend self
  
  # required run function with config parameter
  def run config
    puts 'Dummy module...'
    
    puts config
    
    true
  end
  
end
