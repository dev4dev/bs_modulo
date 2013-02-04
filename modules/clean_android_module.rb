
module CleanAndroidModule
  extend self
  
  def run config
    puts "Cleaning..."
    
    # clean deps
    deps      = config.build_android.dependencies
    workspace = config.runtime.workspace
    unless deps.empty?
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
    
    true
  end
  
end
