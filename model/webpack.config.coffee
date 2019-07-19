
path          = require 'path'
_             = require 'lodash'

gmt_local     = process.env.GMT_LOCAL
gmt_global    = process.env.GMT_GLOBAL

[base_config] = require "#{gmt_global}/etc/webpack/webpack.base"
project_name  = "ocs"
module_name   = "controltest_dcs"


model_config =
    name:   "model"
    entry:  "./#{module_name}_ld.coffee"
    output:
        filename:       "#{project_name}_#{module_name}_model.js"
        path:           path.resolve gmt_local, 'lib/js'
        libraryTarget:  'umd'
        library:        module_name

_.extend model_config, base_config

module.exports = [model_config]

