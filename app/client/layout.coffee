# Template.layout.rendered = () ->
#   Session.set('width', $('.snap-drawers').width())
#
#   $(window).resize () ->
#     Session.set('width', $('.snap-drawers').width())
#
#   Tracker.autorun () ->
#     if Session.get('width') >= 768
#       $('.snap-content').css('-webkit-transform', 'translate3d(266px, 0px, 0px)')
#       width = $('.snap-content').width() - 266
#       $('.snap-content').css('width', "#{width}px")
#       Session.set('_showWhenSideMenuOpen', false)
#     else
#       $('.snap-content').css('-webkit-transform', 'translate3d(0px, 0px, 0px)')
#       $('.snap-content').css('width', "100%")
#       Session.set('_showWhenSideMenuOpen', true)

Template.layoutSideMenu.events
  'click a': (event, template) ->
    event.preventDefault()
    ui = $(event.currentTarget)
    _url = ui.attr("href")
    _userHistory.goToUrl(_url)
