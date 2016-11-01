var jsonServer = require('json-server')
var pause = require('connect-pause')

// Returns an Express server
var server = jsonServer.create()

// Set default middlewares (logger, static, cors and no-cache)
server.use(jsonServer.defaults())
// Add in a delay to make this more realistic
server.use(pause(1000))

var router = jsonServer.router('db.json')
server.use(router)

console.log('Listening at 4000')
server.listen(4000)
