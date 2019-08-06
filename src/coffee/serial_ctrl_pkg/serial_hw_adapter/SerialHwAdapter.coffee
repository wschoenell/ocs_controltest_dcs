{Component, PeriodicBehavior} = require 'ocs_core_fwk'

SerialPort = require 'serialport'
Delimiter = require('@serialport/parser-delimiter')

# add write behavior
class SerialBehavior extends PeriodicBehavior

  constructor: (options = {}) ->
    super options
    {@port, @port_clear} = options

  apply: (d, dt) ->
    super(d, dt) if super.apply
    return if (@disabled or not @must_apply)
    if d.value isnt null
      @port.write(d.value, @port_clear)


class SerialHwAdapter extends Component

  serial_err: =>
    console.log("error connecting " + @properties.port_file_path.value)
#    throw("error connecting " + @properties.port_file_path.value)

  serial_open: =>
    @log.info @, "port open"

  serial_data_in: (data) =>
    @log.debug @, "data received: " + data
    @outputs.device_data_in.set(data.toString())
# todo: timestamp

  clear_input_port: () =>
    @inputs.device_data_out.set(null)

  setup: =>
    super()

    # Create serial port instance
    port = new SerialPort(@properties.port_file_path.value, @properties.baud_rate.value) #115200)
    port.on("open", @serial_open)
    port.on("error", @serial_err)

    # Parse input
    parser = new Delimiter({delimiter: @properties.delimiter.value}) #@properties.delimiter.value})
    port.pipe(parser)
    parser.on("data", @serial_data_in)

    # Add output Behavior
    @inputs.device_data_out.behaviors.add new SerialBehavior {
      name: "device_data_out_bh",
      src: "#{@name}/i/device_data_out/value",
      port: port,
      port_clear: @clear_input_port
    }

  step: =>
    super()


module.exports = {SerialHwAdapter}
