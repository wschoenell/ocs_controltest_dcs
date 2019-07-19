Adapter            'el7211_hw_adapter',
  info: 'HDK Hw Adapter'
  desc: 'This component defines the interface with the HDK Actuators and Sensors'
  abstract: false
  extends: ['EthercatAdapter']
  uses: ["ocs_core_fwk", "ocs_io_fwk"]

  input_ports:
    el7211_control_port: {
      type: 'el7211_control',
      protocol: 'pull',
      max_rate: 1000,
      owner: true,
      blocking_mode: 'async',
      desc: 'Control (write) variables',
    }

  output_ports:
    el7211_state_port: {
      type: 'el7211_state',
      protocol: 'push',
      max_rate: 1000,
      owner: false,
      blocking_mode: 'async',
      desc: 'State (read) variables'
    }
    el7211_info_port: {
      type: 'el7211_info',
      protocol: 'push',
      max_rate: 1000,
      owner: false,
      blocking_mode: 'async',
      desc: 'Drive information'
    }

  data_object_map: [
    {data_object: "control_word", port: "el7211_control_port", field: "control_word"}
    {data_object: "target_velocity", port: "el7211_control_port", field: "target_velocity"}
    {data_object: "status_word", port: "el7211_state_port", field: "status_word"}
    {data_object: "position", port: "el7211_state_port", field: "position"}
    {data_object: "actual_velocity", port: "el7211_state_port", field: "actual_velocity"}
    {data_object: "velocity_resolution", port: "el7211_info_port", field: "velocity_resolution"}
  ]

  properties:
    uri: {default: "gmt://el7211_hw_adapter/el7211_hw_adapter"}
    name: {default: "el7211_hw_adapter"}
    host: {default: "127.0.0.1"}
    port: {default: 8011}
    scan_rate: {default: 100}

  instance_configurations: ['el7211_hw1_adapter']
