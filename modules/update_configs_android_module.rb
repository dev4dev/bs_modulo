require "rexml/document"

module UpdateConfigsAndroidModule
  extend self
  
  def run config
    unless config.update_configs_android.enabled?
      puts 'skipping...'
      return true
    end
    
    # update deps config
    deps           = config.build_android.dependencies
    workspace      = config.runtime.workspace
    android_target = config.build_android.android_target
    if deps && !deps.empty?
      deps.each do |dep|
        path = workspace + dep
        system %Q[android update project --path "#{path}" --target "#{android_target}"] or fail "updating project dep #{dep}"
      end
    end
    
    # update project config
    system %Q[android update project --path "#{config.runtime.project_dir}" --target "#{android_target}"] or fail "updating project"
    
    if File.exists? 'build.xml'
      File.open('build.xml', 'r') do |f|
        _doc = REXML::Document.new f
        app_name = _doc.root.attribute('name').to_s
        config.runtime.apk_file = config.runtime.project_dir + "bin/#{app_name}-#{config.build_android.configuration}.apk"
        config.runtime.app_name = app_name
      end
    end
    
    true
  end
  
end
