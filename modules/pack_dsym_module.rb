
module PackDsymModule
  extend self
  
  def run runner
    unless runner.config['pack_dsym']
      puts 'skipping...'
      return true
    end
    
    puts 'Packing dSYMs...'
    
    FileUtils.cd(runner.config['run']['build_dir']) do
      rm_f "*.dSYM.zip"
      dsym_file = "#{runner.config['output_file_name']}.dSYM.zip"
      system "zip -r \"#{dsym_file}\" \"#{runner.config['run']['app_file_name']}.app.dSYM\""
      rm_f "#{runner.config['ipa_dir']}*#{runner.config['file_mask']}.dSYM.zip" or fail "failed to remove dSYM in #{runner.config['ipa_dir']}"
      FileUtils.cp dsym_file, runner.config['ipa_dir'], {:verbose => true}
    end
    
    true
  end
end
