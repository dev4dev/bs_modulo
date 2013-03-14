
class TestsModule < BaseModule
  config_key 'tests'
  check_enabled!
  
  def self.run config
    puts 'Running tests...'
	system %Q[killall -m -KILL "iPhone Simulator"]
    result = system %Q[xcodebuild -target #{config.tests.target} -configuration Debug -sdk iphonesimulator TEST_AFTER_BUILD=YES clean build 2>&1 | ocunit2junit]
    unless result
      fail "Unit tests failed"
    end
  end
end
