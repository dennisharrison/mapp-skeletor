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

# Template._userMediaAddHeaderButton.events
# 	'click .media-add-button': (event, template) ->
#     console.log("_userMediaAddHeaderButton")
#     _input = template.find('input')
#     $(_input).click()

#   'change #file': (event, template) ->
#   	_form = template.find('form')
#   	console.log $(_form)
#   	$(_form).submit()
