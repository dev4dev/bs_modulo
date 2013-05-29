## Build System
Global Configuration Parameters:  
1. `platform` **[choice (ios, osx, android)]** - project platform  
2. `using_pods` **[bool]** - whether project uses CocoaPods [ios, osx]  
3. `project_dir` **[string]** - path to project's dir [default: `.`]  
4. `profile.file` **[string]** - path to profile file [iOS only]  
5. `profile.identity` **[string]** - profile's identity string [iOS only]  
	Example:
	
		profile:
			file:       profiles/adhoc.mobileprovision
			identity:   "iPhone Developer: Trololo, LLC"

###Modules

1. **Branch Module**  
	_Checkout Git Repo to specified branch_  
	Name: `branch`  
	Config Parameters:  

		branch:  
			name:       master  
			submodules: true
	`branch.name` **[string]** - the name of branch git repo will be switched to  
	`branch.submodules` **[bool]** - init submodules or not
2. **Clean Module**  
	Name: `clean`  
	Config Parameters: nothing
3. **Bump Version Module**  
	_Increase project version number_  
	Name: `bump_version`  
	Config Parameters:
	
		bump_version:
			enabled:    false
			push:		false
			up_mver:	false
			simple:		false
	`bump_version.enabled` **[bool]** - enable or disable module for configuration  
	`bump_version.push` **[bool]** - push changes to git repo or not  
	`bump_version.up_mver` **[bool]** - update marketing version field or not (semantic version format major.minor.build)  
	`bump_version.simple` **[bool]** - update marketing version to build number
4. **Build Module**  
	_Main build module for iOS Projects_  
	Name: `build`  
	Config Parameters:
	
		build:
			configuration:  Release
			sdk:            iphoneos
			doclean:		true
			workspace:
				name:       TestProject
				scheme:     TestProject
			project:
				name:       TestProject
				target:     TestProject
	`build.configuration` **[string]** - project's configuration name  
	`build.sdk` **[string]** - SDK version  
	`build.doclean` **[bool]** - enable or disable cleaning project before building  
	`build.workspace.name` **[string]** - workspace name if using pods  
	`build.workspace.scheme` **[string]** - scheme name if using pods  
	`build.project.name` **[string]** - project name if not using pods  
	`build.project.target` **[string]** - target name if not using pods  
5. **Tests Module**  
	_Module for running tests from iOS Project_  
	Name: `tests`  
	Config Parameters:
	
		tests:
			enabled:        false
			target:     TestProjectTest
	`tests.enabled` **[bool]** - run tests or not  
	`tests.target` **[string]** - tests target name

6. **Pack IPA Module**  
	_Packing build into IPA file and sign with specified profile if needed_  
	Name: `pack_ipa`  
	Config Parameters:
	
		pack_ipa:
			enabled:	false
			naming:
				prefix:         TestProject
				append_version: false
	`pack_ipa.enabled` **[bool]** - enable or disable module for configuration  
	`pack_ipa.naming.prefix` **[string]** - prefix for output IPA filename [default: `<empty string>`]  
	`pack_ipa.naming.append_version` **[bool]** - enable or disable appending version number to output IPA filename

7. **Pack dSYM Module**  
	_Pack dSYM data of build_  
	Name: `pack_dsym`  
	Config Parameters:
	
		pack_dsym:
			enabled:    false
			output_dir: ~/Desktop/
	`pack_dsym.enabled` **[bool]** - enable or disable module for configuration  
	`pack_dsym.output_dir` **[string]** - path to output directory

8. **Upload DOA Module _[Abandoned]_**  
	_Upload IPA to DOA service_  
	Name: `upload_doa`  
	Config Parameters:
	
		doa:
			host:       http://doa.domain/
			guid:       app_guid
	`doa.host` **[string]** - host address of DOA server  
	`doa.guid` **[string]** - application's id on DOA server

9. **Copy IPA Module**  
	_Copy IPA file to specified directory_  
	Name: `copy_ipa`  
	Config Parameters:
	
		copy_ipa:
			enabled:    true
			output_dir: ~/Desktop/
			clear_old:  false
	`copy_ipa.enabled` **[bool]** - enable or disable module for configuration  
	`copy_ipa.output_dir` **[string]** - path to output directory  
	`copy_ipa.clear_old` **[bool]** - clear or not old builds

10. **IPA Publisher _[Deprecated]_**  
	_Old style publisher for IPAs to distribute them over air_  
	Name: `ipa_publisher`  
	Config Parameters:
	
		ipa_publisher:
			enabled:    false
			fs_path:    /var/www/app/
			web_path:   http://server.com/app/
			template:   builder/publisher_template.html
	`ipa_publisher.enabled` **[bool]** - enable or disable module for configuration  
	`ipa_publisher.fs_path` **[string]** - path to www accessible dir on server  
	`ipa_publisher.web_path` **[string]** - http address of page  
	`ipa_publisher.template` **[string]** - html template for page  

11. **Resign IPA Module _[Abandoned]_**  
	_Resign IPA file_  
	Name: `ipa_resign`  
	Config Parameters:
	
		...
12. **HockeyApp Module**  
	_Upload build to HockeyApp Service_  
	Name: `hockeyapp`  
	Config Parameters:
	
		hockeyapp:
			enabled:    false
			token:      token
			app_id:     app_id
	`hockeyapp.enabled` **[bool]** - enabled or disabled module for configuration  
	`hockeyapp.token` **[string]** - HockeyApp API Token  
	`hockeyapp.app_id` **[string]** - HockeyApp App ID  
	Accepts parameter `HOCKEYAPP_NOTES` as release note for upload. You can add it in Jenkins build job as "Text Field" parameter. Or just pass as ENV parameter.

13.	**Update Config [Android] Module**  
	_Update configurations for android project & dependencies, generate build.xml files for ant._  
	Name: `update_configs_android`  
	Config Parameters:
	
	    update_configs_android:
	        enabled:    true
	`update_configs_android.enabled` **[bool]** - whether is module enabled for configuration

14. **Clean [Android] Module**  
	_Clean project & dependencies before build_  
	Name: `clean_android`  
	Config Parameters: nothing
15. **Bump Version [Android] Module**  
	_Bump version in android project_  
	Name: `bump_version_android`  
	Config Parameters:
	
	    bump_version_android:
	        enabled:    false
	        push:       false
	`bump_version_android.enabled` **[bool]** - whether is module enabled for 	configuration. 
	`bump_version_android.push` **[bool]** - push changes to git repo or not

16. **Build [Android] Module**  
	_Build android project_  
	Name: `build_android`  
	Config Parameters:
	
	    build_android:
	        configuration:  release
	        android_target: "Google Inc.:Google APIs:17"
	        properties_key: project_key
	        dependencies:
	            - dep1
	            - dep2
	`build_android.configuration` **[string]** - configuration to build  
	`build_android.android_target` **[string]** - android SDK version  
	`build_android.properties_key` **[string]** - key for retrieving data for updating ant.properties file  
	`build_android.dependencies` **[list]** - project's dependencies

17. **Copy APK Module**	  
	_Copy APK file to specified directory_  
	Name: `copy_apk`  
	Config Parameters:
	
		copy_apk:
	        enabled:    false
	        output_dir: "~/Dropbox/<your_project_dir>"
	`copy_apk.enabled` **[bool]** - whether is module enabled for configuration  
	`copy_apk.output_dir` **[string]** - path to output directory

18. **Template File Module**  
	_Copy template files with replacing placeholders with vars specified in config file_  
	Name: `template_file`  
	Config Params:
	
	    template_file:
	        enabled: true
	        files:
	            - {from: 'tpl.txt', to: 'work.txt', vars: {name: 'World', action: 'destroy'}}
	Template file example:
	
		Hello {name},
		Trololo on you!
		piu piu {action}!
	`template_file.enabled` **[bool]** whether is module enabled for configuration  
	`template_file.files` **[array]** array of hashes with required params: **from** - path to template file, **to** - path for output file, **vars** - hash with var names and its values

