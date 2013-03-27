                         _ _
     _ __   ___  ___  __| | | ___  ___ ___
    | '_ \ / _ \/ _ \/ _` | |/ _ \/ __/ __|
    | | | |  __/  __/ (_| | |  __/\__ \__ \
    |_| |_|\___|\___|\__,_|_|\___||___/___/


This tiny little module allows you to remove modules from the `require` cache, easily and reasonably reliably. It can be used to do live code reloading in situations where the parent process **must** keep running. Works with JavaScript and CoffeeScript (but **keep the [known weird stuff][#weird_stuff] in mind**).

It's kind of a hack, so before dumping this in your project and calling it a day, read on!


When (not) to use this
----------------------

As mentioned above, `needless` can be used when it's unpractical to stop the parent process. For instance, I use it to reload plugins for an IRC bot. If the bot's process would be restarted, it would have to reconnect to the server. People on IRC generally don't like blinkenbots.

So. Two genuine use cases for this module:

1. Unit testing, although I would recommend using [mockery](mockery) or [sandboxed-module](sandbox) instead.
2. Live code reloading, when [node-supervisor](supervisor) isn't good enough.

  [mockery]: https://github.com/mfncooper/mockery
  [sandbox]: https://github.com/felixge/node-sandboxed-module
  [supervisor]: https://github.com/isaacs/node-supervisor


Arguments against messing with `require.cache`
----------------------------------------------

There are two good reasons **not** to use this module:

1. It's not officially supported. The `require` API is really stable ("[Stability: 5 - Locked][api]", in fact), but its internals might change, causing your software to explode and splatter broken bits all over your nice desktop wallpaper.
2. If you have a complicated require chain (for example: another module `require`d the same, now unloaded, module), it might behave unpredictably.

  [api]: http://nodejs.org/api/modules.html#modules_modules


How to use this
---------------

Easy! Let me show you using this hilariously contrived example!

```
// child.js
module.exports = 42;
```

```
// parent.js
var needlss = require('needless');

setInterval(function() {
  needless('./child');
  console.log(require('./child'));
}, 2000);
```

Now run `parent.js`:

```
$ node parent
42
42
42
(etc.)
```

Now, without stopping `node`, edit `child.js`. The `node` process should reflect the change:

```
42
42
<<< change child.js >>>
"Not 42"
"Not 42"
"Not 42"
(etc.)
```

"Wow Bob, that looks real easy!"<br />
"You betcha! And if you install within the next 5 minutes, we'll throw in a free .coffee!"


Known weird stuff<a id="weird_stuff"></a>
-----------------------------------------

**Do not use `coffee ./directory`.****

This is the biggest weird thing I ran into. Unline `node`, and unlike the `require` system, CoffeeScript's command-line utility will, when given a direcory as target, **run all files** inside a directory, instead of only `index.coffee` or `index.js`. This is a [known "feature"][bug], and it only happens with `coffee`, not with `node`.

  [bug]: https://github.com/jashkenas/coffee-script/issues/2496

One solution is not to call `coffee` on a directory. So instead of `coffee ./myMod`, use `coffee ./myMod/index.coffee` (or `cd ./myMod` and then `coffee index`). Another solution is to use [CoffeeScriptRedux][redux], although at the time of writing, I have no idea how stable/usable that is.

  [redux]: https://github.com/michaelficarra/CoffeeScriptRedux

I've tested `needless` with various scenario's (including nested modules, relative paths, etc.), but there are things I haven't tested, like genuine _intentional_ cyclic dependencies. So please keep that in mind, and feel free to [open an issue on GitHub] if something doesn't work like you thought it would.

  [issue]: https://github.com/PPvG/node-needless/issues


Why CoffeeScript?
-----------------

Because I happen to like CoffeeScript and because it hilariously enrages some other people. I call that win-win. By the way: the usual argument against CoffeeScript is that it compiles into hard-to-read JavaScript (which is sometimes true, but more so if you write tricky CoffeeScript in the first place). Having said that, go and have a look at `needless.js`. I think it's pretty darn readable.


License
-------

Simplified BSD (2-clause). See LICENSE.
