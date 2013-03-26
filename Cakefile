cp    = require 'child_process'

task 'build', ->
  cp.spawn 'coffee', ['--compile', '--bare', 'needless.coffee'], {stdio: 'inherit'}

task 'test', "Run the tests using mocha", ->
  invoke 'build'
  mocha = 'node_modules/mocha/bin/mocha'
  args = [
    '--compilers', 'coffee:coffee-script'
    '--reporter', 'spec'
    '-colors'
  ]
  cp.spawn mocha, args, {stdio: 'inherit'}

task 'make', "Alias for 'build'", -> invoke 'build'
