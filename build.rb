#!/usr/bin/env ruby -wKU

__DIR__ = File.expand_path(File.dirname(File.readlink(__FILE__))) + '/'
require "#{__DIR__}lib/helpers.rb"
require "#{__DIR__}lib/loader.rb"
require "#{__DIR__}lib/runner.rb"

CONFIGURATION   = ENV['CONFIGURATION']
PROJECT_DIR     = real_dir ENV['WORKSPACE']
CONFIG_FILE     = PROJECT_DIR + 'builder.yml'
MODULES_DIR     = __DIR__ + 'modules/'

fail 'config builder.yml file not found' unless File.exists? CONFIG_FILE

queue, config = load_config CONFIG_FILE, CONFIGURATION
config['run'] = {
  'project_dir'   => PROJECT_DIR,
  'configuration' => CONFIGURATION,
  'build_dir'     => "#{PROJECT_DIR}build/#{config['build']['configuration']}-#{config['build']['sdk']}/",
  'app_file_name' => config['using_pods'] ? config['workspace']['scheme'] : config['project']['target']
}
runner = Runner.new queue, config, MODULES_DIR
