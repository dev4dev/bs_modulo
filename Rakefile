$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
require "constants"
require "helpers"
require "settings"
require "fileutils"
require "yaml"

namespace :gen do
  desc "Generate keystore"
  task :keystore, [:app_name, :password] do |t, args|
    %w{app_name password}.each do |var|
      fail "#{var} var is required" if args[var].nil?
    end
    keystore_path = Settings::System.get.android.keystore_dir
    keystore_file_path = File.join(keystore_path, args[:app_name] + '.keystore')
    if File.exists? keystore_file_path
      fail 'Keystore file already exists'
    end
    
    props_file = Settings::System.get.android.properties_file
    properties = YAML.load_file(props_file)
    if properties.keys.include? args[:app_name]
      fail 'App with such property key exists'
    end
    
    FileUtils.cd keystore_path do
      print "Generating keystore file #{File.join(keystore_path, args[:app_name])}.keystore..."
      res = gen_keystore args[:app_name], args[:app_name], args[:password]
      if res
        properties[args[:app_name]] = {
          'key.alias' => args[:app_name],
          'key.alias.password' => args[:password],
          'key.store' => keystore_file_path,
          'key.store.password' => args[:password]
        }
        
        File.open(props_file, 'w') do |f|
          YAML.dump(properties, f)
        end
        puts "done."
      else
        fail "error."
      end
    end
  end
end
