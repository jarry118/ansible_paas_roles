-- 优先级映射表默认数据
INSERT INTO `priority_map_1` (pvalue,pname, is_default,note) VALUES ('100', 'L', 'N', '低优先级');
INSERT INTO `priority_map_1` (pvalue,pname, is_default,note) VALUES ('200', 'M', 'Y', '中优先级');
INSERT INTO `priority_map_1` (pvalue,pname, is_default,note) VALUES ('300', 'H', 'N', '高优先级');


-- 创建版本及配置表需要的序列信息表
INSERT INTO `t_sequence` VALUES ('IDMM_VERSION_INFO', 'CONFIG_VERSION', '1', '1', null);

-- 版本校验规则表
-- ----------------------------
-- Records of idmm_version_check
-- ----------------------------
INSERT INTO `idmm_version_check` VALUES ('busiCheck', '1_1', '原始主题', '原始主题[xxx]至少应该有1个发布关系.', 'SELECT  a.src_topic_id as resultId FROM  src_topic_info_#configVersion a LEFT JOIN topic_publish_rel_#configVersion b ON a.src_topic_id = b.src_topic_id WHERE  b.src_topic_id IS NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('busiCheck', '1_2', '原始主题', '原始主题[xxx]至少应该有1个主题映射关系.', 'SELECT  a.src_topic_id as resultId   FROM   src_topic_info_#configVersion a LEFT JOIN topic_mapping_rel_#configVersion b    ON a.src_topic_id = b.src_topic_id  WHERE b.src_topic_id IS NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('busiCheck', '2_1', '客户端', '客户端[xxx]至少应该有1个发布关系或1个订阅关系.', 'select c.client_id as resultId  from client_base_info_#configVersion c  where c.client_id not in (  select a.client_id from topic_publish_rel_#configVersion a  union  select b.client_id from topic_subscribe_rel_#configVersion b )', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('busiCheck', '3_1', 'BLE', 'BLE[xxx]至少应该有1个目标主题.', 'select distinct a.ble_id as resultId   from ble_base_info_#configVersion a left join ble_dest_topic_rel_#configVersion b   ON a.ble_id = b.ble_id  where b.ble_id is null', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('busiCheck', '4_1', '目标主题', '目标主题[xxx]至少应该有1个订阅关系.', 'select a.dest_topic_id as resultId  from dest_topic_info_#configVersion a left join topic_subscribe_rel_#configVersion b  on a.dest_topic_id = b.dest_topic_id  where b.dest_topic_id is null', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('busiCheck', '4_2', '目标主题', '目标主题[xxx]至少应该有1个主题映射关系,或1个消费结果通知关系.', 'select a.dest_topic_id as resultId  from dest_topic_info_#configVersion a left join topic_mapping_rel_#configVersion b  on a.dest_topic_id = b.dest_topic_id  where b.dest_topic_id is null and a.dest_topic_id not in (select notice_topic_id from consume_notice_info_#configVersion)', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('busiCheck', '4_3', '目标主题', '目标主题[xxx]必须有归属BLE.', 'select a.dest_topic_id as resultId  from dest_topic_info_#configVersion a left join ble_dest_topic_rel_#configVersion b  on a.dest_topic_id = b.dest_topic_id  where b.dest_topic_id is null', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '10_1', '消费顺序配置表', '映射关系[xxx]在主题发布关系表中不存在.', 'SELECT a.src_topic_id || \'-\' || a.dest_topic_id AS resultId FROM consume_order_info_#configVersion a LEFT JOIN topic_mapping_rel_#configVersion b ON a.dest_topic_id = b.dest_topic_id AND a.src_topic_id = b.src_topic_id WHERE b.dest_topic_id IS NULL GROUP BY a.dest_topic_id, a.dest_topic_id', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '10_2', '消费顺序配置表', '订阅关系[xxx]在主题订阅关系表中不存在.', 'SELECT   a.consumer_client_id||\'-\'||a.dest_topic_id as resultId FROM consume_order_info_#configVersion a LEFT JOIN topic_subscribe_rel_#configVersion b ON a.dest_topic_id=b.dest_topic_id and a.consumer_client_id=b.client_id WHERE b.dest_topic_id IS NULL GROUP BY a.dest_topic_id,a.consumer_client_id', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '10_3', '消费顺序配置表', '原始主题的属性[xxx]在原始主题分区属性表中不存在.', 'SELECT  DISTINCT(concat(a.src_topic_id, \':\', a.attribute_key)) as resultId FROM   consume_order_info_#configVersion a LEFT JOIN topic_attribute_info_#configVersion b ON a.src_topic_id=b.src_topic_id and a.attribute_key = b.attribute_key where a.attribute_key != \'_all\' and b.attribute_key is NULL', 'Y', null);
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '3_1', '客户端访问控制信息表', '客户端[xxx]在客户端定义表中不存在.', 'SELECT  DISTINCT(a.client_id) as resultId FROM  client_limit_info_#configVersion a LEFT JOIN client_base_info_#configVersion b ON a.client_id=b.client_id where b.client_id is NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '4_1', '主题属性表', '原始主题[xxx]在原始主题定义表中不存在', 'SELECT  DISTINCT(a.src_topic_id) as resultId FROM  topic_attribute_info_#configVersion a LEFT JOIN src_topic_info_#configVersion b ON a.src_topic_id=b.src_topic_id where b.src_topic_id is NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '5_1', '目标主题与BLE关系表', '目标主题[xxx]在目标主题定义表中不存在.', 'SELECT  a.dest_topic_id as resultId FROM  ble_dest_topic_rel_#configVersion a LEFT JOIN dest_topic_info_#configVersion b ON a.dest_topic_id=b.dest_topic_id where b.dest_topic_id is NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '5_2', '目标主题与BLE关系表', 'BLE[xxx]在BLE定义表中不存在.', 'SELECT  DISTINCT(a.BLE_id) as resultId FROM  ble_dest_topic_rel_#configVersion a LEFT JOIN ble_base_info_#configVersion b ON a.BLE_id=b.BLE_id where b.BLE_id is NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '6_1', '主题映射关系表', '原始主题[xxx]在原始主题定义表中不存在.', 'SELECT  DISTINCT(a.src_topic_id) as resultId FROM   topic_mapping_rel_#configVersion a LEFT JOIN src_topic_info_#configVersion b ON a.src_topic_id=b.src_topic_id where b.src_topic_id is NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '6_2', '主题映射关系表', '目标主题[xxx]在目标主题定义表中不存在.', 'SELECT  DISTINCT(a.dest_topic_id) as resultId FROM   topic_mapping_rel_#configVersion a LEFT JOIN dest_topic_info_#configVersion b ON a.dest_topic_id=b.dest_topic_id where b.dest_topic_id is NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '6_3', '主题映射关系表', '原始主题的属性[xxx]在原始主题分区属性表中不存在.', 'SELECT  DISTINCT(concat(a.src_topic_id, \':\', a.attribute_key)) as resultId FROM   topic_mapping_rel_#configVersion a LEFT JOIN topic_attribute_info_#configVersion b ON a.src_topic_id=b.src_topic_id and a.attribute_key = b.attribute_key where a.attribute_key != \'_all\' and b.attribute_key is NULL', 'Y', null);
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '7_1', '主题发布关系表', '原始主题[xxx]在原始主题定义表中不存在.', 'SELECT  DISTINCT(a.src_topic_id) as resultId FROM   topic_publish_rel_#configVersion a LEFT JOIN src_topic_info_#configVersion b ON a.src_topic_id=b.src_topic_id where b.src_topic_id is NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '7_2', '主题发布关系表', '发布者客户端[xxx]在客户端定义表中不存在.', 'SELECT  DISTINCT(a.client_id) as resultId FROM   topic_publish_rel_#configVersion a LEFT JOIN client_base_info_#configVersion b ON a.client_id=b.client_id where b.client_id is NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '8_1', '主题订阅关系表', '目标主题[xxx]在目标主题定义表中不存在.', 'SELECT DISTINCT  (a.dest_topic_id) as resultId FROM  topic_subscribe_rel_#configVersion a LEFT JOIN dest_topic_info_#configVersion b ON a.dest_topic_id = b.dest_topic_id WHERE  b.dest_topic_id IS NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '8_2', '主题订阅关系表', '订阅者客户端[xxx]在客户端定义表中不存在.', 'SELECT DISTINCT  (a.client_id) as resultId FROM  topic_subscribe_rel_#configVersion a LEFT JOIN client_base_info_#configVersion b ON a.client_id = b.client_id WHERE  b.client_id IS NULL', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '9_1', '消费结果回送配置表', '发布关系[xxx]在主题发布关系表中不存在.', 'SELECT  a.producer_client_id as resultId,  a.src_topic_id as srcTopicId FROM  consume_notice_info_#configVersion a LEFT JOIN topic_publish_rel_#configVersion b ON a.producer_client_id = b.client_id AND a.src_topic_id = b.src_topic_id WHERE  b.src_topic_id IS NULL  GROUP BY  a.producer_client_id,  a.src_topic_id', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '9_2', '消费结果回送配置表', '订阅关系[xxx]在主题订阅关系表中不存在.', 'SELECT  a.dest_topic_id||\'-\'||a.consumer_client_id as resultId FROM  consume_notice_info_#configVersion a LEFT JOIN topic_subscribe_rel_#configVersion b ON a.consumer_client_id = b.client_id AND a.dest_topic_id = b.dest_topic_id WHERE  b.dest_topic_id IS NULL GROUP BY  a.dest_topic_id,  a.consumer_client_id', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '9_3', '消费结果回送配置表', '映射关系[xxx]在主题映射关系表中不存在.', 'SELECT  a.src_topic_id||\'-\'||a.dest_topic_id as resultId FROM  consume_notice_info_#configVersion a LEFT JOIN topic_mapping_rel_#configVersion b ON a.src_topic_id = b.src_topic_id AND a.dest_topic_id = b.dest_topic_id WHERE  b.dest_topic_id IS NULL GROUP BY  a.src_topic_id,  a.dest_topic_id', 'Y', '');
INSERT INTO `idmm_version_check` VALUES ('tableCheck', '9_4', '消费结果回送配置表', '通知订阅关系[xxx]在主题订阅关系表中不存在.', 'SELECT a.notice_topic_id || \'-\' || a.notice_client_id AS resultId FROM consume_notice_info_#configVersion a LEFT JOIN topic_subscribe_rel_#configVersion b ON a.notice_client_id = b.client_id AND a.notice_topic_id = b.dest_topic_id WHERE b.dest_topic_id IS NULL GROUP BY a.notice_topic_id, a.notice_client_id', 'Y', null);
-- ----------------------------
-- Records of idmm_function_info
-- ----------------------------
INSERT INTO `idmm_function_info` VALUES ('1101', '[系统]用户管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1102', '[系统]日志查询', 'N');
INSERT INTO `idmm_function_info` VALUES ('1200', '[监控]监控主页面', 'N');
INSERT INTO `idmm_function_info` VALUES ('1202', '[监控]监控模块后台', 'N');
INSERT INTO `idmm_function_info` VALUES ('1203', '[维护]消息发送', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1204', '[维护]消息接收', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1205', '[维护]消息删除', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1206', '[维护]消息重置', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1207', '[维护]消息重发', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1208', '[维护]消息查询', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1300', '[配置]版本信息管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1301', '[配置]原始主题信息管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1302', '[配置]Broker信息管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1303', '[配置]BLE信息管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1304', '[配置]目标主题信息管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1305', '[配置]客户端信息管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1306', '[配置]场景配置', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1307', '[配置]主题发布关系管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1308', '[配置]主题订阅关系管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1309', '[配置]主题映射关系管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1310', '[配置]目标主题归属BLE关系管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1311', '[配置]消费顺序配置管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1312', '[配置]消费结果回送配置管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1313', '[配置]白名单管理', 'Y');
INSERT INTO `idmm_function_info` VALUES ('1314', '[配置]优先级管理', 'Y');

-- ----------------------------
-- Records of idmm_role_func_rel
-- ----------------------------
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1101Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1101Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1101Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1101Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1102Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1200GetChartData.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1200MainGetNodeListPage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1200MemGetdatatPage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1200MsgTable.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1202BrokerDetail.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1202GetAllBkMonData.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1202GetbkClientMorePage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1202GetBkMonData.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1202GetBleInfo.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1202GetClientMorePage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1202GetDetail.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1202GetQueueMorePage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1203GetProducerList.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1203GetProgress.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1203SendMsg.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1203UploadSendMsg.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1204RecvMsg.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1204RecvMsgCount.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1204RecvMsgPage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1205DealProgress.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1205GetConsumerList.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1205GetDataPage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1205GetDestTopicList.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1205GetDestTopicListByBle.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1205GetResultStatus.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1205GetSrcTopicList.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1205SubmitDeal.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1205SubmitSearch.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1206DealProgress.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1206GetDataPage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1206GetResultStatus.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1206SubmitDeal.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1206SubmitSearch.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1207DealProgress.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1207GetDataPage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1207GetResultStatus.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1207SubmitDeal.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1207SubmitSearch.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1208GetData.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1208GetResultStatus.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1208SendMsg.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1208SubmitSearch.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1300Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1300ApproveVersion.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1300CheckConfig.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1300CheckEditStatus.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1300CheckVersionCtrl.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1300Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1300Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1300Publish.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1300SumbitVersion.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1301Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1301Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1301Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1301Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1301RelCheck.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1302Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1302Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1302Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1302Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1303Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1303BleRelCheck.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1303Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1303Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1303GetBleInfo.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1303Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1304Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1304Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1304Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1304Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1304RelCheck.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1305Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1305ClientRelCheck.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1305Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1305Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1305Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1306Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1306Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1306Scene01Save.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1306Scene02Save.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1306Scene03Save.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1307Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1307Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1307Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1307Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1307RelCheck.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1308Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1308Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1308Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1308Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1308RelCheck.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1309Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1309Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1309Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1309GetAttrKey.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1309Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1309RelCheck.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1310Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1310Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1310Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1311Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1311Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1311Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1311GetAttrKey.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1311GetAttrValue.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1311GetConsumeClient.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1311GetDestTopic.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1311Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1312Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1312Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1312Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1312GetConsumerList.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1312GetDestTopicList.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1312GetSrcTopicList.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1312Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1313Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1313Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1313DelAll.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1313Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1313Update.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1314Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1314Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1314Update.do', null);

INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1401GetNextBleQueueData.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1402BleQueueContrast.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1402BleQueueDetail.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'f1402GetAllBleQueueData.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'getF1203SendMsgRet.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'getf1203TaskId.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'getF1208SendMsgRet.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'getNewBleQueueDatas.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1101Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1101Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1101Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1102Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1200Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1200MainChart.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1200Mem.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1200MsgTable.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1200MsgView.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotof1202BrokerDetail.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotof1202GetDetail.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1202Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1203Send.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1204Receive.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1205Del.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1206Redo.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1207Resend.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1208Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1300Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1300Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1300List.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1301Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1301Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1301List.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1301Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1302Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1302Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1302Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1302ShowDetail.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1303Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1303Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1303List.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1303Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1304Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1304Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1304List.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1304Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1305Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1305Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1305List.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1305Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1306Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1306Scene01.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1306Scene02.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1306Scene03.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1306Scene04.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1307Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1307Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1307List.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1307Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1308Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1308Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1308List.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1308Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1309Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1309Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1309List.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1309Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1310Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1310Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1310Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1311Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1311Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1311List.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1311Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1312Add.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1312Edit.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1312List.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1312Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1313Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1402Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1402Main2.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoLogin.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'login.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'logout.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'testAdd.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1200GetChartData.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1200MainGetNodeListPage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1200MemGetdatatPage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1200MsgTable.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1202BrokerDetail.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1202GetAllBkMonData.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1202GetbkClientMorePage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1202GetBkMonData.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1202GetBleInfo.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1202GetClientMorePage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1202GetDetail.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1202GetQueueMorePage.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1208GetData.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1208GetResultStatus.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1208SendMsg.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1208SubmitSearch.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'getF1208SendMsgRet.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'gotoF1200Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'gotoF1200MainChart.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'gotoF1200Mem.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'gotoF1200MsgTable.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'gotoF1200MsgView.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'gotof1202BrokerDetail.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'gotof1202GetDetail.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'gotoF1202Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'gotoF1208Main.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('admin', 'gotoF1300ConfigRel.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1205GetConsumerList.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1205GetDestTopicList.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1205GetDestTopicListByBle.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'f1205GetSrcTopicList.do', null);
INSERT INTO `idmm_role_func_rel` VALUES ('user', 'gotoF1300ConfigRel.do', null);





-- ----------------------------
-- Records of idmm_role_info
-- ----------------------------
INSERT INTO `idmm_role_info` VALUES ('admin', '管理员');
INSERT INTO `idmm_role_info` VALUES ('user', '普通用户');



-- ----------------------------
-- Records of idmm_user_info
-- ----------------------------
INSERT INTO `idmm_user_info` VALUES ('admin1', '4AF4D9771E7C1DD2', '1');
INSERT INTO `idmm_user_info` VALUES ('user1', '4AF4D9771E7C1DD2', '2');



-- ----------------------------
-- Records of idmm_user_role_rel
-- ----------------------------
INSERT INTO `idmm_user_role_rel` VALUES ('admin1', 'admin');
INSERT INTO `idmm_user_role_rel` VALUES ('user1', 'user');

