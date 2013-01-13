#!/usr/bin/env ruby -wKU
require "trollop"
require "xcodeproj"

VERSION = 1.0
BANNER = <<-EOS
Build system v#{VERSION} © 2013 Alex Antonyuk

Usage:
  builder build
  builder generate [--workspace|-w <file>] [--project|-p <file>]

Options:
EOS

SUB_COMMANDS = %w(build generate)
global_opts = Trollop::options do
  version "Build system v#{VERSION} © 2013 Alex Antonyuk"
  banner BANNER
  stop_on SUB_COMMANDS
end

action = ARGV.shift || 'build'
action_opts = case action
  when "build"
    Trollop::options do
      
    end
  when "generate"
    Trollop::options do
      banner BANNER
      opt :project, "Xcode project file", :type => :string
      opt :workspace, "Xcode workspace file", :type => :string
    end
  end

