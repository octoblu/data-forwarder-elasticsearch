cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
errorHandler       = require 'errorhandler'
sendError          = require 'express-send-error'
cookieParser       = require 'cookie-parser'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
expressVersion     = require 'express-package-version'
MeshbluConfig      = require 'meshblu-config'
Router             = require './router'

class Server
  constructor: ({@disableLogging, @port, @serviceUrl}, {@meshbluConfig}={})->
    @meshbluConfig ?= new MeshbluConfig().toJSON()
    @serviceUrl    ?= process.env.SERVICE_URL

  address: =>
    @server.address()

  run: (callback) =>
    app = express()
    app.use meshbluHealthcheck()
    app.use expressVersion(format: '{"version": "%s"}')
    app.use morgan 'dev', immediate: false unless @disableLogging
    app.use cors()
    app.use errorHandler()
    app.use cookieParser()
    app.use sendError()
    app.use bodyParser.urlencoded limit: '50mb', extended : true
    app.use bodyParser.json limit : '50mb'

    app.options '*', cors()

    imageUrl   = 'https://s3-us-west-2.amazonaws.com/octoblu-icons/forwarder/elasticsearch.svg'
    deviceType = 'forwarder:elasticsearch'

    router = new Router {@serviceUrl, @meshbluConfig, imageUrl, deviceType}

    router.route app

    @server = app.listen @port, callback

  stop: (callback) =>
    @server.close callback

module.exports = Server
