Package   'serial_ctrl_pkg',
  info: 'SERIAL Controller Package'
  desc: 'Serial Controller Package'
  uses: ["ocs_core_fwk"]

  connectors: [
    # hw adapter outputs
    {
      id: 8101,
      from: {element: "serial_hw1_adapter", port: "device_data_in"},
      to: {element: "serial_main_ctrl", port: "device_data_in"},
      max_latency: 0.5,
      nom_rate: 100,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # hw adapter inputs
    {
      id: 8104,
      from: {element: "serial_main_ctrl", port: "device_data_out"},
      to: {element: "serial_hw1_adapter", port: "device_data_out"},
      max_latency: 0.5,
      nom_rate: 100,
      on_fault: "",
      conversion: "",
      bus: ""
    }
  ]