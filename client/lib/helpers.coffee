Template.mmInputToggle.helpers
  checked: ->
    if this.value is true
      return 'checked'
    else
      return''

Template.mmInputToggle.events
  'click label.toggle.toggle-balanced': (event, template) ->
    console.log this