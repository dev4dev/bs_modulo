
module BuildAndroidModule
  extend self
  
  def run config
    puts 'Building project...'
    
    system %Q[ant #{config.build_android.configuration}] or fail "build project"
    
    true
  end
  
end
