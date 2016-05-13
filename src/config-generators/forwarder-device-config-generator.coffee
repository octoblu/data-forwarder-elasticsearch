_ = require 'lodash'
module.exports = ({authorizedUuid, deviceType, imageUrl, serviceUrl, name, config}) ->
  device =
    name: name
    type: deviceType
    logo: imageUrl
    serviceUrl: serviceUrl
    forwarder:
      version: '1.0.0'
    meshblu:
      version: '2.0.0'
      forwarders:
        message:
          received: [{
            type: 'webhook'
            url:  "#{serviceUrl}/messages"
            method: 'POST'
            generateAndForwardMeshbluCredentials: true
          }]

      schemas:
        configure:
          url: "#{serviceUrl}/schemas/v1/configure.json"

      whitelists:
        broadcast:
          as:       [{uuid: authorizedUuid}]
          received: [{uuid: authorizedUuid}]
          sent:     [{uuid: authorizedUuid}]
        configure:
          as:       [{uuid: authorizedUuid}]
          received: [{uuid: authorizedUuid}]
          sent:     [{uuid: authorizedUuid}]
          update:   [{uuid: authorizedUuid}]
        discover:
          view:     [{uuid: authorizedUuid}]
          as:       [{uuid: authorizedUuid}]
        message:
          as:       [{uuid: authorizedUuid}]
          received: [{uuid: authorizedUuid}]
          sent:     [{uuid: authorizedUuid}]
          from:     [{uuid: authorizedUuid}]

  return _.extend device, config
