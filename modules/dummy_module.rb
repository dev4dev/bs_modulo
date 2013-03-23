
class DummyModule < BaseModule
  config_key 'dummy'
  defaults :enabled => false
  check_enabled!
  
  # required self.run function with config parameter
  def self.run config
    info 'Dummy module...'
    info config
    info sysconf
  end
end
