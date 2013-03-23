
class CleanAndroidModule < BaseModule
  config_key 'build_android'
  
  def self.run config
    info "Cleaning..."
    
    # clean deps
    deps      = config.build_android.dependencies
    workspace = config.runtime.workspace
    if deps && !deps.empty?
      deps.each do |dep|
        path = workspace + dep
        FileUtils.cd path do
          system %Q[ant clean] or fail "clean dependency #{dep}"
        end
      end
    end
    
    # clean project
    FileUtils.cd config.runtime.project_dir do
      system %Q[ant clean] or fail "clean project"
    end
  end
end
