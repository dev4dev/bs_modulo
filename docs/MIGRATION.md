## Migration

### 1. Jenkins Job
1. Rename build parameter `CONFIG_FILE` to `CONFIGURATION`.
2. Build step "Execute shell" change to this:

		git checkout master
		git pull origin master
		builder
3. Click Save button.


### 2. Configuration files
1. `common.sh` file matches to `default:` section from configuration file.
2. Every old configuration file matches to configuration section from new configuration file.  
	e.g. adhoc.sh file -> `adhoc:` section.

Setup `default:` section with values from `common.sh` configuration file. Configuration parameters are quite similar to each other, so that will be easy to convert them.

Setup each configuration section according to each old configuration file, just overriding necessary configuration parameters.
