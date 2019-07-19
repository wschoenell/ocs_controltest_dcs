
require './controltest_dcs'
require './controltest_dcs_types'

# el7211
require './el7211_ctrl_pkg/el7211_hw_adapter'
require './el7211_ctrl_pkg/el7211_ctrl_fb'
require './serial_ctrl_pkg/serial_ctrl_pkg'
require './serial_ctrl_pkg/serial_main_ctrl'

# serial
require './serial_ctrl_pkg/serial_hw_adapter'
require './serial_ctrl_pkg/serial_ctrl_pkg'
require './serial_ctrl_pkg/serial_main_ctrl'

module.exports = require './controltest_dcs_def'
