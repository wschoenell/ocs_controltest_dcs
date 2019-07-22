# EL7211

StructType "el7211_control",
  desc: "Control (write) variables",
  elements:
    control_word: {desc: "Control Word", type: "uint16", units: ""}
    target_velocity: {desc: "Target Velocity", type: "uint32", units: ""}


StructType "el7211_state",
  desc: "State (read) variables",
  elements:
    status_word: {desc: "Status Word", type: "uint16", units: ""}
    position: {desc: "Position", type: "uint32", units: ""}
    actual_velocity: {desc: "Velocity actual value", type: "uint32", units: ""}