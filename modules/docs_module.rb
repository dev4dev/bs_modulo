
module DocsModule
  extend self
  
  def run config
    unless config.docs.enabled?
      puts 'skipping...'
      return true
    end
    
    # docs
    office_path = "/Applications/OpenOffice.org.app/Contents/MacOS/"
    fail 'There is no Office' unless File.exists? office_path
    
    soffice = office_path + 'soffice'
    unopkg = office_path + 'unopkg'
    docs_dir = config.runtime.workspace + 'docs/'
    FileUtils.cd docs_dir do
      # # add OXM lib extension in OpenOffice
      system %Q[#{unopkg} add --shared #{docs_dir}#{config.docs.ext}] if config.docs.ext
      
      config.docs.files.each do |doc_file|
        # pdf
        if config.docs.formats.pdf?
          system %Q[#{soffice} -invisible "macro:///OXMLibrary.OXMExport.ConvertDocToPDF(#{doc_file})"] or fail "Convert to PDF failed"
        end
        
        #html
        if config.docs.formats.html?
          system %Q[#{soffice} -invisible "macro:///OXMLibrary.OXMExport.ConvertDocToHTML(#{doc_file})"] or fail "Convert to HTML failed"
        end
      end
    end
    
    true
  end
  
end
