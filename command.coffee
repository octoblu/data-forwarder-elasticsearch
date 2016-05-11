Server = require './src/server'

server = new Server {port: process.env.PORT || 80}

server.run (error) =>
  return @panic error if error?
  {address,port} = server.address()


process.on 'SIGTERM', =>
  console.log 'SIGTERM caught, exiting'
  server.stop =>
    process.exit 0
