
{ CoreContainer
  Supervisor
  HealthSupervisingBehavior
  CoreCLIApplication } = require 'ocs_core_fwk'
{ SerialHwAdapter }  = require './serial_hw_adapter'


class SerialHwAdapterApp extends CoreCLIApplication

    setup: ->
        @ctnr = new CoreContainer @, null,
            name:    "serial_hw_adapter_app_container"
            scope:   @properties.scope.value
            logging: @properties.logging.value

        @ctnr.create_adapters()

        @serial_hw1_adapter = new SerialHwAdapter @ctnr, null,
            name:    'serial_hw1_adapter'
            scope:   @properties.scope.value
            logging: @properties.logging.value

        @sup = new Supervisor @ctnr, null, {name: "serial_hw_adapter_super"}  # default supervisor just for component testing

        @sup.behaviors.add new HealthSupervisingBehavior {name: 'sup_bh'}

        @sup.add_supervisee {name: 'serial_hw1_adapter'}

        super() if super.setup

app = new SerialHwAdapterApp null,
    name:    "serial_hw_adapter_app"
    scope:   "local"
    logging: "info"

app.setup()
app.start()


