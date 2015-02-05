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

Template.mmNextPage.helpers
  classes: -> 
    classes = ['item-icon-right']
    if this.class?
      customClasses = this.class.split(' ')
      for klass in customClasses
        classes.push(klass)
    return classes.join(' ')
