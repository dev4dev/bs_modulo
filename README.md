## Build System

#### Install

	git clone https://github.com/dev4dev/bs_modulo.git
	cd bs_modulo
	bundle install
	ln -s "`pwd`/build.rb" /usr/local/bin/builder

#### Usage
Run `WORKSPACE=/project/dir CONFIGURATION=conf_name builder [build.yml]` in project directory (where builder.yml file is located)

Usage [documentation](https://github.com/dev4dev/bs_modulo/blob/master/docs/USAGE.md).
