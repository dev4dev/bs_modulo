
class CopyIpaModule < BaseModule
  config_key 'copy_ipa'
  check_enabled!
  
  def self.run config
    output_dir = real_dir config.copy_ipa.output_dir
    if config.copy_ipa.clear_old?
      info "Removing #{output_dir}#{config.runtime.output_file_mask}..."
      rm_rf output_dir + config.runtime.output_file_mask
    end
    
    cp config.runtime.ipa_file, output_dir
  end
end
