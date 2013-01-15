
module CopyIpaModule
  extend self
  
  def run runner
    unless runner.config['copy_ipa']['enabled']
      puts 'skipping...'
      return true
    end
    
    output_dir = real_dir runner.config['copy_ipa']['output_dir']
    if runner.config['copy_ipa']['clear_old']
      FileUtils.cd output_dir do
        rm_f runner.config['runtime']['output_file_mask']
      end
    end
    
    ipa_file = runner.config['runtime']['ipa_file']
    FileUtils.cp ipa_file, output_dir
    
    true
  end
  
end
