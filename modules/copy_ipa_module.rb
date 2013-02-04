
module CopyIpaModule
  extend self
  
  def run config
    unless config.copy_ipa.enabled?
      puts 'skipping...'
      return true
    end
    
    output_dir = real_dir config.copy_ipa.output_dir
    if config.copy_ipa.clear_old?
      puts "Removing #{output_dir}#{config.runtime.output_file_mask}..."
      rm_rf output_dir + config.runtime.output_file_mask
    end
    
    cp config.runtime.ipa_file, output_dir
    
    true
  end
  
end
