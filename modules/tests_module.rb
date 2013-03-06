
class TestsModule < BaseModule
  config_key 'tests'
  check_enabled!
  
  def self.run config
    puts 'Running tests...'
    result = system %Q[xcodebuild -target #{config.tests.target} -configuration Debug -sdk iphonesimulator clean build]
    unless result
      fail "Unit tests failed"
    end
  end
end
