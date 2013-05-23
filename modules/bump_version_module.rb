
class BumpVersionModule < BaseModule
  config_key 'bump_version'
  check_enabled!
  
  def self.run config
    info "Bumping version..."
    
    system %Q[agvtool bump -all]
    build_number = `agvtool vers -terse`.strip
    
    version = `agvtool mvers -terse1`.strip
    unless is_version_ok? version
      info "ERROR: Bad version value #{version}"
      info "Aborting..."
      return false
    end
    
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
    
    if config.bump_version.push?
      hook :complete, proc {
        info "Push updated version numbers to git"
        system %Q[git commit -am "AUTOBUILD -- configuration: #{config.runtime.configuration}, ver: #{version}, build: #{build_number}"]
        system %Q[git push origin #{config.branch.name}]
      }
    end
  end
end
