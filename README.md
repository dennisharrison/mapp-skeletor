# mapp-skeletor

## Installation

1. Clone this repo
2. Modify
3. Deploy
4. Profit :)

### GraphicsMagic
On OSX `brew install graphicsmagick`

## Example settings.json
Place settings.json in app directory
```json
{
	"aws": {
		"accessKeyId": "AWSAccessKeyID",
		"secretAccessKey": "AWSAccessKeySecret",
		"bucket": "your-awesome-bucket-name"
	},
	"uploader": {
		"directory": "/path/to/uploads/on/filesystem"
	},
  "public": {
    "backgroundImageOptions": {
      "FlickrAPIKey": "YourFlickrAPIKey",
      "tags": "Amazing Sunset",
      "interval": 60000
    }
  }
}

```

## Example iOS Build Command
```
meteor run ios-device --mobile-server 192.168.42.11:3000 --settings settings.json
```

## Example Push Notification
```
Push.send({from: 'push',title: 'Hello World',text: 'This notification has been sent from the SERVER',badge: 11,sound: "default",payload: {title: 'Hello World',historyId: 99},query: {}});
```
