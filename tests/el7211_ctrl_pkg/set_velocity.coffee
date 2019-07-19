#!/usr/bin/coffee

msgpack = require 'msgpack-lite'
nn=require 'nanomsg'

sleep = (ms) ->
  start = new Date().getTime()
  continue while new Date().getTime() - start < ms

sendval = (host, port, val) ->
  console.log "Sending value " + val + " to " + port
  packed_val = msgpack.encode (val)
  s = new nn.Socket ('push')
  url = 'tcp://' + host + ':' + port
  s.connect url
  s.send packed_val
  console.log 'Done!'

#ports
port = 10166

# Actuator Enable
val = process.argv[2]

send_sdo = () ->
  console.log 'Setting velocity to', val
  sendval '127.0.0.1', port, val


send_sdo()
