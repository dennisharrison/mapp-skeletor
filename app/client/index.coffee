#Push.addListener('token', (token) ->
#  alert(JSON.stringify(token))
#)

#When messages opens the app:
Push.addListener('startup', (notification) ->
  alert(JSON.stringify(notification.payload))
)

#When messages arrives in app already open:
Push.addListener('message', (notification) ->
  alert(JSON.stringify(notification.payload))
)
