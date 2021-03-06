$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
require "constants"
require "helpers"
require "settings"
require "fileutils"
require "yaml"
require "xcode"

module Rake
  class Task
    def all_required! args
      arg_names().each do |var|
        fail "#{var} var is required" if args[var].nil?
      end
    end
  end
end

def get_app_data app_name
  props_file = real_file Settings::System.get.android.properties_file
  properties = YAML.load_file(props_file)
  unless properties.keys.include? app_name
    fail 'app with such app name does not exist'
  end
  properties[app_name]
end

namespace :apps do
  desc "List applications"
  task :list do
    props_file = real_file Settings::System.get.android.properties_file
    properties = YAML.load_file(props_file)
    puts 'Applications:'
    puts properties.keys.map{|x| "\t * " + x}.join("\n")
  end

  desc "Add new app (generate keystore)"
  task :add, [:app_name, :password] do |t, args|
    t.all_required! args
    keystores_path = real_dir Settings::System.get.android.keystore_dir
    keystore_file_name = args[:app_name] + '.keystore'
    keystore_file_path = File.join(keystores_path, keystore_file_name)
    if File.exists? keystore_file_path
      fail 'Keystore file already exists'
    end
    
    props_file = real_file Settings::System.get.android.properties_file
    properties = YAML.load_file(props_file)
    if properties.keys.include? args[:app_name]
      fail 'App with such property key exists'
    end
    
    FileUtils.cd keystores_path do
      print "Generating keystore file #{keystore_file_path}..."
      res = gen_keystore args[:app_name], args[:app_name], args[:password]
      if res
        properties[args[:app_name]] = {
          'key.alias' => args[:app_name],
          'key.alias.password' => args[:password],
          'key.store' => keystore_file_name,
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
  
  namespace :hash do
    desc "Get sha1 hash for app"
    task :sha1, [:app_name] do |t, args|
      t.all_required! args

      app_data = get_app_data args[:app_name]
      keystores_path = real_dir Settings::System.get.android.keystore_dir
      keystore_file_path = File.join(keystores_path, app_data['key.store'])
      hash = get_sha1_from_keystore keystore_file_path, app_data['key.alias'], app_data['key.store.password']
      puts "SHA1 Hash: #{hash}"
    end

    desc "Get base64 hash for app"
    task :base64, [:app_name] do |t, args|
      t.all_required! args

      app_data = get_app_data args[:app_name]
      keystores_path = real_dir Settings::System.get.android.keystore_dir
      keystore_file_path = File.join(keystores_path, app_data['key.store'])
      hash = get_base64_from_keystore keystore_file_path, app_data['key.alias'], app_data['key.store.password']
      puts "Base64 Hash: #{hash}"
    end
  end
end

namespace :xcode do
  desc "Switch to Xcode version"
  task :switch, [:version] do |t, args|
    t.all_required! args
    version = args[:version]
    path = Settings::System.get.xcode[version]
    begin
      Xcode::switch_to_version version, path
    rescue Exception => e
      puts e.message
    end
  end
end
