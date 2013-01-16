
module BuildModule
  extend self
  
  def run runner
    puts 'Building project...'
    
    profile_file = real_file runner.config.profile.file
    build_profile = real_file '~/Library/MobileDevice/Provisioning Profiles/build.mobileprovision'
    FileUtils.cp profile_file, build_profile
    if runner.config.using_pods?
      ## build workspace
      result = system %Q[xcodebuild -workspace "#{runner.config.workspace.name}.xcworkspace" -scheme "#{runner.config.workspace.scheme}" -configuration "#{runner.config.build.configuration}" -sdk "#{runner.config.build.sdk}" CONFIGURATION_BUILD_DIR="#{runner.config.runtime.build_dir}" clean build]
    else
      result = system %Q[xcodebuild -project "#{runner.config.project.name}.xcodeproj" -target "#{runner.config.project.target}" -configuration "#{runner.config.build.configuration}" -sdk "#{runner.config.build.sdk}" CONFIGURATION_BUILD_DIR="#{runner.config.runtime.build_dir}" clean build]
    end
    rm_f build_profile
    unless result
       fail "Build failed"
    end
    
    true
  end
end
