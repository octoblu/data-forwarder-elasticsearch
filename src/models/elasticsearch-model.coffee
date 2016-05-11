class Elasticsearch
  constructor: ->
    console.warn 'implement Elasticsearch.onMessage if you want this service to actually do something.'

  onMessage: ({message, device}, callback) =>
    console.warn 'implement Elasticsearch.onMessage if you want this service to actually do something.'
    console.log JSON.stringify {message,device}, null, 2
    callback()

module.exports = Elasticsearch
