
module BumpVersionModule
  extend self
  
  def run config
    unless config.bump_version.enabled?
      puts 'skipping...'
      return true
    end
    
    puts "Bumping version..."
    
    system %Q[agvtool bump -all]
    build_number = `agvtool vers -terse`.strip
    
    version = build_number
    if config.bump_version.nice_mver?
      mver = `agvtool mvers -terse1`.strip.split '.'
      (3 - mver.count).times {mver << 0}
      mver[2] = build_number
      version = mver.join '.'
    end
    system %Q[agvtool new-marketing-version "#{version}"]
    
    if config.bump_version.push?
      puts "Push updated version numbers to git"
      system %Q[git commit -am "AUTOBUILD -- configuration: #{config.runtime.configuration}, ver: #{version}"]
      system %Q[git push origin #{config.branch.name}]
    end
    
    true
  end
end
