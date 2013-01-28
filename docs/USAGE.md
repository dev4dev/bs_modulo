## Build System Usage

1. Save [builder.yml](https://raw.github.com/dev4dev/bs_modulo/master/builder.yml) file into your project's repo root folder.
2. Comment out unnceserry modules from `queue` block.

		queue:
			- branch
			- clean
			- bump_version
			- build
			- tests
			- pack_ipa
			- pack_dsym
			- upload_doa
			- copy_ipa
			- ipa_publisher

	> Description for all config params you can find in [CONFIGURATION.md](https://github.com/dev4dev/bs_modulo/blob/master/docs/CONFIGURATION.md) file.
3. Change default values to your project's ones.
4. Add config file to commit and push it to remote repo.
5. Create new job in Jenkins.
	1. Add Choise build parameter with name `CONFIGURATION` and list of configurations from you `builder.yml` file.
			
			adhoc
			appstore
			…etc
	2. Add Git repo.
	3. Add Build step `Execute Shell` and paste this to input field
	
			git checkout master
			git pull origin master
			/usr/local/bin/builder
	4. Click Save button

## Configuration file
### 1. Add new configuration

Just add new section to configuration file and inherit it from one of existed configurations. Example:

	appstore: <- Configuration name
		<<: *default  <- inherited from default configuration

If you want to inherit new configuration from different configuration than `default`, you have to add alias for inheried configuration. Example:

	adhoc: &adhoc  <- adding alias for configuration
		<<: *default

	adhoc_free:
		<<: *adhoc <- now we can use it here for inheritance
		build:
			configuration:	AdHoc_Free  <- and override necessary config parameter

## Jenkins
[Jenkins job setup](https://github.com/dev4dev/bs_modulo/blob/master/docs/JENKINS.md)

## Migration from old version
[MIGRATION.md](https://github.com/dev4dev/bs_modulo/blob/master/docs/MIGRATION.md)