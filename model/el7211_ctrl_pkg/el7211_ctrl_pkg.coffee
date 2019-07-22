Package   'el7211_ctrl_pkg',
  info: 'EL7211 Controller Package'
  desc: 'EL7211 Controller Package'
  uses: ["ocs_core_fwk"]

  connectors: [
    # hw adapter outputs
    {
      id: 8101,
      from: {element: "el7211_hw1_adapter", port: "el7211_state_port"},
      to: {element: "el7211_main_ctrl", port: "el7211_state_port"},
      max_latency: 0.5,
      nom_rate: 100,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # hw adapter inputs
    {
      id: 8104,
      from: {element: "el7211_main_ctrl", port: "el7211_control_port"},
      to: {element: "el7211_hw1_adapter", port: "el7211_control_port"},
      max_latency: 0.5,
      nom_rate: 100,
      on_fault: "",
      conversion: "",
      bus: ""
    }

    # heartbeats
    {
      id: 8107,
      from: {element: "el7211_hw1_adapter", port: "heartbeat_out"},
      to: {element: "el7211_ctrl_super", port: "heartbeat_in"},
      max_latency: 0.5,
      nom_rate: 100,
    }
    {
      id: 8108,
      from: {element: "el7211_main_ctrl", port: "heartbeat_out"},
      to: {element: "el7211_ctrl_super", port: "heartbeat_in"},
      max_latency: 0.5,
      nom_rate: 100,
    }
  ]