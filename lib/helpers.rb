require 'fileutils'
require 'rest_client'
require 'json'

class String
  def ucwords
    self.gsub(/\b./) {|m| m.upcase}
  end
end

def fail message
  puts "> ERROR: #{message}"
  exit(-1)
end


## paths
def real_dir path
  File.expand_path(path) + '/'
end

def real_file path
  File.expand_path(path)
end

## network
def post url, params = {}, files = {}, *more_headers
  puts "post data to #{url} with params #{params} and files #{files}"
  params ||= {}
  unless files.empty?
    files.each_pair do |name, file|
      params[name] = File.new(file, 'rb')
    end
  end
  
  headers = {:accept => :json}
  unless more_headers.empty?
    headers.merge!(*more_headers)
  end
  
  RestClient.post(url, params, headers)
end

## file system
def rm_f path
  FileUtils.rm_f path, {:verbose => true}
end

def rm_rf path
  FileUtils.rm_rf path, {:verbose => true, :secure => true}
end

def cp src, dest
  FileUtils.cp src, dest, {:verbose => true}
end

def cp_r src, dest
  FileUtils.cp_r src, dest, {:verbose => true}
end

def cpdir src, dst, exclude=[]
  src = File.expand_path(src) + '/'
  dst = File.expand_path(dst) + '/'
  
  Dir[src + '*'].each do |item|
    FileUtils.cp_r(item, dst) unless exclude.include? File.basename(item)
  end
end

def mv src, dest
  FileUtils.mv src, dest, {:verbose => true}
end

## util
def module_name_from_id id
  id.gsub('_', ' ').ucwords.gsub(' ', '')
end

def xc_product_name config
  app_file_name = ''
  FileUtils.cd PROJECT_DIR do
    target = config['using_pods'] ? config['build']['workspace']['scheme'] : config['build']['project']['target']
    type = config['using_pods'] ? '-scheme' : '-target'
    app_file_name = `xcodebuild #{type} "#{target}" -showBuildSettings|grep "FULL_PRODUCT_NAME.*\.app"`.split('=').last.strip
  end
  throw 'PRODUCT_NAME is empty' if app_file_name == ''
  return app_file_name
rescue
  fail 'PRODUCT_NAME is empty'
end

def is_version_ok? ver
  re = /^\d+(\.\d+(\.\d+)?)?$/i
  !(re =~ ver).nil?
end

def gen_keystore name, al, pass, names={}
  # commonName - common name of a person, e.g., "Susan Jones"
  # organizationUnit - small organization (e.g., department or division) name, e.g., "Purchasing"
  # organizationName - large organization name, e.g., "ABCSystems, Inc."
  # localityName - locality (city) name, e.g., "Palo Alto"
  # stateName - state or province name, e.g., "California"
  # country - two-letter country code, e.g., "CH"
  dname = []
  %w{CN OU O L ST C}.each do |key|
    dname << "#{key}=#{names[key].gsub(',', '\\,')}" unless names[key].nil?
  end
  params = [
    "keytool",
    "-genkeypair",
    "-dname '#{dname.join(', ')}'",
    "-keystore #{name}.keystore",
    "-keypass #{pass}",
    "-alias #{al}",
    "-storepass #{pass}",
    "-keyalg RSA",
    "-keysize 2048",
    "-validity 100000"
  ]
  res = system params.join(' ')
end

## system
def shell command, params=[]
  op = [command] + params
  system *op
end

