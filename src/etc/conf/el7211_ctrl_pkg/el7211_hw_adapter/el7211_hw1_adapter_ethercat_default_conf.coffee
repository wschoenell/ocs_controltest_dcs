#!/usr/bin/coffee
module.exports =
  ethercat_config:
    master: [
      { id: 0, rate: 10000 }
    ]

    domains: [
      { id: 0, master: 0,   rate_factor: 1    }
    ]

    modules: [
      { name: "coupler", position: 0, alias: 10, type: "coupler", master_id:0 }
      { name: "motor",    position: 1, alias: 11, type: "EL7211-0010", master_id:0 }      ]

    data_objects: [
      { name: "status_word",           type: "tx_pdo",    label: "Statusword",                               std_name: "Statusword",                                 module: 1, domain: 0 }
      { name: "actual_velocity",       type: "tx_pdo",    label: "Velocity actual value",                    std_name: "Velocity actual value",                      module: 1, domain: 0 }
      { name: "position",              type: "tx_pdo",    label: "Position",                                 std_name: "Position",                                   module: 1, domain: 0 }

      { name: "control_word",          type: "rx_pdo",    label: "Controlword",                              std_name: "Controlword",                                module: 1, domain: 0 }
      { name: "target_velocity",       type: "rx_pdo",    label: "Target velocity",                          std_name: "Target velocity",                            module: 1, domain: 0 }

      { name: "velocity_resolution",   type: "tx_sdo",    label: "Velocity Resolution",                      std_name: "Velocity Resolution",                        module: 1, domain: 0 }
    ]

    pdo_mapping: [
      { pdo_name: "Controlword",           direction: "output", index: 0x1600, sub_index: 0x1, size: 16}
      { pdo_name: "Target velocity",       direction: "output", index: 0x1601, sub_index: 0x1, size: 32}
      { pdo_name: "Position",              direction: "input",  index: 0x1A00, sub_index: 0x1, size: 32}
      { pdo_name: "Statusword",            direction: "input",  index: 0x1A01, sub_index: 0x1, size: 16}
      { pdo_name: "Velocity actual value", direction: "input",  index: 0x1A02, sub_index: 0x1, size: 32}
    ]

    catalog: [
      {
        product_name: "coupler",
        vendor_id:    0x00000002,
        product_code:  0x144c2c52,
        revision_id:  0x10110000,
        objs: [],
        clocks: []
      }
      {
        product_name: "EL7211-0010",
        vendor_id:    0x00000002,
        product_code: 0x1c2b3052,
        revision_id:  0x0018000a,
        objs: [
          { name: "Statusword",            index: 0x6010, sub_index: 0x01,   bit: 0} #TxPDO-Map Statusword
          { name: "Controlword",           index: 0x7010, sub_index: 0x01,   bit: 0} #DRV RxPDO-Map Controlword

          { name: "Velocity actual value", index: 0x6010, sub_index: 0x07,   bit: 0} #DRV TxPDO-Map Velocity actual value
          { name: "Position",              index: 0x6000, sub_index: 0x11,   bit: 0} #FB TxPDO-Map Position
          { name: "Target velocity",       index: 0x7010, sub_index: 0x06,   bit: 0} #DRV RxPDO-Map Target velocity
          { name: "Velocity Resolution",   index: 0x9010, sub_index: 0x14,   bit: 0} #DRV Info data
#          { name: "Position Resolution",   index: 0x9010, sub_index: 0x14,   bit: 0} #DRV Info data
        ],
        clocks: [
          { assign_activate: 0x0700,   cycle_time_sync0: 10000000, shift_time_sync0: 4400000,   cycle_time_sync1: 10000000, shift_time_sync1: 4400000 }
        ]
      }
    ]