require "xcodeproj"

class BuildModule < BaseModule
  config_key 'build'
  defaults :doclean => true, :enabled => true
  build_profile real_file('~/Library/MobileDevice/Provisioning Profiles/build.mobileprovision')
  check_enabled!
  
  def self.run config
    info 'Building project...'
    
    unless check_build_configuration self.project_name(config), config.build.configuration
      fail %Q[Build configuration "#{config.build.configuration}" not found in project "#{config.build.project.name}"]
    end
    
    self.copy_provision_profile config
    
    command = %Q[xctool #{self.build_params config}]
    info command
    result = system command
    
    self.remove_provision_profile
    unless result
       fail "Build failed"
    end
  end
  
  private
  def self.check_build_configuration project_name, configuration_name
    project = Xcodeproj::Project.new project_name
    configurations = project.build_configurations.map(&:name)
    configurations.include? configuration_name
  end
  
  def self.project_name config
    if config.using_pods?
      workspace = Xcodeproj::Workspace.new_from_xcworkspace "#{config.build.workspace.name}.xcworkspace"
      project_name = workspace.schemes[config.build.workspace.scheme]
      unless project_name
        fail %Q[Scheme "#{config.build.workspace.scheme}" not found]
      end
    else
      project_name = "#{config.build.project.name}.xcodeproj"
    end
    project_name
  end
  
  def self.build_params config
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
      build_parameters.unshift %Q[-scheme "#{config.build.project.target}"]
    end
    
    build_parameters.join(' ')
  end
  
  ## provision profile
  def self.copy_provision_profile config
    if config.profile.file
      profile_file  = real_file config.profile.file
      cp(profile_file, build_profile) if File.exists?(profile_file) && File.file?(profile_file)
    end
  end
  
  def self.remove_provision_profile
    rm_f build_profile if File.exists? build_profile
  end
end
