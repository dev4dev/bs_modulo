
class TestsModule < BaseModule
  config_key 'tests'
  check_enabled!
  
  def self.run config
    info 'Running tests...'
    system %Q[killall -m -KILL "iPhone Simulator"]
    parameters = []
    if config.tests.use_workspace
      parameters << "-workspace #{config.tests.workspace.name}.xcworkspace"
      parameters << "-scheme #{config.tests.workspace.scheme}"
    else
      parameters << "-target #{config.tests.target}"
    end
    parameters << "-configuration Debug"
    parameters << "-sdk iphonesimulator"
    parameters << "TEST_AFTER_BUILD=YES clean build 2>&1 | ocunit2junit"
    result = system %Q[xcodebuild #{parameters.join(' ')}]
    unless result
      fail "Unit tests failed"
    end
  end
end
