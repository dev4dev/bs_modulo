
module TestsModule
  extend self
  
  def run config
    unless config.tests.run?
      puts 'skipping...'
      return true
    end
    
    puts 'Running tests...'
    
    result = system %Q[xcodebuild -target #{config.tests.target} -configuration Debug -sdk iphonesimulator clean build]
    
    unless result
      fail "Unit tests failed"
    end
    
    true
  end
end
