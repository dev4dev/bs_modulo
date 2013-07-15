#!/usr/bin/env ruby -KU
# encoding: UTF-8

__F__ = if File.symlink? __FILE__ then File.readlink(__FILE__) else File.expand_path(__FILE__) end
BUILDER_DIR = File.expand_path(File.dirname(__F__)) + '/'
$:.unshift "#{BUILDER_DIR}lib/"
require "constants"
require "helpers"
require "runner"
require "settings"
require 'commander/import'

program :name, 'builder'
program :version, '1.0.0'
program :description, 'Build System'

command :install do |c|
  c.syntax = ' builder install'
  c.description = 'Install builder in system'
  c.action do |args, options|
    if File.exist? BIN_PATH
      fail "builder is already installed or its default name '#{BIN_PATH}' is already taken by another app"
    else
      puts 'Installing...'
      puts "...creating [#{BIN_PATH}] symlink..."
      File.symlink __F__, BIN_PATH
      puts "...creating global configuration file [#{GLOBAL_CONFIG_FILE}]..."
      open(GLOBAL_CONFIG_FILE, "w") { |io|  io << ''} unless File.exist? GLOBAL_CONFIG_FILE
      puts 'Done.'
    end
  end
end

command :build do |c|
  c.syntax = '[WORKSPACE=/path/to/project] [CONFIGURATION=configuration_name] builder build [build_config_file]'
  c.description = 'Run build'
  c.action do |args, options|
    Runner::run args
  end
end
