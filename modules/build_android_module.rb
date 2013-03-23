
class BuildAndroidModule < BaseModule
  config_key 'build_android'
  
  def self.run config
    info 'Building project...'
    
    ## update ant.properties
    properties_file = real_file sysconf.android_project_properties_file
    if properties_file
      properties = YAML.load_file(properties_file) if File.exists? properties_file
      props = properties[config.build_android.properties_key] if properties
    end
    
    if props
      info 'Updating ant.properties file...'
      project_props_file = config.runtime.project_dir + 'ant.properties'
      project_props = nil
      if File.exists? project_props_file
        project_props = Properties.load_from_file project_props_file
      else
        project_props = Properties.new []
      end
      project_props.set props
      project_props.save_to_file project_props_file
    end
    
    ## build
    system %Q[ant #{config.build_android.configuration}] or fail "build project"
  end
end
