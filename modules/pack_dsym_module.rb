
module PackDsymModule
  extend self
  
  def run runner
    unless runner.config.pack_dsym.enabled?
      puts 'skipping...'
      return true
    end
    
    puts 'Packing dSYM...'

    output_dir = real_dir runner.config.pack_dsym.output_dir
    FileUtils.cd(runner.config.runtime.build_dir) do
      dsym_file = "#{runner.config.runtime.output_file_name}.dSYM.zip"
      runner.config.runtime.dsym_file = runner.config.runtime.build_dir + dsym_file
      system %Q[zip -r "#{dsym_file}" "#{runner.config.runtime.app_file_name}.app.dSYM"]
      if runner.config.pack_dsym.copy?
        cp dsym_file, output_dir
      end
    end
    
    true
  end
end
