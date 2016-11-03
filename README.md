# ru_sabnzbd Cookbook

This cookbook is used to setup sabnzbdplus on ubuntu/debian based machine. Currently, it only supports for local machine within your network

## Requirements

Required ru_baseline cookbook for resources

e.g.
### Platforms

- ubuntu-14

### Chef

- Chef 12.0 or later

### Cookbooks

## Attributes

There's no attributes required for this cookbook

## Usage

### ru_sabnzbd::default

Default recipe sets passwordless authentication, install sabnzbdplus, mount your network folder (ideally your file server) and set static IP address. It requires a data bag called sabnzbd and inside there are four data bag items as per below.
1) admin.json
```json
{
	"id":"admin",
	"username":"your_username",
	"public_keys": ["your_public_key"]
}
```
2) network.json
```json
{
	"id":"network",
	"static_ip":"x.x.x.x",
	"device_name":"eth0",
	"mask":"x.x.x.x",
	"network":"x.x.x.x",
	"bcast":"x.x.x.x"
}
```
3) sabnzbd.json
```json
{
	"id":"data_bag_item_sabnzbd_settings",
	"cleanup_list":".sfv, .srr, .nfo, .nbz, md5, nzb, .par, .par2, .lnk, idx, .sub, .url",
	"api_key":"",
	"password":"",
	"port":"8080",
	"host":"0.0.0.0",
	"categories": {
		"tv": {
			"cat_priority" : "0",
			"cat_pp" : "3",
			"cat_name" : "tv",
			"cat_script" : "Default",
			"cat_newzbin" : "tv",
			"cat_dir" : "/tv/*"
		}
	},
	"servers": {
		"astraweb": {
			"server_username" : "",
			"server_enable" : "",
			"server_host" : "",
			"server_ssl" : "",
			"server_fillserver" : "",
			"server_connections" : "",
			"server_timeout" : "",
			"server_password" : "",
			"server_optional" : "",
			"server_port" : "",
			"server_retention" : ""
		}
	}
}
```
4) smb.json


e.g.
Just include `ru_sabnzbd` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ru_sabnzbd]"
  ]
}
```
## License and Authors

Authors: Rinaldi Utomo
