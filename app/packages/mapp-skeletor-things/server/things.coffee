console.log "Adding things"

Meteor.publish 'things', (options) ->
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

  _things = Things.find(search, options)
  return _things
