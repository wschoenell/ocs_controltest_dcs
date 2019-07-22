Controller         'el7211_main_ctrl',
  info: 'EL7211 main Controller'
  desc: 'This component implements the control of the EL7211 module'
  extends: ['BaseController']
  abstract: false
  uses: ["ocs_core_fwk", "ocs_ctrl_fwk"]

#  state_vars:
#    motor_velocity:
#      desc:               'Motor velocity (in RPM)'
#      type:               'int'
#      max_rate:           1000
#      blocking_mode:      'async'
#      is_controllable:    true

  input_ports:
    el7211_state_port:
      desc: 'EL7211 State (read) variables'
      type: 'el7211_state'
      protocol: 'pull'
      max_rate: 1000
      owner: true
      blocking_mode: 'sync'

  output_ports:
    el7211_control_port:
      desc: 'EL7211 Control (write) variables'
      type: 'el7211_control'
      protocol: 'push'
      max_rate: 1000
      owner: false
      blocking_mode: 'sync'

  properties:
    uri: {default: "gmt://127.0.0.1/controltest_dcs"}
    name: {default: "el7211_main_ctrl"}
    host: {default: "127.0.0.1"}
    port: {default: 8010}
    scan_rate: {default: 100}

  instance_configurations: ['el7211_main_ctrl']
