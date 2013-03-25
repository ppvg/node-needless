(function() {
  var needless, searchCache;

  module.exports = needless = function(moduleName) {
    /* Removes a module and all its children from the require cache.
    */

    var error;

    try {
      return searchCache(moduleName, function(module) {
        return delete require.cache[module.id];
      });
    } catch (_error) {
      error = _error;
      return true;
    }
  };

  searchCache = function(moduleName, callback) {
    /* Searches through the cache to find a module and all its children.
        Calls the callback on each of the found modules.
    */

    var module, path, recurse;

    path = require.resolve(moduleName);
    module = require.cache[path];
    if (module != null) {
      return (recurse = function(module) {
        module.children.forEach(recurse);
        return callback(module);
      })(module);
    }
  };

}).call(this);
