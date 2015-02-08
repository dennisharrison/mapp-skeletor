$.Editable.DEFAULTS.key = false

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
  $('textarea.mmInputRichTextArea').editable
    theme: 'custom'
    inlineMode: false
    minHeight: 300
    maxHeight: Math.max(document.documentElement.clientHeight, window.innerHeight or 0) - 80

  $('textarea.mmInputRichTextArea').on 'editable.focus', (e, editor) ->
    console.log("GOT FOCUS")



Template.mmNextPage.helpers
  classes: ->
    classes = ['item-icon-right']
    if this.class?
      customClasses = this.class.split(' ')
      for klass in customClasses
        classes.push(klass)
    return classes.join(' ')
