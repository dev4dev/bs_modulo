require "xcodeproj"
require 'plist'
require "rmagick"
include Magick

class BuildModule < BaseModule
  config_key 'build'
  defaults :doclean => true, :enabled => true
  build_profile real_file('~/Library/MobileDevice/Provisioning Profiles/build.mobileprovision')
  check_enabled!
  
  def self.run config
    info 'Building project...'
    
    project_name = self.project_name(config)
    unless check_build_configuration project_name, config.build.configuration
      fail %Q[Build configuration "#{config.build.configuration}" not found in project "#{config.build.project.name}"]
    end
    
    self.copy_provision_profile config
    self.unlock_keychain config
    self.add_version_number_to_icon config, project_name
    
    ## building
    command = %Q[xctool #{self.build_params config}]
    info command
    result = system command
    ## done building
    
    self.remove_provision_profile
    hook! :build_complete
    unless result
       fail "Build failed"
    end
  end
  
  private
  def self.check_build_configuration project_name, configuration_name
    project = Xcodeproj::Project.open project_name
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

  def self.unlock_keychain config
    properties_file = real_file sysconf.xcode.properties_file
    if properties_file
      properties = YAML.load_file(properties_file) if File.exists? properties_file
      props = properties[config.profile.identity] if properties
      if props
        keychain_file  =  sysconf.xcode.keychain_dir + props['keychain']
        info "Unlock keychain #{keychain_file}..."
        system %Q[security unlock-keychain -p #{props['password']} #{keychain_file}] or fail "failed unlock #{props['keychain']}"
        system %Q[security default-keychain -s #{keychain_file}] or fail "failed switch keychain"
        system %Q[security list-keychains -s #{keychain_file}] or fail "failed switch keychain"

        rollback = proc {
          info "swith to default keychain"
          system %Q[security lock-keychain  #{keychain_file}] 
          system %Q[security default-keychain -s login.keychain] or fail "failed switch keychain"
          system %Q[security list-keychains -s login.keychain] or fail "failed switch keychain"
        }
        hook :failed, rollback
        hook :complete, rollback
      end
    end
  end
  
  def self.remove_provision_profile
    rm_f build_profile if File.exists? build_profile
  end
  
  def self.add_version_number_to_icon config, project_name
    return unless config.runtime.version and config.build.ver_on_icon?
    
    ## get icons
    target_name = if config.build.using_pods?
      config.build.workspace.scheme
    else
      config.build.project.target
    end
    project = Xcodeproj::Project.open project_name
    target = project.targets.select{|t| t.name == target_name}.first
    project_info_file = real_path(target.build_settings(config.build.configuration)['INFOPLIST_FILE'])
    
    begin
      project_info = Plist::parse_xml project_info_file
      icons_names = project_info['CFBundleIcons']['CFBundlePrimaryIcon']['CFBundleIconFiles']
    rescue Exception => e
      icons_names = []
    end
    return if icons_names.empty?
    
    icons_patterns = icons_names.map do |icon|
      "**/#{icon}"
    end
    info icons_patterns
    Dir.glob(icons_patterns).each do |icon|
      filename = real_path icon
      retina = !!filename.index('@')
      begin
        image = Image::read(filename).first
        draw = Draw::new
        draw.annotate(image, 0, 0, 0, 0, config.runtime.version) {
          self.font_family = 'Arial'
          self.fill = 'blue'
          self.stroke = 'black'
          self.pointsize = if retina then 22 else 11 end
          self.font_weight = BoldWeight
          self.gravity = SouthGravity
          self.text_antialias = true
        }
        info "Saving icon with version to #{filename}..."
        image.write filename
      rescue Exception => e
        info "Something went wrong: #{e.message}"
        next
      end
    end
    
    hook :build_complete, proc {
      `git reset --hard`
    }
  end
end
