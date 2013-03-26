                         _ _
     _ __   ___  ___  __| | | ___  ___ ___
    | '_ \ / _ \/ _ \/ _` | |/ _ \/ __/ __|
    | | | |  __/  __/ (_| | |  __/\__ \__ \
    |_| |_|\___|\___|\__,_|_|\___||___/___/


This tiny little module allows you to remove modules from the `require` cache, easily and reasonably reliably. It can be used to do live code reloading in situations where the parent process **must** keep running. Works with JavaScript and CoffeeScript (but keep the [known weird stuff][#weird_stuff] in mind).

It's kind of a hack, so before dumping this in your project and calling it a day, read on!


When (not) to use this
--------------------------

As mentioned above, `needless` can be used when the parent process can't possibly be stopped. For instance, I use it to reload plugins for an IRC bot. If the bot's process would be restarted, it would have to reconnect to the server. People on IRC generally don't like blinkenbots.

So. Two genuine use cases for this module:

1. Unit testing.
2. Live code reloading if and only if there's No Other Way.

For unit testing, there are some really nice frameworks that do the same thing and more, like [mockery](https://github.com/mfncooper/mockery) and [sandboxed-module](https://github.com/felixge/node-sandboxed-module).

If you don't _really_ need to keep the parent process running, there are some great **stable** hot code reloading modules, like [node-supervisor](https://github.com/isaacs/node-supervisor). But if you're reading this, you probably already know that.


Why (not) to use this
-------------------------

Reasons to use this module include "living dangerously" and "because I can", amongst others.

There are two good reasons **not** to use it:

1. It's not officially supported. The `require` API is really stable ("[Stability: 5 - Locked][modules]", in fact), but its internals might change, causing your software to explode and splatter broken bits all over your nice desktop wallpaper.
2. If you have a complicated require chain (for example: another module `require`d the same, now unloaded, module), it might behave unpredictably. Though if all you do is "a requires b requires c", you'll probably be OK.
3. People on the internet will hate you.

OK, so I made that last one up.

  [modules]: http://nodejs.org/api/modules.html#modules_modules


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
-----------------

Be careful when using CoffeeScript, because it sometimes breaks the require chain. The most notable case is when you `require` an entire folder. It seems like only `index.coffee` is loaded, but in reality CoffeeScript loads **all files** in the folder!

So instead of `require "./myMod"`, do `require "./myMod/index.coffee"`. The same goes for running files from the terminal; use `coffee ./myMod/index` (or `cd ./myMod` and then `coffee index`).

With regular Node.js, this weird problem doesn't occur.


Why CoffeeScript?
-----------------

Because I happen to like CoffeeScript, while it hilariously enrages some other people. I call that win-win. By the way: the usual argument against CoffeeScript is that it compiles into hard-to-read JavaScript (which is sometimes true, but more so if you write tricky CoffeeScript in the first place). Having said that, go and have a look at `needless.js`.


License
-------

Simplified BSD (2-clause). See LICENSE.
