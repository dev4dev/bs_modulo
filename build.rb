require "./lib/helpers.rb"
require "./lib/runner.rb"

WORKSPACE = ENV['WORKSPACE']
config = {
  :sdk => "iphoneos",
  :configuration => "adhoc"
}

queue = {
  :branch => 'BranchModule',
  :clean => 'CleanModule',
  :bump_version => 'BumpVersionModule',
  :build => 'BuildModule',
  :tests => 'TestsModule',
  :pack_ipa => 'PackIpaModule',
  :sign_ipa => 'SignIpaModule',
  :pack_dsym => 'PackDsymModule',
  :upload_doa => 'UploadDoaModule'
}

runner = Runner.new queue, config
