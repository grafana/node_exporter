{

  //  any modular observability library should inlcude as inputs:
  // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
  // 'uid' - UID to prefix all dashboards original uids
  filteringSelector: std.get(self, 'nodeExporterSelector', default='job="node"'),
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  dashboardNamePrefix: 'Node exporter / ',
  //uid prefix
  uid: 'node',
  dashboardTags: ['node-exporter-mixin'],

  // Select the fstype for filesystem-related queries. If left
  // empty, all filesystems are selected. If you have unusual
  // filesystem you don't want to include in dashboards and
  // alerting, you can exclude them here, e.g. 'fstype!="tmpfs"'.
  fsSelector: 'fstype!=""',

  // Select the mountpoint for filesystem-related queries. If left
  // empty, all mountpoints are selected. For example if you have a
  // special purpose tmpfs instance that has a fixed size and will
  // always be 100% full, but you still want alerts and dashboards for
  // other tmpfs instances, you can exclude those by mountpoint prefix
  // like so: 'mountpoint!~"/var/lib/foo.*"'.
  fsMountpointSelector: 'mountpoint!=""',

  // Select the device for disk-related queries. If left empty, all
  // devices are selected. If you have unusual devices you don't
  // want to include in dashboards and alerting, you can exclude
  // them here, e.g. 'device!="tmpfs"'.
  diskDeviceSelector: 'device!=""',

  // Some of the alerts are meant to fire if a criticadiskDeviceSelector failure of a
  // node is imminent (e.g. the disk is about to run full). In a
  // true “cloud native” setup, failures of a single node should be
  // tolerated. Hence, even imminent failure of a single node is no
  // reason to create a paging alert. However, in practice there are
  // still many situations where operators like to get paged in time
  // before a node runs out of disk space. nodeCriticalSeverity can
  // be set to the desired severity for this kind of alerts. This
  // can even be templated to depend on labels of the node, e.g. you
  // could make this critical for traditional database masters but
  // just a warning for K8s nodes.
  nodeCriticalSeverity: 'critical',

  // CPU utilization (%) on which to trigger the
  // 'NodeCPUHighUsage' alert.
  cpuHighUsageThreshold: 90,
  // Load average 1m (per core) on which to trigger the
  // 'NodeSystemSaturation' alert.
  systemSaturationPerCoreThreshold: 2,

  // Available disk space (%) thresholds on which to trigger the
  // 'NodeFilesystemSpaceFillingUp' alerts. These alerts fire if the disk
  // usage grows in a way that it is predicted to run out in 4h or 1d
  // and if the provided thresholds have been reached right now.
  // In some cases you'll want to adjust these, e.g., by default, Kubernetes
  // runs the image garbage collection when the disk usage reaches 85%
  // of its available space. In that case, you'll want to reduce the
  // critical threshold below to something like 14 or 15, otherwise
  // the alert could fire under normal node usage.
  // Additionally, the prediction window for the alert can be configured
  // to account for environments where disk usage can fluctuate within
  // a short time frame. By extending the prediction window, you can
  // reduce false positives caused by temporary spikes, providing a
  // more accurate prediction of disk space issues.
  fsSpaceFillingUpWarningThreshold: 40,
  fsSpaceFillingUpCriticalThreshold: 20,
  fsSpaceFillingUpPredictionWindow: '6h',

  // Available disk space (%) thresholds on which to trigger the
  // 'NodeFilesystemAlmostOutOfSpace' alerts.
  fsSpaceAvailableWarningThreshold: 5,
  fsSpaceAvailableCriticalThreshold: 3,

  // Memory utilization (%) level on which to trigger the
  // 'NodeMemoryHighUtilization' alert.
  memoryHighUtilizationThreshold: 90,

  // Threshold for the rate of memory major page faults to trigger
  // 'NodeMemoryMajorPagesFaults' alert.
  memoryMajorPagesFaultsThreshold: 500,

  // Disk IO queue level above which to trigger
  // 'NodeDiskIOSaturation' alert.
  diskIOSaturationThreshold: 10,

  // Enable hardware related panels and alerts (temp sensors)
  enableHardware: false,
  // Temperature sensor treshold
  temperatureWarnTreshold: 80,

  rateInterval: '5m',

  dashboardInterval: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Opt-in for USE method dashboards
  enableUseDashboards: true,
  // Opt-in for multi-cluster support (USE method).
  showMultiCluster: true,
  //used in USE dashboards only. For others, add cluster label to groupLabels var.
  clusterLabel: 'cluster',

  // Thresholds for process count
  processLimitThresholdWarning: 400,
  processLimitThresholdCritical: 600,

  //custom allValue to use for dashboard variables
  customAllValue: '.+',

  // loki logs related related
  enableLokiLogs: false,
  extraLogLabels: ['transport', 'unit', 'level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
  logsFilteringSelector: self.filteringSelector,
  logsExtraFilters:
    |||
      | label_format timestamp="{{__timestamp__}}"
      | line_format `{{ if eq "[[instance]]" ".*" }}{{alignLeft 25 .instance}}|{{alignLeft 25 .unit}}|{{else}}{{alignLeft 25 .unit}}|{{end}} {{__line__}}`
    |||,

}
