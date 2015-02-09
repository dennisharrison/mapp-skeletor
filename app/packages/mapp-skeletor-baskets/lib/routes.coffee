Router.map ->
  @route 'baskets',
    path: '/baskets'
    action: ->
      # Wait on collections
      @wait Meteor.subscribe('baskets')
      @render 'baskets'

  @route 'basket',
    path: '/basket/:id'
    action: ->
      # Wait on collections
      Session.set("_basketId", @params.id)
      @wait Meteor.subscribe('baskets', {_id: @params.id})
      @render 'basketEdit'

  @route 'basketDescription',
    path: '/basket/:id/description'
    action: ->
      Session.set('_basketId', @params.id)
      @wait Meteor.subscribe('baskets', {_id: @params.id})
      @render 'basketDescription'

  @route 'userBaskets',
    path: '/user/:id/baskets'
    action: ->
      # Wait on collections
      @wait Meteor.subscribe('baskets', {userId: @params.id})
      @render 'baskets'
