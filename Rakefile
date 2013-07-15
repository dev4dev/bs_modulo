
require_relative "lib/helpers"

namespace :gen do
  desc "Generate keystore"
  task :keystore, [:name, :alias, :password] do |t, args|
    %w{name alias password}.each do |var|
      fail "#{var} var is required" if args[var].nil?
    end
    gen_keystore args[:name], args[:alias], args[:password]
  end
end