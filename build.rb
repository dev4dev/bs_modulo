__DIR__ = File.expand_path(File.dirname(__FILE__)) + '/'
require "#{__DIR__}lib/helpers.rb"
require "#{__DIR__}lib/loader.rb"
require "#{__DIR__}lib/runner.rb"

CONFIGURATION   = ENV['CONFIGURATION']
PROJECT_DIR     = real_dir ENV['WORKSPACE']
CONFIG_FILE     = PROJECT_DIR + 'builder.yml'
MODULES_DIR     = __DIR__ + 'modules/'

fail 'config builder.yml file not found' unless File.exists? CONFIG_FILE

queue, config = load_config CONFIG_FILE, CONFIGURATION
runner = Runner.new queue, config, MODULES_DIR
