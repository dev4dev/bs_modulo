
module IpaPublisherModule
  extend self
  
  def run runner
    puts "Publishing IPA..."

    FileUtils.cd(runner.config['runtime']['build_dir']) do
      ipa_file = runner.config['runtime']['ipa_file']
      tmp_dir = real_dir './tmp/'
      FileUtils.mkdir_p tmp_dir
      system %Q[/usr/local/bin/IpaPublisher -ipaPath #{ipa_file} -o #{tmp_dir} -htmlPath #{runner.config['ipa_publisher']['template']} -URL #{runner.config['ipa_publisher']['web_path']}]
      system %Q[scp -r "#{tmp_dir}*" "#{runner.config['ipa_publisher']['fs_path']}"]
      FileUtils.rm_rf tmp_dir, {:secure => true}
    end
    
    true
  end
  
end
