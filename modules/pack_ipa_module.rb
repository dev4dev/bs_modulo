
class PackIpaModule < BaseModule
  config_key 'pack_ipa'
  check_enabled!
  
  def self.run config
    app_file = xc_product_name config
    app_name = File.basename app_file, '.app'
    
    output_file_name = config.pack_ipa.naming.prefix ?  config.pack_ipa.naming.prefix + '_' : ''
    output_file_name += "#{app_name}_#{config.branch.name}_#{config.build.configuration}"
    config.runtime.output_file_mask = "#{output_file_name}*"
    if config.pack_ipa.naming.append_version?
      version = `agvtool mvers -terse1`.strip
      output_file_name += version ? '_v' + version : ''
    end
    config.runtime.output_file_name = output_file_name
    
    ipa_file                = "#{output_file_name}.ipa"
    ipa_output_path         = config.runtime.build_dir + ipa_file
    config.runtime.ipa_file = ipa_output_path
    
    if config.profile.identity
      info 'Packing & Signing IPA...'
      sdk          = config.build.sdk
      identity     = config.profile.identity
      profile_file = real_file config.profile.file
      FileUtils.cd(config.runtime.build_dir) do
        system %Q[xcrun -sdk "#{sdk}" PackageApplication -v "#{app_file}" -o "#{ipa_output_path}" --sign "#{identity}" --embed "#{profile_file}"] or fail "xcrun packaging and signing ipa"
      end
    else
      # pack ipa manually
      FileUtils.cd(config.runtime.build_dir) do
        info 'Packing IPA...'
        rm_rf 'Payload'
        rm_f "*.ipa"
        FileUtils.mkdir_p 'Payload/Payload'
        FileUtils.cp_r(app_file, 'Payload/Payload', {:preserve => true})
        if File.exists? "#{app_file}/iTunesArtwork"
           cp "#{app_file}/iTunesArtwork", 'Payload/iTunesArtwork'
        end
        system %Q[ditto -c -k Payload "#{ipa_file}"] or fail "pack API arch file."
        rm_rf "Payload"
      end
    end
  end
end
