
module BuildAndroidModule
  extend self
  
  def run runner
    puts 'Building project...'
    
    system %Q[ant #{runner.config.build_android.configuration}] or fail "Failed to build project"
    
    true
  end
  
end
