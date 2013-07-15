$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
require "constants"
require "helpers"
require "settings"
require "fileutils"

namespace :gen do
  desc "Generate keystore"
  task :keystore, [:name, :alias, :password] do |t, args|
    %w{name alias password}.each do |var|
      fail "#{var} var is required" if args[var].nil?
    end
    keystore_path = Settings::System.get.android.keystore_dir
    if File.exists? File.join(keystore_path, args[:name] + '.keystore')
      fail 'Keystore file already exists'
    end
    
    FileUtils.cd keystore_path do
      print "Generating keystore file #{File.join(keystore_path, args[:name])}.keystore..."
      res = gen_keystore args[:name], args[:alias], args[:password]
      if res
        puts "done."
      else
        fail "error."
      end
    end
  end
end
