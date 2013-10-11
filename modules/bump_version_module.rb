
class BumpVersionModule < BaseModule
  config_key 'bump_version'
  check_enabled!
  
  def self.run config
    info "Bumping version..."
    
    begin
      system %Q[git pull origin #{config.branch.name}] or fail "failed pulling remote repos"
      
      version, build_number = self.bump_version
      self.update_marketing_version config, version, build_number
      
      system %Q[git commit -am "AUTOBUILD -- configuration: #{config.runtime.configuration}, ver: #{version}, build: #{build_number}"]
      info "Push updated version numbers to git"
      result = system %Q[git push origin #{config.branch.name}]
      unless result
        puts "\nFailed pushing data to repo, waiting 5 seconds before retry..."
        system %Q[git reset --hard HEAD^]
        sleep 5
      end
    end until result
  end
  
  private
  def self.bump_version
    system %Q[agvtool bump -all]
    build_number = `agvtool vers -terse`.strip
    version = `agvtool mvers -terse1`.strip
    unless is_version_ok? version
      fail "ERROR: Bad version value #{version}. Aborting..."
    end
    [version, build_number]
  end
  
  def self.update_marketing_version config, version, build_number
    if config.bump_version.up_mver
      if config.bump_version.simple?
        version = build_number
      else
        version_parts = version.split '.'
        (3 - version_parts.count).times {version_parts << 0}
        version_parts[2] = build_number
        version = version_parts.join '.'
      end
      system %Q[agvtool new-marketing-version "#{version}"]
    end
  end
end
