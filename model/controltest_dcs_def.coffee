module.exports =
  elements:
    el7211_ctrl_pkg:
      elements:
        # el7211
        el7211_hw_adapter: {language: ['cpp'], build: 'obj', deploy: 'dist', codegen: true, active: true}
        el7211_main_ctrl:  {language: ['cpp'], build: 'obj', deploy: 'dist', codegen: true, active: true}
#        el7211_ctrl_app:   {language: ['cpp'], build: 'app', deploy: 'dist', codegen: true, active: true}

    serial_ctrl_pkg:
      elements:
        # serial
        serial_hw_adapter: {language: ['cpp'], build: 'obj', deploy: 'dist', codegen: true, active: true}
        serial_main_ctrl:  {language: ['cpp'], build: 'obj', deploy: 'dist', codegen: true, active: true}
        serial_ctrl_app:   {language: ['cpp'], build: 'app', deploy: 'dist', codegen: true, active: true}

