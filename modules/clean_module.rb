
class CleanModule < BaseModule
  config_key 'clean'
  check_enabled_if_set_explicitly!

  def self.run config
    info "Cleaning build dir..."
    rm_rf "#{config.runtime.project_dir}/build/"
  end
end
