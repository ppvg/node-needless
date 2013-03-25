flour = require 'flour'
cp    = require 'child_process'

mochaArgs = [
  '--compilers', 'coffee:coffee-script'
  '-r', 'test/common'
  '-c'
]
mochaPath = 'node_modules/mocha/bin/mocha'

task 'build', ->
  compile "needless.coffee", "needless.js"

task 'test', "Run the tests using mocha", ->
  invoke 'build'
  args = mochaArgs.concat ['--reporter', 'spec']
  cp.spawn mochaPath, args, {stdio: 'inherit'}

task 'make', "Alias for 'build'", -> invoke 'build'
