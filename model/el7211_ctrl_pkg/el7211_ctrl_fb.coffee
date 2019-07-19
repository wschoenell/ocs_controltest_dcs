FieldBus "el7211_ctrl_fb",
  info: "EL7211 EtherCAT bus"
  desc: "EL7211 EtherCAT bus"

  masters: [
    {id: 0, rate: 1000}
  ]

  domains: [
    {id: 0, master: 0, rate: 1000}
  ]

  slaves: [
    {name: "motor", position: 1, type: "EL7211-0010"}
  ]


  data_objects: [
    {
      name: "status_word",
      type: "tx_pdo",
      label: "Statusword",
      std_name: "Statusword",
      module: 0,
      domain: 0
    },
    {
      name: "actual_velocity",
      type: "tx_pdo",
      label: "Velocity actual value",
      std_name: "Velocity actual value",
      module: 0,
      domain: 0
    },
    {
      name: "position",
      type: "tx_pdo",
      label: "Position",
      std_name: "Position",
      module: 0,
      domain: 0
    },
    {
      name: "control_word",
      type: "rx_pdo",
      label: "Controlword",
      std_name: "Controlword",
      module: 0,
      domain: 0
    },
    {
      name: "target_velocity",
      type: "rx_pdo",
      label: "Target Velocity",
      std_name: "Target Velocity",
      module: 0,
      domain: 0
    },
    {
      name: "velocity_resolution",
      type: "sdo",
      label: "Velocity Resolution",
      std_name: "Velocity Resolution",
      module: 0,
      domain: 0
    },
  ]


