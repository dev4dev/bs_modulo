
class DocsModule < BaseModule
  config_key 'docs'
  check_enabled!
  
  def self.run config
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
        doc_file = real_file doc_file
        if config.docs.formats.pdf?
          info "Converting #{doc_file} to PDF..."
          system %Q[#{soffice} -invisible -nofirststartwizard "macro:///OXMLibrary.OXMExport.ConvertDocToPDF(#{doc_file})"] or fail "Convert to PDF failed"
        end
        
        #html
        if config.docs.formats.html?
          info "Converting #{doc_file} to HTML..."
          system %Q[#{soffice} -invisible -nofirststartwizard "macro:///OXMLibrary.OXMExport.ConvertDocToHTML(#{doc_file})"] or fail "Convert to HTML failed"
        end
      end
    end
  end
end
