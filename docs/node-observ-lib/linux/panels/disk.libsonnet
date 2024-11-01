local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local t = this.grafana.targets,
      local table = g.panel.table,
      local fieldOverride = g.panel.table.fieldOverride,
      local instanceLabel = this.config.instanceLabels[0],

      diskTotalRoot:
        commonlib.panels.disk.stat.total.new(
          'Root mount size',
          targets=[t.diskTotalRoot],
          description=|||
            Total capacity on the primary mount point /.
          |||
        ),
      diskUsage:
        commonlib.panels.disk.table.usage.new(
          totalTarget=
          (
            t.diskTotal
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
          ),
          freeTarget=
          t.diskFree
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
          groupLabel='mountpoint'
          ,
          description='Disk utilisation in percent, by mountpoint. Some duplication can occur if the same filesystem is mounted in multiple locations.'
        ),
      diskFreeTs:
        commonlib.panels.disk.timeSeries.available.new(
          'Filesystem space availabe',
          targets=[
            t.diskFree,
          ],
          description='Filesystem space utilisation in bytes, by mountpoint.'
        ),
      diskInodesFree:
        commonlib.panels.disk.timeSeries.base.new(
          'Free inodes',
          targets=[t.diskInodesFree],
          description='The inode is a data structure in a Unix-style file system that describes a file-system object such as a file or a directory.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),
      diskInodesTotal:
        commonlib.panels.disk.timeSeries.base.new(
          'Total inodes',
          targets=[t.diskInodesTotal],
          description='The inode is a data structure in a Unix-style file system that describes a file-system object such as a file or a directory.',
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),
      diskErrorsandRO:
        commonlib.panels.disk.timeSeries.base.new(
          'Filesystems with errors / read-only',
          targets=[
            t.diskDeviceError,
            t.diskReadOnly,
          ],
          description='',
        )
        + g.panel.timeSeries.standardOptions.withMax(1),
      fileDescriptors:
        commonlib.panels.disk.timeSeries.base.new(
          'File descriptors',
          targets=[
            t.processMaxFds,
            t.processOpenFds,
          ],
          description=|||
            File descriptor is a handle to an open file or input/output (I/O) resource, such as a network socket or a pipe.
            The operating system uses file descriptors to keep track of open files and I/O resources, and provides a way for programs to read from and write to them.
          |||
        ),
      diskUsagePercentTopK: commonlib.panels.generic.timeSeries.topkPercentage.new(
        title='Disk space usage',
        target=t.diskUsagePercent,
        topk=25,
        instanceLabels=this.config.instanceLabels + ['volume'],
        drillDownDashboardUid=this.grafana.dashboards['overview.json'].uid,
      ),
      diskIOBytesPerSec: commonlib.panels.disk.timeSeries.ioBytesPerSec.new(
        targets=[t.diskIOreadBytesPerSec, t.diskIOwriteBytesPerSec, t.diskIOutilization]
      ),
      diskIOutilPercentTopK:
        commonlib.panels.generic.timeSeries.topkPercentage.new(
          title='Disk IO',
          target=t.diskIOutilization,
          topk=25,
          instanceLabels=this.config.instanceLabels + ['volume'],
          drillDownDashboardUid=this.grafana.dashboards['overview.json'].uid,
        ),
      diskIOps:
        commonlib.panels.disk.timeSeries.iops.new(
          targets=[
            t.diskIOReads,
            t.diskIOWrites,
          ]
        ),

      diskQueue:
        commonlib.panels.disk.timeSeries.ioQueue.new(
          'Disk average queue',
          targets=
          [
            t.diskAvgQueueSize,
          ]
        ),
      diskIOWaitTime: commonlib.panels.disk.timeSeries.ioWaitTime.new(
        targets=[
          t.diskIOWaitReadTime,
          t.diskIOWaitWriteTime,
        ]
      ),
    },
}
