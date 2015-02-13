Meteor.subscribe('media', {"metadata.user": Session.get('_editUser')})

Template.userMedia.helpers
	user: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})
    return _user
  media: ->
    _editUser = Session.get('_editUser')
    if _editUser?
    	_media = Media.find({"metadata.user": _editUser}, {sort: {updatedAt: 1}}).fetch()
    	return _media

Template._userMediaBackHeaderButton.helpers
	id: ->
    _editUser = Session.get('_editUser')
    return _editUser

Template._userMediaAddHeaderButton.helpers
	id: ->
    _editUser = Session.get('_editUser')
    return _editUser

#Template._userMediaAddHeaderButton.events
#	'click .media-add-button': (event, template) ->
#     console.log("_userMediaAddHeaderButton")
#     _input = template.find('input')
#     $(_input).click()
#
#   'change #file': (event, template) ->
#   	_form = template.find('form')
#   	console.log $(_form)
#   	$(_form).submit()


Template._mediaRow.helpers
  isMobile: ->
    navigator.userAgent.match(/(ip(hone|od|ad))/i)

Template._userMediaAddHeaderButton.events
  'click .media-add-button': (event, template) ->
    console.log("_userMediaAddHeaderButton")
    _input = template.find('input')
    $(_input).click()

  'change input[type=file]': (event,template) ->
    console.log 'Upload started'

    FS.Utility.eachFile event, (file) ->
      fsFile = new FS.File(file)
      console.log Object.keys(fsFile.original)
      fsFile.metadata =
        name: file.name
        size: file.size
        type: file.type
        timestamp: Math.round(new Date().getTime() / 1000)
        user: Session.get('_editUser')
        complete: false
        from_ios: navigator.userAgent.match(/(ip(hone|od|ad))/i)
      console.log 'Uploading File:' + fsFile.metadata.name
      data = Media.insert fsFile, (err, fileObj) ->
        if err?
          console.log err
        if fileObj?
          console.log 'Upload complete!'

      return
