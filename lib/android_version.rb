require "rexml/document"

class AndroidVersion
  
  def initialize(manifest_file_path, write_mode = false)
    @write_mode = write_mode
    @f = File.open(manifest_file_path, write_mode ? 'r+' : 'r') if File.exists? manifest_file_path
    unless @f
      raise "#{manifest_file_path} file does not exist"
    end
    
    read_data
  end
  
  def increment
    return false unless @write_mode && !@f.closed?
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
    return false if @f.closed?
    if @write_mode
      @f.rewind
      @doc.write @f
      @f.flush
    end
  end
  
  def close
    return false if @f.closed?
    write
    @f.close
    true
  end
  
  private
  def read_data
    @doc = REXML::Document.new @f
    if @doc
      @version_code = @doc.root.attribute('versionCode', 'android').to_s
      @version_name = @doc.root.attribute('versionName', 'android').to_s
    end
    
  end
  
end