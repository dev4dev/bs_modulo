#!/usr/bin/env ruby -KU
# encoding: UTF-8

__F__ = if File.symlink? __FILE__ then File.readlink(__FILE__) else __FILE__ end
__DIR__ = File.expand_path(File.dirname(__F__)) + '/'
$:.unshift "#{__DIR__}lib/"
require "helpers.rb"
require "loader.rb"
require "runner.rb"
require "android_version.rb"
require "base_module.rb"
require "properties.rb"

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

CONFIG_FILE_NAME = if ARGV[0] then File.basename ARGV[0] else 'builder.yml' end
CONFIG_FILE_PATH = WORKSPACE + CONFIG_FILE_NAME
MODULES_DIR      = __DIR__ + 'modules/'

fail 'config builder.yml file not found' unless File.exists? CONFIG_FILE_PATH

queue, config = load_config CONFIG_FILE_PATH, CONFIGURATION
PROJECT_DIR = real_dir(WORKSPACE + config['project_dir'])

sysconf_file = File.expand_path '~/.bs_modulo.yml'
sysconf = {}
sysconf = YAML.load_file(sysconf_file) if File.exists? sysconf_file

config['runtime'] = {
  'workspace'     => WORKSPACE,
  'project_dir'   => PROJECT_DIR,
  'configuration' => CONFIGURATION
}

platform_runtime = {}
case config['platform']
  when 'ios', 'osx'
    if config['build']
      platform_runtime = {
        'build_dir'     => "#{PROJECT_DIR}build/#{config['build']['configuration']}-#{config['build']['sdk']}/"
      }
    end
    
  when 'android'
    platform_runtime = {
      
    }
end
config['runtime'].merge! platform_runtime

Runner.new :queue => queue, :config => config, :sysconf => sysconf, :modules_dir => MODULES_DIR
