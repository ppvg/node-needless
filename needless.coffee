module.exports = needless = (moduleName) ->
  ### Removes a module and all its children from the require cache. ###

  try
    searchCache moduleName, (module) ->
      delete require.cache[module.id]
  catch error
    true # Module doesn't exist. Nothing to do here. :)


searchCache = (moduleName, callback) ->
  ### Searches through the cache to find a module and all its children.
      Calls the callback on each of the found modules. ###

  path = require.resolve moduleName # Finds module's filesystem path
  module = require.cache[path]

  if module? then do recurse = (module) ->
    # Recursively go over each of the module's children
    module.children.forEach recurse
    callback module
