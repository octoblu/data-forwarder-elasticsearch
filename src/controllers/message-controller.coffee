debug       = require('debug')('data-forwarder:data-forwarder-elasticsearch')
_           = require 'lodash'
MeshbluHttp = require 'meshblu-http'
Elasticsearch  = require '../models/elasticsearch-model'

class MessageController

  message: (req, res) =>
    message = req.body
    meshblu = new MeshbluHttp req.meshbluAuth
    @getDeviceConfig meshblu, (error, device) =>
      return res.sendError(error) if error?
      {forwarderConfig} = device
      return res.sendStatus 422 unless forwarderConfig?
      elasticsearch = new Elasticsearch
      elasticsearch.onMessage {message, forwarderConfig}, (error) =>
        return res.sendError error if error?
        res.sendStatus 201

  getDeviceConfig: (meshblu, callback) =>
    meshblu.whoami (error, device) =>
      return callback error if error?
      callback null, device

module.exports = MessageController
