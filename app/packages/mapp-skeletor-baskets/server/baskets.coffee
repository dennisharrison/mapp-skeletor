console.log "Adding baskets"

Meteor.publish 'baskets', (options) ->
  # define some defaults here
  search = {}
  defaultOptions =
    sort:
      title: 1

  if Object.isObject options
    if options.search
      Object.merge(search, options.search)

    if options.options
      Object.merge(defaultOptions, options.options)

  else
    options = defaultOptions

  _baskets = Baskets.find(search, options)
  return _baskets
