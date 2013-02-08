
module OnlineDocsModule
  extend self
  
  def run config
    unless config.online_docs.enabled?
      puts 'skipping...'
      return true
    end
    
    system %Q[/usr/local/bin/appledoc --output ./web_docs --no-create-docset]
    mv './web_docs/html', './web_docs/docs'
    path_prefix = "web_docs/#{config.runtime['configuration']}"
    system %Q[scp -r ./web_docs/docs/* #{config.online_docs.fs_path}#{path_prefix}]
    rm_rf './web_docs/' or fail 'to clean docs directory'
    webserver_dir = config.online_docs.web_path + path_prefix
    # section_print "Documentation updated $WEBSERVER_DIR"
    
    true
  end
  
end
