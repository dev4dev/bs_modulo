require "rexml/document"

class BumpVersionAndroidModule < BaseModule
  config_key 'bump_version_android'
  check_enabled!
  
  def self.run config
    manifest_xml_file = config.runtime.project_dir + 'AndroidManifest.xml'
    puts "Bumping Android version..."
    begin
      ver = AndroidVersion.new manifest_xml_file
      ver.increment
      ver.write
      puts "Bumping to versionCode:#{ver.version_code} versionName:#{ver.version_name}"
      if config.bump_version_android.push?
        puts "Push updated version numbers to git"
        system %Q[git commit -am "AUTOBUILD -- configuration: #{config.runtime.configuration}, versionCode:#{ver.version_code} versionName:#{ver.version_name}"]
        system %Q[git push origin #{config.branch.name}]
      end
    rescue e
      fail 'Error bumping version'
    end
  end
end
