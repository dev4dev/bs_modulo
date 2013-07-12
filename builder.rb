#!/usr/bin/env ruby -KU
# encoding: UTF-8

__F__ = if File.symlink? __FILE__ then File.readlink(__FILE__) else File.expand_path(__FILE__) end
BUILDER_DIR = File.expand_path(File.dirname(__F__)) + '/'
$:.unshift "#{BUILDER_DIR}lib/"
require "helpers.rb"
require "runner.rb"
require 'commander/import'

program :name, 'builder'
program :version, '1.0.0'
program :description, 'Build System'

command :install do |c|
  c.syntax = ' builder install'
  c.description = 'Install builder in system'
  bin_path = '/usr/local/bin/builder'
  global_config_file = File.expand_path('~/.bs_modulo.yml')
  c.action do |args, options|
    if File.exist? bin_path
      fail "builder is already installed or its default name '#{bin_path}' is already taken by another app"
    else
      puts 'Installing...'
      puts "...creating [#{bin_path}] symlink..."
      File.symlink __F__, '/usr/local/bin/builder'
      puts "...creating global configuration file [#{global_config_file}]..."
      open(global_config_file, "w") { |io|  io << ''} unless File.exist? global_config_file
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

