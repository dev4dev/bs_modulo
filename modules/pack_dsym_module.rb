
module PackDsymModule
  extend self
  
  def run config
    unless config.pack_dsym.enabled?
      puts 'skipping...'
      return true
    end
    
    puts 'Packing dSYM...'

    output_dir = real_dir config.pack_dsym.output_dir
    FileUtils.cd(config.runtime.build_dir) do
      dsym_file = "#{config.runtime.output_file_name}.dSYM.zip"
      config.runtime.dsym_file = config.runtime.build_dir + dsym_file
      system %Q[zip -r "#{dsym_file}" "#{config.runtime.app_file_name}.app.dSYM"]
      if config.pack_dsym.copy?
        cp dsym_file, output_dir
      end
    end
    
    true
  end
end
