
class IpaPublisherModule < BaseModule
  config_key 'ipa_publisher'
  check_enabled!
  
  def self.run config
    puts "Publishing IPA..."
    template_path = real_file config.ipa_publisher.template
    FileUtils.cd(config.runtime.build_dir) do
      tmp_dir  = real_dir './tmp/'
      FileUtils.mkdir_p tmp_dir
      system %Q[/usr/local/bin/IpaPublisher -ipaPath #{config.runtime.ipa_file} -o #{tmp_dir} -htmlPath #{template_path} -URL #{config.ipa_publisher.web_path}]
      system %Q[scp -r #{tmp_dir}* #{config.ipa_publisher.fs_path}]
      rm_rf tmp_dir
    end
  end
end
