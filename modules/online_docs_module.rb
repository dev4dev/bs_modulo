
module OnlineDocsModule
  extend self
  
  def run config
    unless config.online_docs.enabled?
      puts 'skipping...'
      return true
    end
    
    system %Q[/usr/local/bin/appledoc --output ./web_docs --no-create-docset]
    mv './web_docs/html', './web_docs/docs'
    system %Q[scp -r ./web_docs/docs/* #{config.online_docs.fs_path}]
    rm_rf './web_docs/' or fail 'to clean docs directory'
    puts "Documentation updated #{config.online_docs.web_path}"
    
    true
  end
  
end
