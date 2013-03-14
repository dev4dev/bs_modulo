
class BuildModule < BaseModule
  config_key 'build'
  defaults :doclean => true
  
  def self.run config
    puts 'Building project...'
    
    build_profile = real_file '~/Library/MobileDevice/Provisioning Profiles/build.mobileprovision'
    if config.profile.file
      profile_file  = real_file config.profile.file
      cp(profile_file, build_profile) if File.exists?(profile_file) && File.file?(profile_file)
    end
    build_parameters = [
      %Q[-configuration "#{config.build.configuration}"],
      %Q[-sdk "#{config.build.sdk}"],
      %Q[CONFIGURATION_BUILD_DIR="#{config.runtime.build_dir}"],
      (%Q[clean] if config.build.doclean?),
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
    rm_f build_profile if File.exists? build_profile
    unless result
       fail "Build failed"
    end
  end
end
