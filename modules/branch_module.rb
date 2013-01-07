
module BranchModule
  extend self
  
  def run runner
    puts "switch to branch, #{runner.config['branch']}..."

    branch = runner.config['branch']
    puts "Switch to branch #{branch}...";
    system "git checkout #{branch}"
    system "git pull origin #{branch}"

    true
  end
end
