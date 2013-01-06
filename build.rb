require "./lib/helpers.rb"
require "./lib/runner.rb"
require "yaml"

WORKSPACE = ENV['WORKSPACE']

yaml = YAML::load_file('./config.yml')
queue = yaml['queue']
config = yaml['default']

runner = Runner.new queue, config
