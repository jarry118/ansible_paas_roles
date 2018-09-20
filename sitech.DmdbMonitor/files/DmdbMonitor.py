# -*- coding: utf-8 -*-

#!/usr/bin/env python
# coding: utf-8
# author: mooker
# date: 201807

from flask import Flask, Response
import prometheus_client
from prometheus_client import Gauge, CollectorRegistry
import inspect
import os
from common import MonitorInfo
import commands

app = Flask(__name__)

registry = CollectorRegistry()
dmdb_memory_total = Gauge("dmdb_memory_total", "Memory information field MemTotal(M)", ['name',], registry=registry)
dmdb_memory_used = Gauge("dmdb_memory_used", "Memory information field MemUsed(M)", ['name',], registry=registry)
dmdb_memory_used_percent = Gauge("dmdb_memory_used_percent", "Memory information field MemUsedPercent(%)", ['name',], registry=registry)
dmdb_memory_fragment = Gauge("dmdb_memory_fragment", "Memory information field MemFragment(M)", ['name',], registry=registry)
dmdb_duplicate_applications = Gauge("dmdb_duplicate_applications", "Master-Slave Duplicate information field Applications", ['name',], registry=registry)
dmdb_locks_num = Gauge("dmdb_locks_num", "Lock information field LocksNum", registry=registry)

class DmdbMonitor:

    def __init__(self):
        self.agent_data = ""

    """
    dmdb_status -v

                ##########    节点状态 2018-07-02 13:59:11    ##########

    ----------------------------------------------------------------------------------
    节点        主库                      备库                                       主库状态  备库状态
    db01        172.21.3.163:3910         172.21.3.164:4910;172.21.3.163:5910        Y         YY
    db02        172.21.3.164:3910         172.21.3.163:4910;172.21.3.164:5910        Y         YY

    """
    def get_dmdbstatus_v(self):
        try:
            status, result = commands.getstatusoutput("dmdb_status -v | sed '1,5d' | sed '$d'")
            # status, result = commands.getstatusoutput("dmdb_status -v | sed '1,5d' | sed '$d'")
            if (status == 0):
                data = ""
                for line in result.splitlines():
                    nodeinfo = ' '.join(line.split()).strip()
                    nodename = nodeinfo.split(" ")[0]
                    data += MonitorInfo("dmdb_node_master", "dmdb master node", "nodename", nodename, nodeinfo.split(" ")[1]).printInfo()
                    data += MonitorInfo("dmdb_node_slave", "dmdb slave node", "nodename", nodename, nodeinfo.split(" ")[2]).printInfo()
                    data += MonitorInfo("dmdb_node_master_status", "dmdb master node status", "nodename", nodename, nodeinfo.split(" ")[3]).printInfo()
                    data += MonitorInfo("dmdb_node_slave_status", "dmdb slave node status", "nodename", nodename, nodeinfo.split(" ")[4]).printInfo()
        except Exception as err:
            print err
            data = str(err)
        return data

    """
    dmdb_status -m

                ##########    内存状态 2018-07-02 13:59:51    ##########

    ----------------------------------------------------------------------------------
    节点库      共享内存标识    创建时间               总内存(M)     已用内存(M)       使用率(%)         碎片(M)
    db01        360451          20180626142308           500.000          36.938            7.39            0.00
    db01_bak    1572867         20180626142308           500.000          36.215            7.24            0.05
    db01_bak2   393220          20180626142308           500.000          36.215            7.24            0.05
    db02        1638405         20180626142308           500.000          36.770            7.35            0.00
    db02_bak    425989          20180626142308           500.000          36.340            7.27            0.09
    db02_bak2   1605636         20180626142308           500.000          36.340            7.27            0.09

    """
    def get_dmdbstatus_m(self):
        try:
            result = os.popen("dmdb_status -m | sed '1,5d' | sed '$d'")
            res = result.read()
            data = ""
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
                data += MonitorInfo("dmdb_memory_share_flag", "dmdb memory share flag", "nodename", nodename, nodeinfo.split(" ")[1]).printInfo()
                data += MonitorInfo("dmdb_memory_utc_create", "dmdb memory utc create", "nodename", nodename, nodeinfo.split(" ")[2]).printInfo()
                data += MonitorInfo("dmdb_memory_total", "dmdb memory total(M)", "nodename", nodename, nodeinfo.split(" ")[3]).printInfo()
                data += MonitorInfo("dmdb_memory_used", "dmdb memory used(M)", "nodename", nodename, nodeinfo.split(" ")[4]).printInfo()
                data += MonitorInfo("dmdb_memory_used_percent", "dmdb memory used percent(%)", "nodename", nodename, nodeinfo.split(" ")[5]).printInfo()
                data += MonitorInfo("dmdb_memory_fragment", "dmdb memory fragment(M)", "nodename", nodename, nodeinfo.split(" ")[6]).printInfo()
            result.close()
        except Exception as err:
            print err
            data = str(err)
        return data

    """
    dmdb_status -d

                ##########    复制进程是否存在 2018-07-02 14:00:29    ##########

    节点                主库                备库                备库2
    ----------------------------------------------------------------------------------
    db01                Y                   Y                   Y
    db02                Y                   Y                   Y

    """
    def get_dmdbstatus_d(self):
        try:
            result = os.popen("dmdb_status -d | sed '1,5d' | sed '$d'")
            res = result.read()
            data = ""
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
                data += MonitorInfo("dmdb_duplicate_process_master_status", "dmdb duplicate process master node status", "nodename", nodename, nodeinfo.split(" ")[1]).printInfo()
                data += MonitorInfo("dmdb_duplicate_process_slave1_status", "dmdb duplicate process slave1 node status", "nodename", nodename, nodeinfo.split(" ")[2]).printInfo()
                if (len(nodename) > 3):
                    data += MonitorInfo("dmdb_duplicate_process_slave2_status", "dmdb duplicate process slave2 node status", "nodename", nodename, nodeinfo.split(" ")[3]).printInfo()
            result.close()
        except Exception as err:
            print err
            data = str(err)
        return data

    """
    dmdb_status -y

                ##########    同步进程是否存在 2018-07-02 14:00:59    ##########

    节点                主库                备库                备库2
    ----------------------------------------------------------------------------------
    db01                N                   N                   N
    db02                N                   N                   N

    """
    def get_dmdbstatus_y(self):
        try:
            result = os.popen("dmdb_status -y | sed '1,5d' | sed '$d'")
            res = result.read()
            data = ""
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
                data += MonitorInfo("dmdb_synchronize_process_master_status", "dmdb synchronize process master node status", "nodename", nodename, nodeinfo.split(" ")[1]).printInfo()
                data += MonitorInfo("dmdb_synchronize_process_slave1_status", "dmdb synchronize process slave1 node status", "nodename", nodename, nodeinfo.split(" ")[2]).printInfo()
                if (len(nodename) > 3):
                    data += MonitorInfo("dmdb_synchronize_process_slave2_status", "dmdb synchronize process slave node status", "nodename", nodename, nodeinfo.split(" ")[2]).printInfo()
            result.close()
        except Exception as err:
            print err
            data = str(err)
        return data

    """
    dmdb_status -j


                ##########    复制是否无积压 2018-07-02 14:01:10    ##########
    节点           主发备随            备发主随
    ----------------------------------------------------------------------------------
    db01                Y                   Y
    db02                Y                   Y

    """
    def get_dmdbstatus_j(self):
        try:
            result = os.popen("dmdb_status -j | sed '1,5d' | sed '$d'")
            res = result.read()
            data = ""
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
                data += MonitorInfo("dmdb_duplicate_overstock_master_slave_status", "dmdb duplicate overstock from master to slave status", "nodename", nodename, nodeinfo.split(" ")[1]).printInfo()
                data += MonitorInfo("dmdb_duplicate_overstock_slave_master_status", "dmdb duplicate overstock from slave to master status", "nodename", nodename, nodeinfo.split(" ")[2]).printInfo()
            result.close()
        except Exception as err:
            print err
            data = str(err)
        return data

    """
    #dmdb_status -l
    #
    #             ###########    锁状态 2018-07-02 11:16:30    ##########
    #
    # ----------------------------------------------------------------------------------
    # 节点库      连接标识  进程号    IP地址          登陆时间        进程名          最近加锁时间      加锁的表名
    #
    def get_dmdbstatus_l(self):
        try:
            result = os.popen("dmdb_status -l | sed '1,5d' | sed '$d'")
            res = result.read()
            data = ""
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
            result.close()
        except Exception as err:
            print err
            data = str(err)
        return data

    # dmdb_status -x
    #
    #             ##########    互斥锁状态 2018-07-02 11:18:21    ##########
    #
    # 节点库      表名              互斥锁信息
    # ----------------------------------------------------------------------------------
    #
    def get_dmdbstatus_x(self):
        try:
            result = os.popen("dmdb_status -x | sed '1,5d' | sed '$d'")
            res = result.read()
            data = ""
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
            result.close()
        except Exception as err:
            print err
            data = str(err)
        return data

    #dmdb_status -c
    #
    #             ##########    主备库各表记录数是否一致 2018-07-02 11:19:36    ##########
    #
    # 节点      表名                                                   主库        备库       备库2
    # ------------------------------------------------------------------------------------------------
    # db01      : Y
    # db02      : Y
    #
    # db01      : OCSAPP.OCS_STATE                                        2           0
    # db01      : SUPER.OCS_STATE                                         3           0
    # db01      : SUPER1.OCS_STATE                                       95          93
    # db01      : SUPER2.OCS_STATE                                       95          94
    # db02      : OCSAPP.OCS_STATE                                        2           0
    # db02      : SUPER.OCS_STATE                                         3           0
    # db02      : SUPER1.OCS_STATE                                       95          93
    # db02      : SUPER2.OCS_STATE                                       95          94
    # db03      : OCSAPP.OCS_STATE                                        2           0
    # db03      : SUPER.OCS_STATE                                         3           0
    # db03      : SUPER1.OCS_STATE                                       95          93
    # db03      : SUPER2.OCS_STATE                                       95          94
    # ----------------------------------------------------------------------------------
    #
    def get_dmdbstatus_c(self):
        try:
            result = os.popen("dmdb_status -c | sed '1,5d' | sed '$d'")
            res = result.read()
            data = ""
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
            result.close()
        except Exception as err:
            print err
            data = str(err)
        return data
    """

    """
    dmdb_ha -v all
    状态说明    0:正常态     1:备用态      2:维护态     9:中间待切换

    节点                状态                应用连接数
    ------------------------------------------------------------------
    db01                0                   45
    db01_bak            1                   0
    db02                0                   36
    db02_bak            1                   0
    db03                0                   37
    db03_bak            1                   0

    """
    def get_dmdbha_v_all(self):
        try:
            result = os.popen("dmdb_ha -v all | sed '1,4d' | sed '$d'")
            res = result.read()
            data = ""
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
                data += MonitorInfo("dmdb_duplicate_node_status", "dmdb duplicate node status(0:normal 1:standby 2:maintenance 9:toswitch)", "nodename", nodename, nodeinfo.split(" ")[1]).printInfo()
                data += MonitorInfo("dmdb_duplicate_applications", "how many applications connected dmdb", "nodename", nodename, nodeinfo.split(" ")[2]).printInfo()
            result.close()
        except Exception as err:
            print err
            data = str(err)
        return data

    """
    dmdb_param get MAX_CLIENT
    db01        : MAX_CLIENT = 1024  #允许的最大连接数, 重启生效
    db01_bak    : MAX_CLIENT = 1024  #允许的最大连接数, 重启生效
    db02        : MAX_CLIENT = 1024  #允许的最大连接数, 重启生效
    db02_bak    : MAX_CLIENT = 1024  #允许的最大连接数, 重启生效
    db03        : MAX_CLIENT = 1024  #允许的最大连接数, 重启生效
    db03_bak    : MAX_CLIENT = 1024  #允许的最大连接数, 重启生效

    """
    def get_dmdbparam_max_client(self):
        try:
            result = os.popen("dmdb_param get MAX_CLIENT | sed '$d'")
            res = result.read()
            data = ""
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
                data += MonitorInfo("dmdb_param_max_client", "dmdb param max client", "nodename", nodename, nodeinfo.split(" ")[4]).printInfo()
            result.close()
        except Exception as err:
            print err
            data = str(err)
        return data

    def run_all_get_func(self):
        for func in inspect.getmembers(self, predicate=inspect.ismethod):
            if func[0][:3] == 'get':
                self.agent_data += func[1]()
        return self.agent_data

    """
    dmdb_status -m

                ##########    内存状态 2018-07-02 13:59:51    ##########

    ----------------------------------------------------------------------------------
    节点库      共享内存标识    创建时间               总内存(M)     已用内存(M)       使用率(%)         碎片(M)
    db01        360451          20180626142308           500.000          36.938            7.39            0.00
    db01_bak    1572867         20180626142308           500.000          36.215            7.24            0.05
    db01_bak2   393220          20180626142308           500.000          36.215            7.24            0.05
    db02        1638405         20180626142308           500.000          36.770            7.35            0.00
    db02_bak    425989          20180626142308           500.000          36.340            7.27            0.09
    db02_bak2   1605636         20180626142308           500.000          36.340            7.27            0.09

    """
    def metrics_dmdbstatus_m(self):
        try:
            result = os.popen("dmdb_status -m | sed '1,5d' | sed '$d'")
            res = result.read()
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
                dmdb_memory_total.labels(name=nodename).set(nodeinfo.split(" ")[3])
                dmdb_memory_used.labels(name=nodename).set(nodeinfo.split(" ")[4])
                dmdb_memory_used_percent.labels(name=nodename).set(nodeinfo.split(" ")[5])
                dmdb_memory_fragment.labels(name=nodename).set(nodeinfo.split(" ")[6])
            result.close()
        except Exception as err:
            print err

    """
    dmdb_ha -v all
    状态说明    0:正常态     1:备用态      2:维护态     9:中间待切换

    节点                状态                应用连接数
    ------------------------------------------------------------------
    db01                0                   45
    db01_bak            1                   0
    db02                0                   36
    db02_bak            1                   0
    db03                0                   37
    db03_bak            1                   0

    """
    def metrics_dmdbha_v(self):
        try:
            result = os.popen("dmdb_ha -v all | sed '1,4d' | sed '$d'")
            res = result.read()
            for line in res.splitlines():
                nodeinfo = ' '.join(line.split()).strip()
                nodename = nodeinfo.split(" ")[0]
                dmdb_duplicate_applications.labels(name=nodename).set(nodeinfo.split(" ")[2])
            result.close()
        except Exception as err:
            print err

    """
    #dmdb_status -l
    #
    #             ###########    锁状态 2018-07-02 11:16:30    ##########
    #
    # ----------------------------------------------------------------------------------
    # 节点库      连接标识  进程号    IP地址          登陆时间        进程名          最近加锁时间      加锁的表名
    # db01        11      123       10.7.121.3     20160407095208 dmsql           20160407095208  APP.MYTEST
    # 
    """
    def metrics_dmdbstatus_l(self):
        try:
            result = os.popen("dmdb_status -l | sed '1,5d' | sed '$d'")
            res = result.read()
            dmdb_locks_num.set(len(res.splitlines()))
            result.close()
        except Exception as err:
            print err

    def run_all_metrics_func(self):
        for func in inspect.getmembers(self, predicate=inspect.ismethod):
            if func[0][:7] == 'metrics':
                func[1]()

@app.route('/sensor')
def sensor():
    dm = DmdbMonitor()
    info_data = dm.run_all_get_func()
    return Response(info_data, mimetype='text/plain')

@app.route('/metrics')
def metrics():
    dm = DmdbMonitor()
    dm.run_all_metrics_func()
    return Response(prometheus_client.generate_latest(registry), mimetype='text/plain')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
