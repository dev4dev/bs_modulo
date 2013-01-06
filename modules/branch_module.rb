
module BranchModule
  extend self
  
  def run runner
    puts "switch to branch, #{runner.config['branch']}..."
    true
  end
end
