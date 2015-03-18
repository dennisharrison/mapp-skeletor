Template.userBio.onCreated ->
  userId = Session.get('_editUser')
  this.subscribe('allUsers', {_id: userId})

Template.userBio.helpers
	user: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})
    return _user

Template._userBioBackHeaderButton.helpers
	id: ->
    _editUser = Session.get('_editUser')
    return _editUser

Template._userBioBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()


Template._userBioDoneHeaderButton.events
  'click .bio-done-button': (event, template) ->
#    The ID of the record we are working with
    _id = Session.get('_editUser')
    #    Things we need data from
    _data = {}
    _data._id = _id
    _data['bio'] = $('textarea#edit-bio').editable('getHTML', false, true)

    Meteor.call 'updateUser', _data, (err, data) ->
      if err
        throw new Meteor.error("ERROR", err)
      if data
        _userHistory.goToUrl("/user/#{_id}")
