
class String
  def ucwords
    self.split(' ').select {|w| w.capitalize! || w }.join(' ')
  end
end

def fail message
  puts message
  exit -1
end

def real_dir path
  File.expand_path(path) + '/'
end