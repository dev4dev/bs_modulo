
module SignIpaModule
  extend self
  
  def run runner
    puts 'Signing IPA...'
    
    ipa_file = runner.config['runtime']['ipa_file']
    sdk = runner.config['build']['sdk']
    app_file = runner.config['app_name'] + ".app"
    identity = runner.config['profile']['identity']
    profile_file = runner.config['runtime']['project_dir'] + runner.config['profile']['file']
    unless runner.config['profile']['identity']
      system "xcrun -sdk \"#{sdk}\" PackageApplication -v \"#{app_file}\" -o \"#{ipa_file}\" --sign \"#{identity}\" --embed \"#{profile_file}\"" or fail "Failed xcrun packaging and signing ipa"
    end
    
    true
  end
end
