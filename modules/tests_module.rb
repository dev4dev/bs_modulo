
class TestsModule < BaseModule
  config_key 'tests'
  check_enabled!
  
  def self.run config
    info 'Running tests...'
    system %Q[killall -m -KILL "iPhone Simulator"]
    
    parameters = [
      "-scheme #{config.tests.scheme}",
      "test",
      "-reporter junit:test-reports/junit-report.xml"
    ]
    if config.using_pods?
      parameters.unshift %Q[-workspace "#{config.build.workspace.name}.xcworkspace"]
    else
      parameters.unshift %Q[-project "#{config.build.project.name}.xcodeproj"]
    end
    
    result = system %Q[xctool #{parameters.join(' ')}]
    unless result
      fail "Unit tests failed"
    end
  end
end
