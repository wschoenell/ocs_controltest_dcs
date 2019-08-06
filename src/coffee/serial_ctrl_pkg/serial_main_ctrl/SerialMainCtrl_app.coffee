


{ CoreContainer
  Supervisor
  HealthSupervisingBehavior
  CoreCLIApplication } = require 'ocs_core_fwk'
{ SerialMainCtrl }  = require './serial_main_ctrl'


class SerialMainCtrlApp extends CoreCLIApplication

    setup: ->
        @ctnr = new CoreContainer @, null,
            name:    "serial_main_ctrl_app_container"
            scope:   @properties.scope.value
            logging: @properties.logging.value

        @ctnr.create_adapters()

        @serial_main_ctrl = new SerialMainCtrl @ctnr, null,
            name:    'serial_main_ctrl'
            scope:   @properties.scope.value
            logging: @properties.logging.value

        @sup = new Supervisor @ctnr, null, {name: "serial_main_ctrl_super"}  # default supervisor just for component testing

        @sup.behaviors.add new HealthSupervisingBehavior {name: 'sup_bh'}

        @sup.add_supervisee {name: 'serial_main_ctrl'}

        super() if super.setup

app = new SerialMainCtrlApp null,
    name:    "serial_main_ctrl_app"
    scope:   "local"
    logging: "info"

app.setup()
app.start()


