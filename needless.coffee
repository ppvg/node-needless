path = require 'path'


module.exports = needless = (moduleName) ->
  ### Removes a module and all its children from the require cache. ###

  try
    searchCache moduleName, (mod) ->
      delete require.cache[mod.id]
  catch error
    true # Module doesn't exist. Nothing to do here. :)


searchCache = (moduleName, callback) ->
  ### Searches through the cache to find a module and all its children.
      Calls the callback on each of the found modules. ###

  mod = getModuleFromCache moduleName

  if mod? then do recurse = (mod) ->
    # Recursively go over each of the module's children
    mod.children.forEach recurse
    callback mod


getModuleFromCache = (name) ->
  if isRelativePath name then name = toFullPath name
  modulePath = require.resolve name
  require.cache[modulePath]

isRelativePath = (name) -> (name.indexOf './' is 0)

toFullPath = (relativePath) ->
  parentDirname = path.dirname module.parent.filename
  path.join parentDirname, relativePath
