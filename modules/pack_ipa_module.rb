
module PackIpaModule
  extend self
  
  def run runner
    puts 'Packing IPA...'
    
    output_file_name = runner.config['prefix'] ?  runner.config['prefix'] + '_' : ''
    output_file_name += "#{runner.config['runtime']['app_file_name']}_#{runner.config['branch']['name']}_#{runner.config['build']['configuration']}"
    runner.config['runtime']['output_file_mask'] = "#{output_file_name}*"
    output_file_name += runner.config['runtime']['version'] ? '_v' + runner.config['runtime']['version'] : ''
    runner.config['runtime']['output_file_name'] = output_file_name
    
    ipa_file = "#{output_file_name}.ipa"
    runner.config['runtime']['ipa_file'] = runner.config['runtime']['build_dir'] + ipa_file
    
    file_mask = "#{runner.config['branch']['name']}_#{runner.config['build']['configuration']}"
    #we are already in the runner.PROJDIR
    app_name = runner.config['runtime']['app_file_name']
    FileUtils.cd(runner.config['runtime']['build_dir']) do
      rm_rf 'Payload'
      rm_f "*.ipa"
      FileUtils.mkdir_p 'Payload/Payload'
      FileUtils.cp_r("#{app_name}.app", 'Payload/Payload', {:preserve => true})
      if File.exists? "#{app_name}.app/iTunesArtwork"
         cp "#{app_name}.app/iTunesArtwork", 'Payload/iTunesArtwork'
      end
      system "ditto -c -k Payload \"#{ipa_file}\""
  
      rm_rf "Payload"
    end
    
    puts 'Signing IPA...'
    
    unless runner.config['profile']['identity']
      sdk = runner.config['build']['sdk']
      app_file = app_name + ".app"
      identity = runner.config['profile']['identity']
      profile_file = real_file runner.config['profile']['file']
      system "xcrun -sdk \"#{sdk}\" PackageApplication -v \"#{app_file}\" -o \"#{ipa_file}\" --sign \"#{identity}\" --embed \"#{profile_file}\"" or fail "Failed xcrun packaging and signing ipa"
    end
    
    true
  end
end
