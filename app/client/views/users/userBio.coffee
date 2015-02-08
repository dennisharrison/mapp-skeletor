Template.userBio.helpers
	user: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})
    return _user

Template._userBioBackHeaderButton.helpers
	id: ->
    _editUser = Session.get('_editUser')
    return _editUser

Template._userBioSnapoff.events
  'click .snap-off-button': (event, template) ->
    IonSideMenu.snapper.disable()
