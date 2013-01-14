
module PackDsymModule
  extend self
  
  def run runner
    unless runner.config['pack_dsym']['enabled']
      puts 'skipping...'
      return true
    end
    
    puts 'Packing dSYMs...'

    ipa_dir = File.expand_path(runner.config['ipa_dir']) + '/'
    FileUtils.cd(runner.config['runtime']['build_dir']) do
      dsym_file = "#{runner.config['runtime']['output_file_name']}.dSYM.zip"
      system "zip -r \"#{dsym_file}\" \"#{runner.config['runtime']['app_file_name']}.app.dSYM\""
      rm_f "#{ipa_dir}#{dsym_file}" or fail "failed to remove dSYM in #{ipa_dir}"
      cp dsym_file, ipa_dir
      rm_f dsym_file
    end
    
    true
  end
end
