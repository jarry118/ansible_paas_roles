
SET SESSION FOREIGN_KEY_CHECKS=0;



/* Drop Tables */

DROP TABLE IF EXISTS ble_base_info_1;
DROP TABLE IF EXISTS ble_dest_topic_rel_1;
DROP TABLE IF EXISTS broker_base_info_1;
DROP TABLE IF EXISTS client_base_info_1;
DROP TABLE IF EXISTS client_limit_info_1;
DROP TABLE IF EXISTS consume_notice_info_1;
DROP TABLE IF EXISTS consume_order_info_1;
DROP TABLE IF EXISTS dest_topic_info_1;
DROP TABLE IF EXISTS idmm_function_info;
DROP TABLE IF EXISTS idmm_manager_bk_mon_data;
DROP TABLE IF EXISTS idmm_manager_bk_mon_detail;
DROP TABLE IF EXISTS idmm_manager_ble_mon_data;
DROP TABLE IF EXISTS idmm_manager_ble_mon_detail;
DROP TABLE IF EXISTS idmm_manager_ble_queue_data;
DROP TABLE IF EXISTS idmm_manager_db_mon_data;
DROP TABLE IF EXISTS idmm_manager_mng_mon_data;
DROP TABLE IF EXISTS idmm_manager_msgs_statistics;
DROP TABLE IF EXISTS idmm_manager_zk_mon_data;
DROP TABLE IF EXISTS idmm_op_log;
DROP TABLE IF EXISTS idmm_role_func_rel;
DROP TABLE IF EXISTS idmm_role_info;
DROP TABLE IF EXISTS idmm_task_detail;
DROP TABLE IF EXISTS idmm_task_info;
DROP TABLE IF EXISTS idmm_user_info;
DROP TABLE IF EXISTS idmm_user_role_rel;
DROP TABLE IF EXISTS idmm_version_check;
DROP TABLE IF EXISTS idmm_version_info;
DROP TABLE IF EXISTS priority_map_1;
DROP TABLE IF EXISTS src_topic_info_1;
DROP TABLE IF EXISTS topic_attribute_info_1;
DROP TABLE IF EXISTS topic_mapping_rel_1;
DROP TABLE IF EXISTS topic_publish_rel_1;
DROP TABLE IF EXISTS topic_subscribe_rel_1;
DROP TABLE IF EXISTS t_sequence;
DROP TABLE IF EXISTS white_list_index_1;
DROP TABLE IF EXISTS white_list_1;
DROP TABLE IF EXISTS idmm_client_online_data;
DROP TABLE IF EXISTS idmm_opera_err_log;
DROP TABLE IF EXISTS timing_message;



/* Create Tables */

-- 定时消费表
CREATE TABLE timing_message
(
	idmm_msg_id varchar(60) NOT NULL COMMENT 'idmm创建的消息id',
	create_time bigint(20) COMMENT '消息生产时间',
	req_time bigint(20) COMMENT '消费时间',
	-- 状态0：未操作，1：已操作，2：正在处理
	status char(1) NOT NULL COMMENT '处理状态 : 状态0：未操作，1：已操作，2：正在处理',
	PRIMARY KEY (idmm_msg_id)
) COMMENT = '定时消费表' DEFAULT CHARACTER SET utf8;

-- 异常日志表
CREATE TABLE idmm_opera_err_log
(
	ip char(15) COMMENT 'ip',
	log_file varchar(120) COMMENT '日志文件',
	log_content blob COMMENT '日志内容',
	log_time datetime COMMENT '日志产生时间'
) COMMENT = '异常日志表' DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;


-- 订阅者客户端在线数
CREATE TABLE idmm_client_online_data
(
	id bigint  COMMENT '流水id',
	-- 目标主题
	dest_topic_id char(32) NOT NULL COMMENT '目标主题 : 目标主题',
	-- 订阅者名称
	client_id char(32) NOT NULL COMMENT '订阅者id : 订阅者名称',
	client_count bigint NOT NULL COMMENT '客户端连接数',
	-- 监控时间,YYYYMMDDHH24MISS
	monitor_time datetime NOT NULL COMMENT '监控时间,YYYYMMDDHH24MISS : 监控时间,YYYYMMDDHH24MISS'	
) COMMENT = '订阅者客户端在线数' DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

-- BLE基本信息表
CREATE TABLE ble_base_info_1
(
	BLE_id numeric(8) NOT NULL COMMENT 'BLE节点标识',
	id_number numeric(1) NOT NULL COMMENT '节点序号',
	addr_ip char(15) NOT NULL COMMENT '节点ip地址',
	addr_port numeric(5) NOT NULL COMMENT '节点通信端口',
	-- 0&1
	-- 指配置上的节点使用标志，以方便人工停用某些节点，不是实际生产中节点的实际运行状态；
	-- 生产中实际运行的节点状态可以从zookeeper中获得； 
	-- 1：在用
	-- 0：停用
	use_status char NOT NULL COMMENT '使用标志 : 0&1
指配置上的节点使用标志，以方便人工停用某些节点，不是实际生产中节点的实际运行状态；
生产中实际运行的节点状态可以从zookeeper中获得； 
1：在用
0：停用',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (BLE_id, id_number),
	UNIQUE (BLE_id, id_number),
	UNIQUE (BLE_id, addr_ip, addr_port)
) COMMENT = 'BLE基本信息表' DEFAULT CHARACTER SET utf8;


-- 目标主题归属BLE关系表
CREATE TABLE ble_dest_topic_rel_1
(
	dest_topic_id char(32) NOT NULL COMMENT '目标主题id',
	BLE_id numeric(8) NOT NULL COMMENT 'BLE节点标识',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (dest_topic_id, BLE_id),
	UNIQUE (dest_topic_id, BLE_id)
) COMMENT = '目标主题归属BLE关系表' DEFAULT CHARACTER SET utf8;


-- Broker基本信息表
CREATE TABLE broker_base_info_1
(
	-- >0
	broker_id numeric(8) NOT NULL COMMENT 'Broker节点标识 : >0',
	-- IP地址格式
	comm_ip char(15) NOT NULL COMMENT 'ip地址 : IP地址格式',
	-- 1025-65535
	comm_port numeric(15) NOT NULL COMMENT '通信端口 : 1025-65535',
	-- 0&1
	-- 指配置上的节点使用标志，以方便人工停用某些节点，不是实际生产中节点的实际运行状态；
	-- 生产中实际运行的节点状态可以从zookeeper中获得； 
	-- 1：在用
	-- 0：停用
	use_status char NOT NULL COMMENT '使用标志 : 0&1
指配置上的节点使用标志，以方便人工停用某些节点，不是实际生产中节点的实际运行状态；
生产中实际运行的节点状态可以从zookeeper中获得； 
1：在用
0：停用',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (broker_id)
) COMMENT = 'Broker基本信息表' DEFAULT CHARACTER SET utf8;


-- client基本信息表
CREATE TABLE client_base_info_1
(
	-- 客户端id
	client_id char(32) NOT NULL COMMENT '客户端id : 客户端id',
	-- 子系统名称
	sub_system char(32) NOT NULL COMMENT '归属子系统 : 子系统名称',
	-- 自定义格式
	client_desc varchar(2048) NOT NULL COMMENT 'Client身份说明 : 自定义格式',
	-- 0：停用
	-- 1：使用
	use_status char NOT NULL COMMENT '使用标志 : 0：停用
1：使用',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (client_id)
) COMMENT = 'client基本信息表' DEFAULT CHARACTER SET utf8;


-- client访问控制表
CREATE TABLE client_limit_info_1
(
	-- 客户端id
	client_id char(32) NOT NULL COMMENT '客户端id : 客户端id',
	limit_key char(8) NOT NULL COMMENT '限制类型',
	limit_value varchar(2048) NOT NULL COMMENT '限制范围',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (client_id, limit_key)
) COMMENT = 'client访问控制表' DEFAULT CHARACTER SET utf8;


-- 消费结果回送配置表
CREATE TABLE consume_notice_info_1
(
	producer_client_id char(32) NOT NULL COMMENT '生产者客户端id',
	-- 前缀s
	src_topic_id char(32) NOT NULL COMMENT '原始主题id : 前缀s',
	dest_topic_id char(32) NOT NULL COMMENT '目标主题id',
	consumer_client_id char(32) NOT NULL COMMENT '消费者客户端',
	notice_topic_id char(32) NOT NULL COMMENT '保存消费结果的目标主题',
	-- 接收消费结果的客户端id，可以和生产者相同
	notice_client_id char(32) NOT NULL COMMENT '接收消费结果的客户端id : 接收消费结果的客户端id，可以和生产者相同',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (producer_client_id, src_topic_id, dest_topic_id, consumer_client_id)
) COMMENT = '消费结果回送配置表' DEFAULT CHARACTER SET utf8;


-- 消费顺序配置表 : 同一个clientid+原始主题+业务属性可能产生N个目标主题，这些目标主题的消费次序由consum
CREATE TABLE consume_order_info_1
(
	-- 前缀s
	src_topic_id char(32) NOT NULL COMMENT '原始主题id : 前缀s',
	-- 含_all
	attribute_key char(32) NOT NULL COMMENT '属性key : 含_all',
	-- 含_default
	attribute_value char(32) NOT NULL COMMENT '属性value : 含_default',
	dest_topic_id char(32) NOT NULL COMMENT '目标主题id',
	consumer_client_id char(32) NOT NULL COMMENT '消费者客户端',
	-- 从0开始计数
	consume_seq int NOT NULL COMMENT '消费次序 : 从0开始计数',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (src_topic_id, attribute_key, attribute_value, dest_topic_id, consumer_client_id, consume_seq)
) COMMENT = '消费顺序配置表 : 同一个clientid+原始主题+业务属性可能产生N个目标主题，这些目标主题的消费次序由consum' DEFAULT CHARACTER SET utf8;


-- 目标主题信息表
CREATE TABLE dest_topic_info_1
(
	dest_topic_id char(32) NOT NULL COMMENT '目标主题id',
	dest_topic_desc varchar(2048) NOT NULL COMMENT '目标主题描述',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (dest_topic_id)
) COMMENT = '目标主题信息表' DEFAULT CHARACTER SET utf8;


-- 前台功能说明
CREATE TABLE idmm_function_info
(
	function_code varchar(60) NOT NULL COMMENT '功能编码',
	function_name varchar(120) NOT NULL COMMENT '功能名称',
	-- 是否可以作为下拉框的选择项
	is_query char DEFAULT 'Y' NOT NULL COMMENT '是否可供查询筛选使用 : 是否可以作为下拉框的选择项',
	PRIMARY KEY (function_code)
) COMMENT = '前台功能说明' DEFAULT CHARACTER SET utf8;


-- idmm_manager_bk_mon_data
CREATE TABLE idmm_manager_bk_mon_data
(
	-- 唯一流水,自增
	id bigint(20) NOT NULL AUTO_INCREMENT COMMENT '唯一流水,自增 : 唯一流水,自增',
	-- 监控时间,YYYYMMDDHH24MISS
	monitor_time datetime NOT NULL COMMENT '监控时间,YYYYMMDDHH24MISS : 监控时间,YYYYMMDDHH24MISS',
	-- Broker节点标识
	broker_id char(8) NOT NULL COMMENT 'Broker节点标识 : Broker节点标识',
	-- Broker节点地址
	broker_addr char(32) NOT NULL COMMENT 'Broker节点地址 : Broker节点地址',
	-- broker节点状态
	status char COMMENT 'broker节点状态 : broker节点状态',
	-- 客户端连接数
	client_count int DEFAULT 0 NOT NULL COMMENT '客户端连接数 : 客户端连接数',
	-- tps
	tps float(8,2) DEFAULT 0.00 NOT NULL COMMENT 'tps : tps',
	-- send消息数
	msg_send_count bigint(20) COMMENT 'send消息数 : send消息数',
	-- send确认消息
	msg_send_commit_count bigint(20) COMMENT 'send确认消息 : send确认消息',
	-- fetch消息数
	msg_receive_count bigint(20) COMMENT 'fetch消息数 : fetch消息数',
	-- fetch确认消息数
	msg_receive_commit_count bigint(20) COMMENT 'fetch确认消息数 : fetch确认消息数',
	-- 节点内存使用率
	host_mem_use float(5,2) COMMENT '节点内存使用率 : 节点内存使用率',
	-- 节点cpu使用率
	host_cpu_use float(5,2) COMMENT '节点cpu使用率 : 节点cpu使用率',
	-- 节点所在主机的文件系统使用率
	host_space_use float(5,2) COMMENT '节点所在主机的文件系统使用率 : 节点所在主机的文件系统使用率',
	PRIMARY KEY (id)
) COMMENT = 'idmm_manager_bk_mon_data' DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;


-- idmm_manager_bk_mon_detail
CREATE TABLE idmm_manager_bk_mon_detail
(
	-- 唯一流水,和idmm_manager_bk_mon_data id字段对应
	id bigint(20) NOT NULL COMMENT '唯一流水,和idmm_manager_bk_mon_data id字段对应 : 唯一流水,和idmm_manager_bk_mon_data id字段对应',
	-- 监控时间,YYYYMMDDHH24MISS
	monitor_time datetime NOT NULL COMMENT '监控时间,YYYYMMDDHH24MISS : 监控时间,YYYYMMDDHH24MISS',
	-- Broker节点标识
	broker_id char(8) NOT NULL COMMENT 'Broker节点标识 : Broker节点标识',
	-- 客户端id
	client_id char(32) NOT NULL COMMENT '客户端id : 客户端id',
	-- 客户端地址
	client_ip char(32) NOT NULL COMMENT '客户端地址 : 客户端地址',
	-- 客户端类型，P：生产者；S：订阅者
	client_type char NOT NULL COMMENT '客户端类型，P：生产者；S：订阅者 : 客户端类型，P：生产者；S：订阅者',
	-- 客户端第一次访问时间
	first_connect_time datetime COMMENT '客户端第一次访问时间 : 客户端第一次访问时间',
	-- 客户端最后一次访问时间
	last_connect_time datetime COMMENT '客户端最后一次访问时间 : 客户端最后一次访问时间',
	-- 保留字段1
	RESERVE1 varchar(255) COMMENT '保留字段1 : 保留字段1',
	-- 保留字段2
	RESERVE2 varchar(255) COMMENT '保留字段2 : 保留字段2',
	-- 保留字段3
	RESERVE3 varchar(255) COMMENT '保留字段3 : 保留字段3',
	-- 保留字段4
	RESERVE4 varchar(255) COMMENT '保留字段4 : 保留字段4'
) COMMENT = 'idmm_manager_bk_mon_detail' DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;


-- idmm_manager_ble_mon_data
CREATE TABLE idmm_manager_ble_mon_data
(
	id bigint(16) NOT NULL COMMENT 'id',
	-- 监控时间
	monitor_time datetime NOT NULL COMMENT '监控时间 : 监控时间',
	BLE_id numeric(8) NOT NULL COMMENT 'BLE_id',
	-- 节点ip地址
	addr_ip char(15) COMMENT '节点ip地址 : 节点ip地址',
	-- 节点通信端口
	addr_port decimal(5) COMMENT '节点通信端口 : 节点通信端口',
	-- ble进程状态
	status char COMMENT 'ble进程状态 : ble进程状态',
	-- ble节点类型（主、备）
	BLE_TYPE char COMMENT 'ble节点类型（主、备） : ble节点类型（主、备）',
	-- broker节点上的客户端连接数
	client_count int COMMENT 'broker节点上的客户端连接数 : broker节点上的客户端连接数',
	-- 性能数据
	tps decimal COMMENT '性能数据 : 性能数据',
	host_mem_use float(5,2) COMMENT 'host_mem_use',
	host_cpu_use float(5,2) COMMENT 'host_cpu_use',
	host_space_use float(5,2) COMMENT 'host_space_use'	
) COMMENT = 'idmm_manager_ble_mon_data' DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;


-- idmm_manager_ble_mon_detail
CREATE TABLE idmm_manager_ble_mon_detail
(
	id int NOT NULL COMMENT 'id',
	-- 监控时间
	monitor_time datetime COMMENT '监控时间 : 监控时间',
	ble_id decimal(5) COMMENT 'ble_id',
	-- 客户端id
	client_id char(32) COMMENT '客户端id : 客户端id',
	-- 客户端ip
	client_ip char(15) COMMENT '客户端ip : 客户端ip',
	-- 客户端第一次访问时间
	first_connect_time datetime COMMENT '客户端第一次访问时间 : 客户端第一次访问时间',
	-- 客户端最后一次访问时间
	last_connect_time datetime COMMENT '客户端最后一次访问时间 : 客户端最后一次访问时间',
	PRIMARY KEY (id)
) COMMENT = 'idmm_manager_ble_mon_detail' DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;


-- ble内存队列信息
CREATE TABLE idmm_manager_ble_queue_data
(
	-- 监控时间,YYYYMMDDHH24MISS
	monitor_time datetime NOT NULL COMMENT '监控时间,YYYYMMDDHH24MISS : 监控时间,YYYYMMDDHH24MISS',
	-- BLE_id
	ble_id bigint(20) NOT NULL COMMENT 'BLE_id : BLE_id',
	ble_ip char(20) COMMENT 'ble_ip',
	-- 目标主题
	dest_topic_id char(32) NOT NULL COMMENT '目标主题 : 目标主题',
	-- 订阅者名称
	client_id char(32) NOT NULL COMMENT '订阅者id : 订阅者名称',
	total_count bigint(20) COMMENT '消息总数',
	sending_count bigint(20) COMMENT '正在处理的消息数量',
	blocking_count bigint(20) COMMENT '锁定消息数',
	err_count bigint(20) COMMENT '错误消息数',
	queue_size bigint(20) COMMENT '队列长度',
	max_unsub_time bigint(20) COMMENT '队列长度',
	max_unsign_time bigint(20) COMMENT '队列长度',
	retry_times bigint(20) COMMENT '队列长度',
	-- 消费者客户端连接数
	client_conn_count bigint COMMENT '消费者客户端连接数 : 消费者客户端连接数'
) COMMENT = 'ble内存队列信息' DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;


-- mysql节点监控信息表
CREATE TABLE idmm_manager_db_mon_data
(
	id int(11) NOT NULL COMMENT '唯一流水',
	monitor_time datetime NOT NULL COMMENT '监控时间',
	db_addr char(20) COMMENT '节点地址',
	identity char(1) COMMENT '节点类型。0:follower,1:leader',
	status char(1) COMMENT '运行状态。0:dead,1:running',
	client_count int(5) COMMENT '客户端连接数',
	reserve1 char(64) COMMENT '保留字1',
	reserve2 char(255) COMMENT '保留字2',
	reserve3 char(255) COMMENT '保留字3',
	PRIMARY KEY (id)
) COMMENT = 'mysql节点监控信息表' DEFAULT CHARACTER SET utf8;


-- manager节点监控信息表
CREATE TABLE idmm_manager_mng_mon_data
(
	id int(11) NOT NULL COMMENT '唯一流水',
	monitor_time datetime NOT NULL COMMENT '监控时间',
	mng_addr char(20) COMMENT '节点地址',
	status char(1) COMMENT '运行状态。0:dead,1:running',
	reserve1 char(64) COMMENT '保留字1',
	reserve2 char(255) COMMENT '保留字2',
	reserve3 char(255) COMMENT '保留字3',
	PRIMARY KEY (id)
) COMMENT = 'manager节点监控信息表' DEFAULT CHARACTER SET utf8;


-- 消息统计信息
CREATE TABLE idmm_manager_msgs_statistics
(
	statistics_date varchar(8) NOT NULL COMMENT '统计时间',
	dest_topic_id varchar(32) NOT NULL COMMENT '目标主题',
	client_id varchar(32) NOT NULL COMMENT '订阅者id',
	succ_count bigint(20) COMMENT '成功数量',
	err_count bigint(20) COMMENT '失败数量',
	PRIMARY KEY (statistics_date, dest_topic_id, client_id)
) COMMENT = '消息统计信息' DEFAULT CHARACTER SET utf8;


-- zk节点监控信息表
CREATE TABLE idmm_manager_zk_mon_data
(
	id int(11) NOT NULL COMMENT '唯一流水',
	monitor_time datetime NOT NULL COMMENT '监控时间',
	zk_id int(2) NOT NULL COMMENT 'zk节点标识',
	zk_addr char(20) COMMENT 'zk节点地址ip:port',
	identity char(1) COMMENT '节点类型。0:follower,1:leader',
	status char(1) COMMENT '运行状态。0:dead,1:running',
	client_count int(5) COMMENT '客户端连接数',
	reserve1 varchar(64) COMMENT '保留字1',
	reserve2 varbinary(255) COMMENT '保留字2',
	PRIMARY KEY (id)
) COMMENT = 'zk节点监控信息表' DEFAULT CHARACTER SET utf8;


-- 日志记录表
CREATE TABLE idmm_op_log
(
	-- 这里特指.do形式的链接
	func_url varchar(120) NOT NULL COMMENT '功能链接 : 这里特指.do形式的链接',
	-- 操作工号
	login_no varchar(32) NOT NULL COMMENT '操作工号 : 操作工号',
	opr_time datetime NOT NULL COMMENT '操作时间',
	note varchar(2048) NOT NULL COMMENT '备注'
) COMMENT = '日志记录表' DEFAULT CHARACTER SET utf8;


-- 角色功能关系表
CREATE TABLE idmm_role_func_rel
(
	role_code varchar(60) NOT NULL COMMENT '角色编码',
	-- 这里特指.do形式的链接
	func_url varchar(120) NOT NULL COMMENT '功能链接 : 这里特指.do形式的链接',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (role_code, func_url)
) COMMENT = '角色功能关系表' DEFAULT CHARACTER SET utf8;


-- 角色信息表
CREATE TABLE idmm_role_info
(
	role_code varchar(60) NOT NULL COMMENT '角色编码',
	role_desc varchar(120) COMMENT '角色描述',
	PRIMARY KEY (role_code)
) COMMENT = '角色信息表' DEFAULT CHARACTER SET utf8;


-- 后台任务明细表
CREATE TABLE idmm_task_detail
(
	-- yyyymmddhhmiss + xxxxxxxx，后8位为序列
	TASK_ID varchar(22) NOT NULL COMMENT '任务ID : yyyymmddhhmiss + xxxxxxxx，后8位为序列',
	SEQ bigint(20) NOT NULL COMMENT '序列号',
	MSG_ID varchar(64) COMMENT '消息ID',
	-- 消息状态.0:send,1:send-commit,2:fecth,3:fetch-blocking,4:fetch-commit,5:succ,6:fail
	msg_status char(1) COMMENT '消息状态 : 消息状态.0:send,1:send-commit,2:fecth,3:fetch-blocking,4:fetch-commit,5:succ,6:fail',
	MSG_CONTENT blob COMMENT '消息内容',
	MSG_PROPERTIES varchar(1024) COMMENT '消息属性',
	-- 前缀s
	src_topic_id char(32) COMMENT '原始主题id : 前缀s',
	dest_topic_id char(32) COMMENT '目标主题id',
	producer_client_id char(32) COMMENT '生产者客户端id',
	consumer_client_id char(32) COMMENT '消费者客户端',
	-- 初始值为空
	-- 0：处理成功
	-- 1：处理完成
	-- 
	OPR_RESULT char COMMENT '操作结果 : 初始值为空
0：处理成功
1：处理完成
',
	op_time datetime COMMENT '操作时间',
	-- 创建时间。insert时取系统时间
	CREATE_TIME timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '创建时间 : 创建时间。insert时取系统时间',
	-- 消息重发时使用
	NEW_MSG_ID varchar(128) COMMENT '新消息ID : 消息重发时使用',
		-- 存放消费者客户端的错误信息
	err_desc varchar(1024) COMMENT '错误描述 : 存放消费者客户端的错误信息',
	PRIMARY KEY (TASK_ID, SEQ, MSG_ID)
) COMMENT = '后台任务明细表' DEFAULT CHARACTER SET utf8;


-- 后台任务信息表
CREATE TABLE idmm_task_info
(
	-- yyyymmddhhmiss + xxxxxxxx，后8位为序列
	TASK_ID varchar(22) NOT NULL COMMENT '任务ID : yyyymmddhhmiss + xxxxxxxx，后8位为序列',
	-- 操作任务编码
	-- 消息发送通知：sendMessageNotice；
	-- 消息接收通知：
	-- fetchMessageNotice；
	-- 在途消息查询：
	-- onlineQuery；
	-- 在途消息删除通知：
	-- onlineDelNotice；
	-- 消息重发查询：
	-- resendQuery；
	-- 消息重发通知：
	-- resendMessageNotice；
	-- 消息重置查询：
	-- resetQuery；
	-- 消息重置通知：
	-- resetMessageNotice；
	-- 
	TASK_CODE varchar(32) NOT NULL COMMENT '任务编码 : 操作任务编码
消息发送通知：sendMessageNotice；
消息接收通知：
fetchMessageNotice；
在途消息查询：
onlineQuery；
在途消息删除通知：
onlineDelNotice；
消息重发查询：
resendQuery；
消息重发通知：
resendMessageNotice；
消息重置查询：
resetQuery；
消息重置通知：
resetMessageNotice；
',
	-- 0：待处理
	-- 1：处理中
	-- 2：处理结束
	-- 
	OPR_STATUS char(1) NOT NULL COMMENT '操作状态 : 0：待处理
1：处理中
2：处理结束
',
	-- 初始值为空
	-- 0：处理成功
	-- 1：处理完成
	-- 
	OPR_RESULT char COMMENT '操作结果 : 初始值为空
0：处理成功
1：处理完成
',
	-- 操作开始时间。insert时取系统时间
	OPR_BEGIN datetime NOT NULL COMMENT '操作开始时间 : 操作开始时间。insert时取系统时间',
	-- 操作结束时间。操作完成后更新此字段
	OPR_END datetime COMMENT '操作结束时间 : 操作结束时间。操作完成后更新此字段',
	RECORD_COUNTS bigint(10) COMMENT '操作记录条数',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	note varchar(2048) COMMENT '备注',
	Contition_express varchar(2048) COMMENT '查询条件',
	PRIMARY KEY (TASK_ID, TASK_CODE)
) COMMENT = '后台任务信息表' DEFAULT CHARACTER SET utf8;


-- 用户信息表 : 用于登录控制
CREATE TABLE idmm_user_info
(
	-- 操作工号
	login_no varchar(32) NOT NULL COMMENT '操作工号 : 操作工号',
	password varchar(120) NOT NULL COMMENT '工号密码',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (login_no)
) COMMENT = '用户信息表 : 用于登录控制' DEFAULT CHARACTER SET utf8;


-- 用户角色信息表
CREATE TABLE idmm_user_role_rel
(
	-- 操作工号
	login_no varchar(32) NOT NULL COMMENT '操作工号 : 操作工号',
	role_code varchar(60) NOT NULL COMMENT '角色编码',
	PRIMARY KEY (login_no)
) COMMENT = '用户角色信息表' DEFAULT CHARACTER SET utf8;


-- 版本配置数据校验规则表
CREATE TABLE idmm_version_check
(
	check_type varchar(60) NOT NULL COMMENT '校验大类',
	check_num varchar(10) NOT NULL COMMENT '校验规则编号',
	check_object varchar(60) NOT NULL COMMENT '校验对象',
	check_desc varchar(200) NOT NULL COMMENT '校验规则中文描述',
	check_sql varchar(4000) NOT NULL COMMENT '校验sql',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (check_type, check_num)
) COMMENT = '版本配置数据校验规则表' DEFAULT CHARACTER SET utf8;


-- 版本管理表 : 该表中有且仅有一条记录的版本状态为’1’，就是当前在用的配置版本号；当有新版本发布时，在该表中插入新的记
CREATE TABLE idmm_version_info
(
	-- 配置版本号,>0
	config_version numeric(8) NOT NULL COMMENT '配置版本号 : 配置版本号,>0',
	-- 0 审核通过
	-- 1 使用中
	-- 2 编辑中
	-- 3 待审核
	version_status char NOT NULL COMMENT '版本状态 : 0 审核通过
1 使用中
2 编辑中
3 待审核',
	version_desc varchar(2048) NOT NULL COMMENT '版本描述',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (config_version)
) COMMENT = '版本管理表 : 该表中有且仅有一条记录的版本状态为’1’，就是当前在用的配置版本号；当有新版本发布时，在该表中插入新的记' DEFAULT CHARACTER SET utf8;


-- 优先级映射表 : 优先级名称 与 数字的映射表
CREATE TABLE priority_map_1
(
	-- 优先级名称
	pname varchar(32) NOT NULL COMMENT '优先级名称 : 优先级名称',
	-- 优先级数字
	pvalue int NOT NULL COMMENT '优先级数字 : 优先级数字',
	-- 是否默认优先级， 只能有一个
	-- Y 是
	-- N 否
	-- 
	is_default char(1) COMMENT '是否默认优先级 : 是否默认优先级， 只能有一个
Y 是
N 否
',
	-- 描述
	note varchar(64) COMMENT '描述 : 描述',
	PRIMARY KEY (pvalue),
	UNIQUE (pvalue)
) COMMENT = '优先级映射表 : 优先级名称 与 数字的映射表' DEFAULT CHARACTER SET utf8;


-- 原始主题信息表
CREATE TABLE src_topic_info_1
(
	-- 前缀s
	src_topic_id char(32) NOT NULL COMMENT '原始主题id : 前缀s',
	src_topic_desc varchar(2048) NOT NULL COMMENT '原始主题描述',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (src_topic_id)
) COMMENT = '原始主题信息表' DEFAULT CHARACTER SET utf8;


-- 主题分区属性表 : 如果没有按照分区路由的需求，则只需要配置一个“_all”属性即可，表示不需要分区的情况；
-- 如果有按
CREATE TABLE topic_attribute_info_1
(
	-- 前缀s
	src_topic_id char(32) NOT NULL COMMENT '原始主题id : 前缀s',
	-- 含_all
	attribute_key char(32) NOT NULL COMMENT '属性key : 含_all',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (src_topic_id, attribute_key),
	UNIQUE (src_topic_id, attribute_key)
) COMMENT = '主题分区属性表 : 如果没有按照分区路由的需求，则只需要配置一个“_all”属性即可，表示不需要分区的情况；
如果有按' DEFAULT CHARACTER SET utf8;


-- 主题映射关系表 : 可以针对每一个属性值设置一个或者多个目标主题；
-- 属性值可以是“_default”，表示如果生产者没
CREATE TABLE topic_mapping_rel_1
(
	-- 前缀s
	src_topic_id char(32) NOT NULL COMMENT '原始主题id : 前缀s',
	-- 含_all
	attribute_key char(32) NOT NULL COMMENT '属性key : 含_all',
	-- 含_default
	attribute_value char(32) NOT NULL COMMENT '属性value : 含_default',
	dest_topic_id char(32) NOT NULL COMMENT '目标主题id',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (src_topic_id, attribute_key, attribute_value, dest_topic_id)
) COMMENT = '主题映射关系表 : 可以针对每一个属性值设置一个或者多个目标主题；
属性值可以是“_default”，表示如果生产者没' DEFAULT CHARACTER SET utf8;


-- 主题发布关系表 : 用于描述生产者客户端发布原始主题消息的权限关系；
CREATE TABLE topic_publish_rel_1
(
	-- 客户端id
	client_id char(32) NOT NULL COMMENT '客户端id : 客户端id',
	-- 前缀s
	src_topic_id char(32) NOT NULL COMMENT '原始主题id : 前缀s',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (client_id, src_topic_id),
	UNIQUE (client_id, src_topic_id)
) COMMENT = '主题发布关系表 : 用于描述生产者客户端发布原始主题消息的权限关系；' DEFAULT CHARACTER SET utf8;


-- 主题订阅关系表 : 用于描述消费者客户端接收主题消息的关系；
CREATE TABLE topic_subscribe_rel_1
(
	-- 客户端id
	client_id char(32) NOT NULL COMMENT '客户端id : 客户端id',
	dest_topic_id char(32) NOT NULL COMMENT '目标主题id',
	max_request int(3) COMMENT '最大并发数',
	min_timeout int(8) COMMENT '最小超时时间',
	max_timeout int(8) COMMENT '最大超时时间',
	-- 消费速度限制， 单位 n/miniute
	consume_speed_limit int DEFAULT -1 NOT NULL COMMENT '消费速度限制 : 消费速度限制， 单位 n/miniute',
	-- 积压消息数  最大值
	max_messages int COMMENT '积压消息数最大值 : 积压消息数  最大值',
	-- 积压消息数告警值
	warn_messages int COMMENT '积压消息数告警值 : 积压消息数告警值',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	-- 操作工号
	login_no varchar(32) COMMENT '操作工号 : 操作工号',
	opr_time datetime COMMENT '操作时间',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (client_id, dest_topic_id),
	UNIQUE (client_id, dest_topic_id)
) COMMENT = '主题订阅关系表 : 用于描述消费者客户端接收主题消息的关系；' DEFAULT CHARACTER SET utf8;


-- 序列表
CREATE TABLE t_sequence
(
	table_name varchar(50) NOT NULL COMMENT '表名',
	column_name varchar(50) NOT NULL COMMENT '列名',
	next_value int NOT NULL COMMENT '下一个值',
	seq_increment int NOT NULL COMMENT '步长',
	note varchar(2048) COMMENT '备注',
	PRIMARY KEY (table_name, column_name)
) COMMENT = '序列表' DEFAULT CHARACTER SET utf8;


-- 白名单信息索引表
CREATE TABLE white_list_index_1
(
	-- 用于与white_list_index关联
	index_id varchar(60) NOT NULL COMMENT '索引id : 用于与white_list_index关联',
	begin_ip varchar(15) NOT NULL COMMENT '起始ip地址',
	end_ip varchar(15) NOT NULL COMMENT '终止ip地址',
	-- 0&1
	use_status varchar(1) NOT NULL COMMENT '使用标志 : 0&1',
	PRIMARY KEY (index_id)
) COMMENT = '白名单信息索引表' DEFAULT CHARACTER SET utf8;


-- 白名单信息表
CREATE TABLE white_list_1
(
	ip varchar(15) NOT NULL COMMENT 'ip地址',
	-- 用于与white_list_index关联
	index_id varchar(60) NOT NULL COMMENT '索引id : 用于与white_list_index关联',
	-- 0&1
	use_status varchar(1) DEFAULT '1' NOT NULL COMMENT '使用标志 : 0&1',
	PRIMARY KEY (ip, use_status)
) COMMENT = '白名单信息表' DEFAULT CHARACTER SET utf8;





