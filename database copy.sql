SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ct_admin
-- ----------------------------
DROP TABLE IF EXISTS `ct_admin`;
CREATE TABLE `ct_admin`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户名',
  `nick_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '昵称',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码盐',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `login_fail_count` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '失败次数',
  `last_login_time` bigint(16) NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  `create_time` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `token` varchar(59) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录token',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'normal' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_name`(`user_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_admin
-- ----------------------------
INSERT INTO `ct_admin` VALUES (1, 'admin', 'Admin', 'e621b65128f34ab1d4477a921829dfff', '2c0c1a', 'http://ufa.test/assets/img/avatar.png', 'admin@admin.com', '', 0, 1724416155, '127.0.0.1', 1491635035, 1724416155, '64a173c6-aaba-4126-b1b2-72cce8b3acf4', 'normal');
INSERT INTO `ct_admin` VALUES (2, 'robot', '测试Admin', '259afbe383e9af036db1725bed1231c9', 'Sbdzj7', '/assets/img/avatar.png', '1233@123.com', '13656565656', 0, 1724416004, '127.0.0.1', 1720857909, 1724416004, 'bf23408d-e594-4c1d-9c47-0f92b48d2b91', 'normal');

-- ----------------------------
-- Table structure for ct_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `ct_admin_log`;
CREATE TABLE `ct_admin_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '管理员名字',
  `url` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作页面',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '日志标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'IP',
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'User-Agent',
  `create_time` bigint(16) NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_name`(`user_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_admin_log
-- ----------------------------
INSERT INTO `ct_admin_log` VALUES (1, 1, 'admin', '/RiwxPQYHAv.php/user/user/edit/ids/22?dialog=1', '会员管理 / 会员管理 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"id\":\"22\",\"group_id\":\"2\",\"username\":\"test1\",\"parent_name\":\"卖家\",\"nickname\":\"test1\",\"password\":\"***\",\"expassword\":\"***\",\"email\":\"551@55.com\",\"mobile\":\"\",\"avatar\":\"\",\"level\":\"1\",\"isquality\":\"0\",\"isrecommend\":\"0\",\"gender\":\"0\",\"birthday\":\"\",\"bio\":\"\",\"money\":\"4500.00\",\"score\":\"0\",\"successions\":\"1\",\"maxsuccessions\":\"1\",\"prevtime\":\"2024-07-04 18:12:51\",\"logintime\":\"2024-07-04 18:12:51\",\"loginip\":\"127.0.0.1\",\"loginfailure\":\"0\",\"joinip\":\"127.0.0.1\",\"jointime\":\"2024-07-04 18:12:51\",\"status\":\"normal\"},\"ids\":\"22\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0', 1720090230);
INSERT INTO `ct_admin_log` VALUES (2, 1, 'admin', '/RiwxPQYHAv.php/user/user/edit/ids/22?dialog=1', '会员管理 / 会员管理 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"id\":\"22\",\"group_id\":\"2\",\"username\":\"test1\",\"parent_name\":\"卖家\",\"nickname\":\"test1\",\"password\":\"***\",\"expassword\":\"***\",\"email\":\"551@55.com\",\"mobile\":\"\",\"avatar\":\"\",\"level\":\"1\",\"isquality\":\"0\",\"isrecommend\":\"0\",\"gender\":\"0\",\"birthday\":\"\",\"bio\":\"\",\"money\":\"4500.00\",\"score\":\"0\",\"successions\":\"1\",\"maxsuccessions\":\"1\",\"prevtime\":\"2024-07-04 18:12:51\",\"logintime\":\"2024-07-04 18:12:51\",\"loginip\":\"127.0.0.1\",\"loginfailure\":\"0\",\"joinip\":\"127.0.0.1\",\"jointime\":\"2024-07-04 18:12:51\",\"status\":\"normal\"},\"ids\":\"22\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0', 1720090258);

-- ----------------------------
-- Table structure for ct_admin_group
-- ----------------------------
DROP TABLE IF EXISTS `ct_admin_auth_group`;
CREATE TABLE `ct_admin_group`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父组别',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '组名',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则ID',
  `create_time` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '分组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_admin_group
-- ----------------------------
INSERT INTO `ct_admin_group` VALUES (1, 0, '超管组', '*', 1491635035, 1491635035, 'normal');
INSERT INTO `ct_admin_group` VALUES (2, 1, '默认组', '1', 1720857831, 1724422780, 'normal');

-- ----------------------------
-- Table structure for ct_admin_group_privilege
-- ----------------------------
DROP TABLE IF EXISTS `ct_admin_group_privilege`;
CREATE TABLE `ct_admin_group_privilege`  (
  `uid` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `group_id` int(10) UNSIGNED NOT NULL COMMENT '组ID',
  UNIQUE INDEX `uid_group_id`(`uid`, `group_id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '权限分组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_admin_group_privilege
-- ----------------------------
INSERT INTO `ct_admin_group_privilege` VALUES (1, 1);
INSERT INTO `ct_admin_group_privilege` VALUES (2, 2);

-- ----------------------------
-- Table structure for ct_admin_privilege_rule
-- ----------------------------
DROP TABLE IF EXISTS `ct_admin_privilege_rule`;
CREATE TABLE `ct_admin_privilege_rule`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` enum('menu','action') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'action' COMMENT 'menu为菜单,action为具体操作',
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规则名称',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规则名称',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规则URL',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `order` int(10) NOT NULL DEFAULT 0 COMMENT '权重',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE,
  INDEX `weigh`(`weigh`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 137 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '节点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_admin_privilege_rule
-- ----------------------------
INSERT INTO `ct_admin_privilege_rule` VALUES (1, 'file', 0, 'dashboard', 'Dashboard', 'fa fa-dashboard', '', '', 'Dashboard tips', 1, NULL, '', 'kzt', 'kongzhitai', 1491635035, 1491635035, 143, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (2, 'file', 0, 'general', 'General', 'fa fa-cogs', '', '', '', 1, NULL, '', 'cggl', 'changguiguanli', 1491635035, 1491635035, 137, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (3, 'file', 0, 'category', 'Category', 'fa fa-leaf', '', '', 'Category tips', 0, NULL, '', 'flgl', 'fenleiguanli', 1491635035, 1491635035, 119, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (5, 'file', 0, 'auth', 'Auth', 'fa fa-group', '', '', '', 1, NULL, '', 'qxgl', 'quanxianguanli', 1491635035, 1491635035, 99, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (6, 'file', 2, 'general/config', 'Config', 'fa fa-cog', '', '', 'Config tips', 1, NULL, '', 'xtpz', 'xitongpeizhi', 1491635035, 1491635035, 60, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (7, 'file', 2, 'general/attachment', 'Attachment', 'fa fa-file-image-o', '', '', 'Attachment tips', 1, NULL, '', 'fjgl', 'fujianguanli', 1491635035, 1491635035, 53, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (8, 'file', 2, 'general/profile', 'Profile', 'fa fa-user', '', '', '', 1, NULL, '', 'grzl', 'gerenziliao', 1491635035, 1491635035, 34, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (9, 'file', 5, 'auth/admin', 'Admin', 'fa fa-user', '', '', 'Admin tips', 1, NULL, '', 'glygl', 'guanliyuanguanli', 1491635035, 1491635035, 118, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (10, 'file', 5, 'auth/adminlog', 'Admin log', 'fa fa-list-alt', '', '', 'Admin log tips', 1, NULL, '', 'glyrz', 'guanliyuanrizhi', 1491635035, 1491635035, 113, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (11, 'file', 5, 'auth/group', 'Group', 'fa fa-group', '', '', 'Group tips', 1, NULL, '', 'jsz', 'juesezu', 1491635035, 1491635035, 109, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (12, 'file', 5, 'auth/rule', 'Rule', 'fa fa-bars', '', '', 'Rule tips', 1, NULL, '', 'cdgz', 'caidanguize', 1491635035, 1491635035, 104, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (13, 'file', 1, 'dashboard/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 136, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (14, 'file', 1, 'dashboard/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 135, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (15, 'file', 1, 'dashboard/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 133, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (16, 'file', 1, 'dashboard/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 134, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (17, 'file', 1, 'dashboard/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 132, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (18, 'file', 6, 'general/config/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 52, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (19, 'file', 6, 'general/config/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 51, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (20, 'file', 6, 'general/config/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 50, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (21, 'file', 6, 'general/config/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 49, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (22, 'file', 6, 'general/config/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 48, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (23, 'file', 7, 'general/attachment/index', 'View', 'fa fa-circle-o', '', '', 'Attachment tips', 0, NULL, '', '', '', 1491635035, 1491635035, 59, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (24, 'file', 7, 'general/attachment/select', 'Select attachment', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 58, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (25, 'file', 7, 'general/attachment/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 57, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (26, 'file', 7, 'general/attachment/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 56, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (27, 'file', 7, 'general/attachment/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 55, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (28, 'file', 7, 'general/attachment/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 54, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (29, 'file', 8, 'general/profile/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 33, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (30, 'file', 8, 'general/profile/update', 'Update profile', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 32, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (31, 'file', 8, 'general/profile/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 31, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (32, 'file', 8, 'general/profile/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 30, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (33, 'file', 8, 'general/profile/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 29, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (34, 'file', 8, 'general/profile/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 28, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (35, 'file', 3, 'category/index', 'View', 'fa fa-circle-o', '', '', 'Category tips', 0, NULL, '', '', '', 1491635035, 1491635035, 142, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (36, 'file', 3, 'category/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 141, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (37, 'file', 3, 'category/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 140, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (38, 'file', 3, 'category/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 139, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (39, 'file', 3, 'category/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 138, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (40, 'file', 9, 'auth/admin/index', 'View', 'fa fa-circle-o', '', '', 'Admin tips', 0, NULL, '', '', '', 1491635035, 1491635035, 117, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (41, 'file', 9, 'auth/admin/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 116, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (42, 'file', 9, 'auth/admin/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 115, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (43, 'file', 9, 'auth/admin/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 114, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (44, 'file', 10, 'auth/adminlog/index', 'View', 'fa fa-circle-o', '', '', 'Admin log tips', 0, NULL, '', '', '', 1491635035, 1491635035, 112, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (45, 'file', 10, 'auth/adminlog/detail', 'Detail', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 111, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (46, 'file', 10, 'auth/adminlog/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 110, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (47, 'file', 11, 'auth/group/index', 'View', 'fa fa-circle-o', '', '', 'Group tips', 0, NULL, '', '', '', 1491635035, 1491635035, 108, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (48, 'file', 11, 'auth/group/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 107, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (49, 'file', 11, 'auth/group/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 106, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (50, 'file', 11, 'auth/group/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 105, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (51, 'file', 12, 'auth/rule/index', 'View', 'fa fa-circle-o', '', '', 'Rule tips', 0, NULL, '', '', '', 1491635035, 1491635035, 103, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (52, 'file', 12, 'auth/rule/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 102, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (53, 'file', 12, 'auth/rule/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 101, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (54, 'file', 12, 'auth/rule/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 100, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (66, 'file', 0, 'user', 'User', 'fa fa-user-circle', '', '', '', 1, NULL, '', 'hygl', 'huiyuanguanli', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (67, 'file', 66, 'user/user', 'User', 'fa fa-user', '', '', '', 1, NULL, '', 'hygl', 'huiyuanguanli', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (68, 'file', 67, 'user/user/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (69, 'file', 67, 'user/user/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (70, 'file', 67, 'user/user/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (71, 'file', 67, 'user/user/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (72, 'file', 67, 'user/user/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (73, 'file', 66, 'user/group', 'User group', 'fa fa-users', '', '', '', 1, NULL, '', 'hyfz', 'huiyuanfenzu', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (74, 'file', 73, 'user/group/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (75, 'file', 73, 'user/group/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (76, 'file', 73, 'user/group/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (77, 'file', 73, 'user/group/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (78, 'file', 73, 'user/group/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (79, 'file', 66, 'user/rule', 'User rule', 'fa fa-circle-o', '', '', '', 1, NULL, '', 'hygz', 'huiyuanguize', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (80, 'file', 79, 'user/rule/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (81, 'file', 79, 'user/rule/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (82, 'file', 79, 'user/rule/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (83, 'file', 79, 'user/rule/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (84, 'file', 79, 'user/rule/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (85, 'file', 0, 'exchange', '交易管理', 'fa fa-bank', '', '', '', 1, 'addtabs', '', 'jygl', 'jiaoyiguanli', 1718621548, 1718621548, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (87, 'file', 85, 'excoinorder', '订单管理', 'fa fa-list-ul', '', '', '', 1, 'addtabs', '', 'ddgl', 'dingdanguanli', 1718621841, 1720622954, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (89, 'file', 85, 'pay', '充值管理', 'fa fa-money', '', '', '', 1, 'addtabs', '', 'czgl', 'chongzhiguanli', 1718622138, 1718622138, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (90, 'file', 85, 'withdraw', '提现管理', 'fa fa-jpy', '', '', '', 1, 'addtabs', '', 'txgl', 'tixianguanli', 1718622176, 1718622176, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (91, 'file', 66, 'card', '收付款管理', 'fa fa-cc-visa', '', '', '', 1, 'addtabs', '', 'sfkgl', 'shoufukuanguanli', 1718622270, 1718622270, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (92, 'file', 85, 'pttransfer', '转账管理', 'fa fa-mars-double', '', '', '', 1, 'addtabs', '', 'zzgl', 'zhuanzhangguanli', 1719557923, 1720717899, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (93, 'file', 85, 'usermoneylog', '财务变动', 'fa fa-book', '', '', '', 1, 'addtabs', '', 'cwbd', 'caiwubiandong', 1719563138, 1719563182, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (94, 'file', 85, 'reward', '奖励管理', 'fa fa-list-alt', '', '', '', 1, 'addtabs', '', 'jlgl', 'jiangliguanli', 1720014721, 1720014721, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (95, 'file', 85, '/excoin', '商户管理', 'fa fa-odnoklassniki', '', '', '', 1, 'addtabs', '', 'shgl', 'shanghuguanli', 1720272078, 1720272078, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (96, 'file', 87, 'excoinorder/index', '查看', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zk', 'zhakan', 1720858084, 1720858117, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (97, 'file', 87, 'excoinorder/add', '增加', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zj', 'zengjia', 1720858209, 1720858209, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (98, 'file', 87, 'excoinorder/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'bj', 'bianji', 1720858242, 1720858242, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (99, 'file', 87, 'excoiniorder/delete', '删除', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sc', 'shanchu', 1720858259, 1720858259, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (100, 'file', 89, 'pay/index', '查看', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zk', 'zhakan', 1720858333, 1720869883, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (101, 'file', 89, 'pay/add', '增加', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zj', 'zengjia', 1720858356, 1720858356, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (102, 'file', 89, 'pay/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'bj', 'bianji', 1720858380, 1720858380, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (103, 'file', 89, 'pay/delete', '删除', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sc', 'shanchu', 1720858404, 1720858404, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (104, 'file', 90, 'withdraw/index', '查看', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zk', 'zhakan', 1720858466, 1720858466, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (105, 'file', 90, 'withdraw/add', '增加', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zj', 'zengjia', 1720858488, 1720858488, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (106, 'file', 90, 'withdraw/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'bj', 'bianji', 1720858512, 1720858512, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (107, 'file', 90, 'withdraw/delete', '删除', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sc', 'shanchu', 1720858526, 1720858526, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (108, 'file', 92, 'pttransfer/index', '查看', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zk', 'zhakan', 1720858552, 1720858552, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (109, 'file', 92, 'pttransfer/add', '增加', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zj', 'zengjia', 1720858570, 1720858570, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (110, 'file', 92, 'pttransfer/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'bj', 'bianji', 1720858605, 1720858605, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (111, 'file', 92, 'pttransfer/delete', '删除', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sc', 'shanchu', 1720858623, 1720858623, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (112, 'file', 93, 'usermoneylog/index', '查看', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zk', 'zhakan', 1720858661, 1720858661, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (113, 'file', 93, 'usermoneylog/delete', '删除', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sc', 'shanchu', 1720858682, 1720858682, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (114, 'file', 94, 'reward/index', '查看', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zk', 'zhakan', 1720858725, 1720858725, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (115, 'file', 94, 'reward/add', '增加', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zj', 'zengjia', 1720858739, 1720858739, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (116, 'file', 94, 'reward/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'bj', 'bianji', 1720858756, 1720858756, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (117, 'file', 94, 'reward/delete', '删除', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sc', 'shanchu', 1720858773, 1720858773, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (118, 'file', 95, 'excoin/index', '查看', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zk', 'zhakan', 1720858796, 1720858796, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (119, 'file', 95, 'excoin/add', '增加', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zj', 'zengjia', 1720858813, 1720858813, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (120, 'file', 95, 'excoin/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'bj', 'bianji', 1720858831, 1720858831, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (121, 'file', 95, 'excoin/delete', '删除', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sc', 'shanchu', 1720858845, 1720858845, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (122, 'file', 91, 'card/index', '查看', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zk', 'zhakan', 1720858941, 1720858941, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (123, 'file', 91, 'card/add', '增加', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'zj', 'zengjia', 1720858956, 1720858956, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (124, 'file', 91, 'card/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'bj', 'bianji', 1720858969, 1720858969, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (125, 'file', 91, 'card/delete', '删除', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sc', 'shanchu', 1720858982, 1720858982, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (126, 'file', 89, 'pay/done', '审核', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sh', 'shenhe', 1720872046, 1720872046, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (127, 'file', 90, 'withdraw/done', '审核', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sh', 'shenhe', 1720872311, 1720872311, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (128, 'file', 92, 'pttransfer/done', '审核', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sh', 'shenhe', 1720872336, 1720872336, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (129, 'file', 94, 'reward/done', '审核', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'sh', 'shenhe', 1720872357, 1720872357, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (130, 'file', 2, 'general/twostep', '两步验证', 'fa fa-shield', '', '', '', 1, NULL, '', 'lbyz', 'liangbuyanzheng', 1724315915, 1724315915, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (131, 'file', 130, 'general/twostep/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1724315915, 1724315915, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (132, 'file', 130, 'general/twostep/cancel', '取消动态口令', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'qxdtkl', 'quxiaodongtaikouling', 1724315915, 1724416669, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (133, 'file', 130, 'general/twostep/remove', '移除安全密钥', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'ycaqmy', 'yichuanquanmiyao', 1724315915, 1724315915, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (134, 'file', 130, 'general/twostep/totp', '设置动态口令', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'szdtkl', 'shezhidongtaikouling', 1724315915, 1724417004, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (135, 'file', 130, 'general/twostep/webauthn', '设置安全密钥', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'szaqmy', 'shezhianquanmiyao', 1724315915, 1724315915, 0, 'normal');
INSERT INTO `ct_admin_privilege_rule` VALUES (136, 'file', 130, 'general/twostep/totpreg', '保存动态口令', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'bcdtkl', 'baocundongtaikouling', 1724422677, 1724422747, 0, 'hidden');



-- ----------------------------
-- Table structure for ct_card
-- ----------------------------
DROP TABLE IF EXISTS `ct_card`;
CREATE TABLE `ct_card`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户名',
  `cardtype` enum('alipay','alipaybig','bankcard','gonghu','rmb') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'rmb' COMMENT '类型',
  `cardno` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '卡号',
  `cardname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '持卡人姓名',
  `cardbankname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '所属银行',
  `cardaddr` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '开户行',
  `cardqrimage` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '收付款二维码',
  `createtime` bigint(16) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `updatetime` bigint(16) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `status` enum('0','1') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '状态:0=不可用,1=可用',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `sta`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_card
-- ----------------------------

-- ----------------------------
-- Table structure for ct_config
-- ----------------------------
DROP TABLE IF EXISTS `ct_config`;
CREATE TABLE `ct_config`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '变量名',
  `group` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '分组',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '变量标题',
  `tip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '变量描述',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '类型:string,text,int,bool,array,datetime,date,file',
  `visible` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '可见条件',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '变量值',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '变量字典数据',
  `rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '验证规则',
  `extend` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '扩展属性',
  `setting` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '配置',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_config
-- ----------------------------
INSERT INTO `ct_config` VALUES (1, 'name', 'basic', 'Site name', '请填写站点名称', 'string', '', '币发', '', 'required', '', NULL);
INSERT INTO `ct_config` VALUES (2, 'beian', 'basic', 'Beian', '粤ICP备15000000号-1', 'string', '', '', '', '', '', NULL);
INSERT INTO `ct_config` VALUES (3, 'cdnurl', 'basic', 'Cdn url', '如果全站静态资源使用第三方云储存请配置该值', 'string', '', '', '', '', '', '');
INSERT INTO `ct_config` VALUES (4, 'version', 'basic', 'Version', '如果静态资源有变动请重新配置该值', 'string', '', '1.0.1', '', 'required', '', NULL);
INSERT INTO `ct_config` VALUES (5, 'timezone', 'basic', 'Timezone', '', 'string', '', 'Asia/Shanghai', '', 'required', '', NULL);
INSERT INTO `ct_config` VALUES (6, 'forbiddenip', 'basic', 'Forbidden ip', '一行一条记录', 'text', '', '', '', '', '', NULL);
INSERT INTO `ct_config` VALUES (7, 'languages', 'basic', 'Languages', '', 'array', '', '{\"backend\":\"zh-cn\",\"frontend\":\"zh-cn\"}', '', 'required', '', NULL);
INSERT INTO `ct_config` VALUES (8, 'fixedpage', 'basic', 'Fixed page', '请输入左侧菜单栏存在的链接', 'string', '', 'dashboard', '', 'required', '', NULL);
INSERT INTO `ct_config` VALUES (9, 'categorytype', 'dictionary', 'Category type', '', 'array', '', '{\"default\":\"默认\",\"page\":\"单页\"}', '', '', '', NULL);
INSERT INTO `ct_config` VALUES (10, 'configgroup', 'dictionary', 'Config group', '', 'array', '', '{\"basic\":\"基础配置\",\"email\":\"邮件配置\",\"dictionary\":\"字典配置\",\"user\":\"会员配置\",\"exchange\":\"交易配置\",\"pay\":\"充值配置\"}', '', '', '', NULL);
INSERT INTO `ct_config` VALUES (11, 'mail_type', 'email', 'Mail type', '选择邮件发送方式', 'select', '', '1', '[\"请选择\",\"SMTP\"]', '', '', '');
INSERT INTO `ct_config` VALUES (12, 'mail_smtp_host', 'email', 'Mail smtp host', '错误的配置发送邮件会导致服务器超时', 'string', '', 'smtp.qq.com', '', '', '', '');
INSERT INTO `ct_config` VALUES (13, 'mail_smtp_port', 'email', 'Mail smtp port', '(不加密默认25,SSL默认465,TLS默认587)', 'string', '', '465', '', '', '', '');
INSERT INTO `ct_config` VALUES (14, 'mail_smtp_user', 'email', 'Mail smtp user', '（填写完整用户名）', 'string', '', '', '', '', '', '');
INSERT INTO `ct_config` VALUES (15, 'mail_smtp_pass', 'email', 'Mail smtp password', '（填写您的密码或授权码）', 'password', '', '', '', '', '', '');
INSERT INTO `ct_config` VALUES (16, 'mail_verify_type', 'email', 'Mail vertify type', '（SMTP验证方式[推荐SSL]）', 'select', '', '2', '[\"无\",\"TLS\",\"SSL\"]', '', '', '');
INSERT INTO `ct_config` VALUES (17, 'mail_from', 'email', 'Mail from', '', 'string', '', '', '', '', '', '');
INSERT INTO `ct_config` VALUES (18, 'attachmentcategory', 'dictionary', 'Attachment category', '', 'array', '', '{\"category1\":\"分类一\",\"custom\":\"自定义\"}', '', '', '', NULL);
INSERT INTO `ct_config` VALUES (20, 'need_invitecode', 'user', '强制使用邀请码注册', '必须有邀请码才能注册', 'switch', '', '1', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (22, 'up_rate', 'exchange', '浮动汇率', '在今日汇率的基础上，上浮的价格。如: 0.2', 'string', '', '0.26', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (23, 'usdt_price', 'exchange', '当前币价汇率', 'CNY => USDT的价格，比如：7.23，填0自动每日最新获取。', 'string', '', '7.3', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (26, 'ann', 'basic', '站点公告', '', 'text', '', 'Tokenview APIs 上线 Web3 开发者 APIs 大合集 - 👉点击获取', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (27, 'pay_type', 'pay', '充值类型', '显示在充值页面上的方式，填写：USDT-TRC20 / 微信  / 支付宝等', 'string', '', 'USDT-TRC20', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (28, 'pay_account', 'pay', '收款账户', '填写区块链地址或者收款账号', 'string', '', 'TURYwFtG6gvpEyPSm55FyjJWpgQQ2rDm5e', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (29, 'global_min', 'exchange', '单笔最少交易', '全局单笔交易最少限制，如果卖家设置比该值小，则已该值为准！', 'string', '', '1', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (30, 'default_group_id', 'user', '默认用户组', '', 'radio', '', '1', '{\"1\":\"默认组（无买卖权限）\",\"2\":\"商家组（只能卖）\",\"3\":\"买家组（只能买）\",\"4\":\"测试组（能买能卖）\"}', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (31, 'withdraw_fee', 'pay', '提现手续费', '固定的提现手续费，不收填0', 'string', '', '2', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (32, 'transfer_fee', 'pay', '转账手续费', '', 'string', '', '0', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (33, 'pttransfer_fee', 'pay', '平台转账手续费', '', 'string', '', '2', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (34, 'agent_rule', 'user', '邀请注册规则说明', '邀请注册规则说明（支持HTML）', 'text', '', '邀请人成交额达到30000USDT，即可申请88USDT奖励', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (35, 'pttransfer_min', 'exchange', '平台转账单笔最少', '', 'string', '', '1', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (36, 'order_timeout', 'exchange', '下单后X秒内不付款则自动关闭订单', '单位：秒', 'string', '', '60000', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (37, 'invite_reward_num', 'user', '邀请注册奖励数量', '批准后奖励的数量', 'string', '', '88', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (38, 'invite_start_num', 'user', '邀请奖励起始数量', '', 'string', '', '30000', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (39, 'home_imglist', 'exchange', '交易页面幻灯图片', '建议图片尺寸为 450 x 200', 'images', '', '/uploads/20240704/9966be75c104dd9bb1207d8ca8cd8999.webp,/uploads/20240704/83c18be78f1c7f23bf4b1ccb3d6cf77d.webp,/uploads/20240704/4dc10622c7a1111029c0687e9a09d30b.webp', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (40, 'cs_telegram', 'basic', '客服Telegram号', '', 'string', '', 'https://t.me/cdddccc', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (41, 'cs_email', 'basic', '客服邮箱', '', 'string', '', 'abc@168.com', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (42, 'uprate_bankcard', 'exchange', '银行卡上浮汇率', '', 'string', '', '0.32', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (45, 'uprate_alipay', 'exchange', '支付宝上浮汇率', '', 'string', '', '0.25', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (47, 'uprate_rmb', 'exchange', '数字人民币上浮汇率', '', 'string', '', '0.29', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (48, 'usdt_qrimage', 'pay', '充值地址二维码', '', 'image', '', '/uploads/20240712/da107a2c2abacefe9890a60880aa618b.png', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (50, 'uprate_alibig', 'exchange', '支付宝(大额)', '', 'string', '', '0.82', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (51, 'auth_enabled', 'user', '开启验证器', '', 'radio', '', '1', '{\"1\":\"开启\",\"0\":\"关闭\"}', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');
INSERT INTO `ct_config` VALUES (53, 'auth_name', 'user', '验证器名称', '', 'string', '', '币发', '', '', '', '{\"table\":\"\",\"conditions\":\"\",\"key\":\"\",\"value\":\"\"}');


-- ----------------------------
-- Table structure for ct_excoin
-- ----------------------------
DROP TABLE IF EXISTS `ct_excoin`;
CREATE TABLE `ct_excoin`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户名',
  `title` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商户名称',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '出售数量',
  `sold_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '已出售数量',
  `min_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '单笔最小',
  `current_order` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '当前次数',
  `max_order` int(10) NOT NULL DEFAULT 1 COMMENT '订单次数',
  `is_bankcard` int(1) NOT NULL DEFAULT 0 COMMENT '银行卡上浮',
  `is_rmb` int(1) NOT NULL DEFAULT 0 COMMENT '数字人民上浮',
  `is_alipaybig` int(1) NOT NULL DEFAULT 0 COMMENT '支付宝大额上浮',
  `is_alipay` int(1) NOT NULL DEFAULT 0 COMMENT '支付宝上浮',
  `message` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '附言',
  `createtime` bigint(16) NOT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NOT NULL COMMENT '更新时间',
  `displayorder` int(10) NOT NULL DEFAULT 200 COMMENT '排序',
  `status` enum('0','1') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '状态:0=关闭,1=开启',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `title`(`title`) USING BTREE,
  INDEX `id`(`id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_excoin
-- ----------------------------

-- ----------------------------
-- Table structure for ct_excoinorder
-- ----------------------------
DROP TABLE IF EXISTS `ct_excoinorder`;
CREATE TABLE `ct_excoinorder`  (
  `id` bigint(16) NOT NULL COMMENT 'ID',
  `excoin_id` int(10) UNSIGNED NOT NULL COMMENT '订单编号',
  `buyer_id` int(10) UNSIGNED NOT NULL COMMENT '买家',
  `seller_id` int(10) UNSIGNED NOT NULL COMMENT '卖家',
  `card_id` int(10) UNSIGNED NOT NULL COMMENT '收款卡',
  `status` enum('0','1','2','3','4','5','6','7') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '状态:0=交易取消,1=等待买家付款,2=等待卖家确认,3=交易成功,4=申诉中,5=申诉成功,6=申诉驳回',
  `banktype` enum('alipay','alipaybig','bankcard','rmb') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'bankcard' COMMENT '卖家收款卡',
  `money` decimal(10, 2) UNSIGNED NOT NULL COMMENT '购买金额',
  `usdt_price` decimal(10, 2) UNSIGNED NOT NULL COMMENT '币价',
  `usdt_amount` decimal(10, 2) UNSIGNED NOT NULL COMMENT 'USDT数量',
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) NOT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NOT NULL COMMENT '更新时间',
  `paybankname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '银行名称',
  `paybankaddr` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '开户行',
  `payno` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '付款账号',
  `payphone` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '付款人手机',
  `payname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '付款人姓名',
  `payimages` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '付款截图',
  `recvaddr` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '接收地址',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id`) USING BTREE,
  INDEX `goods_id`(`excoin_id`) USING BTREE,
  INDEX `buyer_id`(`buyer_id`) USING BTREE,
  INDEX `seller_id`(`seller_id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_excoinorder
-- ----------------------------

-- ----------------------------
-- Table structure for ct_goods
-- ----------------------------
DROP TABLE IF EXISTS `ct_goods`;
CREATE TABLE `ct_goods`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户名',
  `card_id` int(10) NULL DEFAULT NULL COMMENT '收款卡号',
  `card_type` enum('USDT-TRC20','USDT-ERC20','alipay','wechat','bankcard') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'bankcard' COMMENT '收款类型',
  `goods_no` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '订单编号',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '出售金额',
  `sold_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '已出售金额',
  `min_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '单笔最低',
  `max_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '单笔最大',
  `isquality` int(1) NOT NULL DEFAULT 0 COMMENT '优质商家',
  `isrecommend` int(1) NOT NULL DEFAULT 0 COMMENT '平台推荐',
  `state` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '省',
  `city` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '市',
  `rate` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '汇率',
  `message` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '附言',
  `createtime` bigint(16) NOT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NOT NULL COMMENT '更新时间',
  `status` enum('0','1','2') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '状态:0=已撒单,1=进行中,2=已完成,3=锁单中',
  `displayorder` int(10) NOT NULL DEFAULT 200 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id`) USING BTREE,
  INDEX `card_type`(`card_type`) USING BTREE,
  INDEX `rate`(`rate`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `sold_amount`(`sold_amount`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_goods
-- ----------------------------

-- ----------------------------
-- Table structure for ct_order
-- ----------------------------
DROP TABLE IF EXISTS `ct_order`;
CREATE TABLE `ct_order`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goods_id` int(10) UNSIGNED NOT NULL COMMENT '订单编号',
  `buyer_id` int(10) UNSIGNED NOT NULL COMMENT '买家',
  `seller_id` int(10) UNSIGNED NOT NULL COMMENT '卖家',
  `seller_card_id` int(10) UNSIGNED NOT NULL COMMENT '卖家收款卡',
  `buyer_card_id` int(10) UNSIGNED NOT NULL COMMENT '买家收款卡',
  `amount` decimal(10, 2) UNSIGNED NOT NULL COMMENT '数量',
  `usdt_price` decimal(10, 2) UNSIGNED NOT NULL COMMENT '币价',
  `money` decimal(10, 2) UNSIGNED NOT NULL COMMENT '应付金额',
  `payimages` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '付款截图',
  `createtime` bigint(16) NOT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NOT NULL COMMENT '更新时间',
  `status` enum('0','1','2','3','4','5','6','7') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '状态:0=交易取消,1=等待买家付款,2=等待卖家确认,3=等待平台下款,4=交易成功,5=申诉中,6=申诉成功,7=申诉驳回',
  `memo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id`) USING BTREE,
  INDEX `goods_id`(`goods_id`) USING BTREE,
  INDEX `buyer_id`(`buyer_id`) USING BTREE,
  INDEX `seller_id`(`seller_id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_order
-- ----------------------------

-- ----------------------------
-- Table structure for ct_pay
-- ----------------------------
DROP TABLE IF EXISTS `ct_pay`;
CREATE TABLE `ct_pay`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户名',
  `amount` decimal(10, 2) NOT NULL COMMENT '数量',
  `message` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `payimages` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '支付截图',
  `rate` decimal(10, 2) UNSIGNED NOT NULL COMMENT '充值汇率',
  `sendname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '充值者姓名',
  `sendaddr` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '充值者账号',
  `createtime` bigint(16) UNSIGNED NOT NULL COMMENT '创建时间',
  `updatetime` bigint(16) UNSIGNED NOT NULL COMMENT '更新时间',
  `status` enum('0','1','2') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '状态:0=取消,1=待处理,2=成功',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_pay
-- ----------------------------

-- ----------------------------
-- Table structure for ct_pttransfer
-- ----------------------------
DROP TABLE IF EXISTS `ct_pttransfer`;
CREATE TABLE `ct_pttransfer`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户名',
  `account` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '收款账号或邮箱',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '数量',
  `actual_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实际到账',
  `fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '手续费',
  `status` enum('0','1','2') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '状态:0=失败,1=待处理,2=已完成',
  `createtime` bigint(16) NOT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_pttransfer
-- ----------------------------

-- ----------------------------
-- Table structure for ct_reward
-- ----------------------------
DROP TABLE IF EXISTS `ct_reward`;
CREATE TABLE `ct_reward`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `agent_id` int(10) NULL DEFAULT NULL COMMENT '申请用户',
  `user_id` int(10) NULL DEFAULT NULL COMMENT '目标用户',
  `regamount` decimal(10, 2) NULL DEFAULT NULL COMMENT '申请金额',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `status` enum('0','1','2') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '状态:0=拒绝,1=待处理,2=通过',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `agent_id`(`agent_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of ct_reward
-- ----------------------------

-- ----------------------------
-- Table structure for ct_transfer
-- ----------------------------
DROP TABLE IF EXISTS `ct_transfer`;
CREATE TABLE `ct_transfer`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户名',
  `recvaddr` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '收款卡',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '数量',
  `actual_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实际到账',
  `fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '手续费',
  `status` enum('0','1','2') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '状态:0=失败,1=待处理,2=已完成',
  `createtime` bigint(16) NOT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_transfer
-- ----------------------------

-- ----------------------------
-- Table structure for ct_twostep
-- ----------------------------
DROP TABLE IF EXISTS `ct_twostep`;
CREATE TABLE `ct_twostep`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户id',
  `secret` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '动态口令',
  `webauthndata` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '安全密钥',
  `isadmin` tinyint(1) NULL DEFAULT 0 COMMENT '是否管理员',
  `createtime` int(10) NULL DEFAULT NULL COMMENT '操作时间',
  `updatetime` int(10) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '两步验证' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_twostep
-- ----------------------------

-- ----------------------------
-- Table structure for ct_user
-- ----------------------------
DROP TABLE IF EXISTS `ct_user`;
CREATE TABLE `ct_user`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `parent_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级ID',
  `parent_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '上级标识',
  `group_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '组别ID',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '昵称',
  `realname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '真实姓名',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `expassword` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '交易密码',
  `salt` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码盐',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像',
  `level` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '等级',
  `gender` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '性别',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `bio` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '格言',
  `money` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '余额',
  `soldamount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '本次成交金额',
  `totalsoldamount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '已成交的金额累加',
  `inviteamount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '邀请用户金额累加',
  `score` int(10) NOT NULL DEFAULT 0 COMMENT '积分',
  `successions` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '连续登录天数',
  `maxsuccessions` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '最大连续登录天数',
  `prevtime` bigint(16) NULL DEFAULT NULL COMMENT '上次登录时间',
  `logintime` bigint(16) NULL DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录IP',
  `loginipaddr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '所属地址',
  `loginipstate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录IP省份',
  `loginipcity` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录IP城市',
  `loginfailure` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '失败次数',
  `joinip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '加入IP',
  `jointime` bigint(16) NULL DEFAULT NULL COMMENT '加入时间',
  `invitecode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '邀请码',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `token` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'Token',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态',
  `verification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '验证',
  `isquality` int(1) NOT NULL DEFAULT 0 COMMENT '优质商家',
  `isrecommend` int(1) NOT NULL DEFAULT 0 COMMENT '平台推荐',
  `nextrewardamount` decimal(10, 2) NOT NULL DEFAULT 30000.00 COMMENT '上家下个等级可申请',
  `otcode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '验证器编码',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `invitecode`(`invitecode`) USING BTREE,
  INDEX `username`(`username`) USING BTREE,
  INDEX `email`(`email`) USING BTREE,
  INDEX `mobile`(`mobile`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_user
-- ----------------------------
INSERT INTO `ct_user` VALUES (1, 1, '通道88', 1, 'admin', 'admin', '', '0048e4560f8eb904fd7e90cd3d5b6132', '', '7a801f', 'admin@163.com', '13000000000', '/assets/img/avatar.png', 0, 0, '2017-04-08', '', 20.00, 0.00, 0.00, 0.00, 0, 1, 1, 1491635035, 1491635035, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1491635035, '35107234', 0, 1720012780, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (2, 1, '', 1, 'cdaf', 'cdaf', '', 'ea5ad8d0cebc0973714f0c93201e9ad0', '', 'pmGzYt', 'aaff@qq.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1718702839, 1718702839, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1718702839, '35102346', 1718702839, 1719038058, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (3, 1, '', 1, 'cadad16', 'cadad16', '', 'fc2443bcb5bc203a05301c421bdbdbde', '', '3n59lJ', 'dd@qq.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1718703016, 1718703053, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1718703016, '', 1718703016, 1719038052, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (4, 0, '', 1, 'casdcc16', 'casdcc16', '', '29b0401b9dbe53d21768ff6d5197beba', '', 'uqeA2F', 'aadd@qq.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1718704562, 1718704562, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1718704562, '35107246', 1718704562, 1718704562, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (5, 0, '', 2, 'casdas', 'casdas', '', '01d9a201ece063dd2c21fe57e119cfd1', '', 'ycpMBC', 'adsad@qq.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719575469, 1719575472, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1718704738, '15042768', 1718704738, 1720080514, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (6, 0, '卖家', 2, 'casda', 'casda', '', 'f151ec4dbe15dcad93ccccac47761a43', 'qq169169', '12dUiF', 'dasda@qq.com', '', '', 1, 0, NULL, '', 600.00, 0.00, 0.00, 0.00, 0, 2, 3, 1720081520, 1720081889, '127.0.0.1', '中国广西南宁', '广西', '南宁', 0, '127.0.0.1', 1718705976, '27863504', 1718705976, 1720082625, '', 'normal', '', 1, 1, 30000.00, '');
INSERT INTO `ct_user` VALUES (7, 0, '', 1, 'dasdasd1', 'dasdasd1', '', '221fcf4e5fd888d2f351664a13b53bb7', '', 'LNZXDV', 'aacc@qq.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1718706051, 1718706051, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1718706051, '53980642', 1718706051, 1718706051, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (8, 0, '', 1, 'vbcb', 'vbcb', '', '4b297b77b971d09534fe34a1ce80b38b', '', 'u2bBmg', 'aadz@qq.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719484249, 1719493805, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1719476351, '05948167', 1719476351, 1719493805, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (9, 0, '', 1, 'bf', 'bf', '', '7d71559656308391c72c9f142462daa7', '168168', 'Ks0gMY', 'qwer@qqw.com', NULL, '', 1, 0, NULL, '', 978.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719505932, 1719505932, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1719505932, '49875603', 1719505932, 1719512278, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (10, 0, '通道2', 3, 'onc', 'onc', '', 'f53531df4675e96fefc64c3c7c20e40b', '168168', 'rqHse2', 'qqwe@qwe.com', '', '', 1, 0, NULL, '', 10.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719507380, 1719507380, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1719507380, '13470526', 1719507380, 1720080367, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (11, 0, '通道1', 3, 'cccc21', '发', '', '80503aadfa0317aa4ed8bc36e77b907b', '', 'hsLrIc', '55@55.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719512426, 1719512426, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1719512426, '41087236', 1719512426, 1720080385, '', 'normal', '', 1, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (12, 0, '', 1, 'bbfada', '买', '', '6b312f2b16157d714f89c9a3e0fc81e6', '168168', 'w59Atk', '565@56.com', '', '', 1, 0, NULL, '', 98.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719512462, 1719512462, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1719512462, '76928143', 1719512462, 1719999410, '', 'normal', '', 1, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (13, 1, '', 2, 'gftgft', 'gftgft', '', 'b99cadda83996ad8089f88dd3a635d0f', '169169', 'lwP61I', 'fvcl@qq.com', '', '', 1, 0, NULL, '', 1830.00, 0.00, 0.00, 0.00, 0, 1, 2, 1720637356, 1720981235, '127.0.0.1', '', '广西', '南宁', 0, '127.0.0.1', 1719993885, '42671035', 1719993885, 1720981235, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (14, 11, '通道1', 3, 'qq168', 'qq168', '', '6a1adcefabed6325e7d85c578639bcaa', 'qq168168', 'e1z0BJ', 'qq@55.com', '', '', 1, 0, NULL, '', 1488.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720001305, 1720001305, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720001305, '36159740', 1720001305, 1720080409, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (15, 14, '通道1', 3, 'qq1122', 'qq1122', '', 'f85a367f06f7004353dc422b34271269', '', 'by5M6l', '6565@23.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720003024, 1720003024, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720003024, '74913806', 1720003024, 1720080397, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (16, 15, '通道1', 3, 'aa12', 'aa12', '', '7fe98cd855786b650c212377c02d743c', 'qq168168', 'sJAX8h', 'aa12@qq.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 2, 2, 1720018858, 1720035554, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720018858, '90687451', 1720018858, 1720080275, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (17, 5, '', 1, 'mai', 'mai', '', 'aa3214fad0d98f52d4a1243209c9f1dd', 'qq168168', 'pZ84Qx', 'mai@qq.com', NULL, '', 1, 0, NULL, '', 466.00, 551.00, 0.00, 0.00, 0, 2, 2, 1720036906, 1720036927, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720018985, '34781206', 1720018985, 1720036927, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (18, 17, '', 3, 'maimaimai', 'maimaimai', '', '9bdb9eb24915595d1bb188dd61f6bd43', 'qq168168', 'HV3sA0', 'qqq@qq.com', '', '', 1, 0, NULL, '', 201.00, 31499.00, 0.00, 0.00, 0, 1, 1, 1720073554, 1720604500, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720030955, '73145962', 1720030955, 1720611963, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (19, 10, '通道2', 3, 'ceshi', 'ceshi', '', '8c0452a0696c07c645a5ff5d6024f171', '', '68sVXI', 'qq@qq.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720080462, 1720080462, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720080462, '67049132', 1720080462, 1720080913, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (20, 5, '卖家', 2, 'test', 'test', '', '3ae6d22d65c78a4a7c5829a26a10b102', 'qq168168', 'DrHgJR', 'qq@qq1.com', '', '', 1, 0, NULL, '', 0.00, 40012.00, 0.00, 0.00, 0, 1, 1, 1720083555, 1720088116, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720080541, '34298510', 1720080541, 1720089867, '', 'normal', '', 1, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (21, 6, '卖家', 2, 'uuuu', 'uuuu', '', '592baf82ebc0666f035a7b34406544db', 'qq168168', 'xCkgSh', 'uuu@uu.com', '', '', 1, 0, NULL, '', 19949.00, 30001.00, 0.00, 0.00, 0, 1, 1, 1720081850, 1720082697, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720081292, '68214753', 1720081292, 1720082697, '', 'normal', '', 1, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (22, 20, '卖家', 2, 'test1', 'test1', '', '38b335ca36d4fde57d430eff0371df22', '5512313', 'Y0qgfb', '551@55.com', '', '', 1, 0, NULL, '', 4500.00, 50.00, 0.00, 0.00, 0, 1, 1, 1720087971, 1720087971, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720087971, '19405683', 1720087971, 1720091358, '', 'normal', '', 1, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (23, 22, '卖家', 2, 'test001', 'test001', '', '705e791f7bf8b2f881a33e70408a9a20', '', 'YP0TGV', 'test22@www.com', '', '', 1, 0, NULL, '', 5000.00, 238.08, 0.00, 0.00, 0, 1, 1, 1720685037, 1720685037, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720685037, '93812476', 1720685037, 1720687605, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (24, 18, '', 3, 'asdad', 'asdad', '', '0f2cbe17e9ea08fcf6621accbcc3286d', '', '9SJoXh', 'qwrqw@q.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720685851, 1720685851, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720685851, '84931206', 1720685851, 1720685875, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (25, 16, '通道1', 3, 'maijia', 'maijia', '', '94c8fd4511d73872092438ec71f978b5', '', '0H7Ijg', 'ww@w.com', '', '', 1, 0, NULL, '', 100.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720687883, 1720687883, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720687883, '40869753', 1720687883, 1720719603, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (26, 23, '卖家', 2, 'ttt', 'ttt', '', 'c7890eca4a035b5ef86aee832c31438e', 'qq168168', 'jqdRYH', 'sss@wqc.com', '', '', 1, 0, NULL, '', 3635.12, 1831.01, 0.00, 0.00, 0, 1, 1, 1720687937, 1720687937, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720687937, '49367815', 1720687937, 1720719603, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (27, 26, '卖家', 2, 'qqq', 'qqq', '', '2f8b0524f0fa6bfdb71428f50b1cdaa3', 'qq168168', 'YwuhXz', 'qq2@qq.com', '', '', 1, 0, NULL, '', 300.93, 188.07, 0.00, 0.00, 0, 1, 1, 1720758641, 1720789938, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720758641, '81240563', 1720758641, 1720789938, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (28, 25, '通道1', 3, 'www', 'www', '', '77eaaa2245fd684b8e37ba0ffee1b314', '', 'VKp9Cf', 'ww@ww.com', '', '', 1, 0, NULL, '', 9.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720771318, 1720771339, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720758670, '42169805', 1720758670, 1720771339, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (29, 28, '通道1', 3, 'test12', 'test12', '', '5436ff16941c851b5b6bd78d4ceb54fd', '', 'KC4SJi', '22@222.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720853254, 1720869703, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720853254, '82671954', 1720853254, 1720869703, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (30, 27, '卖家', 2, 'test23', 'test23', '', '9d60b63105f382ede253071b8b6b8c34', '', 'lZNUK8', '1212@123.com', NULL, '', 1, 0, NULL, '', 552.75, 447.25, 0.00, 0.00, 0, 1, 1, 1720870257, 1720870505, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720853297, '63079128', 1720853297, 1720872088, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (31, 29, '通道1', 2, 'test13', 'test13', '', '2168f80fe5decdcd6ac4b6b58025b389', '', 'kxnQ0v', 'qqw22@qqq.com', NULL, '', 1, 0, NULL, '', 18897.65, 31102.35, 31102.35, 0.00, 0, 1, 1, 1720869637, 1720869637, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720869637, '69783125', 1720869637, 1720870235, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (32, 30, '卖家', 2, 'ceshi1', 'ceshi1', '', '3570d2f0622bccfd93a6e2e55a55c96c', '', 'pHqAYh', 'q@qqqq.com', NULL, '', 1, 0, NULL, '', 10470.51, 39793.49, 39793.49, 0.00, 0, 1, 1, 1721052127, 1721052198, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720870348, '48275391', 1720870348, 1721052211, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (33, 29, '通道1', 1, 'qweqwe', 'qweqwe', '', 'd04cd21c24eb899de3661e10b9a74593', '', '9VGLUJ', 'www@www.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720874458, 1720874458, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720874458, '02834716', 1720874458, 1720874458, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (34, 33, '通道1', 3, 'caca1', 'caca1', '', 'e8aee4fd65895b9410ae82b6d7446195', '', '3pNQws', 'qq@223.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1724423149, 1724423216, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1721025150, '54820976', 1721025150, 1724423236, '', 'normal', '', 0, 0, 30000.00, 'IDS5VBUEH243Q35UG4F634NFWSSRFKFLCPEXG6REK7A3J7SDEYF466KRBB6ILW6ALVU6BMV4X6HOJ3HCWOULVXWCVN5LJ2D7SZPOTHQ');
INSERT INTO `ct_user` VALUES (35, 32, '卖家', 2, 'cece2', 'cece2', '', 'de1bf5b014e8376d92b56933039df9af', '', 'opwIPW', 'wweq2@qqw.com', NULL, '', 1, 0, NULL, 'asd', 59933.16, 90918.84, 90918.84, 0.00, 0, 1, 1, 1721053085, 1721799655, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1721025182, '29316857', 1721025182, 1721799655, '', 'normal', '', 0, 0, 120000.00, '');
INSERT INTO `ct_user` VALUES (36, 35, '卖家', 2, 'cece3', 'cece3', '', 'a9bd8d416a0f45dbe00607bf7a13cd58', '', 'LPW6rw', 'qweqw@qwqeqwe.com', NULL, '', 1, 0, NULL, '', 29265.12, 120734.88, 120734.88, 0.00, 0, 1, 1, 1724423389, 1724423421, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1721052814, '16753428', 1721052814, 1724423446, '', 'normal', '', 0, 0, 150000.00, 'AO34WWUV7MDIJPXTVB76LZVRMT3JFVVWIEMPRGCQWO3PENYBRIOLLSMOMUUTRDX6HNZK733HW7XW2JXTAHHM54NJCF4WTFOY3BRXHFA');
INSERT INTO `ct_user` VALUES (37, 36, '卖家', 1, 'cfeee', 'cfeee', '', 'b42409e66a35732f85edf26dfed2f270', '', 'IYB72k', 'aa@qq.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1721843450, 1721843458, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1721843067, '41089536', 1721843067, 1721843458, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `ct_user` VALUES (38, 37, '卖家', 2, 'qqq222', 'qqq222', '', '1500dc7de76279b8511ff57c215e9262', '', 'z897FJ', 'qq22@qw.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1721844082, 1721844182, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1721843592, '34105679', 1721843592, 1721844182, '', 'normal', '', 0, 0, 30000.00, 'RRKBP7FUDSKTZGLOKPNJTGWMRCEQXB3F54OSRLZFKHBNP27M4BNULULELRIF4N4E5OESA5MTR7FP6RRJA675JTEKCI4THQRBG2LRISI');

-- ----------------------------
-- Table structure for ct_user_group
-- ----------------------------
DROP TABLE IF EXISTS `ct_user_group`;
CREATE TABLE `ct_user_group`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '组名',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '权限节点',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '添加时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `status` enum('normal','hidden') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_user_group
-- ----------------------------
INSERT INTO `ct_user_group` VALUES (1, '默认组', '11,10,9,12,7,6,5,8,4,2,3,1', 1491635035, 1719480799, 'normal');
INSERT INTO `ct_user_group` VALUES (2, '商家组', '1,2,3,4,5,6,7,8,9,10,11,12', 1718620249, 1718620249, 'normal');
INSERT INTO `ct_user_group` VALUES (3, '买家组', '11,10,9,12,7,6,5,8,4,2,3,1', 1719038040, 1719480814, 'normal');
INSERT INTO `ct_user_group` VALUES (4, '测试组', '11,10,9,12,7,6,5,8,4,2,3,1', 1719480826, 1720079645, 'normal');

-- ----------------------------
-- Table structure for ct_user_log
-- ----------------------------
DROP TABLE IF EXISTS `ct_user_log`;
CREATE TABLE `ct_user_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL COMMENT '用户名',
  `message` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '信息',
  `status` enum('0','1') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '状态:0=失败,1=成功',
  `ip` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'IP',
  `createtime` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_user_log
-- ----------------------------

-- ----------------------------
-- Table structure for ct_user_money_log
-- ----------------------------
DROP TABLE IF EXISTS `ct_user_money_log`;
CREATE TABLE `ct_user_money_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员ID',
  `money` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '变更余额',
  `before` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '变更前余额',
  `after` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '变更后余额',
  `memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员余额变动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_user_money_log
-- ----------------------------

-- ----------------------------
-- Table structure for ct_user_rule
-- ----------------------------
DROP TABLE IF EXISTS `ct_user_rule`;
CREATE TABLE `ct_user_rule`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) NULL DEFAULT NULL COMMENT '父ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '标题',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `ismenu` tinyint(1) NULL DEFAULT NULL COMMENT '是否菜单',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NULL DEFAULT 0 COMMENT '权重',
  `status` enum('normal','hidden') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_user_rule
-- ----------------------------
INSERT INTO `ct_user_rule` VALUES (1, 0, 'index', 'Frontend', '', 1, 1491635035, 1491635035, 1, 'normal');
INSERT INTO `ct_user_rule` VALUES (2, 0, 'api', 'API Interface', '', 1, 1491635035, 1491635035, 2, 'normal');
INSERT INTO `ct_user_rule` VALUES (3, 1, 'user', 'User Module', '', 1, 1491635035, 1491635035, 12, 'normal');
INSERT INTO `ct_user_rule` VALUES (4, 2, 'user', 'User Module', '', 1, 1491635035, 1491635035, 11, 'normal');
INSERT INTO `ct_user_rule` VALUES (5, 3, 'index/user/login', 'Login', '', 0, 1491635035, 1491635035, 5, 'normal');
INSERT INTO `ct_user_rule` VALUES (6, 3, 'index/user/register', 'Register', '', 0, 1491635035, 1491635035, 7, 'normal');
INSERT INTO `ct_user_rule` VALUES (7, 3, 'index/user/index', 'User Center', '', 0, 1491635035, 1491635035, 9, 'normal');
INSERT INTO `ct_user_rule` VALUES (8, 3, 'index/user/profile', 'Profile', '', 0, 1491635035, 1491635035, 4, 'normal');
INSERT INTO `ct_user_rule` VALUES (9, 4, 'api/user/login', 'Login', '', 0, 1491635035, 1491635035, 6, 'normal');
INSERT INTO `ct_user_rule` VALUES (10, 4, 'api/user/register', 'Register', '', 0, 1491635035, 1491635035, 8, 'normal');
INSERT INTO `ct_user_rule` VALUES (11, 4, 'api/user/index', 'User Center', '', 0, 1491635035, 1491635035, 10, 'normal');
INSERT INTO `ct_user_rule` VALUES (12, 4, 'api/user/profile', 'Profile', '', 0, 1491635035, 1491635035, 3, 'normal');

-- ----------------------------
-- Table structure for ct_user_score_log
-- ----------------------------
DROP TABLE IF EXISTS `ct_user_score_log`;
CREATE TABLE `ct_user_score_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员ID',
  `score` int(10) NOT NULL DEFAULT 0 COMMENT '变更积分',
  `before` int(10) NOT NULL DEFAULT 0 COMMENT '变更前积分',
  `after` int(10) NOT NULL DEFAULT 0 COMMENT '变更后积分',
  `memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员积分变动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_user_score_log
-- ----------------------------

-- ----------------------------
-- Table structure for ct_user_token
-- ----------------------------
DROP TABLE IF EXISTS `ct_user_token`;
CREATE TABLE `ct_user_token`  (
  `token` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Token',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员ID',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `expiretime` bigint(16) NULL DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`token`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员Token表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_user_token
-- ----------------------------
INSERT INTO `ct_user_token` VALUES ('1dba1e626ab40483bfe5e0dde929c8610644fded', 38, 1721844082, 1724436082);
INSERT INTO `ct_user_token` VALUES ('262c581caaf1c74447c0bdfa2c43dc7b3030aeeb', 37, 1721843450, 1724435450);
INSERT INTO `ct_user_token` VALUES ('284f5b0f931aa5b5ecb9f9f25987cdd69126f56b', 38, 1721844182, 1724436182);
INSERT INTO `ct_user_token` VALUES ('3b23f56ce361348327016e574532aecbfa4962ad', 36, 1724423389, 1727015389);
INSERT INTO `ct_user_token` VALUES ('575e2ac252cea53fea524939d9971190b020efb1', 38, 1721843592, 1724435592);
INSERT INTO `ct_user_token` VALUES ('8c575142e19938f2d6b9aa8a27459058693287d3', 38, 1721844004, 1724436004);
INSERT INTO `ct_user_token` VALUES ('a2d7faa9f6a94437fb8535e248132975171c630e', 37, 1721843153, 1724435153);
INSERT INTO `ct_user_token` VALUES ('b6f14c084127cde8bbc6167a3cb4bb46348d573f', 37, 1721843067, 1724435067);
INSERT INTO `ct_user_token` VALUES ('b9333efde38fa21303ee566b23132eb5fe4db86f', 37, 1721843458, 1724435458);
INSERT INTO `ct_user_token` VALUES ('cc393ff0061a29904bb2a6617a81f58c52ba83f6', 34, 1724423149, 1727015149);
INSERT INTO `ct_user_token` VALUES ('dacea233cea6aa5bc03f9b66a1564f5faf63450c', 36, 1724423421, 1727015421);
INSERT INTO `ct_user_token` VALUES ('fa40ef44fd5508e22f427959ede5f1cc239d0b79', 37, 1721843361, 1724435361);

-- ----------------------------
-- Table structure for ct_withdraw
-- ----------------------------
DROP TABLE IF EXISTS `ct_withdraw`;
CREATE TABLE `ct_withdraw`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户名',
  `card_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '收款卡',
  `cardno` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '收款号码',
  `amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '数量',
  `actual_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实际到账',
  `fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '手续费',
  `status` enum('0','1','2') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '状态:0=拒绝,1=待处理,2=已完成',
  `createtime` bigint(16) NOT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `id`(`id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ct_withdraw
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
