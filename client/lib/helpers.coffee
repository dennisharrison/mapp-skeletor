Template.mmInputToggle.helpers
  checked: ->
    if this.value is true
      return 'checked'
    else
      return''

Template.mmInputRichText.helpers
	value: ->
		console.log(this)
		if this.value?

			return new Spacebars.SafeString(this.value)

Template.mmInputRichText.rendered = ->
	$('textarea.mmInputRichTextArea').editable({
      inlineMode: false
    })

Template.mmInputToggle.events
  'click label.toggle.toggle-balanced': (event, template) ->