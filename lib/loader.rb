require "yaml"
require "deep_symbolize.rb"
require "hashr"

module Loader
  extend self
  
  def load file, configuration = "default"
    yaml = YAML.load_file(file)
    queue = yaml['queue']
    
    tree = inheritance_tree file, configuration
    config = {}
    if tree.empty?
      config = yaml[configuration]
    else
      tree.each do |item|
        fail %Q{Configuration "#{item}" from inheritance tree does not exist} if yaml[item].nil?
        config = deep_merge!(config, yaml[item])
      end
    end
    return queue, Hashr.new(config)
  end
  
  def self.deep_merge!(target, data)
    merger = proc{|key, v1, v2|
      Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    target.merge! data, &merger
  end
  
  private
  def inheritance_tree file, configuration
    File.open(file, 'r') do |f|
      string = f.read
      search = configuration
      tree = [configuration]
      begin
        r = /^#{search}\:.*?\n\s+(?:<<:\s\*(?<parent>\w+))?/mi.match string
        tree << r[:parent] if r && r[:parent]
        search = r[:parent] if r
      end while r
      return tree.reverse
    end
  end
end

def load_config config_file, configuration
  result = Loader.load(config_file, configuration) if File.exists?(config_file)
  result or fail "Something wrong with #{config_file} config file: check queue block and #{configuration} configuration"
end