## zookeeper role使用指南
### 参数介绍

#### 动态参数

|参数名|数据类型|默认值|介绍|
|:---|---|---|---|
|zookeeper_version|string|3.4.12|zookeeper版本号|
|client_port|int|2181|zookeeper端口号|
|zookeeper_cluster_ports|string|2881:3881|zookeeper集群端口|
|zookeeper_dir|string|/dmdb|zookeeper安装目录的绝对路径|
|init_limit|int|5|zookeeper初始化连接时最长能忍受多少个心跳时间间隔数|
|sync_limit|int|2|zookeeper请求和应答时间长度|
|tick_time|int|2000|Zookeeper独立的工作时间单元|
|zookeeper_autopurge_purgeInterval|int|0|zookeeper设置多少小时清理一次日志|
|zookeeper_autopurge_snapRetainCount|int|10|zookeeper设置保留多少个snapshot|
|zookeeper_max_client_connections|int|60|zookeeper最大的客户端连接数|


> * zookeeper测试安装版本为3.4.12
> * JDK版本要求在1.8.0以上


### 测试

* zookeeper.yml

```
---
- hosts: all 
  gather_facts: true
  vars:
    - dynamic:
        zookeeper_version: 3.4.12
        client_port: 2181
        zookeeper_cluster_ports: 2881:3881
        zookeeper_dir： /dmdb
  roles:
    - zookeeper
```