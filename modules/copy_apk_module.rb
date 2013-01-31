module CopyApkModule
  extend self
  
  def run runner
    unless runner.config.copy_apk.enabled?
      puts 'skipping...'
      return true
    end
    
    output_dir = real_dir runner.config.copy_apk.output_dir
    cp runner.config.runtime.apk_file, output_dir
    
    true
  end
  
end
