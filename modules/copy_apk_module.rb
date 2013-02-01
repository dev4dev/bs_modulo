module CopyApkModule
  extend self
  
  def run runner
    unless runner.config.copy_apk.enabled?
      puts 'skipping...'
      return true
    end
    
    FileUtils.cd 'bin' do
      apks = Dir.glob(runner.config.runtime.app_name + '-' + runner.config.build_android.configuration + '*.apk')
      apk_file = apks.first unless apks.empty?
      if apk_file
        runner.config.runtime.apk_file_glob = runner.config.runtime.project_dir + 'bin/' + apk_file
      end
    end
    
    dest_file_name = runner.config.copy_apk.naming.prefix \
      ? runner.config.copy_apk.naming.prefix \
      : runner.config.runtime.app_name
    ver = AndroidVersion.new 'AndroidManifest.xml'
    dest_file_name += "_#{runner.config.branch.name}_#{runner.config.runtime.configuration}_v#{ver.version_name}.apk"
    puts dest_file_name
    output_dir = real_dir runner.config.copy_apk.output_dir
    output_file_path = output_dir + dest_file_name
    if File.exists? runner.config.runtime.apk_file
      cp runner.config.runtime.apk_file, output_file_path
    else
      cp runner.config.runtime.apk_file_glob, output_file_path
    end
    
    true
  end
  
end
