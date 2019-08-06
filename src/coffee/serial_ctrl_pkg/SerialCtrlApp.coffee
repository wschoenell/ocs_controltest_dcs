
{ CoreContainer
  Supervisor
  HealthSupervisingBehavior
  CoreCLIApplication } = require 'ocs_core_fwk'
{SerialHwAdapter}    = require './serial_hw_adapter/SerialHwAdapter'
{SerialMainCtrl}     = require './serial_main_ctrl/SerialMainCtrl'


class SerialCtrlPkgApp extends CoreCLIApplication

    setup: ->
        @ctnr = new CoreContainer @, null,
            name:    "serial_ctrl_pkg_app_container"
            scope:   @properties.scope.value
            logging: @properties.logging.value

        @ctnr.create_adapters()

        @serial_hw1_adapter = new SerialHwAdapter @ctnr, null,
            name:    'serial_hw1_adapter'
            scope:   @properties.scope.value
            logging: @properties.logging.value

        @serial_main_ctrl = new SerialMainCtrl @ctnr, null,
            name:    'serial_main_ctrl'
            scope:   @properties.scope.value
            logging: @properties.logging.value

        @sup = new Supervisor @ctnr, null, {name: "serial_ctrl_pkg_super"}  # Default supervisor, substitute by pkg supervisor

        @sup.behaviors.add new HealthSupervisingBehavior {name: 'sup_bh'}

        @sup.add_supervisee {name: 'serial_hw1_adapter'}
        @sup.add_supervisee {name: 'serial_main_ctrl'}

        super() if super.setup

app = new SerialCtrlPkgApp null,
    name:    "serial_ctrl_pkg_app"
    scope:   "local"
    logging: "info"

app.setup()
app.start()



