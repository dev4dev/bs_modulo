#!/usr/bin/env ruby -KU
# encoding: UTF-8

__F__ = if File.symlink? __FILE__ then File.readlink(__FILE__) else __FILE__ end
BUILDER_DIR = File.expand_path(File.dirname(__F__)) + '/'
$:.unshift "#{BUILDER_DIR}lib/"
require "helpers.rb"
require "runner.rb"
require 'commander/import'

program :name, 'builder'
program :version, '1.0.0'
program :description, 'Build System'

command :build do |c|
  c.syntax = '[WORKSPACE=/path/to/project] [CONFIGURATION=configuration_name builder] build [build_config_file]'
  c.description = 'Run build'
  c.action do |args, options|
    Runner::run args
  end
end

