## Build System Usage

### Project preparation

1. For all targets in **Build Settings** set **Versioning System** to `Apple Generic` and **Current Project Version** to initial project version e.g. `1.0.0`.
2. DO NOT use spaces in target names e.g. `Cool App Lite` --> `CoolAppLite`.

### NB!! CONFIG FILE MUST BE LOCATED IN `MASTER` BRANCH!

1. Save [builder.yml](https://raw.github.com/dev4dev/bs_modulo/master/examples/builder.yml) ([builder_android.yml](https://raw.github.com/dev4dev/bs_modulo/master/examples/builder_android.yml) for android) file into your project's repo root folder.
2. Comment out unnecessary modules from `queue` block.  
	iOS:
	
		queue:
			- branch
			- clean
			- bump_version
			- build
			- tests
			- pack_ipa
			- pack_dsym
			- online_docs
			- upload_doa
			- copy_ipa
			- ipa_publisher
			- hockeyapp
			- docs
			- package

	Android:
	
		queue:
			- branch
			- update_configs_android
			- clean_android
			- bump_version_android
			- build_android
			- copy_apk
			- javadoc
			- hockeyapp
		    
	> Description for all config params you can find in [CONFIGURATION.md](https://github.com/dev4dev/bs_modulo/blob/master/docs/CONFIGURATION.md) file.
3. Change default values to your project's ones.
4. Add config file to commit and push it to remote repo.
5. Create new job in Jenkins.
	1. Add Choice build parameter with name `CONFIGURATION` and list of configurations from you `builder.yml` file.
			
			adhoc
			appstore
			…etc
	2. Add Git repo.
	3. Add Build step `Execute Shell` and paste this to input field
	
			git checkout master
			git pull origin master
			builder
	4. Click Save button

## Configuration file
### 1. Add new configuration

Just add new section to configuration file and inherit it from one of existed configurations. Example:

	appstore: <- Configuration name
		<<: *default  <- inherited from default configuration

If you want to inherit new configuration from different configuration than `default`, you have to add alias for inherited configuration. Example:

	adhoc: &adhoc  <- adding alias for configuration
		<<: *default

	adhoc_free:
		<<: *adhoc <- now we can use it here for inheritance
		build:
			configuration:	AdHoc_Free  <- and override necessary config parameter

## CocoaPods
For using CocoaPods you have to check your workspace's schemas as shared. To do so you have to open schemes manager and check `Shared` checkboxes opposite necessary schemes. It will create *.xcscheme files in corresponding project files.

## Jenkins
[Jenkins job setup](https://github.com/dev4dev/bs_modulo/blob/master/docs/JENKINS.md)

## Migration from old version
[MIGRATION.md](https://github.com/dev4dev/bs_modulo/blob/master/docs/MIGRATION.md)
