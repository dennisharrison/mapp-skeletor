#Media
This package provides an Ionic media view for your Meteor application.

##Configuration
If you set the following session variables you can change the behavior of the package. Defaults are provided.

 - `mediaOwnerId` - The collection independent media owners ID
 
```
 userMediaSetup =
   mm_media_route_path: "/user/:id/media"
   mm_media_route_name: 'userMedia'
   mm_media_route_template: 'mm_media'
   mm_media_back_header_button_url_base: '/user'
 
 Meteor.startup ->
   CreateMediaRoutes(userMediaSetup)
```
 
```
 Template.user.helpers
   mediaUrl: ->
     _editUser = Session.get('_editUser')
     "/user/#{_editUser}/media"
```

```
{{>mm_media_control url=mediaUrl}}
```     
