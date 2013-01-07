
class String
  def ucwords
    self.split(' ').select {|w| w.capitalize! || w }.join(' ')
  end
end

def fail message
  puts message
  exit(-1)
end

def real_dir path
  File.expand_path(path) + '/'
end

require "FileUtils"

def rm_f path
  FileUtils.rm_f path
end

def rm_rf path
  FileUtils.rm_rf path
end
