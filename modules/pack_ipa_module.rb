
module PackIpaModule
  extend self
  
  def run runner
    puts 'Packing IPA...'
    
    output_file_name = "#{runner.config['runtime']['app_file_name']}_#{runner.config['branch']}_#{runner.config['build']['configuration']}"
    runner.config['runtime']['output_file_name'] = output_file_name
    ipa_file = "#{output_file_name}.ipa"
    runner.config['runtime']['ipa_file'] = runner.config['runtime']['build_dir'] + ipa_file
    
    file_mask = "#{runner.config['branch']}_#{runner.config['build']['configuration']}"
    #we are already in the runner.PROJDIR
    FileUtils.cd(runner.config['runtime']['build_dir']) do
      app_name = runner.config['runtime']['app_file_name']
      rm_rf 'Payload'
      rm_f "#{app_name}.*.ipa"
      FileUtils.mkdir_p 'Payload/Payload'
      FileUtils.cp_r("#{app_name}.app", 'Payload/Payload', {:preserve => true})
      if File.exists? "#{app_name}.app/iTunesArtwork"
         cp "#{app_name}.app/iTunesArtwork", 'Payload/iTunesArtwork'
      end
      system "ditto -c -k Payload \"#{ipa_file}\""
  
      rm_rf "Payload"
    end
    
    true
  end
end
