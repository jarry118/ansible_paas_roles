## hdfs role使用指南
### 参数介绍

#### 1. 必选参数

|参数名|数据类型|介绍|
|:---|---|---|
|hadoop_namenodes_list|list|hdfs集群中为namenode的ip地址列表|
|hadoop_home|string|hdfs安装目录|
|java_home|string|jdk安装目录|
|hadoop_resourcemanager_list|list|hdfs集群中为resourcemanager的ip地址列表|
|hadoop_journalnode_list|list|hdfs集群中为journalnode的ip地址列表|
|hadoop_mapreduce_node|string|hdfs集群中为mapreduce的ip地址|
|cdh5_dfs_zookeeper_hosts|list|hdfs集群使用的zk集群ip地址列表|
|cdh5_dfs_zookeeper_clientport|string|hdfs集群使用的zk集群服务绑定端口号|

#### 2. 其他可选参数

|参数名|数据类型|默认值|介绍|
|:---|---|---|---|
|e3base_version|string|3.0.0|e3base版本号|
|hadoop_version|string|2.6.0|hadoop版本号|
|cdh_version|string|5.14.0|cdh版本号|
|hadoop_user|string|inventory中定义的执行用户|安装使用的linux用户|
|hadoop_group|string|同hadoop_user|安装使用的linux用户所在用户组|
|java_version|string|1.8|jdk版本号|
|java_home|string|/opt/java|jdk安装的绝对路径|
|hadoop_home|string|{{ home }}/hadoop|hdfs安装的绝对路径|
|e3_info_home|string|{{ home }}/e3-info|e3_info_home绝对路径|
|hadoop_log_home|string|{{ e3_info_home }}/hadoop/logs|hdfs日志存储目录的绝对路径|
|hadoop_pid_home|string|{{ e3_info_home }}/hadoop/pids|hdfs进程号存储目录的绝对路径|
|cdh5_dfs_nameservices|string|drmcluster|hdfs的nameservices|
|cdh5_dfs_hadoop_tmp_dir|string|{{ e3_info_home }}/hadoop/tmp/hadoop-${user.name}|对应core-site.xml的hadoop.tmp.dir配置项|
|cdh5_dfs_journalnode_edits_dir|string|{{ e3_info_home }}/hadoop/jn||
|cdh5_dfs_namenode_name_dir|string|file://{{ e3_info_home }}/hadoop/nn|对应hdfs-site.xml的dfs.namenode.name.dir配置项|
|cdh5_dfs_datanode_data_dir_list|list|['/data1', '/data2', '/data3']|hdfs使用的数据磁盘挂载个根目录的绝对路径|
|cdh5_dfs_hosts_exclude|string|{{ hadoop_home }}/etc/hadoop/dn-exclude|对应hdfs-site.xml的dfs.hosts.exclude配置项|
|cdh5_dfs_hosts|string|{{ hadoop_home }}/etc/hadoop/dn-include|对应hdfs-site.xml的dfs.hosts配置项|
|cdh5_yarn_rmnode_include|string|{{ hadoop_home }}/etc/hadoop/nm-include|对应yarn-site.xml的yarn.resourcemanager.nodes.include-path配置项|
|cdh5_yarn_rmnode_exclude|string|{{ hadoop_home }}/etc/hadoop/nm-exclude|对应yarn-site.xml的yarn.resourcemanager.nodes.exclude-path配置项|

> * 可选参数已参考e3base的部署手册，按部署手册已进行了配置，一般情况不建议修改
> * 由于hadoop中涉及内存配置和执行用户获取等功能, 需依赖gather_facts功能，本role禁止关闭gather_facts选项

### 测试

* test_hdfs.yml

```
---
- hosts: test
  vars:
    hadoop_namenodes_list:
      - 172.17.0.2
      - 172.17.0.3
    hadoop_resourcemanager_list:
      - 172.17.0.2
      - 172.17.0.3
    hadoop_journalnode_list:
      - 172.17.0.4
      - 172.17.0.5
      - 172.17.0.6
    hadoop_mapreduce_node: 172.17.0.4
    cdh5_dfs_zookeeper_hosts:
      - 172.17.0.4
      - 172.17.0.5
      - 172.17.0.6
    cdh5_dfs_zookeeper_clientport: 11001
    java_home: /opt/java
    hadoop_home: /e3base/hadoop

  roles:
    - sitech.hdfs
```
