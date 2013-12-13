Rake tasks for utility purposes  
To see all available tasks execute in console `rake -T`

### Android Apps

1. List available apps  
	`rake apps:list`
2. Add new app (generate keystore for signing builds)  
	`rake apps:add[app_name,password]` - pass Application name as `app_name` parameter (without spaces) and `password` for keystore  
	**Example:** `rake apps:add[mega_application,super_password]`  
3. Get sha1 hash for application's keystore  
	`rake apps:hash:sha1[app_name]` - pass Application name as `app_name` parameter  
	**Example:** `rake apps:hash:sha1[mega_application]`
4. Get base64 hash for application's keystore  
	`rake apps:hash:base64[app_name]` - pass Application name as `app_name` parameter  
	**Example:** `rake apps:hash:base64[mega_application]`
	

### Xcode

1. Switch Xcode version  
	`rake xcode:switch[version]` - pass Xcode's version as `version` parameter, these versions should be previously set up in system wide config file `~/.bs_modulo.yml` under `xcode` section  
	**Example:** `rake xcode:switch[v5]`
