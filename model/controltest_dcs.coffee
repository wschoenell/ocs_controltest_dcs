DCS       'controltest_dcs',
  info: 'Test Control System'
  desc: require './controltest_dcs.rst'

  uses: [
    "ocs_core_fwk"
    "ocs_ctrl_fwk"
  ]

  types: [
    "el7211_control"
    "el7211_state"
    "el7211_info"
  ]


  connectors: [
    # EL7211 hw adapter
    # inputs
    {
      id: 8110,
      to: {element: "el7211_hw1_adapter", port: "el7211_control_port"},
      from: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 100,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # outputs
    {
      id: 8113,
      from: {element: "el7211_hw1_adapter", port: "el7211_state_port"},
      to: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }
    {
      id: 8114,
      from: {element: "el7211_hw1_adapter", port: "el7211_info_port"},
      to: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # op state
    {
      id: 8111,
      to: {element: "el7211_hw1_adapter", port: "op_state_goal"},
      from: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }
    {
      id: 8112,
      from: {element: "el7211_hw1_adapter", port: "op_state_value"},
      to: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # EL7211 main controller
    # inputs
    {
      id: 8213,
      to: {element: "el7211_main_ctrl", port: "el7211_state_port"},
      from: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }
    {
      id: 8214,
      to: {element: "el7211_main_ctrl", port: "el7211_info_port"},
      from: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }
    # outputs
    {
      id: 8210,
      from: {element: "el7211_main_ctrl", port: "el7211_control_port"},
      to: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 100,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # op state
    {
      id: 8211,
      to: {element: "el7211_main_ctrl", port: "op_state_goal"},
      from: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }
    {
      id: 8212,
      from: {element: "el7211_main_ctrl", port: "op_state_value"},
      to: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }


    # Serial
    # serial_hw_adapter
    # inputs
    {
      id: 9110,
      to: {element: "serial_hw1_adapter", port: "device_data_out"},
      from: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 100,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # outputs
    {
      id: 9113,
      from: {element: "serial_hw1_adapter", port: "device_data_in"},
      to: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # op state
    {
      id: 9111,
      to: {element: "serial_hw1_adapter", port: "op_state_goal"},
      from: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }
    {
      id: 9112,
      from: {element: "serial_hw1_adapter", port: "op_state_value"},
      to: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # serial_main_ctrl
    # inputs
    {
      id: 9213,
      to: {element: "serial_main_ctrl", port: "device_data_in"},
      from: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }
    # outputs
    {
      id: 9210,
      from: {element: "serial_main_ctrl", port: "device_data_out"},
      to: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 100,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # op state
    {
      id: 9211,
      to: {element: "serial_main_ctrl", port: "op_state_goal"},
      from: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }
    {
      id: 9212,
      from: {element: "serial_main_ctrl", port: "op_state_value"},
      to: {element: "*", port: "*"},
      max_latency: 0.5,
      nom_rate: 1,
      on_fault: "",
      conversion: "",
      bus: ""
    }


  ]
