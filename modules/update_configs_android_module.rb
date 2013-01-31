require "rexml/document"

module UpdateConfigsAndroidModule
  extend self
  
  def run runner
    unless runner.config.update_configs_android.enabled?
      puts 'skipping...'
      return true
    end
    
    # update deps config
    deps           = runner.config.build_android.dependencies
    workspace      = runner.config.runtime.workspace
    android_target = runner.config.build_android.android_target
    unless deps.empty?
      deps.each do |dep|
        path = workspace + dep
        system %Q[android update project --path "#{path}" --target "#{android_target}"]
      end
    end
    
    # update project config
    system %Q[android update project --path "#{runner.config.runtime.project_dir}" --target "#{android_target}"]
    
    if File.exists? 'build.xml'
      _doc = REXML::Document.new File.open('build.xml', 'r')
      app_name = _doc.root.attribute('name').to_s
      runner.config.runtime.apk_file = runner.config.runtime.project_dir + "bin/#{app_name}-#{runner.config.build_android.configuration}.apk"
    end
    
    true
  end
  
end
