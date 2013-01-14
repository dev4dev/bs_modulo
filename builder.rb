#!/usr/bin/env ruby -wKU
require "trollop"
require "xcodeproj"

VERSION = 1.0
INFO = <<-EOS
Build system v#{VERSION} © 2013 Alex Antonyuk

Usage:
  WORKSPACE=/path/to/workspace CONFIGURATION=conf_name builder build
  builder generate [--workspace|-w <file>] [--project|-p <file>]
EOS

BANNER = INFO + "
Options:
"

SUB_COMMANDS = %w(build generate)
global_opts = Trollop::options do
  version "Build system v#{VERSION} © 2013 Alex Antonyuk"
  banner BANNER
  stop_on SUB_COMMANDS
end

action = ARGV.shift
action_opts = case action
  when "build"
    Trollop::options do
      banner BANNER
    end
    
  when "generate"
    Trollop::options do
      banner BANNER
      opt :project, "Xcode project file", :type => :string
      opt :workspace, "Xcode workspace file", :type => :string
    end
    
  else
    puts INFO
  end

