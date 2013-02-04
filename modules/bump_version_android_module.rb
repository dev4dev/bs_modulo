require "rexml/document"

module BumpVersionAndroidModule
  extend self
  
  def run config
    unless config.bump_version_android.enabled?
      puts 'skipping...'
      return true
    end
    
    manifest_xml_file = config.runtime.project_dir + 'AndroidManifest.xml'
    puts "Bumping Android version..."
    begin
      ver = AndroidVersion.new manifest_xml_file
      ver.increment
      puts "Bumping to versionCode:#{ver.version_code} versionName:#{ver.version_name}"
      if config.bump_version_android.push?
        puts "Push updated version numbers to git"
        system %Q[git commit -am "AUTOBUILD -- configuration: #{config.runtime.configuration}, versionCode:#{ver.version_code} versionName:#{ver.version_name}"]
        system %Q[git push origin #{config.branch.name}]
      end
      ver.write
    rescue e
      fail 'Error bumping version'
    end
    
    true
  end
end
