
module UploadDoaModule
  extend self
  
  def run runner
    puts 'Uploading build...'
    
    ipa_file = runner.config['ipa_file']
    info_file = runner.config['run']['build_dir'] + runner.config['run']['app_file_name'] + '.app/Info.plist'
    url = runner.config['doa']['host'] + 'upload/' + runner.config['doa']['guid']
    result = post(url, {}, {
      :info => info_file,
      :ipa => ipa_file 
    })
    
    unless result["result"]
      puts result["message"]
      false
    end
    
    true
  end
end
