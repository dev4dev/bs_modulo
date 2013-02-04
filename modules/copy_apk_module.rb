module CopyApkModule
  extend self
  
  def run config
    unless config.copy_apk.enabled?
      puts 'skipping...'
      return true
    end
    
    dest_file_name = config.copy_apk.naming.prefix \
      ? config.copy_apk.naming.prefix \
      : config.runtime.app_name
    ver = AndroidVersion.new 'AndroidManifest.xml'
    dest_file_name += "_#{config.branch.name}_#{config.runtime.configuration}_v#{ver.version_name}.apk"
    puts dest_file_name
    output_dir = real_dir config.copy_apk.output_dir
    output_file_path = output_dir + dest_file_name
    cp config.runtime.apk_file, output_file_path
    
    true
  end
  
end
