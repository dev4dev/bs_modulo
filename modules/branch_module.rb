
module BranchModule
  extend self
  
  def run runner

    branch = runner.config['branch']
    puts "Switch to branch #{branch}...";
    system "git checkout #{branch}"
    system "git pull origin #{branch}"

    true
  end
end
