{
  new(config):: {
    alerts: (import './alerts.libsonnet').new(config),
    cpu: (import './cpu.libsonnet').new(config),
    disk: (import './disk.libsonnet').new(config),
    events: (import './events.libsonnet').new(config),
    hardware: (import './hardware.libsonnet').new(config),
    memory: (import './memory.libsonnet').new(config),
    network: (import './network.libsonnet').new(config),
    system: (import './system.libsonnet').new(config),
  },
}
