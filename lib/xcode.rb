require "settings"

class Xcode
  def self.switch_to_version version, path
    fail %Q{Path #{path} does not exist...} unless Dir::exists? path
    info "Switching Xcode to #{version} version"
    result = system %Q{sudo xcode-select -switch "#{path}"}
    if result
      info "Switched to #{version} Xcode successfully"
    else
      fail "Switching Xcode to #{version} version failed"
    end
  end
end
