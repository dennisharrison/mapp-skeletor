Template.showWhenSideMenuOpen.helpers
  'show': ->
    show = Session.get('_showWhenSideMenuOpen')
    return show
