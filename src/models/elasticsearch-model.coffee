request = require 'request'
class Elasticsearch
  onMessage: ({message, device}, callback) =>
    {url, username, password} = device
    options =
      url: device.url
      json: message

    options.auth = {username, password} if username? || password?
    request.post options
    
    callback()

module.exports = Elasticsearch
