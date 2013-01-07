
module PackIpaModule
  extend self
  
  def run runner
    puts 'Packing IPA...'
    
    output_file_name = "#{runner.config['run']['app_file_name']}_#{runner.config['branch']}_#{runner.config['build']['configuration']}"
    ipa_file = "#{output_file_name}.ipa"
    runner.config['ipa_file'] = ipa_file
    
    ipa_dir = File.expand_path(runner.config['ipa_dir']) + '/'
    runner.config['ipa_dir'] = ipa_dir
    file_mask = "#{runner.config['branch']}_#{runner.config['build']['configuration']}"
    #we are already in the runner.PROJDIR
    FileUtils.cd(runner.config['run']['build_dir']) do
      app_name = runner.config['run']['app_file_name']
      rm_rf 'Payload'
      rm_f "#{app_name}.*.ipa"
      FileUtils.mkdir_p 'Payload/Payload'
      FileUtils.cp_r("#{app_name}.app", 'Payload/Payload', {:preserve => true})
      if File.exists? "#{app_name}.app/iTunesArtwork"
         FileUtils.cp "#{app_name}.app/iTunesArtwork", 'Payload/iTunesArtwork'
      end
      system "ditto -c -k Payload \"#{ipa_file}\""
      begin
        FileUtils.cd ipa_dir do
          begin
            rm_f "*#{file_mask}.ipa"
          rescue
            fail "failed to remove IPA in #{ipa_dir}"
          end
        end
      rescue
        fail "no directory '#{ipa_dir}'"
      end
  
      begin
        FileUtils.cp ipa_file, ipa_dir, {:verbose => true}
      rescue
        fail "Failed to copy ipa"
      end
      begin
        rm_rf ipa_file
        rm_rf "Payload"
      rescue
        fail "Failed to remove working files after IPA packing"
      end
    end
    
    true
  end
end
