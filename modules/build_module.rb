
module BuildModule
  extend self
  
  def run runner
    puts 'Building project...'
    
    profile_file = real_file runner.config.profile.file
    build_profile = real_file '~/Library/MobileDevice/Provisioning Profiles/build.mobileprovision'
    FileUtils.cp profile_file, build_profile
    build_parameters = [
      %Q[-configuration "#{runner.config.build.configuration}"],
      %Q[-sdk "#{runner.config.build.sdk}"],
      %Q[CONFIGURATION_BUILD_DIR="#{runner.config.runtime.build_dir}"],
      %Q[clean],
      %Q[build]
    ]
    if runner.config.using_pods?
      ## build workspace
      build_parameters.unshift %Q[-workspace "#{runner.config.build.workspace.name}.xcworkspace"]
      build_parameters.unshift %Q[-scheme "#{runner.config.build.workspace.scheme}"]
    else
      build_parameters.unshift %Q[-project "#{runner.config.build.project.name}.xcodeproj"]
      build_parameters.unshift %Q[-target "#{runner.config.build.project.target}"]
    end
    result = system %Q[xcodebuild #{build_parameters.join(' ')}]
    rm_f build_profile
    unless result
       fail "Build failed"
    end
    
    true
  end
end
