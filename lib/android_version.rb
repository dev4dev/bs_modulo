require "rexml/document"

class AndroidVersion
  
  def initialize(manifest_file_path)
    @file = manifest_file_path
    if File.exists? manifest_file_path
      File.open(manifest_file_path, 'r') do |f|
        read_data f
      end
    else
      raise "#{manifest_file_path} file does not exist"
    end
  end
  
  def increment
    @version_code = @version_code.to_i + 1
    @doc.root.add_attribute('android:versionCode', @version_code)
    
    v_major, v_minor, v_build = @version_name.split '.'
    v_build = @version_code
    @version_name = "#{v_major}.#{v_minor}.#{v_build}"
    @doc.root.add_attribute('android:versionName', "#{@version_name}")
    true
  end
  
  def version_code
    @version_code
  end
  
  def version_name
    @version_name
  end
  
  def write
    File.open(@file, 'w') do |f|
      @doc.write f
    end
  end
  
  private
  def read_data stream
    @doc = REXML::Document.new stream
    if @doc
      @version_code = @doc.root.attribute('versionCode', 'android').to_s
      @version_name = @doc.root.attribute('versionName', 'android').to_s
    end
    
  end
  
end