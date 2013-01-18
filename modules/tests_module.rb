
module TestsModule
  extend self
  
  def run runner
    unless runner.config.tests.run?
      puts 'skipping...'
      return true
    end
    
    puts 'Running tests...'
    
    result = system %Q[xcodebuild -target #{runner.config.tests.target} -configuration Debug -sdk iphonesimulator clean build]
    
    unless result
      fail "Unit tests failed"
    end
    
    true
  end
end
