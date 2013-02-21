
module OpenxAndroidModule
  extend self
  
  def run config
    unless config.openx_android.enabled?
      puts 'skipping...'
      return true
    end
    
    # bump version
    manifest_xml_file = Dir['**/assembly.xml'].first
    puts "Bumping Android version..."
    version = ''
    begin
      ver = AndroidVersion.new manifest_xml_file
      if config.openx_android.bump_version?
        ver.increment
        ver.write
        puts "Bumping to versionCode:#{ver.version_code} versionName:#{ver.version_name}"
      end
      version = ver.version_name
      if config.openx_android.push_version?
        puts "Push updated version numbers to git"
        system %Q[git commit -am "AUTOBUILD -- configuration: #{config.runtime.configuration}, versionCode:#{ver.version_code} versionName:#{ver.version_name}"]
        system %Q[git push origin #{config.branch.name}]
      end
    rescue e
      fail 'Error bumping version'
    end
    
    build_lib = config.runtime.project_dir + Dir['bin/*.jar'].first
    lib_name = "#{config.openx_android.work_dir}_#{version}.jar"
    
    # pack lib
    puts 'packing data...'
    FileUtils.cd config.runtime.workspace do
      output_dir = real_dir config.openx_android.work_dir
      
      # # remove old release package folder if it exists
      rm_rf output_dir if File.exists? output_dir
      
      # # create temp directory for release package
      FileUtils.mkdir_p output_dir
      
      # copy projects
      puts 'copying items to package...'
      config.openx_android.pack.each do |item|
        if item.is_a? Array
          src, dst = item
        else
          src = dst = item
        end
        puts '---> ' + src
        next if src.nil? || src == '' || !(/^[\w\d]+$/i.match src.to_s)
        next if dst.nil? || dst == '' || !(/^[\w\d]+$/i.match dst.to_s)
        puts 'copying...'
        copy_project(src, output_dir + dst)
        puts 'preparing...'
        prepare(output_dir + dst, dst, 'libs/' + lib_name, config.build_android.android_target)
        puts 'copying lib into it...'
        libs_path = output_dir + dst + '/libs/'
        FileUtils.mkdir_p libs_path
        cp(build_lib, libs_path + lib_name)
      end
      
      # copy SDK
      FileUtils.mkdir_p output_dir + 'SDK'
      cp build_lib, output_dir + 'SDK/' + lib_name
      
      # # zip file name, which be putted in dropbox
      FileUtils.mkdir_p real_dir(config.openx_android.output_dir)
      output_file = real_dir(config.openx_android.output_dir) + config.openx_android.work_dir + "_#{version}.zip"
      
      if config.openx_android.copy_docs?
        # # create docs directory for release package
        docs = real_dir 'docs'
        output_docs_dir = output_dir + 'docs/'
        FileUtils.mkdir_p output_docs_dir
        
        # # copy documetation to release docs folder
        Dir.glob('docs/*.{txt,odt,pdf,html}').each do |doc_file|
          cp doc_file, output_docs_dir
        end
      end
      
      # # clean old zip file
      rm output_file if File.exists? output_file
      
      # # archive release folder and put it in dropbox directory
      system %Q[zip -ry #{output_file} #{config.openx_android.work_dir}] or fail "Release packaging failed"
      
      # # remove temp directory
      rm_rf output_dir
    end
    
    true
  end
  
  private
  def copy_project src, dst
    FileUtils.mkdir_p dst
    cpdir src, dst, ['bin', 'gen']
  end
  
  def prepare path, name, lib_path, target
    project(path + '/.project', name)
    classpath(path + '/.classpath', lib_path)
    project_props(path + '/project.properties', target)
  end
  
  def classpath file, lib_path
    template = <<DOC
<?xml version="1.0" encoding="UTF-8"?>
<classpath>
	<classpathentry kind="src" path="src"/>
	<classpathentry kind="src" path="gen"/>
	<classpathentry kind="con" path="com.android.ide.eclipse.adt.ANDROID_FRAMEWORK"/>
	<classpathentry kind="con" path="com.android.ide.eclipse.adt.LIBRARIES"/>
	<classpathentry kind="lib" path="%s"/>
	<classpathentry kind="output" path="bin/classes"/>
</classpath>
DOC
    File.open(file, 'w') do |f|
      f << (template % lib_path)
    end
  end
  
  def project file, name
    template = <<DOC
<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
	<name>%s</name>
	<comment></comment>
	<projects>
	</projects>
	<buildSpec>
		<buildCommand>
			<name>com.android.ide.eclipse.adt.ResourceManagerBuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
		<buildCommand>
			<name>com.android.ide.eclipse.adt.PreCompilerBuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
		<buildCommand>
			<name>org.eclipse.jdt.core.javabuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
		<buildCommand>
			<name>com.android.ide.eclipse.adt.ApkBuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
	</buildSpec>
	<natures>
		<nature>com.android.ide.eclipse.adt.AndroidNature</nature>
		<nature>org.eclipse.jdt.core.javanature</nature>
	</natures>
</projectDescription>
DOC
    File.open(file, 'w') do |f|
      f << (template % name)
    end
  end
  
  def project_props file, target
    template = <<DOC
# This file is automatically generated by Android Tools.
# Do not modify this file -- YOUR CHANGES WILL BE ERASED!
#
# This file must be checked in Version Control Systems.
#
# To customize properties used by the Ant build system use,
# "ant.properties", and override values to adapt the script to your
# project structure.

# Project target.
target=%s
DOC
    File.open(file, 'w') do |f|
      f << (template % target)
    end
  end
end
