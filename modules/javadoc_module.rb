
class JavadocModule < BaseModule
  config_key 'javadoc'
  check_enabled!
  
  def self.run config
    output_dir = real_dir config.javadoc.output_dir
    src_dir    = real_dir config.javadoc.src_dir
    system %Q[/usr/bin/javadoc -d %s -sourcepath %s -subpackages %s -classpath %s] \
      % [output_dir, src_dir, config.javadoc.subpackages.join(':'), config.javadoc.classpath]
    
    if config.javadoc.copy?
      system %Q[scp -r #{real_dir config.javadoc.output_dir}* #{config.javadoc.fs_path}]
      rm_rf config.javadoc.output_dir
    end
  end
end
