SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for jh_admin
-- ----------------------------
DROP TABLE IF EXISTS `jh_admin`;
CREATE TABLE `jh_admin`  (
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
-- Records of jh_admin
-- ----------------------------
INSERT INTO `jh_admin` VALUES (1, 'admin', 'Admin', 'e621b65128f34ab1d4477a921829dfff', '2c0c1a', 'http://ufa.test/assets/img/avatar.png', 'admin@admin.com', '', 0, 1724416155, '127.0.0.1', 1491635035, 1724416155, '64a173c6-aaba-4126-b1b2-72cce8b3acf4', 'normal');
INSERT INTO `jh_admin` VALUES (2, 'robot', '测试Admin', '259afbe383e9af036db1725bed1231c9', 'Sbdzj7', '/assets/img/avatar.png', '1233@123.com', '13656565656', 0, 1724416004, '127.0.0.1', 1720857909, 1724416004, 'bf23408d-e594-4c1d-9c47-0f92b48d2b91', 'normal');

-- ----------------------------
-- Table structure for jh_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `jh_admin_log`;
CREATE TABLE `jh_admin_log`  (
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
-- Records of jh_admin_log
-- ----------------------------
INSERT INTO `jh_admin_log` VALUES (1, 1, 'admin', '/RiwxPQYHAv.php/user/user/edit/ids/22?dialog=1', '会员管理 / 会员管理 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"id\":\"22\",\"group_id\":\"2\",\"username\":\"test1\",\"parent_name\":\"卖家\",\"nickname\":\"test1\",\"password\":\"***\",\"expassword\":\"***\",\"email\":\"551@55.com\",\"mobile\":\"\",\"avatar\":\"\",\"level\":\"1\",\"isquality\":\"0\",\"isrecommend\":\"0\",\"gender\":\"0\",\"birthday\":\"\",\"bio\":\"\",\"money\":\"4500.00\",\"score\":\"0\",\"successions\":\"1\",\"maxsuccessions\":\"1\",\"prevtime\":\"2024-07-04 18:12:51\",\"logintime\":\"2024-07-04 18:12:51\",\"loginip\":\"127.0.0.1\",\"loginfailure\":\"0\",\"joinip\":\"127.0.0.1\",\"jointime\":\"2024-07-04 18:12:51\",\"status\":\"normal\"},\"ids\":\"22\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0', 1720090230);
INSERT INTO `jh_admin_log` VALUES (2, 1, 'admin', '/RiwxPQYHAv.php/user/user/edit/ids/22?dialog=1', '会员管理 / 会员管理 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"id\":\"22\",\"group_id\":\"2\",\"username\":\"test1\",\"parent_name\":\"卖家\",\"nickname\":\"test1\",\"password\":\"***\",\"expassword\":\"***\",\"email\":\"551@55.com\",\"mobile\":\"\",\"avatar\":\"\",\"level\":\"1\",\"isquality\":\"0\",\"isrecommend\":\"0\",\"gender\":\"0\",\"birthday\":\"\",\"bio\":\"\",\"money\":\"4500.00\",\"score\":\"0\",\"successions\":\"1\",\"maxsuccessions\":\"1\",\"prevtime\":\"2024-07-04 18:12:51\",\"logintime\":\"2024-07-04 18:12:51\",\"loginip\":\"127.0.0.1\",\"loginfailure\":\"0\",\"joinip\":\"127.0.0.1\",\"jointime\":\"2024-07-04 18:12:51\",\"status\":\"normal\"},\"ids\":\"22\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0', 1720090258);

-- ----------------------------
-- Table structure for jh_admin_group
-- ----------------------------
DROP TABLE IF EXISTS `jh_admin_auth_group`;
CREATE TABLE `jh_admin_group`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父组别',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '组名',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则ID',
  `create_time` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员分组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of jh_admin_group
-- ----------------------------
INSERT INTO `jh_admin_group` VALUES (1, 0, '超管组', '*', 1491635035, 1491635035, 'normal');
INSERT INTO `jh_admin_group` VALUES (2, 1, '默认组', '1', 1720857831, 1724422780, 'normal');

-- ----------------------------
-- Table structure for jh_admin_group_privilege
-- ----------------------------
DROP TABLE IF EXISTS `jh_admin_group_privilege`;
CREATE TABLE `jh_admin_group_privilege`  (
  `uid` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `group_id` int(10) UNSIGNED NOT NULL COMMENT '组ID',
  UNIQUE INDEX `uid_group_id`(`uid`, `group_id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员权限分组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of jh_admin_group_privilege
-- ----------------------------
INSERT INTO `jh_admin_group_privilege` VALUES (1, 1);
INSERT INTO `jh_admin_group_privilege` VALUES (2, 2);

-- ----------------------------
-- Table structure for jh_admin_privilege_rule
-- ----------------------------
DROP TABLE IF EXISTS `jh_admin_privilege_rule`;
CREATE TABLE `jh_admin_privilege_rule`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` enum('menu','action') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'action' COMMENT 'menu为菜单,action为具体操作',
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规则名称',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规则名称',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规则URL',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `create_time` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `order` int(10) NOT NULL DEFAULT 0 COMMENT '权重',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE,
  INDEX `order`(`order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 137 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台权限规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of jh_admin_privilege_rule
-- ----------------------------
INSERT INTO `jh_admin_privilege_rule` VALUES (1, 'action', 0, 'dashboard', 'Dashboard', 'fa fa-dashboard', '', '', 'Dashboard tips', 1, NULL, '', 'kzt', 'kongzhitai', 1491635035, 1491635035, 143, 'normal');
INSERT INTO `jh_admin_privilege_rule` VALUES (2, 'action', 0, 'general', 'General', 'fa fa-cogs', '', '', '', 1, NULL, '', 'cggl', 'changguiguanli', 1491635035, 1491635035, 137, 'normal');
INSERT INTO `jh_admin_privilege_rule` VALUES (3, 'action', 0, 'category', 'Category', 'fa fa-leaf', '', '', 'Category tips', 0, NULL, '', 'flgl', 'fenleiguanli', 1491635035, 1491635035, 119, 'normal');
INSERT INTO `jh_admin_privilege_rule` VALUES (5, 'action', 0, 'auth', 'Auth', 'fa fa-group', '', '', '', 1, NULL, '', 'qxgl', 'quanxianguanli', 1491635035, 1491635035, 99, 'normal');
INSERT INTO `jh_admin_privilege_rule` VALUES (6, 'action', 2, 'general/config', 'Config', 'fa fa-cog', '', '', 'Config tips', 1, NULL, '', 'xtpz', 'xitongpeizhi', 1491635035, 1491635035, 60, 'normal');
INSERT INTO `jh_admin_privilege_rule` VALUES (7, 'action', 2, 'general/attachment', 'Attachment', 'fa fa-file-image-o', '', '', 'Attachment tips', 1, NULL, '', 'fjgl', 'fujianguanli', 1491635035, 1491635035, 53, 'normal');
INSERT INTO `jh_admin_privilege_rule` VALUES (8, 'action', 2, 'general/profile', 'Profile', 'fa fa-user', '', '', '', 1, NULL, '', 'grzl', 'gerenziliao', 1491635035, 1491635035, 34, 'normal');


-- ----------------------------
-- Table structure for jh_user
-- ----------------------------
DROP TABLE IF EXISTS `jh_user`;
CREATE TABLE `jh_user`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `parent_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级ID',
  `parent_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '上级标识',
  `group_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '组别ID',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '昵称',
  `realname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '真实姓名',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
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
-- Records of jh_user
-- ----------------------------
INSERT INTO `jh_user` VALUES (1, 1, '通道88', 1, 'admin', 'admin', '', '0048e4560f8eb904fd7e90cd3d5b6132', '', '7a801f', 'admin@163.com', '13000000000', '/assets/img/avatar.png', 0, 0, '2017-04-08', '', 20.00, 0.00, 0.00, 0.00, 0, 1, 1, 1491635035, 1491635035, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1491635035, '35107234', 0, 1720012780, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (2, 1, '', 1, 'cdaf', 'cdaf', '', 'ea5ad8d0cebc0973714f0c93201e9ad0', '', 'pmGzYt', 'aaff@qq.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1718702839, 1718702839, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1718702839, '35102346', 1718702839, 1719038058, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (3, 1, '', 1, 'cadad16', 'cadad16', '', 'fc2443bcb5bc203a05301c421bdbdbde', '', '3n59lJ', 'dd@qq.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1718703016, 1718703053, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1718703016, '', 1718703016, 1719038052, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (4, 0, '', 1, 'casdcc16', 'casdcc16', '', '29b0401b9dbe53d21768ff6d5197beba', '', 'uqeA2F', 'aadd@qq.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1718704562, 1718704562, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1718704562, '35107246', 1718704562, 1718704562, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (5, 0, '', 2, 'casdas', 'casdas', '', '01d9a201ece063dd2c21fe57e119cfd1', '', 'ycpMBC', 'adsad@qq.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719575469, 1719575472, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1718704738, '15042768', 1718704738, 1720080514, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (6, 0, '卖家', 2, 'casda', 'casda', '', 'f151ec4dbe15dcad93ccccac47761a43', 'qq169169', '12dUiF', 'dasda@qq.com', '', '', 1, 0, NULL, '', 600.00, 0.00, 0.00, 0.00, 0, 2, 3, 1720081520, 1720081889, '127.0.0.1', '中国广西南宁', '广西', '南宁', 0, '127.0.0.1', 1718705976, '27863504', 1718705976, 1720082625, '', 'normal', '', 1, 1, 30000.00, '');
INSERT INTO `jh_user` VALUES (7, 0, '', 1, 'dasdasd1', 'dasdasd1', '', '221fcf4e5fd888d2f351664a13b53bb7', '', 'LNZXDV', 'aacc@qq.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1718706051, 1718706051, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1718706051, '53980642', 1718706051, 1718706051, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (8, 0, '', 1, 'vbcb', 'vbcb', '', '4b297b77b971d09534fe34a1ce80b38b', '', 'u2bBmg', 'aadz@qq.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719484249, 1719493805, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1719476351, '05948167', 1719476351, 1719493805, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (9, 0, '', 1, 'bf', 'bf', '', '7d71559656308391c72c9f142462daa7', '168168', 'Ks0gMY', 'qwer@qqw.com', NULL, '', 1, 0, NULL, '', 978.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719505932, 1719505932, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1719505932, '49875603', 1719505932, 1719512278, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (10, 0, '通道2', 3, 'onc', 'onc', '', 'f53531df4675e96fefc64c3c7c20e40b', '168168', 'rqHse2', 'qqwe@qwe.com', '', '', 1, 0, NULL, '', 10.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719507380, 1719507380, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1719507380, '13470526', 1719507380, 1720080367, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (11, 0, '通道1', 3, 'cccc21', '发', '', '80503aadfa0317aa4ed8bc36e77b907b', '', 'hsLrIc', '55@55.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719512426, 1719512426, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1719512426, '41087236', 1719512426, 1720080385, '', 'normal', '', 1, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (12, 0, '', 1, 'bbfada', '买', '', '6b312f2b16157d714f89c9a3e0fc81e6', '168168', 'w59Atk', '565@56.com', '', '', 1, 0, NULL, '', 98.00, 0.00, 0.00, 0.00, 0, 1, 1, 1719512462, 1719512462, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1719512462, '76928143', 1719512462, 1719999410, '', 'normal', '', 1, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (13, 1, '', 2, 'gftgft', 'gftgft', '', 'b99cadda83996ad8089f88dd3a635d0f', '169169', 'lwP61I', 'fvcl@qq.com', '', '', 1, 0, NULL, '', 1830.00, 0.00, 0.00, 0.00, 0, 1, 2, 1720637356, 1720981235, '127.0.0.1', '', '广西', '南宁', 0, '127.0.0.1', 1719993885, '42671035', 1719993885, 1720981235, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (14, 11, '通道1', 3, 'qq168', 'qq168', '', '6a1adcefabed6325e7d85c578639bcaa', 'qq168168', 'e1z0BJ', 'qq@55.com', '', '', 1, 0, NULL, '', 1488.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720001305, 1720001305, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720001305, '36159740', 1720001305, 1720080409, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (15, 14, '通道1', 3, 'qq1122', 'qq1122', '', 'f85a367f06f7004353dc422b34271269', '', 'by5M6l', '6565@23.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720003024, 1720003024, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720003024, '74913806', 1720003024, 1720080397, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (16, 15, '通道1', 3, 'aa12', 'aa12', '', '7fe98cd855786b650c212377c02d743c', 'qq168168', 'sJAX8h', 'aa12@qq.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 2, 2, 1720018858, 1720035554, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720018858, '90687451', 1720018858, 1720080275, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (17, 5, '', 1, 'mai', 'mai', '', 'aa3214fad0d98f52d4a1243209c9f1dd', 'qq168168', 'pZ84Qx', 'mai@qq.com', NULL, '', 1, 0, NULL, '', 466.00, 551.00, 0.00, 0.00, 0, 2, 2, 1720036906, 1720036927, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720018985, '34781206', 1720018985, 1720036927, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (18, 17, '', 3, 'maimaimai', 'maimaimai', '', '9bdb9eb24915595d1bb188dd61f6bd43', 'qq168168', 'HV3sA0', 'qqq@qq.com', '', '', 1, 0, NULL, '', 201.00, 31499.00, 0.00, 0.00, 0, 1, 1, 1720073554, 1720604500, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720030955, '73145962', 1720030955, 1720611963, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (19, 10, '通道2', 3, 'ceshi', 'ceshi', '', '8c0452a0696c07c645a5ff5d6024f171', '', '68sVXI', 'qq@qq.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720080462, 1720080462, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720080462, '67049132', 1720080462, 1720080913, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (20, 5, '卖家', 2, 'test', 'test', '', '3ae6d22d65c78a4a7c5829a26a10b102', 'qq168168', 'DrHgJR', 'qq@qq1.com', '', '', 1, 0, NULL, '', 0.00, 40012.00, 0.00, 0.00, 0, 1, 1, 1720083555, 1720088116, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720080541, '34298510', 1720080541, 1720089867, '', 'normal', '', 1, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (21, 6, '卖家', 2, 'uuuu', 'uuuu', '', '592baf82ebc0666f035a7b34406544db', 'qq168168', 'xCkgSh', 'uuu@uu.com', '', '', 1, 0, NULL, '', 19949.00, 30001.00, 0.00, 0.00, 0, 1, 1, 1720081850, 1720082697, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720081292, '68214753', 1720081292, 1720082697, '', 'normal', '', 1, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (22, 20, '卖家', 2, 'test1', 'test1', '', '38b335ca36d4fde57d430eff0371df22', '5512313', 'Y0qgfb', '551@55.com', '', '', 1, 0, NULL, '', 4500.00, 50.00, 0.00, 0.00, 0, 1, 1, 1720087971, 1720087971, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720087971, '19405683', 1720087971, 1720091358, '', 'normal', '', 1, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (23, 22, '卖家', 2, 'test001', 'test001', '', '705e791f7bf8b2f881a33e70408a9a20', '', 'YP0TGV', 'test22@www.com', '', '', 1, 0, NULL, '', 5000.00, 238.08, 0.00, 0.00, 0, 1, 1, 1720685037, 1720685037, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720685037, '93812476', 1720685037, 1720687605, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (24, 18, '', 3, 'asdad', 'asdad', '', '0f2cbe17e9ea08fcf6621accbcc3286d', '', '9SJoXh', 'qwrqw@q.com', '', '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720685851, 1720685851, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720685851, '84931206', 1720685851, 1720685875, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (25, 16, '通道1', 3, 'maijia', 'maijia', '', '94c8fd4511d73872092438ec71f978b5', '', '0H7Ijg', 'ww@w.com', '', '', 1, 0, NULL, '', 100.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720687883, 1720687883, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720687883, '40869753', 1720687883, 1720719603, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (26, 23, '卖家', 2, 'ttt', 'ttt', '', 'c7890eca4a035b5ef86aee832c31438e', 'qq168168', 'jqdRYH', 'sss@wqc.com', '', '', 1, 0, NULL, '', 3635.12, 1831.01, 0.00, 0.00, 0, 1, 1, 1720687937, 1720687937, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720687937, '49367815', 1720687937, 1720719603, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (27, 26, '卖家', 2, 'qqq', 'qqq', '', '2f8b0524f0fa6bfdb71428f50b1cdaa3', 'qq168168', 'YwuhXz', 'qq2@qq.com', '', '', 1, 0, NULL, '', 300.93, 188.07, 0.00, 0.00, 0, 1, 1, 1720758641, 1720789938, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720758641, '81240563', 1720758641, 1720789938, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (28, 25, '通道1', 3, 'www', 'www', '', '77eaaa2245fd684b8e37ba0ffee1b314', '', 'VKp9Cf', 'ww@ww.com', '', '', 1, 0, NULL, '', 9.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720771318, 1720771339, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720758670, '42169805', 1720758670, 1720771339, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (29, 28, '通道1', 3, 'test12', 'test12', '', '5436ff16941c851b5b6bd78d4ceb54fd', '', 'KC4SJi', '22@222.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720853254, 1720869703, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720853254, '82671954', 1720853254, 1720869703, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (30, 27, '卖家', 2, 'test23', 'test23', '', '9d60b63105f382ede253071b8b6b8c34', '', 'lZNUK8', '1212@123.com', NULL, '', 1, 0, NULL, '', 552.75, 447.25, 0.00, 0.00, 0, 1, 1, 1720870257, 1720870505, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720853297, '63079128', 1720853297, 1720872088, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (31, 29, '通道1', 2, 'test13', 'test13', '', '2168f80fe5decdcd6ac4b6b58025b389', '', 'kxnQ0v', 'qqw22@qqq.com', NULL, '', 1, 0, NULL, '', 18897.65, 31102.35, 31102.35, 0.00, 0, 1, 1, 1720869637, 1720869637, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720869637, '69783125', 1720869637, 1720870235, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (32, 30, '卖家', 2, 'ceshi1', 'ceshi1', '', '3570d2f0622bccfd93a6e2e55a55c96c', '', 'pHqAYh', 'q@qqqq.com', NULL, '', 1, 0, NULL, '', 10470.51, 39793.49, 39793.49, 0.00, 0, 1, 1, 1721052127, 1721052198, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720870348, '48275391', 1720870348, 1721052211, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (33, 29, '通道1', 1, 'qweqwe', 'qweqwe', '', 'd04cd21c24eb899de3661e10b9a74593', '', '9VGLUJ', 'www@www.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1720874458, 1720874458, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1720874458, '02834716', 1720874458, 1720874458, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (34, 33, '通道1', 3, 'caca1', 'caca1', '', 'e8aee4fd65895b9410ae82b6d7446195', '', '3pNQws', 'qq@223.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1724423149, 1724423216, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1721025150, '54820976', 1721025150, 1724423236, '', 'normal', '', 0, 0, 30000.00, 'IDS5VBUEH243Q35UG4F634NFWSSRFKFLCPEXG6REK7A3J7SDEYF466KRBB6ILW6ALVU6BMV4X6HOJ3HCWOULVXWCVN5LJ2D7SZPOTHQ');
INSERT INTO `jh_user` VALUES (35, 32, '卖家', 2, 'cece2', 'cece2', '', 'de1bf5b014e8376d92b56933039df9af', '', 'opwIPW', 'wweq2@qqw.com', NULL, '', 1, 0, NULL, 'asd', 59933.16, 90918.84, 90918.84, 0.00, 0, 1, 1, 1721053085, 1721799655, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1721025182, '29316857', 1721025182, 1721799655, '', 'normal', '', 0, 0, 120000.00, '');
INSERT INTO `jh_user` VALUES (36, 35, '卖家', 2, 'cece3', 'cece3', '', 'a9bd8d416a0f45dbe00607bf7a13cd58', '', 'LPW6rw', 'qweqw@qwqeqwe.com', NULL, '', 1, 0, NULL, '', 29265.12, 120734.88, 120734.88, 0.00, 0, 1, 1, 1724423389, 1724423421, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1721052814, '16753428', 1721052814, 1724423446, '', 'normal', '', 0, 0, 150000.00, 'AO34WWUV7MDIJPXTVB76LZVRMT3JFVVWIEMPRGCQWO3PENYBRIOLLSMOMUUTRDX6HNZK733HW7XW2JXTAHHM54NJCF4WTFOY3BRXHFA');
INSERT INTO `jh_user` VALUES (37, 36, '卖家', 1, 'cfeee', 'cfeee', '', 'b42409e66a35732f85edf26dfed2f270', '', 'IYB72k', 'aa@qq.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1721843450, 1721843458, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1721843067, '41089536', 1721843067, 1721843458, '', 'normal', '', 0, 0, 30000.00, '');
INSERT INTO `jh_user` VALUES (38, 37, '卖家', 2, 'qqq222', 'qqq222', '', '1500dc7de76279b8511ff57c215e9262', '', 'z897FJ', 'qq22@qw.com', NULL, '', 1, 0, NULL, '', 0.00, 0.00, 0.00, 0.00, 0, 1, 1, 1721844082, 1721844182, '127.0.0.1', '', '', '', 0, '127.0.0.1', 1721843592, '34105679', 1721843592, 1721844182, '', 'normal', '', 0, 0, 30000.00, 'RRKBP7FUDSKTZGLOKPNJTGWMRCEQXB3F54OSRLZFKHBNP27M4BNULULELRIF4N4E5OESA5MTR7FP6RRJA675JTEKCI4THQRBG2LRISI');