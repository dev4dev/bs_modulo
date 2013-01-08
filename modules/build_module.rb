
module BuildModule
  extend self
  
  def run runner
    puts 'Building project...'
    
    if runner.config['using_pods']
      ## build workspace
      result = system "xcodebuild -workspace \"#{runner.config['workspace']['name']}.xcworkspace\" -scheme \"#{runner.config['workspace']['scheme']}\" -configuration \"#{runner.config['build']['configuration']}\" -sdk \"#{runner.config['build']['sdk']}\" CONFIGURATION_BUILD_DIR=\"#{runner.config['run']['build_dir']}\" clean build"
    else
      result = system "xcodebuild -project \"#{runner.config['project']['name']}.xcodeproj\" -configuration \"#{runner.config['build']['configuration']}\" -sdk \"#{runner.config['build']['sdk']}\" -target \"#{runner.config['project']['target']}\" clean build CONFIGURATION_BUILD_DIR=\"#{runner.config['run']['build_dir']}\""
    end
    unless result
       fail "Build failed"
    end
    
    true
  end
end
