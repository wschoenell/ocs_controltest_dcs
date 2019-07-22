Adapter 'serial_hw_adapter',
  info: 'Serial Hardware Adapter'
  desc: 'Sample Serial Hardware Adapter'
  abstract: false
  extends: ['SerialAdapter']
  uses: ["ocs_core_fwk", "ocs_io_fwk"]

  input_ports:
    rts: {
      type: 'bool',
      protocol: 'pull',
      max_rate: 10000,
      owner: true,
      default: false,
      blocking_mode: 'async',
      desc: 'request to send'
    }
    device_data_out: {
      type: 'string',
      protocol: 'pull',
      max_rate: 10000,
      owner: true,
      blocking_mode: 'async',
      desc: 'data to send to the serial port'
    }
  output_ports:
    device_data_in: {
      type: 'string',
      protocol: 'push',
      max_rate: 10000,
      owner: false,
      blocking_mode: 'async',
      desc: 'data received from the serial port'
    }


  properties:
    uri: {default: "gmt://127.0.0.1/controltest_dcs"}
    name: {default: "serial_hw_adapter"}
    host: {default: "127.0.0.1"}
    port: {default: 9000}
    scan_rate: {default: 100}
    port_file_path: {default: '/dev/ttyS0'}
    baud_rate: {default: 'B9600'}

  instance_configurations: ['serial_hw1_adapter']
