
module BranchModule
  extend self
  
  def run runner

    branch_name = runner.config.branch.name
    puts "Switch to branch #{branch_name}...";
    system %Q[git checkout #{branch_name}]
    system %Q[git pull origin #{branch_name}]
    if runner.config.branch.submodules?
      system %Q[git submodule update --init]
    end

    true
  end
end
