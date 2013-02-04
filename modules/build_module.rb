
module BuildModule
  extend self
  
  def run config
    puts 'Building project...'
    
    profile_file  = real_file config.profile.file
    build_profile = real_file '~/Library/MobileDevice/Provisioning Profiles/build.mobileprovision'
    cp profile_file, build_profile
    build_parameters = [
      %Q[-configuration "#{config.build.configuration}"],
      %Q[-sdk "#{config.build.sdk}"],
      %Q[CONFIGURATION_BUILD_DIR="#{config.runtime.build_dir}"],
      %Q[clean],
      %Q[build]
    ]
    if config.using_pods?
      ## build workspace
      build_parameters.unshift %Q[-workspace "#{config.build.workspace.name}.xcworkspace"]
      build_parameters.unshift %Q[-scheme "#{config.build.workspace.scheme}"]
    else
      build_parameters.unshift %Q[-project "#{config.build.project.name}.xcodeproj"]
      build_parameters.unshift %Q[-target "#{config.build.project.target}"]
    end
    result = system %Q[xcodebuild #{build_parameters.join(' ')}]
    rm_f build_profile
    unless result
       fail "Build failed"
    end
    
    true
  end
end
