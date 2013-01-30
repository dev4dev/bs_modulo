
module CopyIpaModule
  extend self
  
  def run runner
    unless runner.config.copy_ipa.enabled?
      puts 'skipping...'
      return true
    end
    
    output_dir = real_dir runner.config.copy_ipa.output_dir
    if runner.config.copy_ipa.clear_old?
      puts "Removing #{output_dir}#{runner.config.runtime.output_file_mask}..."
      rm_rf output_dir + runner.config.runtime.output_file_mask
    end
    
    cp runner.config.runtime.ipa_file, output_dir
    
    true
  end
  
end
