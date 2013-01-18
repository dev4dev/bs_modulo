#!/usr/bin/env ruby -KU

__DIR__ = File.expand_path(File.dirname(begin File.readlink(__FILE__) rescue __FILE__ end)) + '/'
require "#{__DIR__}lib/helpers.rb"
require "#{__DIR__}lib/loader.rb"
require "#{__DIR__}lib/runner.rb"

## check input parameters
errors = []
if ENV['CONFIGURATION']
  CONFIGURATION = ENV['CONFIGURATION']
else
  errors << "\tpass CONFIGURATION parameter"
end

if ENV['WORKSPACE']
  WORKSPACE   = real_dir ENV['WORKSPACE']
else
  errors << "\tpass WORKSPACE parameter"
end

unless errors.empty?
  puts "Usage of builder:"
  puts "  WORKSPACE=/path/to/project CONFIGURATION=configuration_name builder\n\n"
  
  puts "Error:\n"
  puts errors.join "\n"
  exit(-1)
end

CONFIG_FILE     = WORKSPACE + 'builder.yml'
MODULES_DIR     = __DIR__ + 'modules/'

fail 'config builder.yml file not found' unless File.exists? CONFIG_FILE

queue, config = load_config CONFIG_FILE, CONFIGURATION
PROJECT_DIR = real_dir(WORKSPACE + config['project_dir'])
config['runtime'] = {
  'project_dir'   => PROJECT_DIR,
  'configuration' => CONFIGURATION,
  'build_dir'     => "#{PROJECT_DIR}build/#{config['build']['configuration']}-#{config['build']['sdk']}/",
  'app_file_name' => config['using_pods'] ? config['build']['workspace']['scheme'] : config['build']['project']['target']
}

FileUtils.cd PROJECT_DIR do
  runner = Runner.new queue, config, MODULES_DIR
end
