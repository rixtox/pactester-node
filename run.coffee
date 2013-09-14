dns = require 'dns'
fs = require 'fs'
vm = require 'vm'
Future = require 'fibers/future'
argv = require('optimist').argv
context = require './context'

pac = fs.readFileSync(argv._[0]).toString()

context.isResolvable = (host) ->
  try
    Fiber(->
      Future.wrap(dns.resolve)(host).wait()
    ).run()
  catch e
    return false
  return true

context.console = console
context.myIpAddress = argv.c ? '127.0.0.1'
context.retval = ''

pac += "retval = FindProxyForURL(\"#{argv.u}\", \"#{argv.h}\");"
vm.runInNewContext pac, context, argv._[0]
console.log context.retval