require "xcodeproj"

class BuildModule < BaseModule
  config_key 'build'
  defaults :doclean => true, :enabled => true
  check_enabled!
  
  def self.run config
    info 'Building project...'
    
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
    
    if config.using_pods?
      workspace = Xcodeproj::Workspace.new_from_xcworkspace "#{config.build.workspace.name}.xcworkspace"
      project_name = workspace.schemes[config.build.workspace.scheme]
      unless project_name
        fail %Q[Scheme "#{config.build.workspace.scheme}" not found]
      end
    else
      project_name = "#{config.build.project.name}.xcodeproj"
    end
    
    unless check_build_configuration project_name, config.build.configuration
      fail %Q[Build configuration "#{config.build.configuration}" not found in project "#{config.build.project.name}"]
    end
    
    result = system %Q[xcodebuild #{build_parameters.join(' ')}]
    rm_f build_profile if File.exists? build_profile
    unless result
       fail "Build failed"
    end
  end
  
  private
  def self.check_build_configuration project, configuration
    project = Xcodeproj::Project.new project
    configurations = project.build_configurations.map(&:name)
    configurations.include? configuration
  end
end
