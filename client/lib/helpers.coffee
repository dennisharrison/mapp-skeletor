Template.mmInputToggle.helpers
  checked: ->
    if this.value is 'on'
      return 'checked'
    else
      return''

Template.mmInputToggle.events
  'click .item-toggle.label.track.handle': (event, template) ->
    console.log this



