require "yaml"
__DIR__ = real_dir File.dirname(__FILE__)
require __DIR__ + "deep_symbolize.rb"

module Loader
  extend self
  
  def load file, configuration = "default", default = "default"
    yaml = YAML.load_file(file)
    queue = yaml['queue']
    if configuration == default
      return queue, yaml[configuration]
    else
      y_default = yaml[default]
      y_configuration = yaml[configuration]
      return queue, deep_merge!(y_default, y_configuration) if !y_default.nil? && !y_configuration.nil? && !queue.nil?
    end
  end
  
  def self.deep_merge!(target, data)
    merger = proc{|key, v1, v2|
      Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    target.merge! data, &merger
  end
end

def load_config config_file, configuration
  result = Loader.load(config_file, configuration) if File.exists?(config_file)
  result or fail "Something wrong with #{config_file} config file: check queue block and #{configuration} configuration"
end