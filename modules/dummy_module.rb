
class DummyModule < BaseModule
  config_key 'dummy'
  check_enabled!
  
  # required self.run function with config parameter
  def self.run config
    puts 'Dummy module...'
    puts config
  end
end
