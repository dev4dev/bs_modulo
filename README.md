## Build System

#### Requirements
Ruby 1.9.3 --  checkout [rvm.io](https://rvm.io/)  
Bundler gem -- `gem install bundler`  

#### Install

	git clone https://github.com/dev4dev/bs_modulo.git
	cd bs_modulo
	bundle install
	ln -s "`pwd`/build.rb" /usr/local/bin/builder
	# check that /usr/local/bin is in your $PATH var

#### Usage
Execute command in project directory (where builder.yml file is located)

	WORKSPACE=/project/dir CONFIGURATION=conf_name builder [builder.yml]

Usage [documentation](https://github.com/dev4dev/bs_modulo/blob/master/docs/USAGE.md).  
Module's config params [documentation](https://github.com/dev4dev/bs_modulo/blob/master/docs/CONFIGURATION.md).
