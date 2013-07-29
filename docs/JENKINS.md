### Jenkins project setup

1. Add new job with title as your app's name. 
2. Add build parameter of type "choice" with name `CONFIGURATION` and list of configurations from your `builder.yml` file.
3. _(Optional)_ Add build parameter "text" with name `BUILD_NOTES` if you use `hockeyapp` or `testflight` module and want to specify build notes for build.
4. Add git repo of your project.
5. _(Optional)_ Setup build schedule.
6. Add build step "execute shell" and paste that into it 

		git checkout master
		git pull origin master
		builder build
7. Click save button.

Now you can build it.
