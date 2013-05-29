Q: Android build signing has failed  
A: You need a key for signing. Ask somebody to generate it on build server. And provide `build_android.properties_key` (preferable to set it as <your_jenkins_job_name>) value from your build configuration file.

Q: Android build has failed  
A: Check previous answer, if it doesn't help - scream.

Q: Android build has failed  
A: All dependencies (libs) should be listed in `build_android.dependencies`
