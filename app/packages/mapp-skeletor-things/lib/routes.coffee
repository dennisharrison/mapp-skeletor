Router.map ->
  @route 'things',
    path: '/things'
    action: ->
      # Wait on collections
      @wait Meteor.subscribe('things')
      @render 'things'

  @route 'thing',
    path: '/thing/:id'
    action: ->
      # Wait on collections
      Session.set("_thingId", @params.id)
      @wait Meteor.subscribe('things', {_id: @params.id})
      @render 'thingEdit'

  @route 'thingDescription',
    path: '/thing/:id/description'
    action: ->
      Session.set('_thingId', @params.id)
      @wait Meteor.subscribe('things', {_id: @params.id})
      @render 'thingDescription'

  @route 'userThings',
    path: '/user/:id/things'
    action: ->
      # Wait on collections
      @wait Meteor.subscribe('things', {userId: @params.id})
      @render 'things'
