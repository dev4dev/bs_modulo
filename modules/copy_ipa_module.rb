
module CopyIpaModule
  extend self
  
  def run runner
    unless runner.config['copy_ipa']['enabled']
      puts 'skipping...'
      return true
    end
    
    ipa_file = runner.config['runtime']['ipa_file']
    output_dir = real_dir runner.config['copy_ipa']['output_dir']
    FileUtils.cp ipa_file, output_dir
    
    true
  end
  
end
