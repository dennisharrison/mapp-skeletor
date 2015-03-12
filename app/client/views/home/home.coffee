Template.home.helpers
  homeViewTemplate: () ->
    getHomeViewTemplate = Session.get("homeViewTemplate")
    if getHomeViewTemplate?
      return getHomeViewTemplate
    else
      return "defaultHome"

Template.defaultHome.helpers
  times: () ->
    return Number.range(0,25).every()
