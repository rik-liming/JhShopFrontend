SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for jh_user
-- ----------------------------
DROP TABLE IF EXISTS `jh_user`;
CREATE TABLE `jh_user` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `inviter_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级ID',
  `inviter_name` varchar(255) NOT NULL DEFAULT '' COMMENT '上级名字',
  `privilege_group_id` int(10) UNSIGNED DEFAULT NULL COMMENT '权限组ID',
  `user_name` varchar(32) NOT NULL DEFAULT '' COMMENT '用户名',
  `real_name` varchar(50) DEFAULT '' COMMENT '真实姓名',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '密码（哈希存储）',
  `email` varchar(100) DEFAULT '' COMMENT '电子邮箱',
  `phone` varchar(20) DEFAULT '' COMMENT '电话',
  `avatar` varchar(255) DEFAULT '' COMMENT '头像',
  `last_login_ip` varchar(50) DEFAULT '' COMMENT '最后登录IP',
  `last_login_time` DATETIME(3) DEFAULT NULL COMMENT '最后登录时间',
  `invite_code` varchar(50) DEFAULT '' COMMENT '邀请码',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：0禁用，1启用',
  `two_factor_secret` varchar(255) DEFAULT '' COMMENT '二步验证密钥',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_email` (`email`),
  UNIQUE KEY `uk_user_name` (`user_name`),
  UNIQUE KEY `uk_invite_code` (`invite_code`),
  CONSTRAINT `fk_user_group` FOREIGN KEY (`privilege_group_id`) REFERENCES `jh_user_privilege_group`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户表';


-- ----------------------------
-- Records of jh_user
-- ----------------------------
INSERT INTO `jh_user` 
(`inviter_id`, `inviter_name`, `privilege_group_id`, `user_name`, `real_name`, `password`, `email`, `phone`, `avatar`, `last_login_ip`, `last_login_time`, `invite_code`, `create_time`, `update_time`, `status`, `two_factor_secret`) 
VALUES
(0, '', 1, 'admin', '系统管理员', '$2a$10$abcdefghijklmnopqrstuv', 'admin@example.com', '13800000001', '/avatars/admin.png', '127.0.0.1', NOW(3), 'INVITE001', NOW(3), NOW(3), 1, ''),
(1, 'admin', 2, 'user01', '张三', '$2a$10$mnopqrstuvwxyzabcdefghi', 'zhangsan@example.com', '13800000002', '/avatars/user01.png', '192.168.0.10', NOW(3), 'INVITE002', NOW(3), NOW(3), 1, '2FASECRET123456'),
(1, 'admin', 2, 'user02', '李四', '$2a$10$uvwxyzabcdefghijklmno', 'lisi@example.com', '13800000003', '/avatars/user02.png', '192.168.0.11', NOW(3), 'INVITE003', NOW(3), NOW(3), 0, ''),
(2, 'user01', 2, 'user03', '王五', '$2a$10$abcdef1234567890ghijk', 'wangwu@example.com', '13800000004', '/avatars/user03.png', '10.0.0.1', NOW(3), 'INVITE004', NOW(3), NOW(3), 1, '');

-- ----------------------------
-- Table structure for jh_user_privilege_group
-- ----------------------------
CREATE TABLE `jh_user_privilege_group` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '组名',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：0禁用，1启用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='权限组表';


-- ----------------------------
-- Records of jh_user_privilege_group
-- ----------------------------
INSERT INTO `jh_user_privilege_group` (`name`, `status`) VALUES
('超级管理员', 1),
('普通用户', 1),
('访客用户', 1);


-- ----------------------------
-- Table structure for jh_user_privilege_rule
-- ----------------------------
CREATE TABLE `jh_user_privilege_rule` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父ID，0为根节点',
  `router_key` varchar(50) DEFAULT NULL COMMENT '路径标识（唯一）',
  `type` enum('menu','action') NOT NULL DEFAULT 'action' COMMENT 'menu=菜单,action=操作',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '名字',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `sort_order` int(10) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：0禁用，1启用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_router_key` (`router_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='权限规则表';


-- ----------------------------
-- Records of jh_user_privilege_rule
-- ----------------------------
-- 一级菜单
INSERT INTO `jh_user_privilege_rule` (`pid`, `router_key`, `type`, `name`, `remark`, `sort_order`, `status`) VALUES
(0, 'dashboard', 'menu', '仪表盘', '系统首页', 1, 1),
(0, 'user_mgmt', 'menu', '用户管理', '用户相关功能', 2, 1),
(0, 'setting', 'menu', '系统设置', '系统配置', 3, 1);

-- 二级菜单（用户管理下）
-- 获取 user_mgmt 的 id
SET @user_mgmt_id := (SELECT id FROM jh_user_privilege_rule WHERE router_key='user_mgmt');

INSERT INTO `jh_user_privilege_rule`
(`pid`, `router_key`, `type`, `name`, `remark`, `sort_order`, `status`)
VALUES
(@user_mgmt_id, 'user_list', 'menu', '用户列表', '查看用户', 1, 1),
(@user_mgmt_id, 'priv_group', 'menu', '权限组管理', '管理权限组', 2, 1);


-- 操作权限（动作）
SET @user_list_id := (SELECT id FROM jh_user_privilege_rule WHERE router_key='user_list');

INSERT INTO `jh_user_privilege_rule`
(`pid`, `router_key`, `type`, `name`, `remark`, `sort_order`, `status`)
VALUES
(@user_list_id, 'user_add', 'action', '新增用户', '添加新用户', 1, 1),
(@user_list_id, 'user_edit', 'action', '编辑用户', '修改用户资料', 2, 1),
(@user_list_id, 'user_delete', 'action', '删除用户', '移除用户', 3, 1),


SET @group_id := (SELECT id FROM jh_user_privilege_rule WHERE router_key='priv_group');

INSERT INTO `jh_user_privilege_rule`
(`pid`, `router_key`, `type`, `name`, `remark`, `sort_order`, `status`)
VALUES
(@group_id, 'group_add', 'action', '新增权限组', '添加权限组', 1, 1),
(group_id, 'group_edit', 'action', '编辑权限组', '修改权限组', 2, 1);


-- ----------------------------
-- Table structure for jh_user_privilege_group_rule
-- ----------------------------
CREATE TABLE `jh_user_privilege_group_rule` (
  `group_id` int(10) UNSIGNED NOT NULL,
  `rule_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`group_id`,`rule_id`),
  KEY `idx_rule_id` (`rule_id`),
  CONSTRAINT `fk_group` FOREIGN KEY (`group_id`) REFERENCES `jh_user_privilege_group`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rule` FOREIGN KEY (`rule_id`) REFERENCES `jh_user_privilege_rule`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='组与规则关联表';


-- ----------------------------
-- Records of jh_user_privilege_group_rule
-- ----------------------------
-- 超级管理员：拥有所有权限
INSERT INTO `jh_user_privilege_group_rule` (`group_id`, `rule_id`)
SELECT 1, id FROM jh_user_privilege_rule;

-- 普通用户：只能访问仪表盘、用户列表（但不能删除用户）
INSERT INTO `jh_user_privilege_group_rule` (`group_id`, `rule_id`)
SELECT 2, id FROM jh_user_privilege_rule WHERE router_key IN 
('dashboard','user_mgmt','user_list','user_add','user_edit');

-- 访客用户：只能访问仪表盘
INSERT INTO `jh_user_privilege_group_rule` (`group_id`, `rule_id`)
SELECT 3, id FROM jh_user_privilege_rule WHERE router_key IN ('dashboard');
