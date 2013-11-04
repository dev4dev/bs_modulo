require 'fileutils'
require 'rest_client'
require 'json'

class String
  def ucwords
    self.gsub(/\b./) {|m| m.upcase}
  end
end

def info message
  puts "> #{message}"
end

def fail message
  throw "> ERROR: #{message}"
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
  FileUtils.cd config.runtime.project_dir do
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
    value = names[key].nil? ? 'Unknown' : names[key].gsub(',', '\\,')
    dname << "#{key}=#{value}"
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
  system params.join(' ')
end

def get_sha1_from_keystore keystore_file, key_alias, keystore_password
  res = `keytool -list -v -keystore #{keystore_file} -storepass #{keystore_password}`
  matches = /Alias name: #{key_alias}\b.+?sha1:\s(?<sha1>[:0-9A-Z]+)/mi.match res
  matches[:sha1]
end

def get_base64_from_keystore  keystore_file, key_alias, keystore_password
  `keytool -exportcert -alias #{key_alias} -keystore #{keystore_file} -storepass #{keystore_password} | openssl sha1 -binary | openssl base64`
end

## system
def shell command, params=[]
  op = [command] + params
  system *op
end

