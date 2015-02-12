Router.map ->
  @route 'baskets',
    path: '/baskets'
    action: ->
      Session.set("lastBasketsUrl", @request.url)
      # Wait on collections
      @wait Meteor.subscribe('baskets')
      @render 'baskets'

  @route 'basket',
    path: '/basket/:id'
    action: ->
      _lastBasketsUrl = Session.get("lastBasketsUrl")
      if _lastBasketsUrl?
        console.log(_lastBasketsUrl)
      else
        console.log("No Baskets!")
        _userId = Meteor.userId()
        if _userId?
          Session.set("lastBasketsUrl", "/user/#{_userId}baskets/")
        else
          Session.set("lastBasketsUrl", "/baskets")

      Session.set("_basketId", @params.id)
      # Wait on collections
      @wait Meteor.subscribe('baskets', {_id: @params.id})
      @render 'basketEdit'

  @route 'newBasket',
    path: '/baskets/new'
    action: ->
      Session.set("_basketId", null)
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
      Session.set("lastBasketsUrl", @request.url)
      # Wait on collections
      @wait Meteor.subscribe('baskets', {userId: @params.id})
      @render 'baskets'
