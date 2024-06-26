{
  _config+:: {
    // Selectors are inserted between {} in Prometheus queries.

    // Select the metrics coming from the node exporter. Note that all
    // the selected metrics are shown stacked on top of each other in
    // the 'USE Method / Cluster' dashboard. Consider disabling that
    // dashboard if mixing up all those metrics in the same dashboard
    // doesn't make sense (e.g. because they are coming from different
    // clusters).
    nodeExporterSelector: 'job="node"',

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

    // Some of the alerts are meant to fire if a critical failure of a
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
    // In some cases you'll want to adjust these, e.g. by default Kubernetes
    // runs the image garbage collection when the disk usage reaches 85%
    // of its available space. In that case, you'll want to reduce the
    // critical threshold below to something like 14 or 15, otherwise
    // the alert could fire under normal node usage.
    fsSpaceFillingUpWarningThreshold: 40,
    fsSpaceFillingUpCriticalThreshold: 20,

    // Available disk space (%) thresholds on which to trigger the
    // 'NodeFilesystemAlmostOutOfSpace' alerts.
    fsSpaceAvailableWarningThreshold: 5,
    fsSpaceAvailableCriticalThreshold: 3,

    // Memory utilzation (%) level on which to trigger the
    // 'NodeMemoryHighUtilization' alert.
    memoryHighUtilizationThreshold: 90,

    // Threshold for the rate of memory major page faults to trigger
    // 'NodeMemoryMajorPagesFaults' alert.
    memoryMajorPagesFaultsThreshold: 500,

    // Disk IO queue level above which to trigger
    // 'NodeDiskIOSaturation' alert.
    diskIOSaturationThreshold: 10,

    rateInterval: '5m',
    // Opt-in for multi-cluster support.
    showMultiCluster: false,

    clusterLabel: 'cluster',

    // groupLabels is a string with comma-separated
    // labels that are common labels of instances belonging to the
    // same logical group. Include not only enough labels to
    // identify cluster members, but also all common labels you want
    // to keep for resulting cluster-level alerts.
    groupLabels: 'job',
    // commaSeparated list of labels identifying a single instance:
    instanceLabels: 'instance',

    dashboardNamePrefix: 'Node Exporter / ',
    dashboardTags: ['node-exporter-mixin'],
    dashboardRefresh: '30s',
    dashboardTimezone: 'utc',
    dashboardInterval: 'now-2h',

    // Grafana dashboard IDs are necessary for stable links for dashboards
    grafanaDashboardIDs: {
      'node-rsrc-use.json': 'node-rsrc-use',
      'node-cluster-rsrc-use.json': 'node-cluster-rsrc-use',
      'node-multicluster-rsrc-use.json': 'node-multicluster-rsrc-use',
      'nodes.json': 'nodes',
      'nodes-darwin.json': 'nodes-darwin',
      'nodes-system.json': 'node-system',
      'nodes-memory.json': 'node-memory',
      'nodes-network.json': 'node-network',
      'nodes-disk.json': 'node-disk',
      'nodes-fleet.json': 'node-fleet',
    },
  },
}
