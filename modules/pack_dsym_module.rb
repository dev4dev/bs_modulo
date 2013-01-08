
module PackDsymModule
  extend self
  
  def run runner
    unless runner.config['pack_dsym']
      puts 'skipping...'
      return true
    end
    
    puts 'Packing dSYMs...'
    
    FileUtils.cd(runner.config['run']['build_dir']) do
      dsym_file = "#{runner.config['output_file_name']}.dSYM.zip"
      system "zip -r \"#{dsym_file}\" \"#{runner.config['run']['app_file_name']}.app.dSYM\""
      rm_f "#{runner.config['ipa_dir']}#{dsym_file}" or fail "failed to remove dSYM in #{runner.config['ipa_dir']}"
      cp dsym_file, runner.config['ipa_dir']
      rm_f dsym_file
    end
    
    true
  end
end
