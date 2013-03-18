
class TemplateFileModule < BaseModule
  config_key 'template_file'
  check_enabled!
  
  def self.run config
    files = config.template_file.files
    if files
      files.each do |file|
        File.open(file[:from], 'r') do |input_file|
          puts "copy #{file[:from]} to #{file[:to]} with #{file[:vars]}"
          data = input_file.read
          file[:vars].each {|from, to| data.gsub! %Q[{#{from.to_s}}], to}
          File.open(file[:to], 'w') do |output_file|
            output_file << data
          end
        end if File.exists? file[:from]
      end
    end
  end
end
