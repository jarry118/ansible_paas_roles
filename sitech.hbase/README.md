## hdfs role使用指南
### 参数介绍

#### 1. 必选参数

|参数名|数据类型|介绍|
|:---|---|---|
|chd5_region_master_nodes|list|hbase集群中为region master节点的ip地址列表|
|cdh5_dfs_zookeeper_hosts|list|hdfs集群使用的zk集群ip地址列表|

#### 2. 其他可选参数

|参数名|数据类型|默认值|介绍|
|:---|---|---|---|
|e3base_version|string|3.0.0|e3base版本号|
|hadoop_version|string|2.6.0|hadoop版本号|
|cdh_version|string|5.14.0|cdh版本号|
|hadoop_user|string|inventory中定义的执行用户|安装使用的linux用户|
|hadoop_group|string|同hadoop_user|安装使用的linux用户所在用户组|
|hbase_pid_home|string|{{ e3_info_home }}/hbase/pids|hbase集群进程号存储目录的绝对路径|
|hbase_log_home|string|{{ e3_info_home }}/hbase/logs|hbase集群日志存储目录的绝对路径|
|chd5_dfs_zookeeper_clientport|int|11001|对应hbase-site.xml的hbase.zookeeper.property.clientPort配置项|
|cdh5_dfs_zookeeper_peerport|int|11002|对应hbase-site.xml的hbase.zookeeper.peerport配置项|
|cdh5_dfs_zookeeper_leaderport|int|11002|对应hbase-site.xml的hbase.zookeeper.leaderport配置项|


> * 可选参数已参考e3base的部署手册，按部署手册已进行了配置，一般情况不建议修改
> * 由于hbase中涉及内存配置和执行用户获取等功能, 需依赖gather_facts功能，本role禁止关闭gather_facts选项
> * 特别提醒: 由于hbase依赖于hdfs, 多数参数的获取无法直接定义，需依赖hdfs的配置文件和hdfs安装过程增加的环境变量配置，请保证hbase的执行用户与hdfs执行用户一致，否则将无法正常获取java_home, hadoop_home, e3_info_home等参数值


### 测试

* test_hbase.yml

```
---
- hosts: test
  vars:
    chd5_region_master_nodes:
      - 172.17.0.2
      - 172.17.0.3
    cdh5_dfs_zookeeper_hosts:
      - 172.17.0.4
      - 172.17.0.5
      - 172.17.0.6
  roles:
    - sitech.hbase
```
