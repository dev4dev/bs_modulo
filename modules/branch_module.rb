
class BranchModule < BaseModule
  config_key 'branch'
  
  def self.run config
    branch_name = config.branch.name
    info "Switch to branch #{branch_name}..."
    system %Q[git checkout #{branch_name}] or fail "failed switching to branch #{branch_name}"
    system %Q[git pull origin #{branch_name}] or fail "failed pulling remote repos"
    if config.branch.submodules?
      FileUtils.cd config.runtime.workspace do
        system %Q[git submodule update --init]
      end
    end
  end
end
