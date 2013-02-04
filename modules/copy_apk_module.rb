module CopyApkModule
  extend self
  
  def run runner
    unless runner.config.copy_apk.enabled?
      puts 'skipping...'
      return true
    end
    
    dest_file_name = runner.config.copy_apk.naming.prefix \
      ? runner.config.copy_apk.naming.prefix \
      : runner.config.runtime.app_name
    ver = AndroidVersion.new 'AndroidManifest.xml'
    dest_file_name += "_#{runner.config.branch.name}_#{runner.config.runtime.configuration}_v#{ver.version_name}.apk"
    puts dest_file_name
    output_dir = real_dir runner.config.copy_apk.output_dir
    output_file_path = output_dir + dest_file_name
    cp runner.config.runtime.apk_file, output_file_path
    
    true
  end
  
end
