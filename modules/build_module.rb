
module BuildModule
  extend self
  
  def run runner
    puts 'Building project...'
    
    puts "Building project..."
    if runner.config['using_pods']
      ## build workspace
      system "xcodebuild -workspace \"#{runner.config['workspace']['name']}.xcworkspace\" -scheme \"#{runner.config['workspace']['scheme']}\" -configuration \"#{runner.config['build']['configuration']}\" -sdk \"#{runner.config['build']['sdk']}\" CONFIGURATION_BUILD_DIR=\"#{runner.config['run']['build_dir']}\" clean build" or fail "Build failed"
    else
      system "xcodebuild -configuration \"#{runner.config['build']['configuration']}\" -sdk \"#{runner.config['build']['sdk']}\" -target \"#{runner.config['project']['target']}\" clean build CONFIGURATION_BUILD_DIR=\"#{runner.config['run']['build_dir']}\"" or fail "Build failed"
    end
    
    true
  end
end
