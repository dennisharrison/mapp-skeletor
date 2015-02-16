Router.map ->
  @route 'things',
    path: '/things'
    action: ->
      Session.set("lastThingsUrl", @request.url)
      # Wait on collections
      @wait Meteor.subscribe('things')
      @render 'things'

  @route 'thing',
    path: '/thing/:id'
    action: ->
      _relationshipBackToParentUrl = Session.get('relationshipBackToParentUrl')
      if _relationshipBackToParentUrl?
        Session.set("lastThingsUrl", _relationshipBackToParentUrl)

      if not _lastThingsUrl?
        _lastThingsUrl = "/things"
        Session.set("lastThingsUrl", _lastThingsUrl)


      Session.set("_thingId", @params.id)
      # Wait on collections
      @wait Meteor.subscribe('things', {_id: @params.id})
      @render 'thingEdit'

  @route 'newThing',
    path: '/things/new'
    action: ->
      Session.set("_thingId", null)
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
      Session.set("lastThingsUrl", @request.url)
      # Wait on collections
      @wait Meteor.subscribe('things', {userId: @params.id})
      @render 'things'
