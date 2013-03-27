###
Copyright (c) 2013, Peter-Paul van Gemerden <info@ppvg.nl>
License: Simplified BSD (2-clause)
         http://opensource.org/licenses/BSD-2-Clause
###

path = require 'path'

### Calls needless on itself. See the end of this file for clarification. ###
inception = -> needless module.filename

module.exports = needless = (moduleName) ->
  ###
  Removes a module and all its children from the require cache.
  ###
  throwErrorIfCircularReference()
  parent = getModuleFromCache moduleName
  if parent?
    deleteModule mod for mod in getDescendants parent
    return true
  return false

throwErrorIfCircularReference = ->
  if circularReference()
    error = new Error 'Found a circular reference. Did you run `cake` on a directory?'
    error.code = 'CIRCULAR_REFERENCE'
    throw error

circularReference = ->
  ###
  Returns true if any module in the require cache has itself as parent.
  ###
  for key, mod of require.cache when mod.filename is mod.parent?.filename
    if mod.filename is mod.parent?.filename
      return true
  return false

getModuleFromCache = (name) ->
  if isRelativePath name then name = toFullPath name
  modulePath = require.resolve name
  require.cache[modulePath]

isRelativePath = (name) -> (name.indexOf './') is 0

toFullPath = (relativePath) ->
  parentDirname = path.dirname module.parent.filename
  path.join parentDirname, relativePath

getDescendants = (parent) ->
  ###
  Returns array with parent and all direct and indirect descendents.
  ###
  descendants = []
  do recurse = (parent) ->
    descendants.push parent
    parent.children.forEach recurse
  descendants

deleteModule = (mod) ->
  delete require.cache[mod.id]
  deleteModuleFromParent mod

deleteModuleFromParent = (mod) ->
  ###
  Removes the given module from its parent's `.children`.
  ###
  for child, i in mod.parent.children by -1 when child.id is mod.id
    # Iterate backwards because of splice ^
    mod.parent.children.splice i, 1

###
Calling `needless` on itself allows us to re-require needless in nested
modules, without having to worry about relative paths.
###
inception()
