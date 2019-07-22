Controller         'serial_main_ctrl',
  info:          'Serial main Controller'
  desc:          'This component implements the control of a Serial Port'
  extends:       ['BaseController']
  abstract:      false
  uses:          ["ocs_core_fwk", "ocs_ctrl_fwk"]

  input_ports:
    device_data_in:
      desc:            'Serial data computer <- device'
      type:            'string'
      protocol:        'pull'
      max_rate:        1000
      blocking_mode:   'async'
      owner: true

  output_ports:
    device_data_out:
      desc:            'Serial data computer -> device'
      type:            'string'
      protocol:        'pull'
      max_rate:        1000
      blocking_mode:   'async'
      owner: false

  properties:
    uri:       {default: "gmt://127.0.0.1/controltest_dcs"}
    name:      {default: "serial_main_ctrl"}
    host:      {default: "127.0.0.1"}
    port:      {default: 9001}
    scan_rate: {default: 100}

  instance_configurations: ['serial_main_ctrl']
