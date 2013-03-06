
class PackDsymModule < BaseModule
  config_key 'pack_dsym'
  check_enabled!
  
  def self.run config
    puts 'Packing dSYM...'
    
    output_dir = real_dir config.pack_dsym.output_dir
    app_file_name = xc_product_name config
    FileUtils.cd(config.runtime.build_dir) do
      dsym_file = "#{config.runtime.output_file_name}.dSYM.zip"
      config.runtime.dsym_file = config.runtime.build_dir + dsym_file
      system %Q[zip -r "#{dsym_file}" "#{app_file_name}.dSYM"]
      if config.pack_dsym.copy?
        cp dsym_file, output_dir
      end
    end
  end
end
