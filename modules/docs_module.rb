
module DocsModule
  extend self
  
  def run config
    unless config.docs.enabled?
      puts 'skipping...'
      return true
    end
    
    # docs
    OFFICE_PATH = "/Applications/OpenOffice.org.app/Contents/MacOS/"
    fail 'There is no Office' unless File.exists? OFFICE_PATH
    
    SOFFICE = OFFICE_PATH + 'soffice'
    UNOPKG = OFFICE_PATH + 'unopkg'
    FileUtils.cd 'docs' do
      # # add OXM lib extension in OpenOffice
      system %Q[#{UNOPKG} add --shared #{docs}#{config.docs.ext}] if config.docs.ext
      
      config.docs.files.each do |doc_file|
        # pdf
        if config.docs.formats.pdf?
          system %Q[#{SOFFICE} -invisible "macro:///OXMLibrary.OXMExport.ConvertDocToPDF(#{doc_file})"] or fail "Convert to PDF failed"
        end
        
        #html
        if config.docs.formats.html?
          system %Q[#{SOFFICE} -invisible "macro:///OXMLibrary.OXMExport.ConvertDocToHTML(#{doc_file})"] or fail "Convert to HTML failed"
        end
      end
    end
    
    true
  end
  
end
