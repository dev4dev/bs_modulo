
module SignIpaModule
  extend self
  
  def run runner
    puts 'Signing IPA...'
    
    unless runner.config['profile']['identity']
      system "xcrun -sdk \"#{runner.config['build']['sdk']}\" PackageApplication -v \"#{runner.config['app_name']}.app\" -o \"#{runner.config['ipa_dir']}#{runner.config['ipa_file']}\" --sign \"#{$config['profile']['identity']}\" --embed \"#{runner.config['run']['project_dir']}#{$config['profile']['file']}\"" or fail "Failed xcrun packaging and signing ipa"
    end
    
    true
  end
end
