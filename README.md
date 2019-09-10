   
EL7211 Example - Servomotor terminal for resolver, 50 V DC, 4.5 ARMS

```bash
sed -i 's/isample_dcs/controltest_dcs/g' $GMT_LOCAL/etc/bundles/ocs_local_bundle.coffee
sed -i 's/hdk_dcs/# hdk_dcs/g' $GMT_LOCAL/etc/bundles/ocs_local_bundle.coffee
cd $GMT_LOCAL/modules/ocs_controltest_dcs/model
rm -fr $GMT_LOCAL/etc/conf/controltest_dcs/
webpack && gds gen controltest_dcs && gds install controltest_dcs
cd $GMT_LOCAL/modules/ocs_controltest_dcs/src/cpp
sed -i 's/# MO/MO/g' */module.mk

vim el7211_ctrl_pkg/el7211_main_ctrl/El7211MainCtrl.cpp ## paste activation state machine ##

make clean && rm $GMT_LOCAL_BIN/*
make

gds install
sed -i 's,tcp://127.0.0.1:8000,,g' $GMT_LOCAL_ETC/conf/controltest_dcs/*coffee  # fix https://github.com/GMTO/gmt_issues/issues/135
for i in $(ls $GMT_LOCAL_ETC/conf/controltest_dcs/ | grep coffee | grep -v ethercat | cut -f1-3 -d_); do grs compile $i; done
grs compile --input /home/wschoenell/gmt_local/etc/conf/controltest_dcs/el7211_hw1_adapter_ethercat_default_conf.coffee --output /home/wschoenell/gmt_local/etc/conf/controltest_dcs/el7211_hw1_adapter_ethercat_default_conf.cfg
```

EL7211 state machine

```cpp
// Implement activation state machine for EL7211
if ((el7211_state_port.status_word >> 3) & 0x01) { // EL7211 status: fault
    el7211_control_port.control_word = 0x80;
    log_info("EL7211 status: fault");
} else if ((el7211_state_port.status_word >> 6) & 0x01) { // EL7211 status: disabled
    el7211_control_port.control_word = 0x06;
    log_info("EL7211 status: switch on disabled");
} else if (((el7211_state_port.status_word >> 0) & 0x01) &&
           !((el7211_state_port.status_word >> 1) & 0x01)) { // EL7211 status: ready and no switched on
    el7211_control_port.control_word = 0x07;
    log_info("EL7211 status: ready to switch on");
} else if ((el7211_state_port.status_word >> 1) & 0x01) { // EL7211 status: switched on
    if (el7211_control_port.control_word != 0xf) {
        log_info("EL7211 status: Switched on");
}
    el7211_control_port.control_word = 0xf;
}
if (is_step_rate(100)) {
    // this will be executed every 100 steps
    log_info("step  = " + std::to_string(step_counter));
    log_info("el7211_state_port.status_word: " + std::to_string(el7211_state_port.status_word));
    log_info("el7211_control_port.control_word: " + std::to_string(el7211_control_port.control_word));
} 
```
