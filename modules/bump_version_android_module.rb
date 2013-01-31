require "rexml/document"

module BumpVersionAndroidModule
  extend self
  
  def run runner
    unless runner.config.bump_version_android.enabled?
      puts 'skipping...'
      return true
    end
    
    manifest_xml_file = runner.config.runtime.project_dir + 'AndroidManifest.xml'
    puts "Bumping Android version..."
    doc = REXML::Document.new File.open(manifest_xml_file) if File.exists? manifest_xml_file
    if doc
      version_code = doc.root.attribute('versionCode', 'android').to_s
      version_name = doc.root.attribute('versionName', 'android').to_s
      
      if version_code
        version_code = version_code.to_i + 1
        doc.root.add_attribute('android:versionCode', version_code)
        
        v_major, v_minor, v_build = version_name.split '.'
        v_build = version_code
        doc.root.add_attribute('android:versionName', "#{v_major}.#{v_minor}.#{v_build}")
        puts "Bumping to versionCode:#{version_code} versionName:#{v_major}.#{v_minor}.#{v_build}"
        puts "Push updated version numbers to git"
        system %Q[git commit -am "AUTOBUILD -- configuration: #{runner.config.runtime.configuration}, versionCode:#{version_code} versionName:#{v_major}.#{v_minor}.#{v_build}"]
        system %Q[git push origin #{runner.config.branch.name}]
      end
      
      File.open(manifest_xml_file, 'w') do |f|
        doc.write(f)
      end
    else
      fail "Can not find AndroidManifest.xml file"
    end
    
    true
  end
end
