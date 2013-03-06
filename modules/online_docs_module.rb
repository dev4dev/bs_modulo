
class OnlineDocsModule < BaseModule
  config_key 'online_docs'
  check_enabled!
  
  def self.run config
    system %Q[/usr/local/bin/appledoc --output ./web_docs --no-create-docset]
    mv './web_docs/html', './web_docs/docs'
    system %Q[scp -r ./web_docs/docs/* #{config.online_docs.fs_path}]
    rm_rf './web_docs/' or fail 'to clean docs directory'
    puts "Documentation updated #{config.online_docs.web_path}"
  end
end
