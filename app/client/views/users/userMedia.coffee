Meteor.subscribe('media', {userId: Session.get('_editUser')})
Template.userMedia.helpers
	user: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})
    return _user
  media: ->
    _editUser = Session.get('_editUser')
    if _editUser?
    	_media = Media.find({userId: _editUser}).fetch()
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


Template._userMediaAddHeaderButton.events
  'click .media-add-button': (event, template) ->
    console.log("_userMediaAddHeaderButton")
    _input = template.find('input')
    $(_input).click()

  'change input[type=file]': (event,template) ->
    files = event.currentTarget.files;
    # console.log parent_id, template.data

    uploaded_files = []
    console.log 'Upload started'
    FS.Utility.eachFile event, (file) ->
      fsFile = new FS.File(file)
      fsFile.metadata =
        name: file.name
        size: file.size
        type: file.type
        timestamp: Math.round(new Date().getTime() / 1000)
        user: Meteor.user()._id
        complete: false
      console.log 'Uploading File:' + fsFile.metadata.name
      data = Media.insert fsFile, (err, fileObj) ->
        console.log err
        return

      console.log 'Upload complete!'

      return
