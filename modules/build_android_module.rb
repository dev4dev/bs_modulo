
class BuildAndroidModule < BaseModule
  config_key 'build_android'
  
  def self.run config
    puts 'Building project...'
    system %Q[ant #{config.build_android.configuration}] or fail "build project"
  end
end
