
module BumpVersionModule
  extend self
  
  def run config
    unless config.bump_version.enabled?
      puts 'skipping...'
      return true
    end
    
    puts "Bumping version..."
    
    system %Q[agvtool bump -all]
    version_number = `agvtool vers -terse`.strip
    system %Q[agvtool new-marketing-version "#{version_number}"]
    if config.bump_version.push?
      puts "Push updated version numbers to git"
      system %Q[git commit -am "AUTOBUILD -- configuration: #{config.runtime.configuration}, ver: #{version_number}"]
      system %Q[git push origin #{config.branch.name}]
    end
    
    true
  end
end
