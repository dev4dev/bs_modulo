
class PackAppzipModule < BaseModule
  config_key 'pack_appzip'
  check_enabled!
  
  def self.run config
    app_file = xc_product_name config
    app_name = File.basename app_file, '.app'
    
    output_file_name = config.pack_appzip.naming.prefix ?  config.pack_appzip.naming.prefix + '_' : ''
    output_file_name += "#{app_name}_#{config.branch.name}_#{config.build.configuration}"
    config.runtime.output_file_mask = "#{output_file_name}*"
    if config.pack_appzip.naming.append_version?
      version = `agvtool mvers -terse1`.strip
      output_file_name += version ? '_v' + version : ''
    end
    config.runtime.output_file_name = output_file_name
    
    zip_file                = "#{output_file_name}.zip"
    zip_output_path         = config.runtime.build_dir + zip_file
    config.runtime.zip_file = zip_output_path
    
    # pack appzip manually
    FileUtils.cd(config.runtime.build_dir) do
      info 'Packing Zip...'
      rm_f "*.zip"
      system %Q[ditto -c -k --sequesterRsrc --keepParent #{app_file} "#{zip_file}"] or fail "pack zip arch file."
    end
  end
end
