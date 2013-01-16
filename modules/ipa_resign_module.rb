
module IpaResignModule
  extend self
  
  def run runner
    
    # Unzip
    app_file_name = runner.config.app_file_name
    ipa_file_path = real_file runner.config.ipa_file.input
    system %Q[unzip #{ipa_file_path}]
    # Remove old data
    system %Q[rm -r "Payload/#{app_file_name}/_CodeSignature"]
    # Replace profile
    profile_file = real_file runner.config.profile.file
    cp profile_file "Payload/#{app_file_name}/embedded.mobileprovision"
    # Resign
    system %Q[/usr/bin/codesign -f -s "#{runner.config.profile.identity}" --resource-rules "Payload/#{app_file_name}/ResourceRules.plist" "Payload/#{app_file_name}"]
    # Repack
    output_ipa_path = real_file runner.config.ipa_file.output
    system %Q[zip -qr "#{output_ipa_path}" Payload]
    
    true
  end
end
