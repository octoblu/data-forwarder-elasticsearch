request = require 'request'
class Elasticsearch
  onMessage: ({message, forwarderConfig}, callback) =>
    {url, username, password} = forwarderConfig
    options =
      url: device.url
      json: message

    options.auth = {username, password} if username? || password?
    request.post options

    callback()

module.exports = Elasticsearch
