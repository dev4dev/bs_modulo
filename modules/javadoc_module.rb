
module JavadocModule
  extend self
  
  def run config
    unless config.javadoc.enabled?
      puts 'skipping...'
      return true
    end
    
    output_dir = real_dir config.javadoc.output_dir
    src_dir    = real_dir config.javadoc.src_dir
    system %Q[/usr/bin/javadoc -d %s -sourcepath %s -subpackages %s -classpath %s] \
      % [output_dir, src_dir, config.javadoc.subpackages.join(':'), config.javadoc.classpath]
    
    if config.javadoc.copy?
      system %Q[scp -r #{real_dir config.javadoc.output_dir}* #{config.javadoc.fs_path}]
      rm_rf config.javadoc.output_dir
    end
    
    true
  end
  
end
