
module BumpVersionModule
  extend self
  
  def run runner
    unless runner.config.bump_version.enabled?
      puts 'skipping...'
      return true
    end
    
    puts "Bumping version..."
    
    system %Q[agvtool bump -all]
    version_number = system %Q[agvtool vers -terse]
    system %Q[agvtool new-marketing-version "#{version_number}"]
    puts "Push updated version numbers to git"
    system %Q[git commit -am "AUTOBUILD -- configuration: #{runner.config.runtime.configuration}, ver: #{version_number}"]
    system %Q[git push origin #{runner.config.branch.name}]
    
    true
  end
end
