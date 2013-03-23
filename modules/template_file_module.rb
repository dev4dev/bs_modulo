
class TemplateFileModule < BaseModule
  config_key 'template_file'
  check_enabled!
  
  def self.run config
    files = config.template_file.files
    if files
      files.each do |file|
        if File.exists? real_file(file[:from])
          File.open(real_file(file[:from]), 'r') do |input_file|
            info "Copy #{file[:from]} to #{file[:to]} with #{file[:vars]}"
            data = input_file.read
            file[:vars].each {|from, to| data.gsub! %Q[{#{from.to_s}}], to}
            File.open(real_file(file[:to]), 'w') do |output_file|
              output_file << data
            end
          end
        else
          info %Q[Warning: Template file does not exist "#{file[:from]}"...]
        end
      end
    end
  end
end
