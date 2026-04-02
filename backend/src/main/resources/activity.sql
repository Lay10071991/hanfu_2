SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES (1, '普通用户');
INSERT INTO `user_role` VALUES (2, '商家');
INSERT INTO `user_role` VALUES (3, '平台负责人');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `gender` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '性别',
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '简介',
  `user_role_id` bigint NOT NULL COMMENT '用户角色ID',
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`user_role_id`) REFERENCES `user_role` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '123456', 'male', '平台管理员', 3);
INSERT INTO `user` VALUES (2, 'lay', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (3, 'shop', '123456', 'male', '商家', 2);
INSERT INTO `user` VALUES (4, 'Echo', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (5, 'Wanderer', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (6, 'Nostalgia', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (7, 'Paradox', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (8, 'Serendipity', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (9, 'Aurora', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (10, 'Ghost', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (11, 'Clarity', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (12, 'Velocity', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (13, 'Solitude', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (14, 'Eclipse', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (15, 'Phoenix', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (16, 'Cipher', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (17, 'Mirage', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (18, 'Nova', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (19, 'Zenith', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (20, 'Whisper', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (21, '挽墨', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (22, '寄风给你', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (23, '且听风吟', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (24, '星河滚烫', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (25, '人间理想', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (26, '温柔半两', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (27, '清风徐来', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (28, '北岛信物', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (29, '南邮信笺', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (30, '春日部', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (31, '晚风吻尽', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (32, '云边小卖部', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (33, '橘子汽水', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (34, '半糖主义', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (35, '月亮邮递员', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (36, '落日飞车', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (37, '海盐幻想', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (38, '银河投递员', '123456', 'male', '普通用户', 1);
INSERT INTO `user` VALUES (39, '桃桃气泡水', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (40, '芝士奶盖', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (41, '小熊软糖', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (42, '抹茶星冰乐', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (43, '草莓甜心', '123456', 'female', '普通用户', 1);
INSERT INTO `user` VALUES (44, '织云', '123456', 'female', '商家', 2);
INSERT INTO `user` VALUES (45, '衔花', '123456', 'female', '商家', 2);
INSERT INTO `user` VALUES (46, '南风', '123456', 'male', '商家', 2);
INSERT INTO `user` VALUES (47, '锦瑟', '123456', 'female', '商家', 2);
INSERT INTO `user` VALUES (48, '枕霞', '123456', 'female', '商家', 2);
INSERT INTO `user` VALUES (49, '听雨', '123456', 'male', '商家', 2);
INSERT INTO `user` VALUES (50, '裁月', '123456', 'female', '商家', 2);
INSERT INTO `user` VALUES (51, '清商', '123456', 'female', '商家', 2);
INSERT INTO `user` VALUES (52, '栖霞', '123456', 'female', '商家', 2);
INSERT INTO `user` VALUES (53, '拾花', '123456', 'female', '商家', 2);
INSERT INTO `user` VALUES (54, '云想', '123456', 'female', '商家', 2);
INSERT INTO `user` VALUES (55, '未央', '123456', 'female', '商家', 2);

-- ----------------------------
-- Table structure for historical_era
-- ----------------------------
DROP TABLE IF EXISTS `historical_era`;
CREATE TABLE `historical_era`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '历史朝代ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '朝代名称',
  `years` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '年代',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '历史朝代表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of historical_era
-- ----------------------------
INSERT INTO `historical_era` VALUES (1, '先秦时期', '公元前21世纪-前221年', '衣裳制度确立，汉服出现', '先秦时期确立了汉服的基本形制——上衣下裳制。深衣开始出现，成为后世汉服的重要基础。服饰体现了严格的等级制度和社会规范。', '2026-03-01 19:22:16', '2026-03-01 19:22:16');
INSERT INTO `historical_era` VALUES (2, '秦汉时期', '前221年-220年', '秦汉汉服流行，官服定制', '秦汉时期秦汉汉服流行，官服开始定制。服饰风格端庄厚重，体现了大一统帝国的威严和气度。', '2026-03-01 19:22:16', '2026-03-01 19:22:16');
INSERT INTO `historical_era` VALUES (3, '魏晋南北朝', '220年-589年', '魏晋风流，服饰风格洒脱', '受玄学思想影响，服饰风格趋向宽松洒脱，褒衣博带成为时尚。服饰更加注重个性表达和审美追求。', '2026-03-01 19:22:16', '2026-03-01 19:22:16');
INSERT INTO `historical_era` VALUES (4, '隋唐时期', '581年-907年', '隋唐开放，女装丰富多彩', '隋唐时期国力强盛，服饰开放多样。衫裙装成为女性主要服饰，女装样式多样，色彩斑斓，体现了开放包容的时代精神。', '2026-03-01 19:22:16', '2026-03-01 19:22:16');
INSERT INTO `historical_era` VALUES (5, '宋明时期', '960年-1644年', '宋明理学影响，服饰趋向内敛', '宋明时期理学思想影响下，服饰风格趋于内敛含蓄。襦裙成为流行服饰，整体造型简洁质朴。', '2026-03-01 19:22:16', '2026-03-01 19:22:16');
INSERT INTO `historical_era` VALUES (6, '清代', '1644年-1911年', '汉服衰落，满汉融合', '清代推行剃发易服政策，汉服逐渐衰落。但在民间，汉服仍有一定程度的保留，并与满族服饰相互影响融合。', '2026-03-01 19:22:16', '2026-03-01 19:22:16');

-- ----------------------------
-- Table structure for cultural_content
-- ----------------------------
DROP TABLE IF EXISTS `cultural_content`;
CREATE TABLE `cultural_content`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '内容ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型(overview/history)',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `years` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年代',
  `create_time` datetime(6) NULL DEFAULT NULL,
  `update_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文化内容表-汉服历史概述和演变' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cultural_content
-- ----------------------------
INSERT INTO `cultural_content` VALUES (1, '汉服的历史概述', '汉服，全称是"汉民族传统服饰"，又称汉衣冠、汉装、华服，是从黄帝即位到公元17世纪中叶(明末清初)，在汉族的主要居住区，以"华夏-汉"文化为背景和主导思想，以华夏礼仪文化为中心，通过自然演化而形成的具有独特汉民族风貌性格，明显区别于其他民族的传统服装和配饰体系。\n\n汉服历史悠久，源远流长，承载着中华民族几千年的文化底蕴和审美理念。从黄帝"垂衣裳而天下治"开始，汉服就已经具备了基本形制，历经夏商周、秦汉、魏晋南北朝、隋唐、宋元明清各个朝代的发展演变，形成了丰富多彩的服饰文化体系。', 'overview', '汉服概述', '', NULL, NULL);
INSERT INTO `cultural_content` VALUES (2, '衣裳制度确立，汉服出现', '先秦时期确立了汉服的基本形制——上衣下裳制。深衣开始出现，成为后世汉服的重要基础。服饰体现了严格的等级制度和社会规范。', 'history', '先秦时期', '公元前21世纪-前221年', NULL, NULL);
INSERT INTO `cultural_content` VALUES (3, '秦汉汉服流行，官服定制', '秦汉时期秦汉汉服流行，官服开始定制。服饰风格端庄厚重，体现了大一统帝国的威严和气度。', 'history', '秦汉时期', '前221年-220年', NULL, NULL);
INSERT INTO `cultural_content` VALUES (4, '魏晋风流，服饰风格洒脱', '受玄学思想影响，服饰风格趋向宽松洒脱，褒衣博带成为时尚。服饰更加注重个性表达和审美追求。', 'history', '魏晋南北朝', '220年-589年', NULL, NULL);
INSERT INTO `cultural_content` VALUES (5, '隋唐开放，女装丰富多彩', '隋唐时期国力强盛，服饰开放多样。衫裙装成为女性主要服饰，女装样式多样，色彩斑斓，体现了开放包容的时代精神。', 'history', '隋唐时期', '581年-907年', NULL, NULL);
INSERT INTO `cultural_content` VALUES (6, '宋明理学影响，服饰趋向内敛', '宋明时期理学思想影响下，服饰风格趋于内敛含蓄。襦裙成为流行服饰，整体造型简洁质朴。', 'history', '宋明时期', '960年-1644年', NULL, NULL);

-- ----------------------------
-- Table structure for culture_influence
-- ----------------------------
DROP TABLE IF EXISTS `culture_influence`;
CREATE TABLE `culture_influence`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文化影响ID',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文化影响与传承表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of culture_influence
-- ----------------------------
INSERT INTO `culture_influence` VALUES (1, '礼仪制度', '汉服与华夏礼仪制度密不可分，自古以来就有衣冠之治的说法。不同场合、身份、性别都有相应的服饰规范，体现了礼的文化内涵和等级秩序。', '2026-03-01 19:22:16', '2026-03-01 19:22:16');
INSERT INTO `culture_influence` VALUES (2, '审美观念', '汉服体现了天人合一的哲学思想，服饰讲究与自然和谐统一。宽大的袖口象征天地，交领右衽体现阴阳，整体造型追求自然流畅。', '2026-03-01 19:22:16', '2026-03-01 19:22:16');
INSERT INTO `culture_influence` VALUES (3, '现代复兴', '21世纪初，汉服复兴运动开始兴起。最初由少数文化爱好者发起，逐渐发展成为一场涉及全国的文化运动，吸引了大量年轻人参与。', '2026-03-01 19:22:16', '2026-03-01 19:22:16');

-- ----------------------------
-- Table structure for shape_type
-- ----------------------------
DROP TABLE IF EXISTS `shape_type`;
CREATE TABLE `shape_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '形制分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '形制名称',
  `period` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '流行时期',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '形制描述',
  `characteristics` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '形制特点',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细内容',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图片URL',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序顺序',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '汉服形制分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shape_type
-- ----------------------------
INSERT INTO `shape_type` VALUES (1, '深衣制', '战国至明代', '上下连属的服饰，将上衣下裳连为一体，体现深意。', '上下连属、端庄大方、适用广泛', '深衣制是汉服的重要形制之一，其最大特点是将上衣和下裳连在一起，形成上下连属的服饰结构。这种形制体现了中国古代"天地合一"的哲学思想，上衣用深色象征天，下裳用浅色象征地。深衣在战国时期开始流行，历经秦汉、魏晋南北朝，一直沿用到明代，是中国古代穿着时间最长的服饰形制之一。深衣的裁剪工艺精湛，线条流畅，穿着端庄大方，既适合日常穿着，也适用于各种礼仪场合。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shenyi1.webp', 1, '2026-03-01 19:22:16', '2026-03-01 19:22:16');
INSERT INTO `shape_type` VALUES (2, '衣裳制', '先秦至明清', '上衣下裳的基本形制，最古老的汉服形式，象征天地秩序。', '上下分裁、庄严正统、礼仪性强', '衣裳制是汉服最古老、最基本的形制，由上衣和下裳两部分组成。这种形制的起源可以追溯到远古时期，是中国服饰文化的源头。上衣代表天，下裳代表地，体现了中国古代"天人合一"的宇宙观。衣裳制在先秦时期就已经成熟，成为华夏衣冠的标准形制。历代王朝在制定礼服制度时，都以衣裳制为基础。这种形制庄严正统，礼仪性强，是古代祭祀、朝会等重大场合的主要服饰形式。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/yishang1.webp', 2, '2026-03-01 19:22:16', '2026-03-01 19:22:16');
INSERT INTO `shape_type` VALUES (3, '襦裙制', '历代流行', '上衣下裙的女装组合，历代款式变化丰富多样。', '上衣下裙、款式多样、女性特色', '襦裙制是汉服女装的主要形制，由短上衣（襦）和裙子组成。这种形制在中国历史上流传时间最长、影响最为深远。历代襦裙款式变化丰富，有齐胸襦裙、齐腰襦裙、高腰襦裙等多种形式。襦裙制充分展现了东方女性的优雅气质，上衣短小精悍，裙子飘逸动人，整体线条流畅优美。从汉代的深衣制襦裙，到唐代的齐胸襦裙，再到宋明时期的各类襦裙，这种形制随着时代发展不断演变，成为中国传统女装的经典代表。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/ruqun1.webp', 3, '2026-03-01 19:22:16', '2026-03-01 19:22:16');
INSERT INTO `shape_type` VALUES (4, '袍服制', '汉代以后', '一体裁剪的长衣，便于活动，逐渐成为日常服饰。', '一体裁剪、便于活动、日常实用', '袍服制是一体裁剪的长衣形制，有衬里的称袍，无衬里的称衫。这种形制在汉代以后广泛流行，因其便于活动、穿着舒适而深受人们喜爱。袍服的特点是上下连属，一体成型，没有上衣下裳的分界。袍服的长度一般到脚踝，袖子宽大，体现了汉服的庄重与大气。历代袍服款式多样，有直裾袍、曲裾袍、圆领袍等，不同款式适应不同的场合和身份。袍服制既保留了汉服的典雅气质，又增加了实用性，成为古代日常穿着的主要服饰形式。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/paofu1.webp', 4, '2026-03-01 19:22:16', '2026-03-01 19:22:16');

-- ----------------------------
-- Table structure for clothing_component
-- ----------------------------
DROP TABLE IF EXISTS `clothing_component`;
CREATE TABLE `clothing_component`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '服饰部件ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '部件名称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '部件类型',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '部件描述',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细内容',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图片URL',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序顺序',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '服饰部件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of clothing_component
-- ----------------------------
INSERT INTO `clothing_component` VALUES (1, '衣', '上身服饰', '汉服的上身部分，包括各种款式的上衣。', '衣是汉服的上身部分，包括各种款式的上衣。根据形制、用途的不同，衣有多种分类。常见的上衣包括襦、衫、袄等。襦为短上衣，衫为单层上衣，袄为有衬里的上衣。衣的领型有交领、直领、圆领等多种形式，袖型有广袖、窄袖、琵琶袖等变化。不同朝代、不同场合的衣在款式、色彩、纹样上都有严格的规定，体现了汉服的礼仪性。衣的长度从短至腰到长及膝下不等，根据季节和场合选择合适的款式。衣的纹样装饰丰富多样，常见的有云纹、龙纹、凤纹等，体现了穿着者的身份和地位。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/yi1.webp', 1, '2026-03-14 21:44:34', '2026-03-14 21:44:34');
INSERT INTO `clothing_component` VALUES (2, '裳', '下身服饰', '汉服的下身部分，主要指裙装。', '裳是汉服的下身部分，主要指裙装。在古代，裳是男女皆可穿着的下装。裳的款式多样，包括单片裙、多片裙、马面裙等。不同形制的裳在裁剪和穿着方式上各有特点。裳的长度、幅数、褶数等都有特定的文化含义，体现了古人的审美观念和社会规范。随着时代发展，裳的款式不断丰富，成为汉服文化中的重要组成部分。裳的穿着方式讲究层次，通常内穿衬裙，外罩主裙，体现了汉服的层次感。裳的色彩搭配讲究和谐，常与上衣形成对比或呼应，展现整体美感。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shang1.webp', 2, '2026-03-14 21:44:34', '2026-03-14 21:44:34');
INSERT INTO `clothing_component` VALUES (3, '袍', '一体服饰', '上下连属的长衣，有衬里的称袍。', '袍是上下连属的长衣，有衬里的称袍，是汉服中重要的服饰类型。袍的特点是保暖性好，适合秋冬季节穿着，也是正式场合的常见服饰。袍的款式包括直裾袍、曲裾袍等，不同款式适应不同的场合和身份。袍的长度一般到脚踝，袖子宽大，体现了汉服的庄重与大气。袍的颜色和纹样有严格的等级规定，不同品级的官员穿着不同颜色的袍服。袍的穿着方式讲究系带和配饰，体现了汉服的礼仪规范。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/pao1.webp', 3, '2026-03-14 21:44:34', '2026-03-14 21:44:34');
INSERT INTO `clothing_component` VALUES (4, '衫', '一体服饰', '单层的长衣，无衬里的称衫。', '衫是单层的长衣，无衬里的称衫，适合春夏季节穿着。衫的特点是轻薄透气，穿着舒适，是日常休闲的常见选择。衫的款式包括直领衫、交领衫等，面料多为丝绸、棉麻等轻薄材质。衫的长度变化多样，有长及脚踝的长衫，也有短至腰部的短衫。衫的颜色以素雅为主，常见的有白色、浅蓝、淡粉等清新色调。衫的穿着场合广泛，既可作为内衣，也可作为外衣，体现了汉服的实用性。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shan1.webp', 4, '2026-03-14 21:44:34', '2026-03-14 21:44:34');
INSERT INTO `clothing_component` VALUES (5, '襦', '上衣', '短上衣，通常与裙搭配穿着。', '襦是短上衣，长度一般到腰部，通常与裙搭配穿着。襦的特点是短小精悍，便于活动，是女性日常穿着的主要上衣类型。襦的领型多为交领，也有对襟款式，袖子有窄袖和广袖之分。襦与裙的搭配形成了襦裙这一经典女装形制，历代款式变化丰富。襦的装饰精美，常在领口、袖口、下摆处绣有花纹，体现女性审美。襦的颜色选择丰富，可根据季节和场合搭配不同颜色的裙子。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/ru1.webp', 5, '2026-03-14 21:44:34', '2026-03-14 21:44:34');
INSERT INTO `clothing_component` VALUES (6, '裙', '下裳', '下身穿着的裙装，款式多样。', '裙是下身穿着的裙装，是女性汉服的重要组成部分。裙的款式多样，包括百褶裙、马面裙、月华裙等，每种都有独特的审美特点。裙的穿着位置有齐胸、齐腰、高腰之分，不同位置展现不同的身材比例。裙的面料多为丝绸、锦缎等，质地轻盈，行走时飘逸动人。裙的纹样装饰丰富，常见的有花卉、云纹、几何图案等。裙的色彩搭配讲究，常与上衣形成和谐或对比的视觉效果。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/qun1.webp', 6, '2026-03-14 21:44:34', '2026-03-14 21:44:34');
INSERT INTO `clothing_component` VALUES (7, '裤', '下裳', '下身穿着的裤装，便于活动。', '裤是下身穿着的裤装，便于活动，是实用的下装选择。古代的裤与现代有所不同，早期为无裆的胫衣，后发展为合裆裤。裤的款式包括长裤、短裤、灯笼裤等，适应不同的活动和场合。裤常穿在裙内作为衬裤，也可单独外穿，体现了汉服的层次感。裤的面料多为棉麻、丝绸等，注重舒适性和实用性。裤的系带设计便于调节松紧，适应不同身材和活动需求。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/ku1.webp', 7, '2026-03-14 21:44:34', '2026-03-14 21:44:34');
INSERT INTO `clothing_component` VALUES (8, '冠', '首服', '头上戴的冠帽，体现身份等级。', '冠是头上戴的冠帽，是汉服首服的重要组成部分，体现身份等级。冠的种类繁多，包括冕冠、通天冠、进贤冠等，不同冠代表不同身份。冠的佩戴有严格的礼仪规范，不同场合佩戴不同的冠。冠的制作工艺精湛，常用金玉、珠宝等装饰，体现尊贵地位。冠与服饰的搭配讲究和谐，形成完整的礼仪装束。除冠外，首服还包括巾、帽等，适应不同场合和身份需求。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/guan1.webp', 8, '2026-03-14 21:44:34', '2026-03-14 21:44:34');

-- ----------------------------
-- Table structure for pattern_symbol
-- ----------------------------
DROP TABLE IF EXISTS `pattern_symbol`;
CREATE TABLE `pattern_symbol`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '图案ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图案名称',
  `meaning` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '象征意义',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图案图片URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '图案描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图案象征表-汉服常见图案及寓意' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pattern_symbol
-- ----------------------------
INSERT INTO `pattern_symbol` VALUES (1, '祥云', '吉祥如意', '/uploads/DM_20260301185757_001.png', '祥云纹是中国传统图案，象征吉祥如意，常用于宫廷和民间装饰。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (2, '龙', '权势尊贵', '/uploads/DM_20260301185757_002.png', '龙是中国古代神话中的神兽，象征权势、尊贵和祥瑞，是帝王的象征。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (3, '凤', '吉祥和谐', '/uploads/DM_20260301185757_003.png', '凤是中国古代神话中的神鸟，象征吉祥、和谐和高贵，是皇后的象征。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (4, '牡丹', '富贵荣华', '/uploads/DM_20260301185757_004.png', '牡丹是中国传统名花，象征富贵荣华和繁荣昌盛，被称为"花中之王"。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (5, '莲花', '纯洁高雅', '/uploads/DM_20260301185757_005.png', '莲花象征纯洁高雅和超凡脱俗，是佛教中的圣物。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (6, '菊花', '长寿安康', '/uploads/DM_20260301185757_006.png', '菊花象征长寿安康和高洁品格，是重阳节的象征花卉。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (7, '梅花', '坚韧不拔', '/uploads/DM_20260301185757_007.png', '梅花象征坚韧不拔和高洁品格，在严寒中绽放，象征顽强的生命力。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (8, '竹子', '正直虚心', '/uploads/DM_20260301185757_008.png', '竹子象征正直虚心和高洁品格，四季常青，象征坚韧不拔。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (9, '兰草', '高雅脱俗', '/uploads/DM_20260301185757_009.png', '兰草象征高雅脱俗和君子品格，是"四君子"之一。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (10, '麒麟', '祥瑞太平', '/uploads/DM_20260301185757_010.png', '麒麟是中国古代神话中的瑞兽，象征祥瑞太平和吉祥如意。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (11, '仙鹤', '长寿吉祥', '/uploads/DM_20260301185757_011.png', '仙鹤象征长寿吉祥和高洁品格，是道教中的灵禽。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (12, '蝙蝠', '福气临门', '/uploads/DM_20260301185757_012.png', '蝙蝠因与"福"谐音，象征福气临门和吉祥如意。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (13, '鱼纹', '年年有余', '/uploads/DM_20260301185757_013.png', '鱼因与"余"谐音，象征年年有余和富足吉祥。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (14, '回纹', '富贵不断', '/uploads/DM_20260301185758_014.png', '回纹象征富贵不断和吉祥如意，是中国传统纹样之一。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');
INSERT INTO `pattern_symbol` VALUES (15, '云雷纹', '威严神秘', '/uploads/DM_20260301185758_014.png', '云雷纹象征威严神秘和神圣不可侵犯，常用于青铜器装饰。', '2026-03-01 19:22:16', '2026-03-01 19:22:21');

-- ----------------------------
-- Table structure for etiquette
-- ----------------------------
DROP TABLE IF EXISTS `etiquette`;
CREATE TABLE `etiquette`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '礼仪ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '礼仪名称',
  `period` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属朝代',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '礼仪类别(worship/standing)',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '示意图URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '礼仪描述',
  `features` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '礼仪特点(|分隔)',
  `steps` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '行礼步骤(|分隔)',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '注意事项',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '古代礼容仪态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of etiquette
-- ----------------------------
INSERT INTO `etiquette` VALUES (1, '肃拜礼', '秦汉时期', 'worship', '/uploads/DM_20260301183058_002.png', '秦汉时期的重要礼仪，用于正式场合的拜见，体现尊卑有序的礼制思想。行礼时身体微躬，双手合抱，神情庄重，动作缓慢而有力。', '体现尊卑有序的礼制思想|动作庄重缓慢|适用于正式场合|体现对长者和尊者的尊敬', '站立端正，双脚并拢|双手缓缓合抱于胸前|身体微躬，头略低|保持姿势片刻后缓缓起身', '行礼时要保持神情庄重，动作不宜过快，体现对对方的尊重。', '2026-03-01 19:22:16', '2026-03-01 19:33:54');
INSERT INTO `etiquette` VALUES (2, '颜首礼', '魏晋时期', 'worship', '/uploads/DM_20260301183058_003.png', '魏晋名士风度的体现，行礼时注重仪态的自然与优雅。体现了当时文人雅士追求个性解放和自然之美的思想。', '体现名士风度|动作自然优雅|注重个人气质|融合道家思想', '自然站立，神情从容|头部微倾，目光温和|右手轻抚左胸|微笑示意，动作流畅', '行礼时要保持自然从容，避免刻意做作，体现文人雅士的风范。', '2026-03-01 19:22:16', '2026-03-01 19:33:54');
INSERT INTO `etiquette` VALUES (3, '叉手礼', '唐代', 'standing', '/uploads/DM_20260301183058_004.png', '唐代流行的日常礼节，双手交叉于胸前，体现唐代的开放与包容。是当时社会各阶层通用的见面礼节。', '日常通用礼节|体现开放包容|动作简洁大方|适用于各种场合', '双手自然下垂|右手在上，左手在下交叉|双手置于胸前|微微点头示意', '此礼适用于平辈之间的日常问候，动作要自然流畅。', '2026-03-01 19:22:16', '2026-03-01 19:33:54');
INSERT INTO `etiquette` VALUES (4, '万福礼', '宋代', 'standing', '/uploads/DM_20260301183058_005.png', '宋代女性常用礼仪，双手合抱于腰侧，微屈膝，体现女性的柔美。是古代女性见面的标准礼节。', '女性专用礼节|体现柔美气质|动作优雅含蓄|表达美好祝愿', '双手合抱于腰侧右侧|右腿稍向后撤|双膝微屈|口称"万福"', '行礼时要保持姿态优雅，动作轻柔，体现女性特有的温柔气质。', '2026-03-01 19:22:16', '2026-03-01 19:33:54');
INSERT INTO `etiquette` VALUES (5, '揖礼', '明代', 'standing', '/uploads/DM_20260301183058_006.png', '明代通用的见面礼节，双手合抱鞠躬，体现明代礼仪的规范化。是当时社会交往中的基本礼节。', '通用见面礼节|体现礼仪规范化|动作简洁明了|表达相互尊重', '双手合抱于胸前|身体前倾鞠躬|保持姿势片刻|缓缓直身', '行礼时动作要规范，体现明代礼仪的庄重。', '2026-03-01 19:22:16', '2026-03-01 19:33:54');
INSERT INTO `etiquette` VALUES (6, '请安礼', '清代', 'standing', '/uploads/DM_20260301183058_007.png', '清代流行的问候礼节，体现清代礼仪的等级制度。是清代社会各阶层通用的问候方式。', '清代通用问候礼节|体现等级制度|动作规范严格|表达敬意', '按照身份等级行礼|双手合抱或垂手|身体微躬|口称问候语', '行礼时要根据身份等级选择适当的礼节。', '2026-03-01 19:22:16', '2026-03-01 19:33:54');
INSERT INTO `etiquette` VALUES (7, '稽首礼', '周代', 'worship', '/uploads/DM_20260301183058_008.png', '古代最隆重的跪拜礼，用于祭祀天地和拜见君王。是九拜中最重的礼节，表达极度的尊敬。', '最隆重的礼节|用于祭祀和朝见|表达极度尊敬|动作庄重规范', '跪地，双手伏地|头触地停留片刻|缓缓抬头|再拜一次', '此礼极为庄重，只在重要场合使用，动作要规范严谨。', '2026-03-01 19:22:16', '2026-03-01 19:33:54');
INSERT INTO `etiquette` VALUES (8, '顿首礼', '汉代', 'worship', '/uploads/DM_20260301183058_009.png', '磕头礼，用于请罪或表达极度尊敬之情。动作较为急促，表达强烈的情感。', '表达强烈情感|用于请罪或极度尊敬|动作较为急促|头触地即起', '快速跪地|头触地即起|可连续多次|神情恳切', '此礼表达的情感较为强烈，要配合适当的神情和语气。', '2026-03-01 19:22:16', '2026-03-01 19:33:54');
INSERT INTO `etiquette` VALUES (9, '空首礼', '唐代', 'worship', '/uploads/DM_20260301183058_009.png', '跪拜礼的一种，头不至地，用于地位相当者之间的礼节。比稽首礼稍轻，表达平等的尊重。', '地位相当者使用|头不至地|表达平等尊重|动作较为轻松', '跪地，双手拱合|头向前倾但不触地|保持姿势片刻|缓缓直身', '行礼时要注意头不能触地，体现平等的尊重关系。', '2026-03-01 19:22:16', '2026-03-01 19:33:54');

-- ----------------------------
-- Table structure for festival
-- ----------------------------
DROP TABLE IF EXISTS `festival`;
CREATE TABLE `festival`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '节日ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '节日名称',
  `date` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '节日日期',
  `season` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属季节(spring/summer/autumn/winter)',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '节日图片URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '节日描述',
  `customs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '节日习俗(|分隔)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '古代节俗礼仪表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of festival
-- ----------------------------
INSERT INTO `festival` VALUES (1, '成人礼', '农历三月三', 'spring', '/uploads/DM_20260301184327_001.png', '古代重要的成年仪式，男子二十岁行冠礼，女子十五岁行笄礼，标志正式成年，承担社会责任。', '加冠:男子二十岁时举行冠礼，加冠三次，象征成年，获得社会认可|及笄:女子十五岁时举行笄礼，将头发盘起，标志成年，可以婚嫁|取字:成年后取字，用于社交场合，体现文化修养', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival` VALUES (2, '上元节', '农历正月十五', 'spring', '/uploads/DM_20260301184327_002.png', '新年第一个月圆之夜，赏灯猜谜，祈求新的一年平安顺利。', '赏花灯:各地举办灯会，展示各种精美的花灯造型|猜灯谜:将谜语写在灯笼上，供人猜射，增添节日趣味|吃元宵:食用糯米制成的圆形食品，象征团圆美满', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival` VALUES (3, '乞巧节', '农历七月初七', 'summer', '/uploads/DM_20260301184327_003.png', '中国的情人节，源于牛郎织女的传说，女子乞巧祈福。', '乞巧:女子向织女星祈求智巧，提高女红技艺|观星:夜晚仰望星空，寻找牛郎织女星|祈福:祈求美好姻缘和幸福生活', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival` VALUES (4, '清明节', '公历四月四-六日', 'spring', '/uploads/DM_20260301184327_004.png', '祭祖扫墓，缅怀先人，同时也是踏青郊游的好时节。', '扫墓祭祖:清理祖先墓地，献上祭品，表达对先人的怀念|踏青郊游:春光明媚时节，外出游玩，感受大自然|放风筝:放飞风筝，寓意放走晦气，迎接好运', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival` VALUES (5, '端午节', '农历五月初五', 'summer', '/uploads/DM_20260301184327_005.png', '纪念屈原的节日，有赛龙舟、吃粽子的习俗，驱邪避疫。', '赛龙舟:多人划桨竞赛，纪念屈原投江，体现团结协作精神|吃粽子:用糯米包裹各种馅料，纪念屈原，也是时令美食|挂艾草:悬挂艾草和菖蒲，驱除蚊虫，净化空气', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival` VALUES (6, '中秋节', '农历八月十五', 'autumn', '/uploads/DM_20260301184327_006.png', '月圆人团圆，赏月吃月饼，寄托思念之情。', '赏月:家人团聚，欣赏圆月，寄托思念之情|吃月饼:食用圆形月饼，象征团圆美满|祭月:设香案祭拜月神，祈求平安吉祥', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival` VALUES (7, '重阳节', '农历九月初九', 'autumn', '/uploads/DM_20260301184327_007.png', '敬老爱老的节日，登高赏菊，祈求健康长寿。', '登高:登山远眺，锻炼身体，祈求避灾|赏菊:欣赏菊花，饮酒赋诗，陶冶情操|敬老:慰问老人，表达对长者的尊敬和关爱', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival` VALUES (8, '冬至节', '公历十二月二十一-二十三日', 'winter', '/uploads/DM_20260301184327_008.png', '一年中白昼最短的一天，北方吃饺子，南方吃汤圆。', '吃饺子:北方习俗，吃饺子寓意不冻耳朵|吃汤圆:南方习俗，吃汤圆象征团圆|祭祖:祭祀祖先，表达对先人的怀念', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival` VALUES (9, '腊八节', '农历腊月初八', 'winter', '/uploads/DM_20260301184327_009.png', '佛教节日，喝腊八粥，祈求平安吉祥。', '喝腊八粥:用多种食材熬制粥品，祈求五谷丰登|祭祀:祭祀祖先和神灵，祈求来年平安|施粥:向穷人施粥，体现慈悲心肠', '2026-03-01 19:22:16', '2026-03-01 19:34:46');

-- ----------------------------
-- Table structure for festival_activity
-- ----------------------------
DROP TABLE IF EXISTS `festival_activity`;
CREATE TABLE `festival_activity`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '活动标题',
  `season` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属季节(spring/summer/autumn/winter)',
  `date` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '活动日期',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '活动地点',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '活动图片URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '活动描述',
  `tradition_experience` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '传统习俗体验',
  `precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '注意事项',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '节庆雅集活动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of festival_activity
-- ----------------------------
INSERT INTO `festival_activity` VALUES (1, '上元节灯会', 'spring', '2026年2月12日', '北京故宫', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/festival1.webp', '上元节，又称元宵节，是新年第一个月圆之夜。本次活动将在故宫举办盛大的灯会，展示各种精美的花灯造型，参与者可以猜灯谜、吃元宵，感受传统节日的魅力。', '猜灯谜：活动现场设置各类灯谜，参与者可凭智慧赢取精美奖品。\n赏花灯：欣赏各种传统花灯造型，包括宫灯、走马灯、荷花灯等。\n吃元宵：品尝各种口味的传统元宵，体验团圆美满的寓意。\n穿汉服：鼓励参与者身着汉服参加，感受古代上元节的氛围。', '请提前在官方平台预约门票，活动期间人流量较大。\n建议穿着舒适的鞋子，活动场地较大需要步行。\n夜间气温较低，请注意保暖。\n请遵守现场秩序，文明观灯。', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival_activity` VALUES (2, '清明踏青雅集', 'spring', '2026年4月4日', '杭州西湖', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/festival2.webp', '清明时节，春光明媚。本次活动将在西湖边举行踏青雅集，参与者可以身着汉服，漫步苏堤春晓，放风筝，品尝清明团子，感受春日的美好。', '踏青赏花：漫步西湖苏堤，欣赏春日美景，感受万物复苏的气息。\n放风筝：在指定区域放飞传统风筝，体验清明时节放风筝的习俗。\n品尝青团：品尝清明传统美食青团，了解其制作工艺和文化寓意。\n插柳戴柳：学习清明插柳戴柳的传统习俗，祈求平安健康。', '请穿着适合户外活动的服装和鞋子。\n春季天气多变，建议携带雨具和外套。\n注意防晒，建议携带遮阳帽和防晒霜。\n请爱护环境，不乱扔垃圾。', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival_activity` VALUES (3, '端午龙舟竞渡', 'summer', '2026年6月19日', '苏州金鸡湖', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/festival3.webp', '端午节是纪念屈原的传统节日。本次活动将在金鸡湖举办龙舟竞渡，参与者可以体验划龙舟的乐趣，品尝各种口味的粽子，学习包粽子的技艺。', '龙舟竞渡：观看或参与龙舟比赛，体验团队协作的乐趣。\n包粽子：学习传统包粽子技艺，了解不同地区粽子的特色。\n佩香囊：制作和佩戴端午香囊，驱邪避瘟，祈求健康。\n挂艾草：学习端午挂艾草、菖蒲的传统习俗。', '夏季户外活动请注意防暑降温，及时补充水分。\n参与水上活动请听从工作人员安排，注意安全。\n建议穿着轻便透气的服装和防滑鞋。\n请做好防晒措施，携带遮阳帽和防晒霜。', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival_activity` VALUES (4, '七夕乞巧大会', 'summer', '2026年8月19日', '西安大唐芙蓉园', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/festival4.webp', '七夕节是中国的情人节，源于牛郎织女的美丽传说。本次活动将在大唐芙蓉园举办乞巧大会，参与者可以学习传统女红技艺，祈求美好姻缘。', '穿针乞巧：体验传统乞巧习俗，比赛穿针引线，祈求心灵手巧。\n女红体验：学习刺绣、编织等传统女红技艺。\n拜织女：了解七夕拜织女的传统仪式和文化内涵。\n放河灯：在芙蓉园水域放河灯，祈求美好姻缘。', '活动场地为户外，夏季请注意防暑降温。\n建议穿着汉服或传统服饰参加活动，增强氛围感。\n夜间活动请注意安全，听从工作人员指引。\n请爱护园区设施和环境。', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival_activity` VALUES (5, '中秋赏月诗会', 'autumn', '2026年9月24日', '南京夫子庙', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/festival5.webp', '中秋节是月圆人团圆的美好时刻。本次活动将在夫子庙举办赏月诗会，参与者可以品尝各种口味的月饼，吟诗作对，欣赏秦淮河的月色。', '赏月吟诗：在秦淮河畔赏月，参与诗词接龙和即兴创作。\n品尝月饼：品尝苏式、广式等各种风味的传统月饼。\n拜月仪式：了解和学习传统中秋拜月仪式。\n放天灯：在指定区域放飞孔明灯，许下美好心愿。', '秋季夜晚气温较低，请注意保暖，建议携带外套。\n活动涉及水域，请注意安全，不要靠近水边。\n请遵守现场秩序，文明参与活动。\n建议提前到达，选择最佳赏月位置。', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival_activity` VALUES (6, '重阳登高敬老', 'autumn', '2026年10月11日', '泰山', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/festival6.webp', '重阳节是敬老爱老的传统节日。本次活动将组织登泰山活动，参与者可以欣赏秋日的壮丽景色，品尝菊花酒，表达对长者的尊敬和关爱。', '登高望远：登泰山赏秋景，体验重阳登高的传统习俗。\n敬老活动：参与敬老爱老活动，向长者表达敬意和祝福。\n赏菊品酒：品尝菊花酒，欣赏各种菊花品种。\n佩茱萸：佩戴茱萸囊，了解其驱邪避灾的寓意。', '登山活动请根据自身身体状况量力而行。\n请穿着舒适的运动鞋和适合登山的服装。\n秋季山顶气温较低，请携带保暖衣物。\n请携带足够的饮用水和简单食物。', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival_activity` VALUES (7, '冬至饺子宴', 'winter', '2026年12月21日', '北京四合院', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/festival7.webp', '冬至是一年中白昼最短的一天。本次活动将在传统四合院举办饺子宴，参与者可以学习包饺子的技艺，了解冬至的传统习俗，感受冬日的温暖。', '包饺子：学习传统包饺子技艺，了解不同馅料的寓意。\n吃饺子：品尝各种口味的饺子，体验冬至吃饺子的传统。\n数九消寒：了解冬至数九习俗，制作九九消寒图。\n祭祖祈福：了解冬至祭祖的传统习俗和文化内涵。', '冬季户外活动请注意保暖，穿着厚实的冬装。\n四合院室内外温差较大，请注意增减衣物。\n如有食物过敏请提前告知工作人员。\n请遵守活动秩序，文明参与。', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival_activity` VALUES (8, '腊八施粥祈福', 'winter', '2027年1月17日', '杭州灵隐寺', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/festival8.webp', '腊八节是佛教重要节日。本次活动将在灵隐寺举办施粥祈福活动，参与者可以品尝用多种食材熬制的腊八粥，祈求来年平安吉祥。', '品尝腊八粥：品尝用多种食材熬制的传统腊八粥。\n祈福许愿：在寺庙内祈福许愿，祈求来年平安吉祥。\n了解佛文化：参观寺庙，了解腊八节的佛教文化内涵。\n布施结缘：参与施粥活动，体验布施的功德。', '进入寺庙请保持安静，尊重佛教礼仪。\n冬季山区气温较低，请注意保暖。\n请穿着端庄得体的服装，不宜过于暴露。\n请遵守寺庙规定，不随意拍照。', '2026-03-01 19:22:16', '2026-03-01 19:34:46');
INSERT INTO `festival_activity` VALUES (9, '成人礼仪式', 'spring', '2026年3月21日', '曲阜孔庙', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/festival9.webp', '成人礼是古代重要的成年仪式。本次活动将在孔庙举办传统成人礼，男子行冠礼，女子行笄礼，标志正式成年，承担社会责任，传承中华礼仪文化。', '冠礼仪式：男子行冠礼，三加冠服，象征成年。\n笄礼仪式：女子行笄礼，加笄换装，标志成年。\n聆训受教：聆听长辈训诫，接受成人责任。\n宣誓立志：宣读成人誓词，立志承担社会责任。', '请穿着正式汉服参加仪式，建议提前准备。\n仪式庄重，请保持肃静，手机调至静音。\n请提前到达，熟悉仪式流程和站位。\n家长可陪同观礼，但请遵守现场秩序。', '2026-03-01 19:22:16', '2026-03-01 19:34:46');

-- ----------------------------
-- Table structure for festival_activity_comment
-- ----------------------------
DROP TABLE IF EXISTS `festival_activity_comment`;
CREATE TABLE `festival_activity_comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `activity_id` bigint NOT NULL COMMENT '活动ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `activity_id`(`activity_id` ASC) USING BTREE,
  CONSTRAINT `festival_activity_comment_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `festival_activity` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '节庆活动评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of festival_activity_comment
-- ----------------------------
-- 节庆活动1(上元节灯会)的17条评论 - 活动已结束
INSERT INTO `festival_activity_comment` VALUES (1, 1, 'lay', '故宫的灯会太美了！各种花灯造型精美绝伦，猜灯谜也很有趣。', '2026-02-12 21:30:00');
INSERT INTO `festival_activity_comment` VALUES (2, 1, 'Echo', '第一次穿汉服参加灯会，氛围感满满，明年一定还要来！', '2026-02-12 22:00:00');
INSERT INTO `festival_activity_comment` VALUES (3, 1, '挽墨', '元宵特别甜，和同袍们一起赏灯的感觉真好。', '2026-02-13 10:00:00');
INSERT INTO `festival_activity_comment` VALUES (4, 1, '星河滚烫', '故宫夜景配上汉服和花灯，像穿越回古代一样。', '2026-02-13 11:30:00');
INSERT INTO `festival_activity_comment` VALUES (5, 1, '清风徐来', '灯谜很有意思，还赢了不少小礼品，开心！', '2026-02-13 14:00:00');
INSERT INTO `festival_activity_comment` VALUES (6, 1, '北岛信物', '人有点多，但氛围真的很好，传统文化活动要多举办。', '2026-02-13 16:00:00');
INSERT INTO `festival_activity_comment` VALUES (7, 1, '橘子汽水', '拍了很多照片，每一张都是大片，太喜欢了！', '2026-02-14 09:00:00');
INSERT INTO `festival_activity_comment` VALUES (8, 1, '半糖主义', '汉服配花灯真的绝美，下次要带朋友一起来。', '2026-02-14 11:00:00');
INSERT INTO `festival_activity_comment` VALUES (9, 1, '月亮邮递员', '传统节日就该这样过，有仪式感又有文化内涵。', '2026-02-14 15:00:00');
INSERT INTO `festival_activity_comment` VALUES (10, 1, 'Wanderer', '故宫的夜景真的太震撼了，花灯设计得很用心。', '2026-02-14 17:00:00');
INSERT INTO `festival_activity_comment` VALUES (11, 1, 'Nostalgia', '猜灯谜环节特别有趣，学到了很多传统文化知识。', '2026-02-15 09:30:00');
INSERT INTO `festival_activity_comment` VALUES (12, 1, 'Paradox', '穿着汉服在故宫赏灯，感觉像穿越了一样。', '2026-02-15 11:00:00');
INSERT INTO `festival_activity_comment` VALUES (13, 1, 'Serendipity', '元宵节的活动办得真好，期待明年的灯会！', '2026-02-15 14:00:00');
INSERT INTO `festival_activity_comment` VALUES (14, 1, '寄风给你', '和同袍们一起过节的感觉太棒了，认识了很多新朋友。', '2026-02-15 16:30:00');
INSERT INTO `festival_activity_comment` VALUES (15, 1, '且听风吟', '花灯的造型太精致了，每个都想拍照留念。', '2026-02-16 10:00:00');
INSERT INTO `festival_activity_comment` VALUES (16, 1, '温柔半两', '传统节日的氛围感拉满，这才是过年的感觉。', '2026-02-16 14:00:00');
INSERT INTO `festival_activity_comment` VALUES (17, 1, '晚风吻尽', '明年元宵节一定还要来，太喜欢这种氛围了！', '2026-02-16 17:00:00');

-- 节庆活动9(成人礼仪式)的17条评论 - 活动已结束
INSERT INTO `festival_activity_comment` VALUES (18, 9, 'lay', '在孔庙参加成人礼太有仪式感了，终生难忘的经历！', '2026-03-21 17:00:00');
INSERT INTO `festival_activity_comment` VALUES (19, 9, 'Nostalgia', '冠礼和笄礼的仪式很庄重，感受到了成年的责任。', '2026-03-21 18:30:00');
INSERT INTO `festival_activity_comment` VALUES (20, 9, 'Paradox', '曲阜孔庙的氛围特别好，礼仪老师讲解得很细致。', '2026-03-22 09:00:00');
INSERT INTO `festival_activity_comment` VALUES (21, 9, 'Serendipity', '第一次参加传统成人礼，比西式成人礼有意义多了。', '2026-03-22 10:30:00');
INSERT INTO `festival_activity_comment` VALUES (22, 9, '寄风给你', '穿着汉服行成人礼，感觉真正长大了，要承担责任了。', '2026-03-22 14:00:00');
INSERT INTO `festival_activity_comment` VALUES (23, 9, '且听风吟', '仪式感满满，传统文化需要这样的传承方式。', '2026-03-22 16:00:00');
INSERT INTO `festival_activity_comment` VALUES (24, 9, '温柔半两', '父母在台下看着我行礼，那一刻真的很感动。', '2026-03-23 09:30:00');
INSERT INTO `festival_activity_comment` VALUES (25, 9, '晚风吻尽', '希望以后能有更多年轻人参与传统成人礼。', '2026-03-23 11:00:00');
INSERT INTO `festival_activity_comment` VALUES (26, 9, 'Echo', '孔庙的环境很庄严，让整个仪式更有意义。', '2026-03-23 14:00:00');
INSERT INTO `festival_activity_comment` VALUES (27, 9, '挽墨', '礼仪老师很专业，每个步骤都讲解得很清楚。', '2026-03-23 16:30:00');
INSERT INTO `festival_activity_comment` VALUES (28, 9, '星河滚烫', '成人礼让我真正理解了成长的意义。', '2026-03-24 09:00:00');
INSERT INTO `festival_activity_comment` VALUES (29, 9, '清风徐来', '传统礼仪文化需要传承，这样的活动很有价值。', '2026-03-24 11:00:00');
INSERT INTO `festival_activity_comment` VALUES (30, 9, '北岛信物', '穿着汉服行礼的感觉很特别，终生难忘。', '2026-03-24 14:00:00');
INSERT INTO `festival_activity_comment` VALUES (31, 9, '橘子汽水', '仪式后和同袍们合影留念，记录下这重要的时刻。', '2026-03-24 16:00:00');
INSERT INTO `festival_activity_comment` VALUES (32, 9, '半糖主义', '感谢主办方，让我有了一次难忘的成人礼体验。', '2026-03-25 09:30:00');
INSERT INTO `festival_activity_comment` VALUES (33, 9, '月亮邮递员', '传统文化活动办得越来越好，支持！', '2026-03-25 11:00:00');
INSERT INTO `festival_activity_comment` VALUES (34, 9, '落日飞车', '以后有类似活动一定还会参加。', '2026-03-25 14:00:00');

-- ----------------------------
-- Table structure for festival_activity_registration
-- ----------------------------
DROP TABLE IF EXISTS `festival_activity_registration`;
CREATE TABLE `festival_activity_registration`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '报名ID',
  `festival_activity_id` bigint NOT NULL COMMENT '节庆活动ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'registered' COMMENT '报名状态(registered/attended/cancelled)',
  `registration_time` datetime NOT NULL COMMENT '报名时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_festival_activity_user`(`festival_activity_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `festival_activity_registration_ibfk_1` FOREIGN KEY (`festival_activity_id`) REFERENCES `festival_activity` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `festival_activity_registration_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 184 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '节庆活动报名表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of festival_activity_registration
-- ----------------------------
-- 节庆活动1(上元节灯会)的21条报名记录，包含lay(id=2)
INSERT INTO `festival_activity_registration` VALUES (1, 1, 2, 'registered', '2026-02-01 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (2, 1, 4, 'registered', '2026-02-01 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (3, 1, 5, 'registered', '2026-02-01 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (4, 1, 6, 'registered', '2026-02-01 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (5, 1, 7, 'registered', '2026-02-01 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (6, 1, 8, 'registered', '2026-02-02 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (7, 1, 9, 'registered', '2026-02-02 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (8, 1, 10, 'registered', '2026-02-02 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (9, 1, 22, 'registered', '2026-02-02 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (10, 1, 23, 'registered', '2026-02-02 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (11, 1, 24, 'registered', '2026-02-03 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (12, 1, 25, 'registered', '2026-02-03 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (13, 1, 26, 'registered', '2026-02-03 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (14, 1, 27, 'registered', '2026-02-03 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (15, 1, 28, 'registered', '2026-02-03 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (16, 1, 29, 'registered', '2026-02-04 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (17, 1, 30, 'registered', '2026-02-04 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (18, 1, 31, 'registered', '2026-02-04 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (19, 1, 32, 'registered', '2026-02-04 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (20, 1, 33, 'registered', '2026-02-04 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (21, 1, 34, 'registered', '2026-02-05 09:00:00');

-- 节庆活动2(清明踏青雅集)的19条报名记录，包含lay(id=2)
INSERT INTO `festival_activity_registration` VALUES (22, 2, 2, 'registered', '2026-03-25 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (23, 2, 4, 'registered', '2026-03-25 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (24, 2, 5, 'registered', '2026-03-25 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (25, 2, 6, 'registered', '2026-03-25 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (26, 2, 7, 'registered', '2026-03-25 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (27, 2, 8, 'registered', '2026-03-26 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (28, 2, 9, 'registered', '2026-03-26 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (29, 2, 10, 'registered', '2026-03-26 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (30, 2, 22, 'registered', '2026-03-26 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (31, 2, 23, 'registered', '2026-03-26 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (32, 2, 24, 'registered', '2026-03-27 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (33, 2, 25, 'registered', '2026-03-27 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (34, 2, 26, 'registered', '2026-03-27 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (35, 2, 27, 'registered', '2026-03-27 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (36, 2, 28, 'registered', '2026-03-27 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (37, 2, 29, 'registered', '2026-03-28 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (38, 2, 30, 'registered', '2026-03-28 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (39, 2, 31, 'registered', '2026-03-28 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (40, 2, 32, 'registered', '2026-03-28 14:30:00');

-- 节庆活动3(端午龙舟竞渡)的24条报名记录，包含lay(id=2)
INSERT INTO `festival_activity_registration` VALUES (41, 3, 2, 'registered', '2026-06-01 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (42, 3, 4, 'registered', '2026-06-01 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (43, 3, 5, 'registered', '2026-06-01 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (44, 3, 6, 'registered', '2026-06-01 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (45, 3, 7, 'registered', '2026-06-01 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (46, 3, 8, 'registered', '2026-06-02 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (47, 3, 9, 'registered', '2026-06-02 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (48, 3, 10, 'registered', '2026-06-02 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (49, 3, 22, 'registered', '2026-06-02 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (50, 3, 23, 'registered', '2026-06-02 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (51, 3, 24, 'registered', '2026-06-03 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (52, 3, 25, 'registered', '2026-06-03 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (53, 3, 26, 'registered', '2026-06-03 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (54, 3, 27, 'registered', '2026-06-03 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (55, 3, 28, 'registered', '2026-06-03 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (56, 3, 29, 'registered', '2026-06-04 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (57, 3, 30, 'registered', '2026-06-04 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (58, 3, 31, 'registered', '2026-06-04 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (59, 3, 32, 'registered', '2026-06-04 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (60, 3, 33, 'registered', '2026-06-04 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (61, 3, 34, 'registered', '2026-06-05 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (62, 3, 35, 'registered', '2026-06-05 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (63, 3, 36, 'registered', '2026-06-05 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (64, 3, 37, 'registered', '2026-06-05 14:00:00');

-- 节庆活动4(七夕乞巧大会)的22条报名记录，包含lay(id=2)
INSERT INTO `festival_activity_registration` VALUES (65, 4, 2, 'registered', '2026-08-01 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (66, 4, 4, 'registered', '2026-08-01 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (67, 4, 5, 'registered', '2026-08-01 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (68, 4, 6, 'registered', '2026-08-01 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (69, 4, 7, 'registered', '2026-08-01 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (70, 4, 8, 'registered', '2026-08-02 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (71, 4, 9, 'registered', '2026-08-02 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (72, 4, 10, 'registered', '2026-08-02 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (73, 4, 22, 'registered', '2026-08-02 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (74, 4, 23, 'registered', '2026-08-02 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (75, 4, 24, 'registered', '2026-08-03 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (76, 4, 25, 'registered', '2026-08-03 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (77, 4, 26, 'registered', '2026-08-03 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (78, 4, 27, 'registered', '2026-08-03 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (79, 4, 28, 'registered', '2026-08-03 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (80, 4, 29, 'registered', '2026-08-04 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (81, 4, 30, 'registered', '2026-08-04 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (82, 4, 31, 'registered', '2026-08-04 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (83, 4, 32, 'registered', '2026-08-04 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (84, 4, 33, 'registered', '2026-08-04 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (85, 4, 34, 'registered', '2026-08-05 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (86, 4, 35, 'registered', '2026-08-05 10:30:00');

-- 节庆活动5(中秋赏月诗会)的20条报名记录
INSERT INTO `festival_activity_registration` VALUES (87, 5, 4, 'registered', '2026-09-10 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (88, 5, 5, 'registered', '2026-09-10 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (89, 5, 6, 'registered', '2026-09-10 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (90, 5, 7, 'registered', '2026-09-10 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (91, 5, 8, 'registered', '2026-09-10 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (92, 5, 9, 'registered', '2026-09-11 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (93, 5, 10, 'registered', '2026-09-11 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (94, 5, 22, 'registered', '2026-09-11 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (95, 5, 23, 'registered', '2026-09-11 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (96, 5, 24, 'registered', '2026-09-11 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (97, 5, 25, 'registered', '2026-09-12 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (98, 5, 26, 'registered', '2026-09-12 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (99, 5, 27, 'registered', '2026-09-12 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (100, 5, 28, 'registered', '2026-09-12 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (101, 5, 29, 'registered', '2026-09-12 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (102, 5, 30, 'registered', '2026-09-13 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (103, 5, 31, 'registered', '2026-09-13 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (104, 5, 32, 'registered', '2026-09-13 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (105, 5, 33, 'registered', '2026-09-13 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (106, 5, 34, 'registered', '2026-09-13 16:00:00');

-- 节庆活动6(重阳登高敬老)的18条报名记录，包含lay(id=2)
INSERT INTO `festival_activity_registration` VALUES (107, 6, 2, 'registered', '2026-10-01 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (108, 6, 4, 'registered', '2026-10-01 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (109, 6, 5, 'registered', '2026-10-01 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (110, 6, 6, 'registered', '2026-10-01 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (111, 6, 7, 'registered', '2026-10-01 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (112, 6, 8, 'registered', '2026-10-02 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (113, 6, 9, 'registered', '2026-10-02 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (114, 6, 10, 'registered', '2026-10-02 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (115, 6, 22, 'registered', '2026-10-02 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (116, 6, 23, 'registered', '2026-10-02 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (117, 6, 24, 'registered', '2026-10-03 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (118, 6, 25, 'registered', '2026-10-03 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (119, 6, 26, 'registered', '2026-10-03 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (120, 6, 27, 'registered', '2026-10-03 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (121, 6, 28, 'registered', '2026-10-03 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (122, 6, 29, 'registered', '2026-10-04 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (123, 6, 30, 'registered', '2026-10-04 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (124, 6, 31, 'registered', '2026-10-04 12:00:00');

-- 节庆活动7(冬至饺子宴)的17条报名记录
INSERT INTO `festival_activity_registration` VALUES (125, 7, 4, 'registered', '2026-12-10 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (126, 7, 5, 'registered', '2026-12-10 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (127, 7, 6, 'registered', '2026-12-10 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (128, 7, 7, 'registered', '2026-12-10 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (129, 7, 8, 'registered', '2026-12-10 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (130, 7, 9, 'registered', '2026-12-11 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (131, 7, 10, 'registered', '2026-12-11 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (132, 7, 22, 'registered', '2026-12-11 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (133, 7, 23, 'registered', '2026-12-11 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (134, 7, 24, 'registered', '2026-12-11 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (135, 7, 25, 'registered', '2026-12-12 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (136, 7, 26, 'registered', '2026-12-12 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (137, 7, 27, 'registered', '2026-12-12 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (138, 7, 28, 'registered', '2026-12-12 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (139, 7, 29, 'registered', '2026-12-12 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (140, 7, 30, 'registered', '2026-12-13 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (141, 7, 31, 'registered', '2026-12-13 10:45:00');

-- 节庆活动8(腊八施粥祈福)的19条报名记录，包含lay(id=2)
INSERT INTO `festival_activity_registration` VALUES (142, 8, 2, 'registered', '2027-01-05 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (143, 8, 4, 'registered', '2027-01-05 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (144, 8, 5, 'registered', '2027-01-05 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (145, 8, 6, 'registered', '2027-01-05 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (146, 8, 7, 'registered', '2027-01-05 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (147, 8, 8, 'registered', '2027-01-06 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (148, 8, 9, 'registered', '2027-01-06 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (149, 8, 10, 'registered', '2027-01-06 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (150, 8, 22, 'registered', '2027-01-06 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (151, 8, 23, 'registered', '2027-01-06 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (152, 8, 24, 'registered', '2027-01-07 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (153, 8, 25, 'registered', '2027-01-07 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (154, 8, 26, 'registered', '2027-01-07 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (155, 8, 27, 'registered', '2027-01-07 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (156, 8, 28, 'registered', '2027-01-07 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (157, 8, 29, 'registered', '2027-01-08 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (158, 8, 30, 'registered', '2027-01-08 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (159, 8, 31, 'registered', '2027-01-08 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (160, 8, 32, 'registered', '2027-01-08 14:30:00');

-- 节庆活动9(成人礼仪式)的23条报名记录，包含lay(id=2)
INSERT INTO `festival_activity_registration` VALUES (161, 9, 2, 'registered', '2026-03-10 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (162, 9, 4, 'registered', '2026-03-10 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (163, 9, 5, 'registered', '2026-03-10 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (164, 9, 6, 'registered', '2026-03-10 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (165, 9, 7, 'registered', '2026-03-10 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (166, 9, 8, 'registered', '2026-03-11 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (167, 9, 9, 'registered', '2026-03-11 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (168, 9, 10, 'registered', '2026-03-11 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (169, 9, 22, 'registered', '2026-03-11 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (170, 9, 23, 'registered', '2026-03-11 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (171, 9, 24, 'registered', '2026-03-12 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (172, 9, 25, 'registered', '2026-03-12 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (173, 9, 26, 'registered', '2026-03-12 11:45:00');
INSERT INTO `festival_activity_registration` VALUES (174, 9, 27, 'registered', '2026-03-12 14:00:00');
INSERT INTO `festival_activity_registration` VALUES (175, 9, 28, 'registered', '2026-03-12 15:30:00');
INSERT INTO `festival_activity_registration` VALUES (176, 9, 29, 'registered', '2026-03-13 09:15:00');
INSERT INTO `festival_activity_registration` VALUES (177, 9, 30, 'registered', '2026-03-13 10:45:00');
INSERT INTO `festival_activity_registration` VALUES (178, 9, 31, 'registered', '2026-03-13 12:00:00');
INSERT INTO `festival_activity_registration` VALUES (179, 9, 32, 'registered', '2026-03-13 14:30:00');
INSERT INTO `festival_activity_registration` VALUES (180, 9, 33, 'registered', '2026-03-13 16:00:00');
INSERT INTO `festival_activity_registration` VALUES (181, 9, 34, 'registered', '2026-03-14 09:00:00');
INSERT INTO `festival_activity_registration` VALUES (182, 9, 35, 'registered', '2026-03-14 10:30:00');
INSERT INTO `festival_activity_registration` VALUES (183, 9, 36, 'registered', '2026-03-14 11:45:00');

-- ----------------------------
-- Table structure for exhibition
-- ----------------------------
DROP TABLE IF EXISTS `exhibition`;
CREATE TABLE `exhibition`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '展览ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '展览标题',
  `organizer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '组织者',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '展览描述',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '展览地点',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NOT NULL COMMENT '结束日期',
  `opening_hours` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '开放时间',
  `ticket_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票价',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '展览图片URL',
  `notice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '参观须知',
  `highlights` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '展览亮点',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT '展览表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exhibition
-- ----------------------------
INSERT INTO `exhibition` VALUES (1, '千年汉服文化展', '中国汉服协会', '展示从先秦到明清的汉服实物和复制品，呈现汉服的历史演变和文化内涵。', '北京国家博物馆', '2026-03-15', '2026-04-15', '09:00-17:00 (周一闭馆)', 50.00, 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/exhibition1.webp', '1. 请提前预约参观时间\n2. 保持安静，勿触摸展品\n3. 禁止使用闪光灯拍照\n4. 遵守展馆各项规定', '汇集了从先秦到明清的珍贵汉服实物，包括宫廷御用服饰和民间日常服装，展现汉服的完整历史演变脉络', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `exhibition` VALUES (2, '唐代服饰艺术展', '陕西历史博物馆', '展示唐代各阶层的服饰文物和复原品，重现盛唐服饰的华丽与开放。', '西安陕西历史博物馆', '2026-03-20', '2026-05-20', '09:00-17:30 (周一闭馆)', 40.00, 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/exhibition2.webp', '1. 请提前预约参观时间\n2. 保持安静，勿触摸展品\n3. 禁止使用闪光灯拍照\n4. 遵守展馆各项规定', '展出唐代丝绸珍品和壁画中的服饰形象，重现盛唐时期的开放与繁荣，特别展示了武则天时期的宫廷服饰', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `exhibition` VALUES (3, '明代汉服精品展', '南京博物院', '展出明代宫廷和民间的汉服精品，展示明代服饰的精致与典雅。', '南京博物院', '2026-04-01', '2026-06-01', '09:00-17:00 (周一闭馆)', 45.00, 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/exhibition3.webp', '1. 请提前预约参观时间\n2. 保持安静，勿触摸展品\n3. 禁止使用闪光灯拍照\n4. 遵守展馆各项规定', '展示明代刺绣工艺的巅峰之作，包括皇室御用龙袍和民间刺绣精品，展现明代服饰的精致工艺', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `exhibition` VALUES (4, '汉服纹样艺术展', '中国丝绸博物馆', '展示汉服上的各种传统纹样，分析其文化象征意义和艺术价值。', '杭州中国丝绸博物馆', '2026-04-10', '2026-07-10', '09:00-17:00 (周一闭馆)', 35.00, 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/exhibition4.webp', '1. 请提前预约参观时间\n2. 保持安静，勿触摸展品\n3. 禁止使用闪光灯拍照\n4. 遵守展馆各项规定', '深入解析汉服纹样的文化寓意，包括龙纹、云纹、花卉纹等传统图案的演变和象征意义', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `exhibition` VALUES (5, '现代汉服设计展', '上海时尚博物馆', '展示当代设计师的汉服创新作品，探索传统与现代的融合。', '上海时尚博物馆', '2026-04-15', '2026-06-15', '10:00-18:00 (周二闭馆)', 55.00, 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/exhibition5.webp', '1. 请提前预约参观时间\n2. 保持安静，勿触摸展品\n3. 禁止使用闪光灯拍照\n4. 遵守展馆各项规定', '汇聚当代设计师的创新汉服作品，融合现代面料和工艺，展现汉服在当代的时尚表达', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `exhibition` VALUES (6, '汉服与生活展', '苏州博物馆', '展示汉服在传统生活中的应用场景，重现古代生活的服饰细节。', '苏州博物馆', '2026-04-20', '2026-06-20', '09:00-17:00 (周一闭馆)', 30.00, 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/exhibition6.webp', '1. 请提前预约参观时间\n2. 保持安静，勿触摸展品\n3. 禁止使用闪光灯拍照\n4. 遵守展馆各项规定', '通过场景复原展示汉服在传统生活中的实际应用，包括婚礼、节日、日常等不同场景的服饰搭配', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `exhibition` VALUES (7, '少数民族与汉服展', '云南民族博物馆', '展示各少数民族的传统服饰与汉服的交流融合，体现多元文化的魅力。', '昆明云南民族博物馆', '2026-05-01', '2026-07-01', '09:00-17:00 (周一闭馆)', 40.00, 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/exhibition7.webp', '1. 请提前预约参观时间\n2. 保持安静，勿触摸展品\n3. 禁止使用闪光灯拍照\n4. 遵守展馆各项规定', '展示各少数民族服饰与汉服的交流融合，呈现多元文化背景下的服饰创新与演变', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `exhibition` VALUES (8, '汉服国际交流展', '广州文化中心', '展示各国汉服爱好者的作品和收藏，促进国际文化交流。', '广州文化中心', '2026-05-10', '2026-07-10', '10:00-18:00 (周二闭馆)', 60.00, 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/exhibition8.webp', '1. 请提前预约参观时间\n2. 保持安静，勿触摸展品\n3. 禁止使用闪光灯拍照\n4. 遵守展馆各项规定', '汇集来自全球各地汉服爱好者的作品和收藏，展现汉服在国际视野中的传播与发展', '2026-03-14 10:00:00', '2026-03-14 10:00:00');

-- ----------------------------
-- Table structure for exhibition_registration
-- ----------------------------
DROP TABLE IF EXISTS `exhibition_registration`;
CREATE TABLE `exhibition_registration`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '报名ID',
  `exhibition_id` bigint NOT NULL COMMENT '展览ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'registered' COMMENT '报名状态(registered/attended/cancelled)',
  `registration_time` datetime NOT NULL COMMENT '报名时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_exhibition_user`(`exhibition_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `exhibition_registration_ibfk_1` FOREIGN KEY (`exhibition_id`) REFERENCES `exhibition` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `exhibition_registration_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 166 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '展览报名表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exhibition_registration
-- ----------------------------
-- 展览1(千年汉服文化展)的20条报名记录，包含lay(id=2)
INSERT INTO `exhibition_registration` VALUES (1, 1, 2, 'registered', '2026-03-10 09:00:00');
INSERT INTO `exhibition_registration` VALUES (2, 1, 4, 'registered', '2026-03-10 10:30:00');
INSERT INTO `exhibition_registration` VALUES (3, 1, 5, 'registered', '2026-03-10 11:45:00');
INSERT INTO `exhibition_registration` VALUES (4, 1, 6, 'registered', '2026-03-10 14:00:00');
INSERT INTO `exhibition_registration` VALUES (5, 1, 7, 'registered', '2026-03-10 15:30:00');
INSERT INTO `exhibition_registration` VALUES (6, 1, 8, 'registered', '2026-03-11 09:15:00');
INSERT INTO `exhibition_registration` VALUES (7, 1, 9, 'registered', '2026-03-11 10:45:00');
INSERT INTO `exhibition_registration` VALUES (8, 1, 10, 'registered', '2026-03-11 12:00:00');
INSERT INTO `exhibition_registration` VALUES (9, 1, 22, 'registered', '2026-03-11 14:30:00');
INSERT INTO `exhibition_registration` VALUES (10, 1, 23, 'registered', '2026-03-11 16:00:00');
INSERT INTO `exhibition_registration` VALUES (11, 1, 24, 'registered', '2026-03-12 09:00:00');
INSERT INTO `exhibition_registration` VALUES (12, 1, 25, 'registered', '2026-03-12 10:30:00');
INSERT INTO `exhibition_registration` VALUES (13, 1, 26, 'registered', '2026-03-12 11:45:00');
INSERT INTO `exhibition_registration` VALUES (14, 1, 27, 'registered', '2026-03-12 14:00:00');
INSERT INTO `exhibition_registration` VALUES (15, 1, 28, 'registered', '2026-03-12 15:30:00');
INSERT INTO `exhibition_registration` VALUES (16, 1, 29, 'registered', '2026-03-13 09:15:00');
INSERT INTO `exhibition_registration` VALUES (17, 1, 30, 'registered', '2026-03-13 10:45:00');
INSERT INTO `exhibition_registration` VALUES (18, 1, 31, 'registered', '2026-03-13 12:00:00');
INSERT INTO `exhibition_registration` VALUES (19, 1, 32, 'registered', '2026-03-13 14:30:00');
INSERT INTO `exhibition_registration` VALUES (20, 1, 33, 'registered', '2026-03-13 16:00:00');

-- 展览2(唐代服饰艺术展)的22条报名记录，包含lay(id=2)
INSERT INTO `exhibition_registration` VALUES (21, 2, 2, 'registered', '2026-03-15 09:00:00');
INSERT INTO `exhibition_registration` VALUES (22, 2, 4, 'registered', '2026-03-15 10:30:00');
INSERT INTO `exhibition_registration` VALUES (23, 2, 5, 'registered', '2026-03-15 11:45:00');
INSERT INTO `exhibition_registration` VALUES (24, 2, 6, 'registered', '2026-03-15 14:00:00');
INSERT INTO `exhibition_registration` VALUES (25, 2, 7, 'registered', '2026-03-15 15:30:00');
INSERT INTO `exhibition_registration` VALUES (26, 2, 8, 'registered', '2026-03-16 09:15:00');
INSERT INTO `exhibition_registration` VALUES (27, 2, 9, 'registered', '2026-03-16 10:45:00');
INSERT INTO `exhibition_registration` VALUES (28, 2, 10, 'registered', '2026-03-16 12:00:00');
INSERT INTO `exhibition_registration` VALUES (29, 2, 22, 'registered', '2026-03-16 14:30:00');
INSERT INTO `exhibition_registration` VALUES (30, 2, 23, 'registered', '2026-03-16 16:00:00');
INSERT INTO `exhibition_registration` VALUES (31, 2, 24, 'registered', '2026-03-17 09:00:00');
INSERT INTO `exhibition_registration` VALUES (32, 2, 25, 'registered', '2026-03-17 10:30:00');
INSERT INTO `exhibition_registration` VALUES (33, 2, 26, 'registered', '2026-03-17 11:45:00');
INSERT INTO `exhibition_registration` VALUES (34, 2, 27, 'registered', '2026-03-17 14:00:00');
INSERT INTO `exhibition_registration` VALUES (35, 2, 28, 'registered', '2026-03-17 15:30:00');
INSERT INTO `exhibition_registration` VALUES (36, 2, 29, 'registered', '2026-03-18 09:15:00');
INSERT INTO `exhibition_registration` VALUES (37, 2, 30, 'registered', '2026-03-18 10:45:00');
INSERT INTO `exhibition_registration` VALUES (38, 2, 31, 'registered', '2026-03-18 12:00:00');
INSERT INTO `exhibition_registration` VALUES (39, 2, 32, 'registered', '2026-03-18 14:30:00');
INSERT INTO `exhibition_registration` VALUES (40, 2, 33, 'registered', '2026-03-18 16:00:00');
INSERT INTO `exhibition_registration` VALUES (41, 2, 34, 'registered', '2026-03-19 09:00:00');
INSERT INTO `exhibition_registration` VALUES (42, 2, 35, 'registered', '2026-03-19 10:30:00');

-- 展览3(明代汉服精品展)的18条报名记录，包含lay(id=2)
INSERT INTO `exhibition_registration` VALUES (43, 3, 2, 'registered', '2026-03-25 09:00:00');
INSERT INTO `exhibition_registration` VALUES (44, 3, 4, 'registered', '2026-03-25 10:30:00');
INSERT INTO `exhibition_registration` VALUES (45, 3, 5, 'registered', '2026-03-25 11:45:00');
INSERT INTO `exhibition_registration` VALUES (46, 3, 6, 'registered', '2026-03-25 14:00:00');
INSERT INTO `exhibition_registration` VALUES (47, 3, 7, 'registered', '2026-03-25 15:30:00');
INSERT INTO `exhibition_registration` VALUES (48, 3, 8, 'registered', '2026-03-26 09:15:00');
INSERT INTO `exhibition_registration` VALUES (49, 3, 9, 'registered', '2026-03-26 10:45:00');
INSERT INTO `exhibition_registration` VALUES (50, 3, 10, 'registered', '2026-03-26 12:00:00');
INSERT INTO `exhibition_registration` VALUES (51, 3, 22, 'registered', '2026-03-26 14:30:00');
INSERT INTO `exhibition_registration` VALUES (52, 3, 23, 'registered', '2026-03-26 16:00:00');
INSERT INTO `exhibition_registration` VALUES (53, 3, 24, 'registered', '2026-03-27 09:00:00');
INSERT INTO `exhibition_registration` VALUES (54, 3, 25, 'registered', '2026-03-27 10:30:00');
INSERT INTO `exhibition_registration` VALUES (55, 3, 26, 'registered', '2026-03-27 11:45:00');
INSERT INTO `exhibition_registration` VALUES (56, 3, 27, 'registered', '2026-03-27 14:00:00');
INSERT INTO `exhibition_registration` VALUES (57, 3, 28, 'registered', '2026-03-27 15:30:00');
INSERT INTO `exhibition_registration` VALUES (58, 3, 29, 'registered', '2026-03-28 09:15:00');
INSERT INTO `exhibition_registration` VALUES (59, 3, 30, 'registered', '2026-03-28 10:45:00');
INSERT INTO `exhibition_registration` VALUES (60, 3, 31, 'registered', '2026-03-28 12:00:00');

-- 展览4(汉服纹样艺术展)的25条报名记录，包含lay(id=2)
INSERT INTO `exhibition_registration` VALUES (61, 4, 2, 'registered', '2026-04-01 09:00:00');
INSERT INTO `exhibition_registration` VALUES (62, 4, 4, 'registered', '2026-04-01 10:30:00');
INSERT INTO `exhibition_registration` VALUES (63, 4, 5, 'registered', '2026-04-01 11:45:00');
INSERT INTO `exhibition_registration` VALUES (64, 4, 6, 'registered', '2026-04-01 14:00:00');
INSERT INTO `exhibition_registration` VALUES (65, 4, 7, 'registered', '2026-04-01 15:30:00');
INSERT INTO `exhibition_registration` VALUES (66, 4, 8, 'registered', '2026-04-02 09:15:00');
INSERT INTO `exhibition_registration` VALUES (67, 4, 9, 'registered', '2026-04-02 10:45:00');
INSERT INTO `exhibition_registration` VALUES (68, 4, 10, 'registered', '2026-04-02 12:00:00');
INSERT INTO `exhibition_registration` VALUES (69, 4, 22, 'registered', '2026-04-02 14:30:00');
INSERT INTO `exhibition_registration` VALUES (70, 4, 23, 'registered', '2026-04-02 16:00:00');
INSERT INTO `exhibition_registration` VALUES (71, 4, 24, 'registered', '2026-04-03 09:00:00');
INSERT INTO `exhibition_registration` VALUES (72, 4, 25, 'registered', '2026-04-03 10:30:00');
INSERT INTO `exhibition_registration` VALUES (73, 4, 26, 'registered', '2026-04-03 11:45:00');
INSERT INTO `exhibition_registration` VALUES (74, 4, 27, 'registered', '2026-04-03 14:00:00');
INSERT INTO `exhibition_registration` VALUES (75, 4, 28, 'registered', '2026-04-03 15:30:00');
INSERT INTO `exhibition_registration` VALUES (76, 4, 29, 'registered', '2026-04-04 09:15:00');
INSERT INTO `exhibition_registration` VALUES (77, 4, 30, 'registered', '2026-04-04 10:45:00');
INSERT INTO `exhibition_registration` VALUES (78, 4, 31, 'registered', '2026-04-04 12:00:00');
INSERT INTO `exhibition_registration` VALUES (79, 4, 32, 'registered', '2026-04-04 14:30:00');
INSERT INTO `exhibition_registration` VALUES (80, 4, 33, 'registered', '2026-04-04 16:00:00');
INSERT INTO `exhibition_registration` VALUES (81, 4, 34, 'registered', '2026-04-05 09:00:00');
INSERT INTO `exhibition_registration` VALUES (82, 4, 35, 'registered', '2026-04-05 10:30:00');
INSERT INTO `exhibition_registration` VALUES (83, 4, 36, 'registered', '2026-04-05 11:45:00');
INSERT INTO `exhibition_registration` VALUES (84, 4, 37, 'registered', '2026-04-05 14:00:00');
INSERT INTO `exhibition_registration` VALUES (85, 4, 38, 'registered', '2026-04-05 15:30:00');

-- 展览5(现代汉服设计展)的19条报名记录，包含lay(id=2)
INSERT INTO `exhibition_registration` VALUES (86, 5, 2, 'registered', '2026-04-08 09:00:00');
INSERT INTO `exhibition_registration` VALUES (87, 5, 4, 'registered', '2026-04-08 10:30:00');
INSERT INTO `exhibition_registration` VALUES (88, 5, 5, 'registered', '2026-04-08 11:45:00');
INSERT INTO `exhibition_registration` VALUES (89, 5, 6, 'registered', '2026-04-08 14:00:00');
INSERT INTO `exhibition_registration` VALUES (90, 5, 7, 'registered', '2026-04-08 15:30:00');
INSERT INTO `exhibition_registration` VALUES (91, 5, 8, 'registered', '2026-04-09 09:15:00');
INSERT INTO `exhibition_registration` VALUES (92, 5, 9, 'registered', '2026-04-09 10:45:00');
INSERT INTO `exhibition_registration` VALUES (93, 5, 10, 'registered', '2026-04-09 12:00:00');
INSERT INTO `exhibition_registration` VALUES (94, 5, 22, 'registered', '2026-04-09 14:30:00');
INSERT INTO `exhibition_registration` VALUES (95, 5, 23, 'registered', '2026-04-09 16:00:00');
INSERT INTO `exhibition_registration` VALUES (96, 5, 24, 'registered', '2026-04-10 09:00:00');
INSERT INTO `exhibition_registration` VALUES (97, 5, 25, 'registered', '2026-04-10 10:30:00');
INSERT INTO `exhibition_registration` VALUES (98, 5, 26, 'registered', '2026-04-10 11:45:00');
INSERT INTO `exhibition_registration` VALUES (99, 5, 27, 'registered', '2026-04-10 14:00:00');
INSERT INTO `exhibition_registration` VALUES (100, 5, 28, 'registered', '2026-04-10 15:30:00');
INSERT INTO `exhibition_registration` VALUES (101, 5, 29, 'registered', '2026-04-11 09:15:00');
INSERT INTO `exhibition_registration` VALUES (102, 5, 30, 'registered', '2026-04-11 10:45:00');
INSERT INTO `exhibition_registration` VALUES (103, 5, 31, 'registered', '2026-04-11 12:00:00');
INSERT INTO `exhibition_registration` VALUES (104, 5, 32, 'registered', '2026-04-11 14:30:00');

-- 展览6(汉服与生活展)的21条报名记录
INSERT INTO `exhibition_registration` VALUES (105, 6, 4, 'registered', '2026-04-12 09:00:00');
INSERT INTO `exhibition_registration` VALUES (106, 6, 5, 'registered', '2026-04-12 10:30:00');
INSERT INTO `exhibition_registration` VALUES (107, 6, 6, 'registered', '2026-04-12 11:45:00');
INSERT INTO `exhibition_registration` VALUES (108, 6, 7, 'registered', '2026-04-12 14:00:00');
INSERT INTO `exhibition_registration` VALUES (109, 6, 8, 'registered', '2026-04-12 15:30:00');
INSERT INTO `exhibition_registration` VALUES (110, 6, 9, 'registered', '2026-04-13 09:15:00');
INSERT INTO `exhibition_registration` VALUES (111, 6, 10, 'registered', '2026-04-13 10:45:00');
INSERT INTO `exhibition_registration` VALUES (112, 6, 22, 'registered', '2026-04-13 12:00:00');
INSERT INTO `exhibition_registration` VALUES (113, 6, 23, 'registered', '2026-04-13 14:30:00');
INSERT INTO `exhibition_registration` VALUES (114, 6, 24, 'registered', '2026-04-13 16:00:00');
INSERT INTO `exhibition_registration` VALUES (115, 6, 25, 'registered', '2026-04-14 09:00:00');
INSERT INTO `exhibition_registration` VALUES (116, 6, 26, 'registered', '2026-04-14 10:30:00');
INSERT INTO `exhibition_registration` VALUES (117, 6, 27, 'registered', '2026-04-14 11:45:00');
INSERT INTO `exhibition_registration` VALUES (118, 6, 28, 'registered', '2026-04-14 14:00:00');
INSERT INTO `exhibition_registration` VALUES (119, 6, 29, 'registered', '2026-04-14 15:30:00');
INSERT INTO `exhibition_registration` VALUES (120, 6, 30, 'registered', '2026-04-15 09:15:00');
INSERT INTO `exhibition_registration` VALUES (121, 6, 31, 'registered', '2026-04-15 10:45:00');
INSERT INTO `exhibition_registration` VALUES (122, 6, 32, 'registered', '2026-04-15 12:00:00');
INSERT INTO `exhibition_registration` VALUES (123, 6, 33, 'registered', '2026-04-15 14:30:00');
INSERT INTO `exhibition_registration` VALUES (124, 6, 34, 'registered', '2026-04-15 16:00:00');
INSERT INTO `exhibition_registration` VALUES (125, 6, 35, 'registered', '2026-04-16 09:00:00');

-- 展览7(少数民族与汉服展)的17条报名记录
INSERT INTO `exhibition_registration` VALUES (126, 7, 4, 'registered', '2026-04-20 09:00:00');
INSERT INTO `exhibition_registration` VALUES (127, 7, 5, 'registered', '2026-04-20 10:30:00');
INSERT INTO `exhibition_registration` VALUES (128, 7, 6, 'registered', '2026-04-20 11:45:00');
INSERT INTO `exhibition_registration` VALUES (129, 7, 7, 'registered', '2026-04-20 14:00:00');
INSERT INTO `exhibition_registration` VALUES (130, 7, 8, 'registered', '2026-04-20 15:30:00');
INSERT INTO `exhibition_registration` VALUES (131, 7, 9, 'registered', '2026-04-21 09:15:00');
INSERT INTO `exhibition_registration` VALUES (132, 7, 10, 'registered', '2026-04-21 10:45:00');
INSERT INTO `exhibition_registration` VALUES (133, 7, 22, 'registered', '2026-04-21 12:00:00');
INSERT INTO `exhibition_registration` VALUES (134, 7, 23, 'registered', '2026-04-21 14:30:00');
INSERT INTO `exhibition_registration` VALUES (135, 7, 24, 'registered', '2026-04-21 16:00:00');
INSERT INTO `exhibition_registration` VALUES (136, 7, 25, 'registered', '2026-04-22 09:00:00');
INSERT INTO `exhibition_registration` VALUES (137, 7, 26, 'registered', '2026-04-22 10:30:00');
INSERT INTO `exhibition_registration` VALUES (138, 7, 27, 'registered', '2026-04-22 11:45:00');
INSERT INTO `exhibition_registration` VALUES (139, 7, 28, 'registered', '2026-04-22 14:00:00');
INSERT INTO `exhibition_registration` VALUES (140, 7, 29, 'registered', '2026-04-22 15:30:00');
INSERT INTO `exhibition_registration` VALUES (141, 7, 30, 'registered', '2026-04-23 09:15:00');
INSERT INTO `exhibition_registration` VALUES (142, 7, 31, 'registered', '2026-04-23 10:45:00');

-- 展览8(汉服国际交流展)的23条报名记录，包含lay(id=2)
INSERT INTO `exhibition_registration` VALUES (143, 8, 2, 'registered', '2026-04-28 09:00:00');
INSERT INTO `exhibition_registration` VALUES (144, 8, 4, 'registered', '2026-04-28 10:30:00');
INSERT INTO `exhibition_registration` VALUES (145, 8, 5, 'registered', '2026-04-28 11:45:00');
INSERT INTO `exhibition_registration` VALUES (146, 8, 6, 'registered', '2026-04-28 14:00:00');
INSERT INTO `exhibition_registration` VALUES (147, 8, 7, 'registered', '2026-04-28 15:30:00');
INSERT INTO `exhibition_registration` VALUES (148, 8, 8, 'registered', '2026-04-29 09:15:00');
INSERT INTO `exhibition_registration` VALUES (149, 8, 9, 'registered', '2026-04-29 10:45:00');
INSERT INTO `exhibition_registration` VALUES (150, 8, 10, 'registered', '2026-04-29 12:00:00');
INSERT INTO `exhibition_registration` VALUES (151, 8, 22, 'registered', '2026-04-29 14:30:00');
INSERT INTO `exhibition_registration` VALUES (152, 8, 23, 'registered', '2026-04-29 16:00:00');
INSERT INTO `exhibition_registration` VALUES (153, 8, 24, 'registered', '2026-04-30 09:00:00');
INSERT INTO `exhibition_registration` VALUES (154, 8, 25, 'registered', '2026-04-30 10:30:00');
INSERT INTO `exhibition_registration` VALUES (155, 8, 26, 'registered', '2026-04-30 11:45:00');
INSERT INTO `exhibition_registration` VALUES (156, 8, 27, 'registered', '2026-04-30 14:00:00');
INSERT INTO `exhibition_registration` VALUES (157, 8, 28, 'registered', '2026-04-30 15:30:00');
INSERT INTO `exhibition_registration` VALUES (158, 8, 29, 'registered', '2026-05-01 09:15:00');
INSERT INTO `exhibition_registration` VALUES (159, 8, 30, 'registered', '2026-05-01 10:45:00');
INSERT INTO `exhibition_registration` VALUES (160, 8, 31, 'registered', '2026-05-01 12:00:00');
INSERT INTO `exhibition_registration` VALUES (161, 8, 32, 'registered', '2026-05-01 14:30:00');
INSERT INTO `exhibition_registration` VALUES (162, 8, 33, 'registered', '2026-05-01 16:00:00');
INSERT INTO `exhibition_registration` VALUES (163, 8, 34, 'registered', '2026-05-02 09:00:00');
INSERT INTO `exhibition_registration` VALUES (164, 8, 35, 'registered', '2026-05-02 10:30:00');
INSERT INTO `exhibition_registration` VALUES (165, 8, 36, 'registered', '2026-05-02 11:45:00');

-- ----------------------------
-- Table structure for lecture
-- ----------------------------
DROP TABLE IF EXISTS `lecture`;
CREATE TABLE `lecture`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '讲座ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '讲座标题',
  `speaker` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '讲师',
  `speaker_bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '主讲人介绍',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '讲座描述',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '讲座内容',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '讲座地点',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `capacity` int NULL DEFAULT 0 COMMENT '容纳人数',
  `registered_count` int NULL DEFAULT 0 COMMENT '已注册人数',
  `notice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '参观须知',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '讲座图片URL',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT '讲座表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lecture
-- ----------------------------
INSERT INTO `lecture` VALUES (1, '汉服的历史演变', '张教授', '历史学博士，专注于中国古代服饰史研究，出版《汉服史话》等多部学术著作，在汉服文化研究领域享有盛誉。', '详细介绍汉服从先秦到明清的历史演变过程，探讨不同朝代汉服的特点和文化内涵。', '本讲座将从汉服的起源讲起，详细介绍先秦时期的深衣、汉代的袍服、唐代的幞头襕衫、宋代的褙子、明代的补服等不同时期的代表性服饰，分析其款式、色彩、纹样的变化，以及背后的社会文化因素。通过大量历史图片和实物资料，展现汉服发展的完整脉络。', '北京文化中心', '2026-03-20 14:00:00', '2026-03-20 16:00:00', 100, 35, '请提前15分钟到场签到\n讲座期间请保持安静\n可携带笔记本记录\n讲座结束后设有互动问答环节', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/lecture1.webp', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `lecture` VALUES (2, '汉服制作工艺', '李师傅', '国家级非物质文化遗产传承人，从事传统汉服制作40余年，擅长各种传统缝制工艺，培养了众多汉服制作人才。', '讲解传统汉服的制作工艺和技巧，包括面料选择、裁剪方法和缝制技术。', '本讲座将详细介绍汉服制作的完整流程，从面料的选择与处理开始，讲解传统汉服的裁剪方法、缝制技巧、装饰工艺等。李师傅将现场展示传统针法和刺绣技巧，并分享多年积累的制作经验，让参与者了解汉服制作的精髓所在。', '上海手工艺中心', '2026-03-25 10:00:00', '2026-03-25 12:00:00', 80, 28, '请提前10分钟到场\n现场将有互动制作环节\n可携带小型工具\n听从现场工作人员安排', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/lecture2.webp', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `lecture` VALUES (3, '汉服与传统礼仪', '王教授', '礼仪学专家，研究中国传统礼仪文化30余年，著有《中国传统礼仪大全》等著作，经常受邀参加国内外文化交流活动。', '探讨汉服与传统礼仪的关系，介绍不同场合的汉服穿着规范和礼仪要求。', '本讲座将深入探讨汉服与传统礼仪的紧密关系，详细介绍不同场合（如婚礼、祭祀、朝会等）的汉服穿着规范和礼仪要求。王教授将通过生动的案例和现场演示，讲解汉服穿着的礼仪细节，以及如何在现代社会中恰当运用传统礼仪。', '西安大唐芙蓉园', '2026-04-02 14:00:00', '2026-04-02 16:00:00', 120, 45, '请提前20分钟到场\n讲座期间将有礼仪演示\n建议穿着舒适服装\n保持手机静音', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/lecture3.webp', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `lecture` VALUES (4, '明代汉服的特点', '刘博士', '明史专家，专注于明代服饰研究，主持多项国家级研究课题，发表学术论文数十篇，对明代汉服有深入研究。', '深入解析明代汉服的款式、纹样和穿着特点，展示明代服饰的独特魅力。', '本讲座将聚焦明代汉服的独特特点，详细解析明代官服的补子制度、常服的款式变化、女子服饰的多样风格等。刘博士将结合南京博物馆的馆藏文物，分析明代汉服的面料、色彩、纹样特点，以及其背后的社会等级制度和文化内涵。', '南京博物馆', '2026-04-10 09:30:00', '2026-04-10 11:30:00', 90, 32, '请提前15分钟到场签到\n讲座期间有实物展示\n禁止触摸展品\n遵守博物馆相关规定', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/lecture4.webp', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `lecture` VALUES (5, '汉服复兴运动', '陈老师', '汉服文化推广者，参与组织多次大型汉服文化活动，撰写《汉服复兴之路》等著作，致力于汉服文化的现代传承。', '讲述现代汉服复兴运动的发展历程，分析其文化意义和社会影响。', '本讲座将系统梳理现代汉服复兴运动的发展历程，从早期的民间自发活动到如今的规模化文化现象。陈老师将分享自己参与组织的大型汉服活动经验，分析汉服复兴对当代社会的文化意义，以及如何在现代生活中更好地传承和发展汉服文化。', '杭州西湖文化广场', '2026-04-15 15:00:00', '2026-04-15 17:00:00', 150, 68, '请提前10分钟到场\n讲座结束后有交流环节\n可携带汉服相关问题\n保持会场整洁', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/lecture5.webp', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `lecture` VALUES (6, '唐代汉服与时尚', '赵教授', '服装史专家，研究唐代服饰文化20余年，曾参与多个唐代服饰复原项目，对唐代时尚文化有独特见解。', '探讨唐代汉服的时尚元素和设计特点，分析其对现代时尚的影响。', '本讲座将深入探讨唐代汉服的时尚元素，详细分析唐代女子的襦裙、男子的幞头袍衫等代表性服饰的设计特点。赵教授将结合唐代壁画、陶俑等资料，展示唐代服饰的色彩搭配、纹样设计和配饰风格，并分析其对现代时尚设计的影响和启发。', '洛阳龙门石窟', '2026-04-20 14:00:00', '2026-04-20 16:00:00', 100, 42, '请提前15分钟到场\n讲座期间有唐代服饰展示\n可拍照但禁止闪光灯\n遵守景区相关规定', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/lecture6.webp', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `lecture` VALUES (7, '汉服与文学艺术', '钱老师', '文学博士，研究中国古代文学与服饰文化的关系，发表多篇相关学术论文，对汉服在文学作品中的表现有深入研究。', '分析汉服在文学、绘画等艺术形式中的表现，探讨其文化象征意义。', '本讲座将从文学艺术的角度解读汉服文化，通过分析《诗经》、唐诗宋词等文学作品中对汉服的描写，以及绘画、壁画中汉服的视觉表现，探讨汉服在艺术作品中的文化象征意义。钱老师将通过经典文学片段的朗诵和赏析，展现汉服与文学艺术的紧密联系。', '苏州园林', '2026-04-28 10:00:00', '2026-04-28 12:00:00', 80, 25, '请提前10分钟到场\n讲座期间有文学作品朗诵\n保持安静聆听\n遵守园林参观规定', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/lecture7.webp', '2026-03-14 10:00:00', '2026-03-14 10:00:00');
INSERT INTO `lecture` VALUES (8, '汉服的国际化发展', '孙博士', '文化传播学专家，研究中国传统文化的国际传播，曾在多个国际学术会议上发表关于汉服国际化的演讲。', '探讨汉服在国际舞台上的传播和发展，分析其作为文化符号的意义。', '本讲座将探讨汉服在国际舞台上的传播与发展历程，分析汉服如何从传统服饰转变为具有全球影响力的文化符号。孙博士将分享汉服在国际时尚界、文化交流活动中的表现，以及海外汉服社团的发展状况，探讨如何进一步推动汉服的国际化传播。', '广州文化中心', '2026-05-05 15:00:00', '2026-05-05 17:00:00', 120, 50, '请提前15分钟到场\n讲座期间有国际汉服展示\n鼓励提问交流\n保持会场秩序', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/lecture8.webp', '2026-03-14 10:00:00', '2026-03-14 10:00:00');

-- ----------------------------
-- Table structure for lecture_registration
-- ----------------------------
DROP TABLE IF EXISTS `lecture_registration`;
CREATE TABLE `lecture_registration`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `lecture_id` bigint NOT NULL COMMENT '讲座ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'registered' COMMENT '预约状态(registered/attended/cancelled)',
  `registration_time` datetime NOT NULL COMMENT '预约时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_lecture_user`(`lecture_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `lecture_registration_ibfk_1` FOREIGN KEY (`lecture_id`) REFERENCES `lecture` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `lecture_registration_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 173 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '讲座预约表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lecture_registration
-- ----------------------------
-- 讲座1(汉服的历史演变)的22条预约记录，包含lay(id=2)
INSERT INTO `lecture_registration` VALUES (1, 1, 2, 'registered', '2026-03-10 09:00:00');
INSERT INTO `lecture_registration` VALUES (2, 1, 4, 'registered', '2026-03-10 10:30:00');
INSERT INTO `lecture_registration` VALUES (3, 1, 5, 'registered', '2026-03-10 11:45:00');
INSERT INTO `lecture_registration` VALUES (4, 1, 6, 'registered', '2026-03-10 14:00:00');
INSERT INTO `lecture_registration` VALUES (5, 1, 7, 'registered', '2026-03-10 15:30:00');
INSERT INTO `lecture_registration` VALUES (6, 1, 8, 'registered', '2026-03-11 09:15:00');
INSERT INTO `lecture_registration` VALUES (7, 1, 9, 'registered', '2026-03-11 10:45:00');
INSERT INTO `lecture_registration` VALUES (8, 1, 10, 'registered', '2026-03-11 12:00:00');
INSERT INTO `lecture_registration` VALUES (9, 1, 22, 'registered', '2026-03-11 14:30:00');
INSERT INTO `lecture_registration` VALUES (10, 1, 23, 'registered', '2026-03-11 16:00:00');
INSERT INTO `lecture_registration` VALUES (11, 1, 24, 'registered', '2026-03-12 09:00:00');
INSERT INTO `lecture_registration` VALUES (12, 1, 25, 'registered', '2026-03-12 10:30:00');
INSERT INTO `lecture_registration` VALUES (13, 1, 26, 'registered', '2026-03-12 11:45:00');
INSERT INTO `lecture_registration` VALUES (14, 1, 27, 'registered', '2026-03-12 14:00:00');
INSERT INTO `lecture_registration` VALUES (15, 1, 28, 'registered', '2026-03-12 15:30:00');
INSERT INTO `lecture_registration` VALUES (16, 1, 29, 'registered', '2026-03-13 09:15:00');
INSERT INTO `lecture_registration` VALUES (17, 1, 30, 'registered', '2026-03-13 10:45:00');
INSERT INTO `lecture_registration` VALUES (18, 1, 31, 'registered', '2026-03-13 12:00:00');
INSERT INTO `lecture_registration` VALUES (19, 1, 32, 'registered', '2026-03-13 14:30:00');
INSERT INTO `lecture_registration` VALUES (20, 1, 33, 'registered', '2026-03-13 16:00:00');
INSERT INTO `lecture_registration` VALUES (21, 1, 34, 'registered', '2026-03-14 09:00:00');
INSERT INTO `lecture_registration` VALUES (22, 1, 35, 'registered', '2026-03-14 10:30:00');

-- 讲座2(汉服制作工艺)的19条预约记录，包含lay(id=2)
INSERT INTO `lecture_registration` VALUES (23, 2, 2, 'registered', '2026-03-15 09:00:00');
INSERT INTO `lecture_registration` VALUES (24, 2, 4, 'registered', '2026-03-15 10:30:00');
INSERT INTO `lecture_registration` VALUES (25, 2, 5, 'registered', '2026-03-15 11:45:00');
INSERT INTO `lecture_registration` VALUES (26, 2, 6, 'registered', '2026-03-15 14:00:00');
INSERT INTO `lecture_registration` VALUES (27, 2, 7, 'registered', '2026-03-15 15:30:00');
INSERT INTO `lecture_registration` VALUES (28, 2, 8, 'registered', '2026-03-16 09:15:00');
INSERT INTO `lecture_registration` VALUES (29, 2, 9, 'registered', '2026-03-16 10:45:00');
INSERT INTO `lecture_registration` VALUES (30, 2, 10, 'registered', '2026-03-16 12:00:00');
INSERT INTO `lecture_registration` VALUES (31, 2, 22, 'registered', '2026-03-16 14:30:00');
INSERT INTO `lecture_registration` VALUES (32, 2, 23, 'registered', '2026-03-16 16:00:00');
INSERT INTO `lecture_registration` VALUES (33, 2, 24, 'registered', '2026-03-17 09:00:00');
INSERT INTO `lecture_registration` VALUES (34, 2, 25, 'registered', '2026-03-17 10:30:00');
INSERT INTO `lecture_registration` VALUES (35, 2, 26, 'registered', '2026-03-17 11:45:00');
INSERT INTO `lecture_registration` VALUES (36, 2, 27, 'registered', '2026-03-17 14:00:00');
INSERT INTO `lecture_registration` VALUES (37, 2, 28, 'registered', '2026-03-17 15:30:00');
INSERT INTO `lecture_registration` VALUES (38, 2, 29, 'registered', '2026-03-18 09:15:00');
INSERT INTO `lecture_registration` VALUES (39, 2, 30, 'registered', '2026-03-18 10:45:00');
INSERT INTO `lecture_registration` VALUES (40, 2, 31, 'registered', '2026-03-18 12:00:00');
INSERT INTO `lecture_registration` VALUES (41, 2, 32, 'registered', '2026-03-18 14:30:00');

-- 讲座3(汉服与传统礼仪)的25条预约记录，包含lay(id=2)
INSERT INTO `lecture_registration` VALUES (42, 3, 2, 'registered', '2026-03-20 09:00:00');
INSERT INTO `lecture_registration` VALUES (43, 3, 4, 'registered', '2026-03-20 10:30:00');
INSERT INTO `lecture_registration` VALUES (44, 3, 5, 'registered', '2026-03-20 11:45:00');
INSERT INTO `lecture_registration` VALUES (45, 3, 6, 'registered', '2026-03-20 14:00:00');
INSERT INTO `lecture_registration` VALUES (46, 3, 7, 'registered', '2026-03-20 15:30:00');
INSERT INTO `lecture_registration` VALUES (47, 3, 8, 'registered', '2026-03-21 09:15:00');
INSERT INTO `lecture_registration` VALUES (48, 3, 9, 'registered', '2026-03-21 10:45:00');
INSERT INTO `lecture_registration` VALUES (49, 3, 10, 'registered', '2026-03-21 12:00:00');
INSERT INTO `lecture_registration` VALUES (50, 3, 22, 'registered', '2026-03-21 14:30:00');
INSERT INTO `lecture_registration` VALUES (51, 3, 23, 'registered', '2026-03-21 16:00:00');
INSERT INTO `lecture_registration` VALUES (52, 3, 24, 'registered', '2026-03-22 09:00:00');
INSERT INTO `lecture_registration` VALUES (53, 3, 25, 'registered', '2026-03-22 10:30:00');
INSERT INTO `lecture_registration` VALUES (54, 3, 26, 'registered', '2026-03-22 11:45:00');
INSERT INTO `lecture_registration` VALUES (55, 3, 27, 'registered', '2026-03-22 14:00:00');
INSERT INTO `lecture_registration` VALUES (56, 3, 28, 'registered', '2026-03-22 15:30:00');
INSERT INTO `lecture_registration` VALUES (57, 3, 29, 'registered', '2026-03-23 09:15:00');
INSERT INTO `lecture_registration` VALUES (58, 3, 30, 'registered', '2026-03-23 10:45:00');
INSERT INTO `lecture_registration` VALUES (59, 3, 31, 'registered', '2026-03-23 12:00:00');
INSERT INTO `lecture_registration` VALUES (60, 3, 32, 'registered', '2026-03-23 14:30:00');
INSERT INTO `lecture_registration` VALUES (61, 3, 33, 'registered', '2026-03-23 16:00:00');
INSERT INTO `lecture_registration` VALUES (62, 3, 34, 'registered', '2026-03-24 09:00:00');
INSERT INTO `lecture_registration` VALUES (63, 3, 35, 'registered', '2026-03-24 10:30:00');
INSERT INTO `lecture_registration` VALUES (64, 3, 36, 'registered', '2026-03-24 11:45:00');
INSERT INTO `lecture_registration` VALUES (65, 3, 37, 'registered', '2026-03-24 14:00:00');
INSERT INTO `lecture_registration` VALUES (66, 3, 38, 'registered', '2026-03-24 15:30:00');

-- 讲座4(明代汉服的特点)的18条预约记录，包含lay(id=2)
INSERT INTO `lecture_registration` VALUES (67, 4, 2, 'registered', '2026-03-28 09:00:00');
INSERT INTO `lecture_registration` VALUES (68, 4, 4, 'registered', '2026-03-28 10:30:00');
INSERT INTO `lecture_registration` VALUES (69, 4, 5, 'registered', '2026-03-28 11:45:00');
INSERT INTO `lecture_registration` VALUES (70, 4, 6, 'registered', '2026-03-28 14:00:00');
INSERT INTO `lecture_registration` VALUES (71, 4, 7, 'registered', '2026-03-28 15:30:00');
INSERT INTO `lecture_registration` VALUES (72, 4, 8, 'registered', '2026-03-29 09:15:00');
INSERT INTO `lecture_registration` VALUES (73, 4, 9, 'registered', '2026-03-29 10:45:00');
INSERT INTO `lecture_registration` VALUES (74, 4, 10, 'registered', '2026-03-29 12:00:00');
INSERT INTO `lecture_registration` VALUES (75, 4, 22, 'registered', '2026-03-29 14:30:00');
INSERT INTO `lecture_registration` VALUES (76, 4, 23, 'registered', '2026-03-29 16:00:00');
INSERT INTO `lecture_registration` VALUES (77, 4, 24, 'registered', '2026-03-30 09:00:00');
INSERT INTO `lecture_registration` VALUES (78, 4, 25, 'registered', '2026-03-30 10:30:00');
INSERT INTO `lecture_registration` VALUES (79, 4, 26, 'registered', '2026-03-30 11:45:00');
INSERT INTO `lecture_registration` VALUES (80, 4, 27, 'registered', '2026-03-30 14:00:00');
INSERT INTO `lecture_registration` VALUES (81, 4, 28, 'registered', '2026-03-30 15:30:00');
INSERT INTO `lecture_registration` VALUES (82, 4, 29, 'registered', '2026-03-31 09:15:00');
INSERT INTO `lecture_registration` VALUES (83, 4, 30, 'registered', '2026-03-31 10:45:00');
INSERT INTO `lecture_registration` VALUES (84, 4, 31, 'registered', '2026-03-31 12:00:00');

-- 讲座5(汉服复兴运动)的27条预约记录，包含lay(id=2)
INSERT INTO `lecture_registration` VALUES (85, 5, 2, 'registered', '2026-04-01 09:00:00');
INSERT INTO `lecture_registration` VALUES (86, 5, 4, 'registered', '2026-04-01 10:30:00');
INSERT INTO `lecture_registration` VALUES (87, 5, 5, 'registered', '2026-04-01 11:45:00');
INSERT INTO `lecture_registration` VALUES (88, 5, 6, 'registered', '2026-04-01 14:00:00');
INSERT INTO `lecture_registration` VALUES (89, 5, 7, 'registered', '2026-04-01 15:30:00');
INSERT INTO `lecture_registration` VALUES (90, 5, 8, 'registered', '2026-04-02 09:15:00');
INSERT INTO `lecture_registration` VALUES (91, 5, 9, 'registered', '2026-04-02 10:45:00');
INSERT INTO `lecture_registration` VALUES (92, 5, 10, 'registered', '2026-04-02 12:00:00');
INSERT INTO `lecture_registration` VALUES (93, 5, 22, 'registered', '2026-04-02 14:30:00');
INSERT INTO `lecture_registration` VALUES (94, 5, 23, 'registered', '2026-04-02 16:00:00');
INSERT INTO `lecture_registration` VALUES (95, 5, 24, 'registered', '2026-04-03 09:00:00');
INSERT INTO `lecture_registration` VALUES (96, 5, 25, 'registered', '2026-04-03 10:30:00');
INSERT INTO `lecture_registration` VALUES (97, 5, 26, 'registered', '2026-04-03 11:45:00');
INSERT INTO `lecture_registration` VALUES (98, 5, 27, 'registered', '2026-04-03 14:00:00');
INSERT INTO `lecture_registration` VALUES (99, 5, 28, 'registered', '2026-04-03 15:30:00');
INSERT INTO `lecture_registration` VALUES (100, 5, 29, 'registered', '2026-04-04 09:15:00');
INSERT INTO `lecture_registration` VALUES (101, 5, 30, 'registered', '2026-04-04 10:45:00');
INSERT INTO `lecture_registration` VALUES (102, 5, 31, 'registered', '2026-04-04 12:00:00');
INSERT INTO `lecture_registration` VALUES (103, 5, 32, 'registered', '2026-04-04 14:30:00');
INSERT INTO `lecture_registration` VALUES (104, 5, 33, 'registered', '2026-04-04 16:00:00');
INSERT INTO `lecture_registration` VALUES (105, 5, 34, 'registered', '2026-04-05 09:00:00');
INSERT INTO `lecture_registration` VALUES (106, 5, 35, 'registered', '2026-04-05 10:30:00');
INSERT INTO `lecture_registration` VALUES (107, 5, 36, 'registered', '2026-04-05 11:45:00');
INSERT INTO `lecture_registration` VALUES (108, 5, 37, 'registered', '2026-04-05 14:00:00');
INSERT INTO `lecture_registration` VALUES (109, 5, 38, 'registered', '2026-04-05 15:30:00');
INSERT INTO `lecture_registration` VALUES (110, 5, 39, 'registered', '2026-04-06 09:15:00');
INSERT INTO `lecture_registration` VALUES (111, 5, 40, 'registered', '2026-04-06 10:45:00');

-- 讲座6(唐代汉服与时尚)的21条预约记录，包含lay(id=2)
INSERT INTO `lecture_registration` VALUES (112, 6, 2, 'registered', '2026-04-08 09:00:00');
INSERT INTO `lecture_registration` VALUES (113, 6, 4, 'registered', '2026-04-08 10:30:00');
INSERT INTO `lecture_registration` VALUES (114, 6, 5, 'registered', '2026-04-08 11:45:00');
INSERT INTO `lecture_registration` VALUES (115, 6, 6, 'registered', '2026-04-08 14:00:00');
INSERT INTO `lecture_registration` VALUES (116, 6, 7, 'registered', '2026-04-08 15:30:00');
INSERT INTO `lecture_registration` VALUES (117, 6, 8, 'registered', '2026-04-09 09:15:00');
INSERT INTO `lecture_registration` VALUES (118, 6, 9, 'registered', '2026-04-09 10:45:00');
INSERT INTO `lecture_registration` VALUES (119, 6, 10, 'registered', '2026-04-09 12:00:00');
INSERT INTO `lecture_registration` VALUES (120, 6, 22, 'registered', '2026-04-09 14:30:00');
INSERT INTO `lecture_registration` VALUES (121, 6, 23, 'registered', '2026-04-09 16:00:00');
INSERT INTO `lecture_registration` VALUES (122, 6, 24, 'registered', '2026-04-10 09:00:00');
INSERT INTO `lecture_registration` VALUES (123, 6, 25, 'registered', '2026-04-10 10:30:00');
INSERT INTO `lecture_registration` VALUES (124, 6, 26, 'registered', '2026-04-10 11:45:00');
INSERT INTO `lecture_registration` VALUES (125, 6, 27, 'registered', '2026-04-10 14:00:00');
INSERT INTO `lecture_registration` VALUES (126, 6, 28, 'registered', '2026-04-10 15:30:00');
INSERT INTO `lecture_registration` VALUES (127, 6, 29, 'registered', '2026-04-11 09:15:00');
INSERT INTO `lecture_registration` VALUES (128, 6, 30, 'registered', '2026-04-11 10:45:00');
INSERT INTO `lecture_registration` VALUES (129, 6, 31, 'registered', '2026-04-11 12:00:00');
INSERT INTO `lecture_registration` VALUES (130, 6, 32, 'registered', '2026-04-11 14:30:00');
INSERT INTO `lecture_registration` VALUES (131, 6, 33, 'registered', '2026-04-11 16:00:00');
INSERT INTO `lecture_registration` VALUES (132, 6, 34, 'registered', '2026-04-12 09:00:00');

-- 讲座7(汉服与文学艺术)的17条预约记录
INSERT INTO `lecture_registration` VALUES (133, 7, 4, 'registered', '2026-04-15 09:00:00');
INSERT INTO `lecture_registration` VALUES (134, 7, 5, 'registered', '2026-04-15 10:30:00');
INSERT INTO `lecture_registration` VALUES (135, 7, 6, 'registered', '2026-04-15 11:45:00');
INSERT INTO `lecture_registration` VALUES (136, 7, 7, 'registered', '2026-04-15 14:00:00');
INSERT INTO `lecture_registration` VALUES (137, 7, 8, 'registered', '2026-04-15 15:30:00');
INSERT INTO `lecture_registration` VALUES (138, 7, 9, 'registered', '2026-04-16 09:15:00');
INSERT INTO `lecture_registration` VALUES (139, 7, 10, 'registered', '2026-04-16 10:45:00');
INSERT INTO `lecture_registration` VALUES (140, 7, 22, 'registered', '2026-04-16 12:00:00');
INSERT INTO `lecture_registration` VALUES (141, 7, 23, 'registered', '2026-04-16 14:30:00');
INSERT INTO `lecture_registration` VALUES (142, 7, 24, 'registered', '2026-04-16 16:00:00');
INSERT INTO `lecture_registration` VALUES (143, 7, 25, 'registered', '2026-04-17 09:00:00');
INSERT INTO `lecture_registration` VALUES (144, 7, 26, 'registered', '2026-04-17 10:30:00');
INSERT INTO `lecture_registration` VALUES (145, 7, 27, 'registered', '2026-04-17 11:45:00');
INSERT INTO `lecture_registration` VALUES (146, 7, 28, 'registered', '2026-04-17 14:00:00');
INSERT INTO `lecture_registration` VALUES (147, 7, 29, 'registered', '2026-04-17 15:30:00');
INSERT INTO `lecture_registration` VALUES (148, 7, 30, 'registered', '2026-04-18 09:15:00');
INSERT INTO `lecture_registration` VALUES (149, 7, 31, 'registered', '2026-04-18 10:45:00');

-- 讲座8(汉服的国际化发展)的23条预约记录，包含lay(id=2)
INSERT INTO `lecture_registration` VALUES (150, 8, 2, 'registered', '2026-04-22 09:00:00');
INSERT INTO `lecture_registration` VALUES (151, 8, 4, 'registered', '2026-04-22 10:30:00');
INSERT INTO `lecture_registration` VALUES (152, 8, 5, 'registered', '2026-04-22 11:45:00');
INSERT INTO `lecture_registration` VALUES (153, 8, 6, 'registered', '2026-04-22 14:00:00');
INSERT INTO `lecture_registration` VALUES (154, 8, 7, 'registered', '2026-04-22 15:30:00');
INSERT INTO `lecture_registration` VALUES (155, 8, 8, 'registered', '2026-04-23 09:15:00');
INSERT INTO `lecture_registration` VALUES (156, 8, 9, 'registered', '2026-04-23 10:45:00');
INSERT INTO `lecture_registration` VALUES (157, 8, 10, 'registered', '2026-04-23 12:00:00');
INSERT INTO `lecture_registration` VALUES (158, 8, 22, 'registered', '2026-04-23 14:30:00');
INSERT INTO `lecture_registration` VALUES (159, 8, 23, 'registered', '2026-04-23 16:00:00');
INSERT INTO `lecture_registration` VALUES (160, 8, 24, 'registered', '2026-04-24 09:00:00');
INSERT INTO `lecture_registration` VALUES (161, 8, 25, 'registered', '2026-04-24 10:30:00');
INSERT INTO `lecture_registration` VALUES (162, 8, 26, 'registered', '2026-04-24 11:45:00');
INSERT INTO `lecture_registration` VALUES (163, 8, 27, 'registered', '2026-04-24 14:00:00');
INSERT INTO `lecture_registration` VALUES (164, 8, 28, 'registered', '2026-04-24 15:30:00');
INSERT INTO `lecture_registration` VALUES (165, 8, 29, 'registered', '2026-04-25 09:15:00');
INSERT INTO `lecture_registration` VALUES (166, 8, 30, 'registered', '2026-04-25 10:45:00');
INSERT INTO `lecture_registration` VALUES (167, 8, 31, 'registered', '2026-04-25 12:00:00');
INSERT INTO `lecture_registration` VALUES (168, 8, 32, 'registered', '2026-04-25 14:30:00');
INSERT INTO `lecture_registration` VALUES (169, 8, 33, 'registered', '2026-04-25 16:00:00');
INSERT INTO `lecture_registration` VALUES (170, 8, 34, 'registered', '2026-04-26 09:00:00');
INSERT INTO `lecture_registration` VALUES (171, 8, 35, 'registered', '2026-04-26 10:30:00');
INSERT INTO `lecture_registration` VALUES (172, 8, 36, 'registered', '2026-04-26 11:45:00');

-- ----------------------------
-- Table structure for shop
-- ----------------------------
DROP TABLE IF EXISTS `shop`;
CREATE TABLE `shop`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '店铺ID',
  `user_id` bigint NOT NULL COMMENT '商家用户ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '店铺名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '店铺描述',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '店铺图片URL',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '地址',
  `contact` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系方式',
  `price_range` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '价格区间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `shop_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '店铺表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop
-- ----------------------------
-- 商家1 (shop, id=3): 1个店铺 - 普通档
INSERT INTO `shop` VALUES (1, 3, '汉服小铺', '专注于平价汉服的店铺，款式多样，适合入门爱好者。我们提供各种风格的汉服，从日常穿着到节日庆典，满足不同场合的需求。所有汉服均采用优质面料，做工精细，让您在穿着舒适的同时展现传统文化之美。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop1.webp', '北京市朝阳区', '13800138001', '普通档（0-400）', '2026-01-01 10:00:00', '2026-01-01 10:00:00');

-- 商家2 (织云, id=44): 2个店铺 - 普通档+中档
INSERT INTO `shop` VALUES (2, 44, '霓裳羽衣', '提供性价比高的汉服，适合日常穿着。我们的汉服设计简约大方，注重舒适度和实用性，让您在日常生活中也能轻松驾驭传统服饰。所有款式均经过精心挑选，确保质量和时尚感并存。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop2.webp', '上海市浦东新区', '13900139002', '普通档（0-400）', '2026-01-02 10:00:00', '2026-01-02 10:00:00');
INSERT INTO `shop` VALUES (7, 44, '汉唐华服', '中等价位的汉服店铺，做工精细。我们专注于将传统工艺与现代设计相结合，打造出既符合传统形制又适合现代穿着的汉服。每一件汉服都经过精心制作，从面料选择到细节处理，都体现了我们对品质的追求。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop7.webp', '北京市海淀区', '13800138007', '中档（400-700）', '2026-01-07 10:00:00', '2026-01-07 10:00:00');

-- 商家3 (衔花, id=45): 2个店铺 - 普通档+中档
INSERT INTO `shop` VALUES (3, 45, '汉风堂', '传统汉服店铺，价格亲民，款式经典。我们专注于传承经典汉服款式，每一件汉服都体现了传统工艺的精髓。我们的设计师深入研究历史文献，确保每一款汉服都符合传统形制，让您感受到真正的华夏衣冠之美。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop3.webp', '广州市天河区', '13700137003', '普通档（0-400）', '2026-01-03 10:00:00', '2026-01-03 10:00:00');
INSERT INTO `shop` VALUES (8, 45, '锦绣坊', '绣花精美的中档汉服店铺。我们以精美的绣花工艺著称，每一件汉服都装饰有精致的刺绣图案。我们的绣工师傅拥有多年经验，能够将各种传统图案栩栩如生地呈现在汉服上，让您的服饰更加独特和精美。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop8.webp', '上海市静安区', '13900139008', '中档（400-700）', '2026-01-08 10:00:00', '2026-01-08 10:00:00');

-- 商家4 (南风, id=46): 1个店铺 - 普通档
INSERT INTO `shop` VALUES (4, 46, '华服小馆', '小而精致的汉服店铺，主打平价款式。我们虽然规模不大，但致力于为顾客提供最精致的汉服体验。每一件汉服都经过精心挑选和质量检验，确保您能以实惠的价格购买到高品质的传统服饰。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop4.webp', '杭州市西湖区', '13600136004', '普通档（0-400）', '2026-01-04 10:00:00', '2026-01-04 10:00:00');

-- 商家5 (锦瑟, id=47): 2个店铺 - 普通档+中档
INSERT INTO `shop` VALUES (5, 47, '汉服世家', '家族经营的汉服店铺，价格实惠。我们是一家有着多年历史的家族企业，传承了数代人的汉服制作工艺。我们的汉服不仅价格实惠，而且做工精细，每一件都凝聚了我们对传统文化的热爱和敬意。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop5.webp', '成都市锦江区', '13500135005', '普通档（0-400）', '2026-01-05 10:00:00', '2026-01-05 10:00:00');
INSERT INTO `shop` VALUES (9, 47, '古风雅韵', '主打古风设计的中档汉服店铺。我们专注于古风设计，将传统元素与现代审美相结合，打造出具有浓郁古风韵味的汉服。我们的设计师深入研究古代服饰文化，确保每一款汉服都能展现出古典的美感和现代的时尚。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop9.webp', '广州市越秀区', '13700137009', '中档（400-700）', '2026-01-09 10:00:00', '2026-01-09 10:00:00');

-- 商家6 (枕霞, id=48): 2个店铺 - 普通档+中档
INSERT INTO `shop` VALUES (6, 48, '雅韵汉服', '优雅韵味的汉服店铺，价格适中。我们的汉服设计注重优雅的气质和传统的韵味，每一件都能展现出穿着者的古典美。我们选用优质面料，精心制作，让您在各种场合都能展现出独特的魅力。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop6.webp', '南京市玄武区', '13400134006', '普通档（0-400）', '2026-01-06 10:00:00', '2026-01-06 10:00:00');
INSERT INTO `shop` VALUES (10, 48, '汉衣坊', '传统工艺制作的中档汉服店铺。我们坚持使用传统工艺制作汉服，每一件都经过精心的手工制作。我们的工匠师傅拥有丰富的经验，能够将传统工艺与现代需求相结合，打造出既传统又实用的汉服。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop10.webp', '深圳市南山区', '13600136010', '中档（400-700）', '2026-01-10 10:00:00', '2026-01-10 10:00:00');

-- 商家7 (听雨, id=49): 1个店铺 - 中高档
INSERT INTO `shop` VALUES (11, 49, '华裳九州', '中高端汉服品牌，设计独特。我们是一家专注于高端汉服设计的品牌，每一件汉服都由专业设计师精心设计，具有独特的风格和创意。我们选用高品质面料，结合传统工艺和现代设计，打造出既美观又舒适的高端汉服。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop11.webp', '北京市朝阳区', '13800138011', '中高档（700-1000）', '2026-01-11 10:00:00', '2026-01-11 10:00:00');

-- 商家8 (裁月, id=50): 1个店铺 - 中高档
INSERT INTO `shop` VALUES (12, 50, '礼乐衣冠', '注重礼仪文化的中高端汉服店铺。我们专注于礼仪文化，提供符合传统礼仪规范的汉服。我们的汉服设计参考了大量历史文献和文物，确保每一件都符合传统礼仪要求，让您在各种礼仪场合都能展现出得体的形象。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop12.webp', '上海市黄浦区', '13900139012', '中高档（700-1000）', '2026-01-12 10:00:00', '2026-01-12 10:00:00');

-- 商家9 (清商, id=51): 1个店铺 - 中高档
INSERT INTO `shop` VALUES (13, 51, '盛世华服', '重现盛世风采的中高端汉服品牌。我们致力于重现古代盛世的服饰风采，每一件汉服都参考了历史上的经典款式。我们的设计师深入研究各个朝代的服饰特点，结合现代工艺，打造出既具有历史感又适合现代穿着的高端汉服。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop13.webp', '杭州市余杭区', '13700137013', '中高档（700-1000）', '2026-01-13 10:00:00', '2026-01-13 10:00:00');

-- 商家10 (栖霞, id=52): 1个店铺 - 中高档
INSERT INTO `shop` VALUES (14, 52, '古风堂', '古典风格的中高端汉服店铺。我们专注于古典风格的汉服设计，每一件都体现了传统服饰的精髓。我们的汉服采用传统工艺制作，面料选用高品质的丝绸和棉麻，确保穿着舒适且具有古典美感。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop14.webp', '苏州市姑苏区', '13600136014', '中高档（700-1000）', '2026-01-14 10:00:00', '2026-01-14 10:00:00');

-- 商家11 (拾花, id=53): 1个店铺 - 高档
INSERT INTO `shop` VALUES (15, 53, '皇家织造', '顶级汉服定制店铺，工艺精湛。我们是一家专注于高端汉服定制的店铺，拥有精湛的传统工艺和丰富的定制经验。每一件汉服都由资深工匠手工制作，从面料选择到细节处理，都体现了我们对品质的极致追求，为您打造独一无二的专属汉服。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop15.webp', '北京市西城区', '13800138015', '高档（1000以上）', '2026-01-15 10:00:00', '2026-01-15 10:00:00');

-- 商家12 (云想, id=54): 1个店铺 - 高档
INSERT INTO `shop` VALUES (16, 54, '御品华服', '皇室风格的高档汉服品牌。我们专注于皇室风格的汉服设计，每一件都体现了皇家的尊贵与典雅。我们选用最优质的面料，采用传统工艺制作，为您打造出具有皇室风范的高端汉服，让您在各种场合都能展现出非凡的气质。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop16.webp', '上海市徐汇区', '13900139016', '高档（1000以上）', '2026-01-16 10:00:00', '2026-01-16 10:00:00');

-- 商家13 (未央, id=55): 1个店铺 - 高档
INSERT INTO `shop` VALUES (17, 55, '天衣无缝', '顶级工艺的高档汉服定制店铺。我们以顶级工艺著称，每一件汉服都由经验丰富的工匠手工制作，确保每一个细节都完美无瑕。我们选用最优质的面料，结合传统工艺和现代技术，为您打造出独一无二的高端定制汉服，展现您的独特品味和气质。', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/shop17.webp', '杭州市西湖区', '13700137017', '高档（1000以上）', '2026-01-17 10:00:00', '2026-01-17 10:00:00');


-- ----------------------------
-- Table structure for shop_review
-- ----------------------------
DROP TABLE IF EXISTS `shop_review`;
CREATE TABLE `shop_review` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `shop_id` bigint NOT NULL COMMENT '店铺ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `rating` double NOT NULL COMMENT '评分(1-5)',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评价内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `average_rating` double NOT NULL COMMENT '平均评分',
  `rating1` int NOT NULL COMMENT '1星评价数',
  `rating2` int NOT NULL COMMENT '2星评价数',
  `rating3` int NOT NULL COMMENT '3星评价数',
  `rating4` int NOT NULL COMMENT '4星评价数',
  `rating5` int NOT NULL COMMENT '5星评价数',
  `review_count` int NOT NULL COMMENT '评价总数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `shop_id`(`shop_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `shop_review_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `shop_review_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 423 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '店铺评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop_review - 店铺1 (汉服小铺)
-- ----------------------------
INSERT INTO `shop_review` VALUES (1, 1, 2, 5.0, '汉服质量很好，款式也很喜欢，客服态度也很棒！', '2026-01-15 10:00:00', '2026-01-15 10:00:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (2, 1, 4, 4.0, '衣服面料很舒服，做工也不错，值得购买。', '2026-01-16 14:30:00', '2026-01-16 14:30:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (3, 1, 5, 5.0, '款式很符合我的预期，穿起来很合身，推荐！', '2026-01-17 09:15:00', '2026-01-17 09:15:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (4, 1, 6, 3.0, '评价内容', '2026-01-18 16:45:00', '2026-01-18 16:45:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (5, 1, 7, 4.0, '发货速度很快，包装也很仔细，满意。', '2026-01-19 11:20:00', '2026-01-19 11:20:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (6, 1, 8, 5.0, '评价内容', '2026-01-20 13:10:00', '2026-01-20 13:10:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (7, 1, 9, 4.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-01-21 15:50:00', '2026-01-21 15:50:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (8, 1, 10, 4.0, '衣服款式多样，选择余地大，服务态度好。', '2026-01-22 10:30:00', '2026-01-22 10:30:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (9, 1, 11, 5.0, '汉服质量超出预期，穿着舒适，很满意。', '2026-01-23 14:00:00', '2026-01-23 14:00:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (10, 1, 12, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-01-24 09:45:00', '2026-01-24 09:45:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (11, 1, 13, 5.0, '衣服做工精细，细节处理到位，值得信赖。', '2026-01-25 16:20:00', '2026-01-25 16:20:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (12, 1, 14, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-01-26 11:00:00', '2026-01-26 11:00:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (13, 1, 15, 5.0, '款式时尚，质量上乘，穿着很有气质。', '2026-01-27 13:45:00', '2026-01-27 13:45:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (14, 1, 16, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 10:15:00', '2026-01-28 10:15:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (15, 1, 17, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 14:30:00', '2026-01-29 14:30:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (16, 1, 18, 3.0, '衣服款式不错，但面料稍显一般。', '2026-01-30 09:30:00', '2026-01-30 09:30:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (17, 1, 19, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-31 16:00:00', '2026-01-31 16:00:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (18, 1, 20, 5.0, '汉服质量很好，款式新颖，很喜欢。', '2026-02-01 11:45:00', '2026-02-01 11:45:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (19, 1, 21, 4.0, '客服态度好，衣服尺码准，穿着合身。', '2026-02-02 14:15:00', '2026-02-02 14:15:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (20, 1, 22, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-03 10:00:00', '2026-02-03 10:00:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (21, 1, 23, 3.0, '评价内容', '2026-02-04 16:30:00', '2026-02-04 16:30:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (22, 1, 24, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-05 11:15:00', '2026-02-05 11:15:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (23, 1, 25, 5.0, '衣服质量很好，款式时尚，推荐购买。', '2026-02-06 13:50:00', '2026-02-06 13:50:00', 4.4, 0, 0, 3, 8, 12, 23);
INSERT INTO `shop_review` VALUES (24, 1, 26, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-07 10:20:00', '2026-02-07 10:20:00', 4.4, 0, 0, 3, 8, 12, 23);

-- ----------------------------
-- Records of shop_review - 店铺2 (霓裳羽衣)
-- ----------------------------
INSERT INTO `shop_review` VALUES (25, 2, 10, 5.0, '款式新颖，面料舒适，穿着很有气质。', '2026-01-15 10:30:00', '2026-01-15 10:30:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (26, 2, 11, 4.0, '客服很耐心，解答了我很多问题，衣服质量也不错。', '2026-01-16 15:00:00', '2026-01-16 15:00:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (27, 2, 12, 5.0, '包装很精美，衣服做工精细，很满意。', '2026-01-17 10:20:00', '2026-01-17 10:20:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (28, 2, 13, 4.0, '评价内容', '2026-01-18 17:00:00', '2026-01-18 17:00:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (29, 2, 14, 5.0, '衣服版型很好，穿起来很修身，推荐给大家。', '2026-01-19 12:00:00', '2026-01-19 12:00:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (30, 2, 15, 3.0, '评价内容', '2026-01-20 14:00:00', '2026-01-20 14:00:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (31, 2, 16, 4.0, '发货速度快，物流给力，衣服质量也很好。', '2026-01-21 16:30:00', '2026-01-21 16:30:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (32, 2, 17, 4.0, '衣服款式时尚，面料舒适，穿着很有气质。', '2026-01-22 11:00:00', '2026-01-22 11:00:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (33, 2, 18, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 14:30:00', '2026-01-23 14:30:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (34, 2, 19, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 10:00:00', '2026-01-24 10:00:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (35, 2, 20, 5.0, '衣服版型很好，穿起来很修身，推荐购买。', '2026-01-25 16:30:00', '2026-01-25 16:30:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (36, 2, 21, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 11:30:00', '2026-01-26 11:30:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (37, 2, 22, 5.0, '衣服质量很好，款式新颖，很喜欢。', '2026-01-27 14:00:00', '2026-01-27 14:00:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (38, 2, 23, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 10:30:00', '2026-01-28 10:30:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (39, 2, 24, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 15:00:00', '2026-01-29 15:00:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (40, 2, 25, 3.0, '衣服款式不错，但面料稍显一般。', '2026-01-30 10:15:00', '2026-01-30 10:15:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (41, 2, 26, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-01-31 16:15:00', '2026-01-31 16:15:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (42, 2, 27, 5.0, '衣服质量很好，款式时尚，推荐购买。', '2026-02-01 11:45:00', '2026-02-01 11:45:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (43, 2, 28, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-02 14:45:00', '2026-02-02 14:45:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (44, 2, 29, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-03 10:45:00', '2026-02-03 10:45:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (45, 2, 30, 3.0, '评价内容', '2026-02-04 16:45:00', '2026-02-04 16:45:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (46, 2, 31, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-02-05 11:30:00', '2026-02-05 11:30:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (47, 2, 32, 5.0, '汉服质量很好，款式新颖，很喜欢。', '2026-02-06 14:20:00', '2026-02-06 14:20:00', 4.3, 0, 0, 3, 9, 11, 23);
INSERT INTO `shop_review` VALUES (48, 2, 33, 4.0, '客服态度好，衣服尺码准，穿着合身。', '2026-02-07 10:50:00', '2026-02-07 10:50:00', 4.3, 0, 0, 3, 9, 11, 23);

-- ----------------------------
-- Records of shop_review - 店铺3 (汉风堂)
-- ----------------------------
INSERT INTO `shop_review` VALUES (49, 3, 17, 5.0, '传统款式很正宗，面料舒适，做工精细。', '2026-01-15 11:00:00', '2026-01-15 11:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (50, 3, 18, 4.0, '客服态度很好，衣服尺码很准，穿着合身。', '2026-01-16 15:30:00', '2026-01-16 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (51, 3, 19, 5.0, '性价比很高，这个价格能买到这样的传统汉服很划算。', '2026-01-17 11:00:00', '2026-01-17 11:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (52, 3, 20, 4.0, '评价内容', '2026-01-18 17:30:00', '2026-01-18 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (53, 3, 21, 5.0, '衣服颜色很正，绣花很精美，很喜欢。', '2026-01-19 12:30:00', '2026-01-19 12:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (54, 3, 22, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-20 14:30:00', '2026-01-20 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (55, 3, 23, 5.0, '评价内容', '2026-01-21 17:00:00', '2026-01-21 17:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (56, 3, 24, 4.0, '传统款式很正宗，面料舒适，穿着很有气质。', '2026-01-22 11:30:00', '2026-01-22 11:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (57, 3, 25, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 15:00:00', '2026-01-23 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (58, 3, 26, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 10:30:00', '2026-01-24 10:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (59, 3, 27, 5.0, '衣服颜色很正，绣花很精美，很喜欢。', '2026-01-25 16:45:00', '2026-01-25 16:45:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (60, 3, 28, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 12:00:00', '2026-01-26 12:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (61, 3, 29, 5.0, '衣服质量很好，款式传统，很正宗。', '2026-01-27 14:30:00', '2026-01-27 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (62, 3, 30, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 11:00:00', '2026-01-28 11:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (63, 3, 31, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 15:30:00', '2026-01-29 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (64, 3, 32, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 10:45:00', '2026-01-30 10:45:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (65, 3, 33, 5.0, '衣服颜色很正，绣花很精美，很喜欢。', '2026-01-31 16:30:00', '2026-01-31 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (66, 3, 34, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 12:15:00', '2026-02-01 12:15:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (67, 3, 35, 5.0, '性价比很高，这个价格能买到这样的传统汉服很划算。', '2026-02-02 14:45:00', '2026-02-02 14:45:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (68, 3, 36, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 11:15:00', '2026-02-03 11:15:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (69, 3, 37, 5.0, '衣服质量很好，款式传统，很正宗。', '2026-02-04 16:45:00', '2026-02-04 16:45:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (70, 3, 2, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-02-05 12:30:00', '2026-02-05 12:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (71, 3, 4, 5.0, '衣服颜色很正，绣花很精美，很喜欢。', '2026-02-06 15:00:00', '2026-02-06 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (72, 3, 5, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-02-07 11:30:00', '2026-02-07 11:30:00', 4.6, 0, 0, 0, 8, 15, 23);

-- ----------------------------
-- Records of shop_review - 店铺4 (华服小馆)
-- ----------------------------
INSERT INTO `shop_review` VALUES (73, 4, 24, 5.0, '小而精致的店铺，衣服质量很好，款式也很独特。', '2026-01-15 11:30:00', '2026-01-15 11:30:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (74, 4, 25, 4.0, '客服很热情，衣服做工精细，穿着很舒服。', '2026-01-16 16:00:00', '2026-01-16 16:00:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (75, 4, 26, 5.0, '平价汉服中的精品，质量和款式都很满意。', '2026-01-17 11:30:00', '2026-01-17 11:30:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (76, 4, 27, 4.0, '评价内容', '2026-01-18 18:00:00', '2026-01-18 18:00:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (77, 4, 28, 5.0, '衣服版型很好，适合日常穿着，推荐！', '2026-01-19 13:00:00', '2026-01-19 13:00:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (78, 4, 29, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-20 15:00:00', '2026-01-20 15:00:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (79, 4, 30, 5.0, '评价内容', '2026-01-21 17:30:00', '2026-01-21 17:30:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (80, 4, 31, 4.0, '店铺虽小，但衣服质量很好，款式独特。', '2026-01-22 11:30:00', '2026-01-22 11:30:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (81, 4, 32, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 15:00:00', '2026-01-23 15:00:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (82, 4, 33, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 10:30:00', '2026-01-24 10:30:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (83, 4, 34, 5.0, '衣服版型很好，适合日常穿着，推荐购买。', '2026-01-25 16:45:00', '2026-01-25 16:45:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (84, 4, 35, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 12:00:00', '2026-01-26 12:00:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (85, 4, 36, 5.0, '衣服质量很好，款式独特，很喜欢。', '2026-01-27 14:30:00', '2026-01-27 14:30:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (86, 4, 37, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 11:00:00', '2026-01-28 11:00:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (87, 4, 2, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 15:30:00', '2026-01-29 15:30:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (88, 4, 4, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 10:45:00', '2026-01-30 10:45:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (89, 4, 5, 5.0, '衣服颜色很正，款式独特，很喜欢。', '2026-01-31 16:30:00', '2026-01-31 16:30:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (90, 4, 6, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 12:15:00', '2026-02-01 12:15:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (91, 4, 7, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 14:45:00', '2026-02-02 14:45:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (92, 4, 8, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 11:15:00', '2026-02-03 11:15:00', 4.6, 0, 0, 0, 8, 12, 20);
INSERT INTO `shop_review` VALUES (93, 4, 9, 5.0, '衣服质量很好，款式独特，推荐购买。', '2026-02-04 16:45:00', '2026-02-04 16:45:00', 4.6, 0, 0, 0, 8, 12, 20);

-- ----------------------------
-- Records of shop_review - 店铺5 (汉服世家)
-- ----------------------------
INSERT INTO `shop_review` VALUES (94, 5, 31, 5.0, '家族经营的店铺，衣服质量有保障，服务也很好。', '2026-01-15 12:00:00', '2026-01-15 12:00:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (95, 5, 32, 4.0, '价格实惠，质量不错，性价比很高。', '2026-01-16 16:30:00', '2026-01-16 16:30:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (96, 5, 33, 5.0, '衣服款式经典，面料舒适，穿着很有气质。', '2026-01-17 12:00:00', '2026-01-17 12:00:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (97, 5, 34, 4.0, '评价内容', '2026-01-18 18:30:00', '2026-01-18 18:30:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (98, 5, 35, 5.0, '客服态度很好，尺码推荐准确，穿着合身。', '2026-01-19 13:30:00', '2026-01-19 13:30:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (99, 5, 36, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-20 15:30:00', '2026-01-20 15:30:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (100, 5, 37, 5.0, '评价内容', '2026-01-21 18:00:00', '2026-01-21 18:00:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (101, 5, 2, 4.0, '家族经营的店铺，服务态度很好，衣服质量也不错。', '2026-01-22 12:00:00', '2026-01-22 12:00:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (102, 5, 4, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 15:30:00', '2026-01-23 15:30:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (103, 5, 5, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 11:00:00', '2026-01-24 11:00:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (104, 5, 6, 5.0, '衣服款式经典，面料舒适，穿着很有气质。', '2026-01-25 17:00:00', '2026-01-25 17:00:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (105, 5, 7, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 12:30:00', '2026-01-26 12:30:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (106, 5, 8, 5.0, '衣服质量很好，款式经典，很喜欢。', '2026-01-27 15:00:00', '2026-01-27 15:00:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (107, 5, 9, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 11:30:00', '2026-01-28 11:30:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (108, 5, 10, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 16:00:00', '2026-01-29 16:00:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (109, 5, 11, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 11:45:00', '2026-01-30 11:45:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (120, 5, 12, 5.0, '衣服颜色很正，款式经典，很喜欢。', '2026-01-31 16:30:00', '2026-01-31 16:30:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (121, 5, 13, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 12:45:00', '2026-02-01 12:45:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (122, 5, 14, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 15:15:00', '2026-02-02 15:15:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (123, 5, 15, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 11:30:00', '2026-02-03 11:30:00', 4.5, 0, 0, 0, 9, 11, 20);
INSERT INTO `shop_review` VALUES (124, 5, 16, 5.0, '衣服质量很好，款式经典，推荐购买。', '2026-02-04 16:45:00', '2026-02-04 16:45:00', 4.5, 0, 0, 0, 9, 11, 20);

-- ----------------------------
-- Records of shop_review - 店铺6 (雅韵汉服)
-- ----------------------------
INSERT INTO `shop_review` VALUES (125, 6, 2, 5.0, '优雅韵味的汉服，穿着很有气质，质量也很好。', '2026-01-15 12:30:00', '2026-01-15 12:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (126, 6, 4, 4.0, '价格适中，质量不错，款式也很优雅。', '2026-01-16 17:00:00', '2026-01-16 17:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (127, 6, 5, 5.0, '客服态度很好，衣服做工精细，很满意。', '2026-01-17 12:30:00', '2026-01-17 12:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (128, 6, 6, 4.0, '评价内容', '2026-01-18 19:00:00', '2026-01-18 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (129, 6, 7, 5.0, '衣服颜色很漂亮，面料舒适，穿着很舒服。', '2026-01-19 14:00:00', '2026-01-19 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (130, 6, 8, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-20 16:00:00', '2026-01-20 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (131, 6, 9, 5.0, '评价内容', '2026-01-21 18:30:00', '2026-01-21 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (132, 6, 10, 4.0, '优雅韵味的汉服，穿着很有气质，质量也很好。', '2026-01-22 12:30:00', '2026-01-22 12:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (133, 6, 11, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 16:00:00', '2026-01-23 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (134, 6, 12, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 12:00:00', '2026-01-24 12:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (135, 6, 13, 5.0, '衣服颜色很漂亮，面料舒适，穿着很舒服。', '2026-01-25 16:30:00', '2026-01-25 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (136, 6, 14, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 12:30:00', '2026-01-26 12:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (137, 6, 15, 5.0, '衣服质量很好，款式优雅，很喜欢。', '2026-01-27 16:00:00', '2026-01-27 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (138, 6, 16, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 12:00:00', '2026-01-28 12:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (139, 6, 17, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 16:30:00', '2026-01-29 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (140, 6, 18, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 12:30:00', '2026-01-30 12:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (141, 6, 19, 5.0, '衣服颜色很漂亮，款式优雅，很喜欢。', '2026-01-31 16:00:00', '2026-01-31 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (142, 6, 20, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 12:00:00', '2026-02-01 12:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (143, 6, 21, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 16:30:00', '2026-02-02 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (144, 6, 22, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 12:30:00', '2026-02-03 12:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (145, 6, 23, 5.0, '衣服质量很好，款式优雅，推荐购买。', '2026-02-04 16:00:00', '2026-02-04 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (146, 6, 24, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-02-05 12:00:00', '2026-02-05 12:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (147, 6, 25, 5.0, '衣服颜色很漂亮，面料舒适，穿着很舒服。', '2026-02-06 16:30:00', '2026-02-06 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (148, 6, 26, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-02-07 12:30:00', '2026-02-07 12:30:00', 4.6, 0, 0, 0, 8, 15, 23);

-- ----------------------------
-- Records of shop_review - 店铺7 (汉唐华服)
-- ----------------------------
INSERT INTO `shop_review` VALUES (149, 7, 10, 5.0, '中等价位，做工精细，款式传统，很喜欢。', '2026-01-15 13:00:00', '2026-01-15 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (150, 7, 11, 4.0, '客服很专业，衣服质量很好，值得购买。', '2026-01-16 17:30:00', '2026-01-16 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (151, 7, 12, 5.0, '传统与现代结合的设计，穿着很有特色。', '2026-01-17 13:00:00', '2026-01-17 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (152, 7, 13, 4.0, '评价内容', '2026-01-18 19:30:00', '2026-01-18 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (153, 7, 14, 5.0, '面料很好，做工精细，穿着很舒适。', '2026-01-19 14:30:00', '2026-01-19 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (154, 7, 15, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-20 16:30:00', '2026-01-20 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (155, 7, 16, 5.0, '评价内容', '2026-01-21 19:00:00', '2026-01-21 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (156, 7, 17, 4.0, '中等价位，做工精细，款式传统，很喜欢。', '2026-01-22 13:00:00', '2026-01-22 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (157, 7, 18, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 17:30:00', '2026-01-23 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (158, 7, 19, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 13:00:00', '2026-01-24 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (159, 7, 20, 5.0, '传统与现代结合的设计，穿着很有特色。', '2026-01-25 17:30:00', '2026-01-25 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (160, 7, 21, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 13:00:00', '2026-01-26 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (161, 7, 22, 5.0, '面料很好，做工精细，穿着很舒适。', '2026-01-27 17:30:00', '2026-01-27 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (162, 7, 23, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 13:00:00', '2026-01-28 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (163, 7, 24, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 17:30:00', '2026-01-29 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (164, 7, 25, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 13:00:00', '2026-01-30 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (165, 7, 26, 5.0, '传统与现代结合的设计，穿着很有特色。', '2026-01-31 17:30:00', '2026-01-31 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (166, 7, 27, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 13:00:00', '2026-02-01 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (167, 7, 28, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 17:30:00', '2026-02-02 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (168, 7, 29, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 13:00:00', '2026-02-03 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (169, 7, 30, 5.0, '面料很好，做工精细，穿着很舒适。', '2026-02-04 17:30:00', '2026-02-04 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (170, 7, 31, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-02-05 13:00:00', '2026-02-05 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (171, 7, 32, 5.0, '传统与现代结合的设计，穿着很有特色。', '2026-02-06 17:30:00', '2026-02-06 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (172, 7, 33, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-02-07 13:00:00', '2026-02-07 13:00:00', 4.6, 0, 0, 0, 8, 15, 23);

-- ----------------------------
-- Records of shop_review - 店铺8 (锦绣坊)
-- ----------------------------
INSERT INTO `shop_review` VALUES (173, 8, 17, 5.0, '绣花很精美，做工精细，衣服质量很好。', '2026-01-15 13:30:00', '2026-01-15 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (174, 8, 18, 4.0, '客服态度很好，衣服尺码很准，穿着合身。', '2026-01-16 18:00:00', '2026-01-16 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (175, 8, 19, 5.0, '绣花图案很漂亮，面料舒适，穿着很有气质。', '2026-01-17 13:30:00', '2026-01-17 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (176, 8, 20, 4.0, '评价内容', '2026-01-18 20:00:00', '2026-01-18 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (177, 8, 21, 5.0, '衣服做工精细，绣花精美，很满意。', '2026-01-19 15:00:00', '2026-01-19 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (178, 8, 22, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-20 17:00:00', '2026-01-20 17:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (179, 8, 23, 5.0, '评价内容', '2026-01-21 19:30:00', '2026-01-21 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (180, 8, 24, 4.0, '绣花很精美，做工精细，衣服质量很好。', '2026-01-22 13:30:00', '2026-01-22 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (190, 8, 25, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 18:00:00', '2026-01-23 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (191, 8, 26, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 13:30:00', '2026-01-24 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (192, 8, 27, 5.0, '绣花图案很漂亮，面料舒适，穿着很有气质。', '2026-01-25 18:00:00', '2026-01-25 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (193, 8, 28, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 13:30:00', '2026-01-26 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (194, 8, 29, 5.0, '衣服做工精细，绣花精美，很满意。', '2026-01-27 18:00:00', '2026-01-27 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (195, 8, 30, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 13:30:00', '2026-01-28 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (196, 8, 31, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 18:00:00', '2026-01-29 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (197, 8, 32, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 13:30:00', '2026-01-30 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (198, 8, 33, 5.0, '绣花图案很漂亮，面料舒适，穿着很有气质。', '2026-01-31 18:00:00', '2026-01-31 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (199, 8, 34, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 13:30:00', '2026-02-01 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (200, 8, 35, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 18:00:00', '2026-02-02 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (201, 8, 36, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 13:30:00', '2026-02-03 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (202, 8, 37, 5.0, '衣服做工精细，绣花精美，很满意。', '2026-02-04 18:00:00', '2026-02-04 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (203, 8, 2, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-02-05 13:30:00', '2026-02-05 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (204, 8, 4, 5.0, '绣花很精美，做工精细，衣服质量很好。', '2026-02-06 18:00:00', '2026-02-06 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (205, 8, 5, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-02-07 13:30:00', '2026-02-07 13:30:00', 4.6, 0, 0, 0, 8, 15, 23);

-- ----------------------------
-- Records of shop_review - 店铺9 (古风雅韵)
-- ----------------------------
INSERT INTO `shop_review` VALUES (206, 9, 24, 5.0, '古风设计很独特，衣服质量很好，穿着很有气质。', '2026-01-15 14:00:00', '2026-01-15 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (207, 9, 25, 4.0, '客服很热情，衣服做工精细，款式新颖。', '2026-01-16 18:30:00', '2026-01-16 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (208, 9, 26, 5.0, '古风韵味十足，面料舒适，穿着很舒服。', '2026-01-17 14:00:00', '2026-01-17 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (209, 9, 27, 4.0, '评价内容', '2026-01-18 20:30:00', '2026-01-18 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (210, 9, 28, 5.0, '衣服设计很有创意，质量很好，推荐！', '2026-01-19 15:30:00', '2026-01-19 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (211, 9, 29, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-20 17:30:00', '2026-01-20 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (212, 9, 30, 5.0, '评价内容', '2026-01-21 20:00:00', '2026-01-21 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (213, 9, 31, 4.0, '古风设计很独特，衣服质量很好，穿着很有气质。', '2026-01-22 14:00:00', '2026-01-22 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (214, 9, 32, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 18:30:00', '2026-01-23 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (215, 9, 33, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 14:00:00', '2026-01-24 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (216, 9, 34, 5.0, '古风韵味十足，面料舒适，穿着很舒服。', '2026-01-25 18:30:00', '2026-01-25 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (217, 9, 35, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 14:00:00', '2026-01-26 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (218, 9, 36, 5.0, '衣服设计很有创意，质量很好，推荐！', '2026-01-27 18:30:00', '2026-01-27 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (219, 9, 37, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 14:00:00', '2026-01-28 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (220, 9, 2, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 18:30:00', '2026-01-29 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (221, 9, 4, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 14:00:00', '2026-01-30 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (222, 9, 5, 5.0, '古风韵味十足，面料舒适，穿着很舒服。', '2026-01-31 18:30:00', '2026-01-31 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (223, 9, 6, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 14:00:00', '2026-02-01 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (224, 9, 7, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 18:30:00', '2026-02-02 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (225, 9, 8, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 14:00:00', '2026-02-03 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (226, 9, 9, 5.0, '衣服设计很有创意，质量很好，推荐购买。', '2026-02-04 18:30:00', '2026-02-04 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (227, 9, 10, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-02-05 14:00:00', '2026-02-05 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (228, 9, 11, 5.0, '古风设计很独特，衣服质量很好，穿着很有气质。', '2026-02-06 18:30:00', '2026-02-06 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (229, 9, 12, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-02-07 14:00:00', '2026-02-07 14:00:00', 4.6, 0, 0, 0, 8, 15, 23);

-- ----------------------------
-- Records of shop_review - 店铺10 (汉衣坊)
-- ----------------------------
INSERT INTO `shop_review` VALUES (230, 10, 31, 5.0, '传统工艺制作，衣服质量很好，款式经典。', '2026-01-15 14:30:00', '2026-01-15 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (231, 10, 32, 4.0, '客服态度很好，衣服做工精细，穿着舒适。', '2026-01-16 19:00:00', '2026-01-16 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (232, 10, 33, 5.0, '传统工艺与现代需求结合，很实用。', '2026-01-17 14:30:00', '2026-01-17 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (233, 10, 34, 4.0, '评价内容', '2026-01-18 21:00:00', '2026-01-18 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (234, 10, 35, 5.0, '衣服质量很好，款式经典，值得购买。', '2026-01-19 16:00:00', '2026-01-19 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (235, 10, 36, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-20 18:00:00', '2026-01-20 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (236, 10, 37, 5.0, '评价内容', '2026-01-21 20:30:00', '2026-01-21 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (237, 10, 2, 4.0, '传统工艺制作，衣服质量很好，款式经典。', '2026-01-22 14:30:00', '2026-01-22 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (238, 10, 4, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 19:00:00', '2026-01-23 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (239, 10, 5, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 14:30:00', '2026-01-24 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (240, 10, 6, 5.0, '传统工艺与现代需求结合，很实用。', '2026-01-25 19:00:00', '2026-01-25 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (241, 10, 7, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 14:30:00', '2026-01-26 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (242, 10, 8, 5.0, '衣服质量很好，款式经典，值得购买。', '2026-01-27 19:00:00', '2026-01-27 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (243, 10, 9, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 14:30:00', '2026-01-28 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (244, 10, 10, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 19:00:00', '2026-01-29 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (245, 10, 11, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 14:30:00', '2026-01-30 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (246, 10, 12, 5.0, '传统工艺与现代需求结合，很实用。', '2026-01-31 19:00:00', '2026-01-31 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (247, 10, 13, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 14:30:00', '2026-02-01 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (248, 10, 14, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 19:00:00', '2026-02-02 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (249, 10, 15, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 14:30:00', '2026-02-03 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (250, 10, 16, 5.0, '衣服质量很好，款式经典，推荐购买。', '2026-02-04 19:00:00', '2026-02-04 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (251, 10, 17, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-02-05 14:30:00', '2026-02-05 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (252, 10, 18, 5.0, '传统工艺制作，衣服质量很好，款式经典。', '2026-02-06 19:00:00', '2026-02-06 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (253, 10, 19, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-02-07 14:30:00', '2026-02-07 14:30:00', 4.6, 0, 0, 0, 8, 15, 23);

-- ----------------------------
-- Records of shop_review - 店铺11 (华裳九州)
-- ----------------------------
INSERT INTO `shop_review` VALUES (254, 11, 2, 5.0, '中高端品牌，设计独特，质量很好，很喜欢。', '2026-01-15 15:00:00', '2026-01-15 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (255, 11, 4, 4.0, '客服很专业，衣服做工精细，穿着很有气质。', '2026-01-16 19:30:00', '2026-01-16 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (256, 11, 5, 5.0, '设计独特，面料优质，穿着舒适，推荐！', '2026-01-17 15:00:00', '2026-01-17 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (257, 11, 6, 4.0, '评价内容', '2026-01-18 21:30:00', '2026-01-18 21:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (258, 11, 7, 5.0, '高端汉服的代表，质量和设计都很出色。', '2026-01-19 16:30:00', '2026-01-19 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (259, 11, 8, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-20 18:30:00', '2026-01-20 18:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (260, 11, 9, 5.0, '评价内容', '2026-01-21 21:00:00', '2026-01-21 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (261, 11, 10, 4.0, '中高端品牌，设计独特，质量很好，很喜欢。', '2026-01-22 15:00:00', '2026-01-22 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (262, 11, 11, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 19:30:00', '2026-01-23 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (263, 11, 12, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 15:00:00', '2026-01-24 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (264, 11, 13, 5.0, '设计独特，面料优质，穿着舒适，推荐！', '2026-01-25 19:30:00', '2026-01-25 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (265, 11, 14, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 15:00:00', '2026-01-26 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (266, 11, 15, 5.0, '高端汉服的代表，质量和设计都很出色。', '2026-01-27 19:30:00', '2026-01-27 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (267, 11, 16, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 15:00:00', '2026-01-28 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (268, 11, 17, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 19:30:00', '2026-01-29 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (269, 11, 18, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 15:00:00', '2026-01-30 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (270, 11, 19, 5.0, '设计独特，面料优质，穿着舒适，推荐！', '2026-01-31 19:30:00', '2026-01-31 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (271, 11, 20, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 15:00:00', '2026-02-01 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (272, 11, 21, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 19:30:00', '2026-02-02 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (273, 11, 22, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 15:00:00', '2026-02-03 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (274, 11, 23, 5.0, '高端汉服的代表，质量和设计都很出色。', '2026-02-04 19:30:00', '2026-02-04 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (275, 11, 24, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-02-05 15:00:00', '2026-02-05 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (276, 11, 25, 5.0, '中高端品牌，设计独特，质量很好，很喜欢。', '2026-02-06 19:30:00', '2026-02-06 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (277, 11, 26, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-02-07 15:00:00', '2026-02-07 15:00:00', 4.6, 0, 0, 0, 8, 15, 23);

-- ----------------------------
-- Records of shop_review - 店铺12 (礼乐衣冠)
-- ----------------------------
INSERT INTO `shop_review` VALUES (278, 12, 10, 5.0, '注重礼仪文化，衣服设计符合传统规范，质量很好。', '2026-01-15 15:30:00', '2026-01-15 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (279, 12, 11, 4.0, '客服很专业，讲解礼仪知识，衣服质量也很好。', '2026-01-16 20:00:00', '2026-01-16 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (280, 12, 12, 5.0, '传统礼仪文化的代表，衣服质量和设计都很出色。', '2026-01-17 15:30:00', '2026-01-17 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (281, 12, 13, 4.0, '评价内容', '2026-01-18 22:00:00', '2026-01-18 22:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (282, 12, 14, 5.0, '衣服设计符合传统礼仪，穿着很得体，推荐！', '2026-01-19 17:00:00', '2026-01-19 17:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (283, 12, 15, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-20 19:00:00', '2026-01-20 19:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (284, 12, 16, 5.0, '评价内容', '2026-01-21 21:30:00', '2026-01-21 21:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (285, 12, 17, 4.0, '注重礼仪文化，衣服设计符合传统规范，质量很好。', '2026-01-22 15:30:00', '2026-01-22 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (286, 12, 18, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 20:00:00', '2026-01-23 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (287, 12, 19, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 15:30:00', '2026-01-24 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (288, 12, 20, 5.0, '传统礼仪文化的代表，衣服质量和设计都很出色。', '2026-01-25 20:00:00', '2026-01-25 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (289, 12, 21, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 15:30:00', '2026-01-26 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (290, 12, 22, 5.0, '衣服设计符合传统礼仪，穿着很得体，推荐！', '2026-01-27 20:00:00', '2026-01-27 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (291, 12, 23, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 15:30:00', '2026-01-28 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (292, 12, 24, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 20:00:00', '2026-01-29 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (293, 12, 25, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 15:30:00', '2026-01-30 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (294, 12, 26, 5.0, '传统礼仪文化的代表，衣服质量和设计都很出色。', '2026-01-31 20:00:00', '2026-01-31 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (295, 12, 27, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 15:30:00', '2026-02-01 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (296, 12, 28, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 20:00:00', '2026-02-02 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (297, 12, 29, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 15:30:00', '2026-02-03 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (298, 12, 30, 5.0, '衣服设计符合传统礼仪，穿着很得体，推荐购买。', '2026-02-04 20:00:00', '2026-02-04 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (299, 12, 31, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-02-05 15:30:00', '2026-02-05 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (300, 12, 32, 5.0, '注重礼仪文化，衣服设计符合传统规范，质量很好。', '2026-02-06 20:00:00', '2026-02-06 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (301, 12, 33, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-02-07 15:30:00', '2026-02-07 15:30:00', 4.6, 0, 0, 0, 8, 15, 23);

-- ----------------------------
-- Records of shop_review - 店铺13 (盛世华服)
-- ----------------------------
INSERT INTO `shop_review` VALUES (302, 13, 17, 5.0, '重现盛世风采，衣服设计大气，质量很好。', '2026-01-15 16:00:00', '2026-01-15 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (303, 13, 18, 4.0, '客服态度很好，衣服做工精细，穿着很有气质。', '2026-01-16 20:30:00', '2026-01-16 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (304, 13, 19, 5.0, '盛世华服的代表，设计大气，质量上乘。', '2026-01-17 16:00:00', '2026-01-17 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (305, 13, 20, 4.0, '评价内容', '2026-01-18 22:30:00', '2026-01-18 22:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (306, 13, 21, 5.0, '衣服设计大气磅礴，面料优质，穿着舒适。', '2026-01-19 17:30:00', '2026-01-19 17:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (307, 13, 22, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-20 19:30:00', '2026-01-20 19:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (308, 13, 23, 5.0, '评价内容', '2026-01-21 22:00:00', '2026-01-21 22:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (309, 13, 24, 4.0, '重现盛世风采，衣服设计大气，质量很好。', '2026-01-22 16:00:00', '2026-01-22 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (310, 13, 25, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 20:30:00', '2026-01-23 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (311, 13, 26, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 16:00:00', '2026-01-24 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (312, 13, 27, 5.0, '盛世华服的代表，设计大气，质量上乘。', '2026-01-25 20:30:00', '2026-01-25 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (313, 13, 28, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 16:00:00', '2026-01-26 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (314, 13, 29, 5.0, '衣服设计大气磅礴，面料优质，穿着舒适。', '2026-01-27 20:30:00', '2026-01-27 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (315, 13, 30, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 16:00:00', '2026-01-28 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (316, 13, 31, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 20:30:00', '2026-01-29 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (317, 13, 32, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 16:00:00', '2026-01-30 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (318, 13, 33, 5.0, '盛世华服的代表，设计大气，质量上乘。', '2026-01-31 20:30:00', '2026-01-31 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (319, 13, 34, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 16:00:00', '2026-02-01 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (320, 13, 35, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 20:30:00', '2026-02-02 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (321, 13, 36, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 16:00:00', '2026-02-03 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (322, 13, 37, 5.0, '衣服设计大气磅礴，面料优质，穿着舒适。', '2026-02-04 20:30:00', '2026-02-04 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (323, 13, 2, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-02-05 16:00:00', '2026-02-05 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (324, 13, 4, 5.0, '重现盛世风采，衣服设计大气，质量很好。', '2026-02-06 20:30:00', '2026-02-06 20:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (325, 13, 5, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-02-07 16:00:00', '2026-02-07 16:00:00', 4.6, 0, 0, 0, 8, 15, 23);

-- ----------------------------
-- Records of shop_review - 店铺14 (古风堂)
-- ----------------------------
INSERT INTO `shop_review` VALUES (326, 14, 24, 5.0, '古典风格，衣服设计典雅，质量很好。', '2026-01-15 16:30:00', '2026-01-15 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (327, 14, 25, 4.0, '客服态度很好，衣服做工精细，穿着很舒适。', '2026-01-16 21:00:00', '2026-01-16 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (328, 14, 26, 5.0, '古典风格的代表，设计典雅，质量上乘。', '2026-01-17 16:30:00', '2026-01-17 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (329, 14, 27, 4.0, '评价内容', '2026-01-18 23:00:00', '2026-01-18 23:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (330, 14, 28, 5.0, '衣服设计典雅，面料优质，穿着很有气质。', '2026-01-19 18:00:00', '2026-01-19 18:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (331, 14, 29, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-20 20:00:00', '2026-01-20 20:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (332, 14, 30, 5.0, '评价内容', '2026-01-21 22:30:00', '2026-01-21 22:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (333, 14, 31, 4.0, '古典风格，衣服设计典雅，质量很好。', '2026-01-22 16:30:00', '2026-01-22 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (334, 14, 32, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 21:00:00', '2026-01-23 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (335, 14, 33, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-01-24 16:30:00', '2026-01-24 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (336, 14, 34, 5.0, '古典风格的代表，设计典雅，质量上乘。', '2026-01-25 21:00:00', '2026-01-25 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (337, 14, 35, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 16:30:00', '2026-01-26 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (338, 14, 36, 5.0, '衣服设计典雅，面料优质，穿着很有气质。', '2026-01-27 21:00:00', '2026-01-27 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (339, 14, 37, 4.0, '性价比高，质量不错，推荐给朋友了。', '2026-01-28 16:30:00', '2026-01-28 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (340, 14, 6, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 21:00:00', '2026-01-29 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (341, 14, 7, 4.0, '发货速度快，包装仔细，衣服质量不错。', '2026-01-30 16:30:00', '2026-01-30 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (342, 14, 8, 5.0, '古典风格的代表，设计典雅，质量上乘。', '2026-01-31 21:00:00', '2026-01-31 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (343, 14, 9, 4.0, '客服态度好，解答问题耐心，衣服质量不错。', '2026-02-01 16:30:00', '2026-02-01 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (344, 14, 10, 5.0, '性价比很高，这个价格能买到这样的质量很划算。', '2026-02-02 21:00:00', '2026-02-02 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (345, 14, 11, 4.0, '发货速度快，物流给力，衣服包装精美。', '2026-02-03 16:30:00', '2026-02-03 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (346, 14, 12, 5.0, '衣服设计典雅，面料优质，穿着很有气质。', '2026-02-04 21:00:00', '2026-02-04 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (347, 14, 13, 4.0, '客服很耐心，解答了我很多问题，推荐购买。', '2026-02-05 16:30:00', '2026-02-05 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (348, 14, 14, 5.0, '古典风格，衣服设计典雅，质量很好。', '2026-02-06 21:00:00', '2026-02-06 21:00:00', 4.6, 0, 0, 0, 8, 15, 23);
INSERT INTO `shop_review` VALUES (349, 14, 15, 4.0, '发货速度快，包装精美，衣服质量不错。', '2026-02-07 16:30:00', '2026-02-07 16:30:00', 4.6, 0, 0, 0, 8, 15, 23);

-- ----------------------------
-- Records of shop_review - 店铺15 (皇家织造)
-- ----------------------------
INSERT INTO `shop_review` VALUES (350, 15, 31, 5.0, '顶级定制店铺，工艺精湛，衣服质量非常好。', '2026-01-15 17:00:00', '2026-01-15 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (351, 15, 32, 5.0, '定制服务很专业，衣服做工精细，非常满意。', '2026-01-16 21:30:00', '2026-01-16 21:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (352, 15, 33, 5.0, '顶级汉服的代表，工艺精湛，质量上乘。', '2026-01-17 17:00:00', '2026-01-17 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (353, 15, 34, 5.0, '评价内容', '2026-01-18 23:30:00', '2026-01-18 23:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (354, 15, 35, 5.0, '定制的汉服非常合身，做工精湛，很喜欢。', '2026-01-19 18:30:00', '2026-01-19 18:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (355, 15, 36, 5.0, '发货速度快，包装精美，衣服质量非常好。', '2026-01-20 20:30:00', '2026-01-20 20:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (356, 15, 37, 5.0, '评价内容', '2026-01-21 23:00:00', '2026-01-21 23:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (357, 15, 2, 5.0, '顶级定制店铺，工艺精湛，衣服质量非常好。', '2026-01-22 17:00:00', '2026-01-22 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (358, 15, 4, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-23 21:30:00', '2026-01-23 21:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (359, 15, 5, 4.0, '定制服务很专业，衣服做工精细，非常满意。', '2026-01-24 17:00:00', '2026-01-24 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (360, 15, 6, 5.0, '顶级汉服的代表，工艺精湛，质量上乘。', '2026-01-25 21:30:00', '2026-01-25 21:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (361, 15, 7, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-26 17:00:00', '2026-01-26 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (362, 15, 8, 5.0, '定制的汉服非常合身，做工精湛，很喜欢。', '2026-01-27 21:30:00', '2026-01-27 21:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (363, 15, 9, 4.0, '发货速度快，包装精美，衣服质量非常好。', '2026-01-28 17:00:00', '2026-01-28 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (364, 15, 10, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-29 21:30:00', '2026-01-29 21:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (365, 15, 11, 4.0, '顶级定制店铺，工艺精湛，衣服质量非常好。', '2026-01-30 17:00:00', '2026-01-30 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (366, 15, 12, 5.0, '定制服务很专业，衣服做工精细，非常满意。', '2026-01-31 21:30:00', '2026-01-31 21:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (367, 15, 13, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-02-01 17:00:00', '2026-02-01 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (368, 15, 14, 5.0, '顶级汉服的代表，工艺精湛，质量上乘。', '2026-02-02 21:30:00', '2026-02-02 21:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (369, 15, 15, 4.0, '发货速度快，包装精美，衣服质量非常好。', '2026-02-03 17:00:00', '2026-02-03 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (370, 15, 16, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-02-04 21:30:00', '2026-02-04 21:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (371, 15, 17, 4.0, '定制的汉服非常合身，做工精湛，很喜欢。', '2026-02-05 17:00:00', '2026-02-05 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (372, 15, 18, 5.0, '顶级定制店铺，工艺精湛，衣服质量非常好。', '2026-02-06 21:30:00', '2026-02-06 21:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (373, 15, 19, 5.0, '定制服务很专业，衣服做工精细，非常满意。', '2026-02-07 17:00:00', '2026-02-07 17:00:00', 4.8, 0, 0, 0, 4, 19, 23);

-- ----------------------------
-- Records of shop_review - 店铺16 (御品华服)
-- ----------------------------
INSERT INTO `shop_review` VALUES (374, 16, 2, 5.0, '皇室风格，衣服设计尊贵典雅，质量很好。', '2026-01-15 17:30:00', '2026-01-15 17:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (378, 16, 4, 5.0, '客服很专业，衣服做工精细，穿着很有气质。', '2026-01-16 22:00:00', '2026-01-16 22:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (379, 16, 5, 5.0, '皇室风格的代表，设计尊贵，质量上乘。', '2026-01-17 17:30:00', '2026-01-17 17:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (380, 16, 6, 5.0, '评价内容', '2026-01-19 00:00:00', '2026-01-19 00:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (381, 16, 7, 5.0, '衣服设计尊贵典雅，面料优质，穿着舒适。', '2026-01-19 19:00:00', '2026-01-19 19:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (382, 16, 8, 5.0, '发货速度快，包装精美，衣服质量非常好。', '2026-01-20 21:00:00', '2026-01-20 21:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (383, 16, 9, 5.0, '评价内容', '2026-01-21 23:30:00', '2026-01-21 23:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (384, 16, 10, 5.0, '皇室风格，衣服设计尊贵典雅，质量很好。', '2026-01-23 17:30:00', '2026-01-23 17:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (385, 16, 11, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-24 22:00:00', '2026-01-24 22:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (386, 16, 12, 4.0, '客服很专业，衣服做工精细，穿着很有气质。', '2026-01-25 17:30:00', '2026-01-25 17:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (387, 16, 13, 5.0, '皇室风格的代表，设计尊贵，质量上乘。', '2026-01-26 22:00:00', '2026-01-26 22:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (388, 16, 14, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-27 17:30:00', '2026-01-27 17:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (389, 16, 15, 5.0, '衣服设计尊贵典雅，面料优质，穿着舒适。', '2026-01-28 22:00:00', '2026-01-28 22:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (390, 16, 16, 4.0, '发货速度快，包装精美，衣服质量非常好。', '2026-01-29 17:30:00', '2026-01-29 17:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (391, 16, 17, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-30 22:00:00', '2026-01-30 22:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (392, 16, 18, 4.0, '皇室风格，衣服设计尊贵典雅，质量很好。', '2026-01-31 17:30:00', '2026-01-31 17:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (393, 16, 19, 5.0, '客服很专业，衣服做工精细，穿着很有气质。', '2026-02-01 22:00:00', '2026-02-01 22:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (394, 16, 20, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-02-02 17:30:00', '2026-02-02 17:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (395, 16, 21, 5.0, '皇室风格的代表，设计尊贵，质量上乘。', '2026-02-03 22:00:00', '2026-02-03 22:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (396, 16, 22, 4.0, '发货速度快，包装精美，衣服质量非常好。', '2026-02-04 17:30:00', '2026-02-04 17:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (397, 16, 23, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-02-05 22:00:00', '2026-02-05 22:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (398, 16, 24, 4.0, '衣服设计尊贵典雅，面料优质，穿着舒适。', '2026-02-06 17:30:00', '2026-02-06 17:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (399, 16, 25, 5.0, '皇室风格，衣服设计尊贵典雅，质量很好。', '2026-02-07 22:00:00', '2026-02-07 22:00:00', 4.8, 0, 0, 0, 4, 19, 23);

-- ----------------------------
-- Records of shop_review - 店铺17 (天衣无缝)
-- ----------------------------
INSERT INTO `shop_review` VALUES (400, 17, 10, 5.0, '顶级工艺，衣服质量非常好，做工精细。', '2026-01-15 18:00:00', '2026-01-15 18:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (401, 17, 11, 5.0, '定制服务很专业，衣服非常合身，很满意。', '2026-01-16 22:30:00', '2026-01-16 22:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (402, 17, 12, 5.0, '顶级工艺的代表，质量上乘，设计精美。', '2026-01-17 18:00:00', '2026-01-17 18:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (403, 17, 13, 5.0, '评价内容', '2026-01-19 00:30:00', '2026-01-19 00:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (404, 17, 14, 5.0, '衣服做工精细，面料优质，穿着很舒适。', '2026-01-19 19:30:00', '2026-01-19 19:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (405, 17, 15, 5.0, '发货速度快，包装精美，衣服质量非常好。', '2026-01-20 21:30:00', '2026-01-20 21:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (406, 17, 16, 5.0, '评价内容', '2026-01-22 00:00:00', '2026-01-22 00:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (407, 17, 17, 5.0, '顶级工艺，衣服质量非常好，做工精细。', '2026-01-23 18:00:00', '2026-01-23 18:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (408, 17, 18, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-24 22:30:00', '2026-01-24 22:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (409, 17, 19, 4.0, '定制服务很专业，衣服非常合身，很满意。', '2026-01-25 18:00:00', '2026-01-25 18:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (410, 17, 20, 5.0, '顶级工艺的代表，质量上乘，设计精美。', '2026-01-26 22:30:00', '2026-01-26 22:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (411, 17, 21, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-01-27 18:00:00', '2026-01-27 18:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (412, 17, 22, 5.0, '衣服做工精细，面料优质，穿着很舒适。', '2026-01-28 22:30:00', '2026-01-28 22:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (413, 17, 23, 4.0, '发货速度快，包装精美，衣服质量非常好。', '2026-01-29 18:00:00', '2026-01-29 18:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (414, 17, 24, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-01-30 22:30:00', '2026-01-30 22:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (415, 17, 25, 4.0, '顶级工艺，衣服质量非常好，做工精细。', '2026-01-31 18:00:00', '2026-01-31 18:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (416, 17, 26, 5.0, '定制服务很专业，衣服非常合身，很满意。', '2026-02-01 22:30:00', '2026-02-01 22:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (417, 17, 27, 4.0, '客服很耐心，解答了我很多问题，推荐。', '2026-02-02 18:00:00', '2026-02-02 18:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (418, 17, 28, 5.0, '顶级工艺的代表，质量上乘，设计精美。', '2026-02-03 22:30:00', '2026-02-03 22:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (419, 17, 29, 4.0, '发货速度快，包装精美，衣服质量非常好。', '2026-02-04 18:00:00', '2026-02-04 18:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (420, 17, 30, 5.0, '客服服务态度很好，衣服质量也很棒。', '2026-02-05 22:30:00', '2026-02-05 22:30:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (421, 17, 31, 4.0, '衣服做工精细，面料优质，穿着很舒适。', '2026-02-06 18:00:00', '2026-02-06 18:00:00', 4.8, 0, 0, 0, 4, 19, 23);
INSERT INTO `shop_review` VALUES (422, 17, 32, 5.0, '顶级工艺，衣服质量非常好，做工精细。', '2026-02-07 22:30:00', '2026-02-07 22:30:00', 4.8, 0, 0, 0, 4, 19, 23);

-- ----------------------------
-- Table structure for shop_service
-- ----------------------------
DROP TABLE IF EXISTS `shop_service`;
CREATE TABLE `shop_service` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '服务ID',
  `shop_id` bigint NOT NULL COMMENT '店铺ID',
  `service_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '服务名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_shop_id` (`shop_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '店铺服务项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop_service
-- ----------------------------
-- 普通档店铺服务
INSERT INTO `shop_service` VALUES (1, 1, '汉服售卖', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (2, 1, '汉服租赁', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (3, 1, '汉服定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (4, 2, '汉服售卖', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (5, 2, '日常汉服', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (6, 2, '汉服配饰', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (7, 3, '传统汉服', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (8, 3, '汉服租赁', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (9, 3, '汉服妆造', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (10, 4, '汉服售卖', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (11, 4, '小众设计', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (12, 4, '汉服定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (13, 5, '汉服售卖', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (14, 5, '传统工艺', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (15, 5, '汉服租赁', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (16, 6, '汉服售卖', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (17, 6, '优雅设计', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (18, 6, '汉服配饰', '2026-01-01 10:00:00', '2026-01-01 10:00:00');

-- 中档店铺服务
INSERT INTO `shop_service` VALUES (19, 7, '汉服定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (20, 7, '高端汉服', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (21, 7, '汉服租赁', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (22, 8, '绣花汉服', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (23, 8, '汉服定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (24, 8, '汉服售卖', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (25, 9, '古风设计', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (26, 9, '汉服定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (27, 9, '汉服租赁', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (28, 10, '传统工艺', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (29, 10, '汉服定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (30, 10, '高端汉服', '2026-01-01 10:00:00', '2026-01-01 10:00:00');

-- 中高档店铺服务
INSERT INTO `shop_service` VALUES (31, 11, '高端定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (32, 11, '设计独特', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (33, 11, '汉服租赁', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (34, 12, '礼仪汉服', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (35, 12, '高端定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (36, 12, '汉服租赁', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (37, 13, '盛世风格', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (38, 13, '高端定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (39, 13, '汉服售卖', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (40, 14, '古典风格', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (41, 14, '高端定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (42, 14, '汉服租赁', '2026-01-01 10:00:00', '2026-01-01 10:00:00');

-- 高档店铺服务
INSERT INTO `shop_service` VALUES (43, 15, '顶级定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (44, 15, '手工制作', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (45, 15, '汉服婚礼', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (46, 16, '皇室风格', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (47, 16, '高端汉服', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (48, 16, '汉服定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (49, 17, '顶级定制', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (50, 17, '手工制作', '2026-01-01 10:00:00', '2026-01-01 10:00:00');
INSERT INTO `shop_service` VALUES (51, 17, '汉服婚礼', '2026-01-01 10:00:00', '2026-01-01 10:00:00');

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子内容',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '帖子简介',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片URL',
  `author_id` bigint NOT NULL COMMENT '作者ID',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '帖子标签',
  `likes` int NULL DEFAULT 0 COMMENT '点赞数',
  `comments` int NULL DEFAULT 0 COMMENT '评论数',
  `publish_date` date NOT NULL COMMENT '发布日期',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `author_id`(`author_id` ASC) USING BTREE,
  CONSTRAINT `post_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '帖子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post
-- ----------------------------
-- 帖子发布人混合：英文名用户、中文名用户、lay用户(id=2)
INSERT INTO `post` VALUES (1, '汉服出行日精彩回顾', '上周末的汉服出行日活动圆满结束，数百名同袍齐聚市中心广场，展示各朝代汉服风采。活动现场气氛热烈，吸引了不少市民驻足观看。大家穿着明制、唐制、宋制等不同朝代的汉服，成为城市一道靓丽的风景线。', '上周末汉服出行日活动回顾，数百名同袍展示各朝代汉服风采', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/1.webp', 2, '文化活动', 20, 15, '2025-12-20', '2025-12-20 10:00:00', '2025-12-20 10:00:00');
INSERT INTO `post` VALUES (2, '春日汉服赏花图集', '春暖花开时节，穿着汉服赏花是最惬意的事情。这组照片记录了我在植物园赏花的美好时光，粉色樱花与淡蓝色汉服相映成趣，仿佛画中走出的古典美人。', '春暖花开时节穿着汉服赏花的美好时光记录', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/2.webp', 4, '摄影作品', 20, 13, '2025-12-18', '2025-12-18 14:30:00', '2025-12-18 14:30:00');
INSERT INTO `post` VALUES (3, '明制汉服穿搭分享', '今日份明制汉服出门，马面裙搭配长袄，既传统又时尚，走在街上回头率超高！马面裙是明代最具代表性的裙装之一，褶皱整齐，行走时摇曳生姿。搭配长袄既保暖又优雅，非常适合秋冬季节穿着。', '明制马面裙搭配长袄，传统与时尚的完美结合', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/3.webp', 21, '穿搭分享', 20, 17, '2025-12-15', '2025-12-15 10:00:00', '2025-12-15 10:00:00');
INSERT INTO `post` VALUES (4, '汉服妆造手把手教学', '很多新手同袍都说不会做汉服妆造，今天我就来分享一个简单实用的日常妆造教程。从打底到眼妆，从眉毛到唇妆，一步步教你打造适合汉服的古典妆容，手残党也能学会！', '新手友好的汉服日常妆造详细教程，手残党也能学会', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/4.webp', 5, '妆容教程', 20, 15, '2025-12-12', '2025-12-12 09:15:00', '2025-12-12 09:15:00');
INSERT INTO `post` VALUES (5, '古风摄影作品欣赏', '在江南古镇拍摄的一组汉服人像，烟雨朦胧中，汉服的韵味被完美展现。选择古镇作为拍摄地点，是因为这里保留着传统的建筑风格，与汉服相得益彰。清晨的薄雾和石板路，营造出穿越时空的感觉。', '江南古镇烟雨朦胧中的汉服人像摄影', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/5.webp', 24, '摄影作品', 20, 14, '2025-12-10', '2025-12-10 16:00:00', '2025-12-10 16:00:00');
INSERT INTO `post` VALUES (6, '魏晋风骨穿搭指南', '魏晋时期的服饰以宽衣博带、飘逸洒脱著称，体现了当时文人雅士的风骨。今天分享一套魏晋风穿搭，大袖衫搭配褶裙，再配上简单的发髻，尽显魏晋风流。', '魏晋风大袖衫搭配褶裙，尽显魏晋风流', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/1.webp', 6, '穿搭分享', 20, 16, '2025-12-08', '2025-12-08 11:00:00', '2025-12-08 11:00:00');
INSERT INTO `post` VALUES (7, '汉服街拍合集', '整理了近期的汉服街拍照片，每一套都是精心搭配。从日常通勤到周末出游，不同场合的汉服穿搭都有涵盖。希望能给喜欢汉服的朋友们一些穿搭灵感。', '近期汉服街拍合集，涵盖多种场合穿搭', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/2.webp', 27, '摄影作品', 20, 13, '2025-12-05', '2025-12-05 14:00:00', '2025-12-05 14:00:00');
INSERT INTO `post` VALUES (8, '传统发饰制作教程', '今天教大家制作一款简单的缠花发饰，材料容易获取，步骤也不复杂。缠花是传统手工艺之一，用丝线缠绕出各种花卉造型，非常适合搭配汉服。跟着教程一步步来，你也能做出精美的发饰！', '传统缠花发饰制作教程，材料简单易上手', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/3.webp', 7, '手工教程', 20, 15, '2025-12-03', '2025-12-03 10:30:00', '2025-12-03 10:30:00');
INSERT INTO `post` VALUES (9, '汉服日常穿搭记录', '记录一下本周的汉服日常穿搭，每天都有不同的风格。周一穿明制端庄大气，周二穿宋制清新雅致，周三穿唐制华丽富贵，周四穿魏晋风流倜傥，周五穿汉制古朴典雅。汉服真的可以让每一天都充满仪式感！', '一周汉服日常穿搭记录，每天都有不同风格', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/4.webp', 30, '穿搭分享', 20, 17, '2025-12-01', '2025-12-01 15:30:00', '2025-12-01 15:30:00');
INSERT INTO `post` VALUES (10, '古风写真拍摄技巧', '想要拍出好看的古风写真，除了服装造型，拍摄技巧也很重要。今天分享几个实用的拍摄技巧：选址要选有古风元素的地方，时间最好选清晨或傍晚光线柔和时，姿势要自然不做作。希望这些技巧能帮到你！', '古风写真拍摄实用技巧分享，从选址到姿势', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/5.webp', 8, '摄影技巧', 20, 14, '2025-11-28', '2025-11-28 09:00:00', '2025-11-28 09:00:00');
INSERT INTO `post` VALUES (11, '汉服活动精彩花絮', '参加汉服游园会的精彩记录，同袍们穿着各式汉服，仿佛穿越回古代。这次游园会汇集了来自各地的汉服爱好者，大家穿着不同朝代的汉服，一起赏花、品茶、吟诗，度过了一个难忘的周末。', '汉服游园会精彩花絮，同袍齐聚共度美好时光', 'https://cdn.jsdelivr.net/gh/Hanerdev/Image-Hosting@main/hanfu/1.webp', 33, '文化活动', 20, 16, '2025-11-25', '2025-11-25 13:00:00', '2025-11-25 13:00:00');

-- ----------------------------
-- Table structure for post_image
-- ----------------------------
DROP TABLE IF EXISTS `post_image`;
CREATE TABLE `post_image`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片URL',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_post_image_post`(`post_id` ASC) USING BTREE,
  CONSTRAINT `fk_post_image_post` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '帖子图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for post_comment
-- ----------------------------
DROP TABLE IF EXISTS `post_comment`;
CREATE TABLE `post_comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `post_id`(`post_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `post_comment_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `post_comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 166 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '帖子评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post_comment
-- ----------------------------
-- 帖子1的评论(15条)
INSERT INTO `post_comment` VALUES (1, 1, 2, '活动真的很精彩，可惜没能参加，期待下次！', '2025-12-20 10:30:00', '2025-12-20 10:30:00');
INSERT INTO `post_comment` VALUES (2, 1, 4, '看到照片了，现场气氛好热闹，大家的汉服都很精致！', '2025-12-20 11:00:00', '2025-12-20 11:00:00');
INSERT INTO `post_comment` VALUES (3, 1, 5, '我也参加了，认识了很多同袍，很开心！', '2025-12-20 11:30:00', '2025-12-20 11:30:00');
INSERT INTO `post_comment` VALUES (4, 1, 6, '这样的活动应该多举办，让更多人了解汉服文化！', '2025-12-20 12:00:00', '2025-12-20 12:00:00');
INSERT INTO `post_comment` VALUES (5, 1, 7, '照片拍得真好看，捕捉到了很多精彩瞬间', '2025-12-20 12:30:00', '2025-12-20 12:30:00');
INSERT INTO `post_comment` VALUES (6, 1, 8, '汉服出行日已经成为我们的传统活动了，每年都很期待', '2025-12-20 13:00:00', '2025-12-20 13:00:00');
INSERT INTO `post_comment` VALUES (7, 1, 9, '希望明年能有更多城市参与，让汉服文化传播得更广', '2025-12-20 13:30:00', '2025-12-20 13:30:00');
INSERT INTO `post_comment` VALUES (8, 1, 10, '活动组织得很有序，辛苦了组织者们！', '2025-12-20 14:00:00', '2025-12-20 14:00:00');
INSERT INTO `post_comment` VALUES (9, 1, 11, '看到好多精美的汉服，又种草了几款', '2025-12-20 14:30:00', '2025-12-20 14:30:00');
INSERT INTO `post_comment` VALUES (10, 1, 12, '这样的活动让我更加热爱汉服文化了', '2025-12-20 15:00:00', '2025-12-20 15:00:00');
INSERT INTO `post_comment` VALUES (11, 1, 13, '期待下一次的汉服出行日，我一定会参加！', '2025-12-20 15:30:00', '2025-12-20 15:30:00');
INSERT INTO `post_comment` VALUES (12, 1, 14, '照片里有我！太开心了，感谢分享', '2025-12-20 16:00:00', '2025-12-20 16:00:00');
INSERT INTO `post_comment` VALUES (13, 1, 15, '汉服文化需要这样的活动来推广，支持！', '2025-12-20 16:30:00', '2025-12-20 16:30:00');
INSERT INTO `post_comment` VALUES (14, 1, 16, '看到大家穿着不同朝代的汉服，仿佛穿越时空', '2025-12-20 17:00:00', '2025-12-20 17:00:00');
INSERT INTO `post_comment` VALUES (15, 1, 17, '活动很成功，希望以后能有更多类似的活动', '2025-12-20 17:30:00', '2025-12-20 17:30:00');

-- 帖子2的评论(13条)
INSERT INTO `post_comment` VALUES (16, 2, 2, '樱花和汉服真的很配，照片拍得太美了！', '2025-12-18 15:00:00', '2025-12-18 15:00:00');
INSERT INTO `post_comment` VALUES (17, 2, 5, '春暖花开穿汉服赏花，想想都觉得美好', '2025-12-18 15:30:00', '2025-12-18 15:30:00');
INSERT INTO `post_comment` VALUES (18, 2, 6, '请问这是在哪里拍的？风景真美', '2025-12-18 16:00:00', '2025-12-18 16:00:00');
INSERT INTO `post_comment` VALUES (19, 2, 7, '淡蓝色的汉服和粉色樱花的搭配太和谐了', '2025-12-18 16:30:00', '2025-12-18 16:30:00');
INSERT INTO `post_comment` VALUES (20, 2, 8, '春天就是要穿汉服去赏花，这组照片给了我灵感', '2025-12-18 17:00:00', '2025-12-18 17:00:00');
INSERT INTO `post_comment` VALUES (21, 2, 9, '拍得真好看，模特也很有气质', '2025-12-18 17:30:00', '2025-12-18 17:30:00');
INSERT INTO `post_comment` VALUES (22, 2, 10, '请问这套汉服是什么款式？很喜欢', '2025-12-18 18:00:00', '2025-12-18 18:00:00');
INSERT INTO `post_comment` VALUES (23, 2, 11, '樱花季就要到了，我也要穿汉服去拍照', '2025-12-18 18:30:00', '2025-12-18 18:30:00');
INSERT INTO `post_comment` VALUES (24, 2, 12, '这组照片太有氛围感了，仿佛画中走出的人', '2025-12-18 19:00:00', '2025-12-18 19:00:00');
INSERT INTO `post_comment` VALUES (25, 2, 13, '汉服和自然风景的结合总是那么美', '2025-12-18 19:30:00', '2025-12-18 19:30:00');
INSERT INTO `post_comment` VALUES (26, 2, 14, '感谢分享，给了我很多拍照灵感', '2025-12-18 20:00:00', '2025-12-18 20:00:00');
INSERT INTO `post_comment` VALUES (27, 2, 15, '樱花汉服照真的是春天的标配', '2025-12-18 20:30:00', '2025-12-18 20:30:00');
INSERT INTO `post_comment` VALUES (28, 2, 16, '拍得太好了，构图和光线都很专业', '2025-12-18 21:00:00', '2025-12-18 21:00:00');

-- 帖子3的评论(17条)
INSERT INTO `post_comment` VALUES (29, 3, 2, '明制汉服真的很有气质，马面裙太漂亮了', '2025-12-15 10:30:00', '2025-12-15 10:30:00');
INSERT INTO `post_comment` VALUES (30, 3, 4, '马面裙搭配长袄，经典的明制搭配', '2025-12-15 11:00:00', '2025-12-15 11:00:00');
INSERT INTO `post_comment` VALUES (31, 3, 5, '请问这套汉服是哪家店的？很喜欢', '2025-12-15 11:30:00', '2025-12-15 11:30:00');
INSERT INTO `post_comment` VALUES (32, 3, 6, '明制汉服确实很适合秋冬季节，既保暖又优雅', '2025-12-15 12:00:00', '2025-12-15 12:00:00');
INSERT INTO `post_comment` VALUES (33, 3, 7, '马面裙的褶皱真的很整齐，走路时摇曳生姿', '2025-12-15 12:30:00', '2025-12-15 12:30:00');
INSERT INTO `post_comment` VALUES (34, 3, 8, '搭配得很好看，颜色也很协调', '2025-12-15 13:00:00', '2025-12-15 13:00:00');
INSERT INTO `post_comment` VALUES (35, 3, 9, '明制汉服的端庄大气真的很吸引人', '2025-12-15 13:30:00', '2025-12-15 13:30:00');
INSERT INTO `post_comment` VALUES (36, 3, 10, '请问身高多少？穿多大码？参考一下', '2025-12-15 14:00:00', '2025-12-15 14:00:00');
INSERT INTO `post_comment` VALUES (37, 3, 11, '马面裙真的是明代最具代表性的裙装之一', '2025-12-15 14:30:00', '2025-12-15 14:30:00');
INSERT INTO `post_comment` VALUES (38, 3, 12, '这样的搭配既传统又时尚，走在街上回头率肯定高', '2025-12-15 15:00:00', '2025-12-15 15:00:00');
INSERT INTO `post_comment` VALUES (39, 3, 13, '明制汉服的细节真的很精致，喜欢', '2025-12-15 15:30:00', '2025-12-15 15:30:00');
INSERT INTO `post_comment` VALUES (40, 3, 14, '秋冬季节就应该穿这样的汉服，保暖又美观', '2025-12-15 16:00:00', '2025-12-15 16:00:00');
INSERT INTO `post_comment` VALUES (41, 3, 15, '搭配的配饰也很协调，整体效果很好', '2025-12-15 16:30:00', '2025-12-15 16:30:00');
INSERT INTO `post_comment` VALUES (42, 3, 16, '明制汉服确实很适合日常穿着', '2025-12-15 17:00:00', '2025-12-15 17:00:00');
INSERT INTO `post_comment` VALUES (43, 3, 17, '感谢分享，给了我很多穿搭灵感', '2025-12-15 17:30:00', '2025-12-15 17:30:00');
INSERT INTO `post_comment` VALUES (44, 3, 18, '马面裙的做工看起来很精细', '2025-12-15 18:00:00', '2025-12-15 18:00:00');
INSERT INTO `post_comment` VALUES (45, 3, 19, '这样的穿搭真的很适合上班穿', '2025-12-15 18:30:00', '2025-12-15 18:30:00');

-- 帖子4的评论(15条)
INSERT INTO `post_comment` VALUES (46, 4, 2, '新手表示太需要这样的教程了，感谢分享', '2025-12-12 09:45:00', '2025-12-12 09:45:00');
INSERT INTO `post_comment` VALUES (47, 4, 4, '教程很详细，步骤清晰，手残党表示有救了', '2025-12-12 10:00:00', '2025-12-12 10:00:00');
INSERT INTO `post_comment` VALUES (48, 4, 5, '请问用的是什么化妆品？效果很好', '2025-12-12 10:15:00', '2025-12-12 10:15:00');
INSERT INTO `post_comment` VALUES (49, 4, 6, '学会了，下次穿汉服可以自己做妆造了', '2025-12-12 10:30:00', '2025-12-12 10:30:00');
INSERT INTO `post_comment` VALUES (50, 4, 7, '教程很实用，讲解也很耐心', '2025-12-12 10:45:00', '2025-12-12 10:45:00');
INSERT INTO `post_comment` VALUES (51, 4, 8, '眼妆部分讲得很详细，学到了很多', '2025-12-12 11:00:00', '2025-12-12 11:00:00');
INSERT INTO `post_comment` VALUES (52, 4, 9, '眉毛的画法很自然，适合汉服', '2025-12-12 11:15:00', '2025-12-12 11:15:00');
INSERT INTO `post_comment` VALUES (53, 4, 10, '唇妆的颜色选择很适合古典妆容', '2025-12-12 11:30:00', '2025-12-12 11:30:00');
INSERT INTO `post_comment` VALUES (54, 4, 11, '教程很全面，从打底到完成都有', '2025-12-12 11:45:00', '2025-12-12 11:45:00');
INSERT INTO `post_comment` VALUES (55, 4, 12, '希望能出更多这样的教程', '2025-12-12 12:00:00', '2025-12-12 12:00:00');
INSERT INTO `post_comment` VALUES (56, 4, 13, '手残党终于找到了救星', '2025-12-12 12:15:00', '2025-12-12 12:15:00');
INSERT INTO `post_comment` VALUES (57, 4, 14, '教程很易懂，步骤也不复杂', '2025-12-12 12:30:00', '2025-12-12 12:30:00');
INSERT INTO `post_comment` VALUES (58, 4, 15, '学会了，以后穿汉服不用愁妆造了', '2025-12-12 12:45:00', '2025-12-12 12:45:00');
INSERT INTO `post_comment` VALUES (59, 4, 16, '感谢分享，太实用了', '2025-12-12 13:00:00', '2025-12-12 13:00:00');
INSERT INTO `post_comment` VALUES (60, 4, 17, '教程很详细，配图也很清晰', '2025-12-12 13:15:00', '2025-12-12 13:15:00');

-- 帖子5的评论(14条)
INSERT INTO `post_comment` VALUES (61, 5, 2, '江南古镇的烟雨朦胧配上汉服，太有感觉了', '2025-12-10 16:30:00', '2025-12-10 16:30:00');
INSERT INTO `post_comment` VALUES (62, 5, 4, '照片拍得太美了，仿佛穿越时空', '2025-12-10 16:45:00', '2025-12-10 16:45:00');
INSERT INTO `post_comment` VALUES (63, 5, 5, '请问这是哪个古镇？想去拍照', '2025-12-10 17:00:00', '2025-12-10 17:00:00');
INSERT INTO `post_comment` VALUES (64, 5, 6, '清晨的薄雾和石板路，营造出的氛围太好了', '2025-12-10 17:15:00', '2025-12-10 17:15:00');
INSERT INTO `post_comment` VALUES (65, 5, 7, '汉服与古镇的结合真的很完美', '2025-12-10 17:30:00', '2025-12-10 17:30:00');
INSERT INTO `post_comment` VALUES (66, 5, 8, '照片的构图和光线都很专业', '2025-12-10 17:45:00', '2025-12-10 17:45:00');
INSERT INTO `post_comment` VALUES (67, 5, 9, '这样的照片太有艺术感了', '2025-12-10 18:00:00', '2025-12-10 18:00:00');
INSERT INTO `post_comment` VALUES (68, 5, 10, '汉服的韵味在这样的环境中被完美展现', '2025-12-10 18:15:00', '2025-12-10 18:15:00');
INSERT INTO `post_comment` VALUES (69, 5, 11, '古镇的建筑风格与汉服相得益彰', '2025-12-10 18:30:00', '2025-12-10 18:30:00');
INSERT INTO `post_comment` VALUES (70, 5, 12, '拍得太好了，收藏了', '2025-12-10 18:45:00', '2025-12-10 18:45:00');
INSERT INTO `post_comment` VALUES (71, 5, 13, '下次我也要去古镇拍汉服照片', '2025-12-10 19:00:00', '2025-12-10 19:00:00');
INSERT INTO `post_comment` VALUES (72, 5, 14, '照片很有故事感，仿佛在讲述一个古代的故事', '2025-12-10 19:15:00', '2025-12-10 19:15:00');
INSERT INTO `post_comment` VALUES (73, 5, 15, '感谢分享这么美的照片', '2025-12-10 19:30:00', '2025-12-10 19:30:00');
INSERT INTO `post_comment` VALUES (74, 5, 16, '烟雨朦胧的感觉太适合汉服了', '2025-12-10 19:45:00', '2025-12-10 19:45:00');

-- 帖子6的评论(16条)
INSERT INTO `post_comment` VALUES (75, 6, 2, '魏晋风的飘逸洒脱真的很吸引人', '2025-12-08 11:30:00', '2025-12-08 11:30:00');
INSERT INTO `post_comment` VALUES (76, 6, 4, '宽衣博带，尽显魏晋风流', '2025-12-08 11:45:00', '2025-12-08 11:45:00');
INSERT INTO `post_comment` VALUES (77, 6, 5, '大袖衫搭配褶裙，很有魏晋文人的气质', '2025-12-08 12:00:00', '2025-12-08 12:00:00');
INSERT INTO `post_comment` VALUES (78, 6, 6, '魏晋时期的服饰风格真的很独特', '2025-12-08 12:15:00', '2025-12-08 12:15:00');
INSERT INTO `post_comment` VALUES (79, 6, 7, '这样的穿搭很适合拍照', '2025-12-08 12:30:00', '2025-12-08 12:30:00');
INSERT INTO `post_comment` VALUES (80, 6, 8, '魏晋风的服饰体现了当时文人雅士的风骨', '2025-12-08 12:45:00', '2025-12-08 12:45:00');
INSERT INTO `post_comment` VALUES (81, 6, 9, '简单的发髻与魏晋风服饰很搭配', '2025-12-08 13:00:00', '2025-12-08 13:00:00');
INSERT INTO `post_comment` VALUES (82, 6, 10, '魏晋风的服饰给人一种洒脱自在的感觉', '2025-12-08 13:15:00', '2025-12-08 13:15:00');
INSERT INTO `post_comment` VALUES (83, 6, 11, '请问这套汉服是什么材质的？看起来很舒适', '2025-12-08 13:30:00', '2025-12-08 13:30:00');
INSERT INTO `post_comment` VALUES (84, 6, 12, '魏晋风的服饰很适合身材修长的人', '2025-12-08 13:45:00', '2025-12-08 13:45:00');
INSERT INTO `post_comment` VALUES (85, 6, 13, '这样的穿搭很有艺术感', '2025-12-08 14:00:00', '2025-12-08 14:00:00');
INSERT INTO `post_comment` VALUES (86, 6, 14, '魏晋风的服饰在现代也很时尚', '2025-12-08 14:15:00', '2025-12-08 14:15:00');
INSERT INTO `post_comment` VALUES (87, 6, 15, '感谢分享，给了我很多穿搭灵感', '2025-12-08 14:30:00', '2025-12-08 14:30:00');
INSERT INTO `post_comment` VALUES (88, 6, 16, '魏晋风的服饰真的很有文化底蕴', '2025-12-08 14:45:00', '2025-12-08 14:45:00');
INSERT INTO `post_comment` VALUES (89, 6, 17, '这样的穿搭很适合参加文化活动', '2025-12-08 15:00:00', '2025-12-08 15:00:00');
INSERT INTO `post_comment` VALUES (90, 6, 18, '魏晋风的飘逸感真的很吸引人', '2025-12-08 15:15:00', '2025-12-08 15:15:00');

-- 帖子7的评论(13条)
INSERT INTO `post_comment` VALUES (91, 7, 2, '街拍合集很有参考价值，感谢分享', '2025-12-05 14:30:00', '2025-12-05 14:30:00');
INSERT INTO `post_comment` VALUES (92, 7, 4, '每一套都搭配得很好看，很有参考价值', '2025-12-05 14:45:00', '2025-12-05 14:45:00');
INSERT INTO `post_comment` VALUES (93, 7, 5, '日常通勤的汉服穿搭很实用', '2025-12-05 15:00:00', '2025-12-05 15:00:00');
INSERT INTO `post_comment` VALUES (94, 7, 6, '周末出游的汉服穿搭很有灵感', '2025-12-05 15:15:00', '2025-12-05 15:15:00');
INSERT INTO `post_comment` VALUES (95, 7, 7, '每一套都精心搭配，看起来很用心', '2025-12-05 15:30:00', '2025-12-05 15:30:00');
INSERT INTO `post_comment` VALUES (96, 7, 8, '这样的街拍很真实，很有参考意义', '2025-12-05 15:45:00', '2025-12-05 15:45:00');
INSERT INTO `post_comment` VALUES (97, 7, 9, '感谢分享，给了我很多穿搭灵感', '2025-12-05 16:00:00', '2025-12-05 16:00:00');
INSERT INTO `post_comment` VALUES (98, 7, 10, '街拍的角度和构图都很专业', '2025-12-05 16:15:00', '2025-12-05 16:15:00');
INSERT INTO `post_comment` VALUES (99, 7, 11, '每一套穿搭都很适合不同的场合', '2025-12-05 16:30:00', '2025-12-05 16:30:00');
INSERT INTO `post_comment` VALUES (100, 7, 12, '日常穿汉服也可以很时尚', '2025-12-05 16:45:00', '2025-12-05 16:45:00');
INSERT INTO `post_comment` VALUES (101, 7, 13, '街拍合集很全面，涵盖了多种场合', '2025-12-05 17:00:00', '2025-12-05 17:00:00');
INSERT INTO `post_comment` VALUES (102, 7, 14, '这样的穿搭很适合现代生活', '2025-12-05 17:15:00', '2025-12-05 17:15:00');
INSERT INTO `post_comment` VALUES (103, 7, 15, '感谢分享，期待更多街拍合集', '2025-12-05 17:30:00', '2025-12-05 17:30:00');

-- 帖子8的评论(15条)
INSERT INTO `post_comment` VALUES (104, 8, 2, '缠花发饰看起来很精美，教程很详细', '2025-12-03 11:00:00', '2025-12-03 11:00:00');
INSERT INTO `post_comment` VALUES (105, 8, 4, '材料容易获取，步骤也不复杂，适合新手', '2025-12-03 11:15:00', '2025-12-03 11:15:00');
INSERT INTO `post_comment` VALUES (106, 8, 5, '缠花是传统手工艺，值得传承', '2025-12-03 11:30:00', '2025-12-03 11:30:00');
INSERT INTO `post_comment` VALUES (107, 8, 6, '教程很详细，步骤清晰，容易跟着做', '2025-12-03 11:45:00', '2025-12-03 11:45:00');
INSERT INTO `post_comment` VALUES (108, 8, 7, '缠花发饰搭配汉服真的很合适', '2025-12-03 12:00:00', '2025-12-03 12:00:00');
INSERT INTO `post_comment` VALUES (109, 8, 8, '跟着教程做了一个，效果很好', '2025-12-03 12:15:00', '2025-12-03 12:15:00');
INSERT INTO `post_comment` VALUES (110, 8, 9, '传统手工艺的魅力真的很吸引人', '2025-12-03 12:30:00', '2025-12-03 12:30:00');
INSERT INTO `post_comment` VALUES (111, 8, 10, '缠花的颜色搭配很重要，教程里讲得很清楚', '2025-12-03 12:45:00', '2025-12-03 12:45:00');
INSERT INTO `post_comment` VALUES (112, 8, 11, '这样的发饰自己做既省钱又有意义', '2025-12-03 13:00:00', '2025-12-03 13:00:00');
INSERT INTO `post_comment` VALUES (113, 8, 12, '教程很实用，适合手工爱好者', '2025-12-03 13:15:00', '2025-12-03 13:15:00');
INSERT INTO `post_comment` VALUES (114, 8, 13, '缠花发饰真的很精美，搭配汉服很出彩', '2025-12-03 13:30:00', '2025-12-03 13:30:00');
INSERT INTO `post_comment` VALUES (115, 8, 14, '感谢分享这么详细的教程', '2025-12-03 13:45:00', '2025-12-03 13:45:00');
INSERT INTO `post_comment` VALUES (116, 8, 15, '传统手工艺需要这样的教程来传承', '2025-12-03 14:00:00', '2025-12-03 14:00:00');
INSERT INTO `post_comment` VALUES (117, 8, 16, '跟着教程做了一个，朋友都说好看', '2025-12-03 14:15:00', '2025-12-03 14:15:00');
INSERT INTO `post_comment` VALUES (118, 8, 17, '缠花发饰的制作过程很有趣', '2025-12-03 14:30:00', '2025-12-03 14:30:00');

-- 帖子9的评论(17条)
INSERT INTO `post_comment` VALUES (119, 9, 2, '一周的汉服穿搭记录很有参考价值', '2025-12-01 16:00:00', '2025-12-01 16:00:00');
INSERT INTO `post_comment` VALUES (120, 9, 4, '每天不同风格的汉服，太有创意了', '2025-12-01 16:15:00', '2025-12-01 16:15:00');
INSERT INTO `post_comment` VALUES (121, 9, 5, '明制端庄大气，宋制清新雅致，唐制华丽富贵，魏晋风流倜傥，汉制古朴典雅，每一套都很好看', '2025-12-01 16:30:00', '2025-12-01 16:30:00');
INSERT INTO `post_comment` VALUES (122, 9, 6, '这样的穿搭记录很有意义，展现了汉服的多样性', '2025-12-01 16:45:00', '2025-12-01 16:45:00');
INSERT INTO `post_comment` VALUES (123, 9, 7, '汉服真的可以让每一天都充满仪式感', '2025-12-01 17:00:00', '2025-12-01 17:00:00');
INSERT INTO `post_comment` VALUES (124, 9, 8, '每天不同朝代的汉服，很有创意', '2025-12-01 17:15:00', '2025-12-01 17:15:00');
INSERT INTO `post_comment` VALUES (125, 9, 9, '这样的穿搭记录给了我很多灵感', '2025-12-01 17:30:00', '2025-12-01 17:30:00');
INSERT INTO `post_comment` VALUES (126, 9, 10, '汉服的多样性真的很让人惊喜', '2025-12-01 17:45:00', '2025-12-01 17:45:00');
INSERT INTO `post_comment` VALUES (127, 9, 11, '每天不同风格的汉服，展现了汉服的魅力', '2025-12-01 18:00:00', '2025-12-01 18:00:00');
INSERT INTO `post_comment` VALUES (128, 9, 12, '这样的穿搭记录很真实，很有参考价值', '2025-12-01 18:15:00', '2025-12-01 18:15:00');
INSERT INTO `post_comment` VALUES (129, 9, 13, '汉服真的可以融入日常生活', '2025-12-01 18:30:00', '2025-12-01 18:30:00');
INSERT INTO `post_comment` VALUES (130, 9, 14, '每天不同风格的汉服，太有创意了', '2025-12-01 18:45:00', '2025-12-01 18:45:00');
INSERT INTO `post_comment` VALUES (131, 9, 15, '汉服的多样性让人着迷', '2025-12-01 19:00:00', '2025-12-01 19:00:00');
INSERT INTO `post_comment` VALUES (132, 9, 16, '这样的穿搭记录很有意义', '2025-12-01 19:15:00', '2025-12-01 19:15:00');
INSERT INTO `post_comment` VALUES (133, 9, 17, '汉服真的可以让生活更有仪式感', '2025-12-01 19:30:00', '2025-12-01 19:30:00');
INSERT INTO `post_comment` VALUES (134, 9, 18, '每天不同朝代的汉服，很有创意', '2025-12-01 19:45:00', '2025-12-01 19:45:00');
INSERT INTO `post_comment` VALUES (135, 9, 19, '感谢分享，给了我很多穿搭灵感', '2025-12-01 20:00:00', '2025-12-01 20:00:00');

-- 帖子10的评论(14条)
INSERT INTO `post_comment` VALUES (136, 10, 2, '拍摄技巧很实用，感谢分享', '2025-11-28 09:30:00', '2025-11-28 09:30:00');
INSERT INTO `post_comment` VALUES (137, 10, 4, '选址很重要，有古风元素的地方确实更适合拍古风写真', '2025-11-28 09:45:00', '2025-11-28 09:45:00');
INSERT INTO `post_comment` VALUES (138, 10, 5, '清晨或傍晚的光线确实更柔和，拍出的效果更好', '2025-11-28 10:00:00', '2025-11-28 10:00:00');
INSERT INTO `post_comment` VALUES (139, 10, 6, '姿势要自然不做作，这一点很重要', '2025-11-28 10:15:00', '2025-11-28 10:15:00');
INSERT INTO `post_comment` VALUES (140, 10, 7, '拍摄技巧很实用，学到了很多', '2025-11-28 10:30:00', '2025-11-28 10:30:00');
INSERT INTO `post_comment` VALUES (141, 10, 8, '希望能有更多这样的拍摄技巧分享', '2025-11-28 10:45:00', '2025-11-28 10:45:00');
INSERT INTO `post_comment` VALUES (142, 10, 9, '拍摄技巧很详细，很有参考价值', '2025-11-28 11:00:00', '2025-11-28 11:00:00');
INSERT INTO `post_comment` VALUES (143, 10, 10, '选址、时间、姿势，这三个要素很重要', '2025-11-28 11:15:00', '2025-11-28 11:15:00');
INSERT INTO `post_comment` VALUES (144, 10, 11, '这样的拍摄技巧分享很实用', '2025-11-28 11:30:00', '2025-11-28 11:30:00');
INSERT INTO `post_comment` VALUES (145, 10, 12, '感谢分享，下次拍古风写真会用到', '2025-11-28 11:45:00', '2025-11-28 11:45:00');
INSERT INTO `post_comment` VALUES (146, 10, 13, '拍摄技巧很实用，学到了很多', '2025-11-28 12:00:00', '2025-11-28 12:00:00');
INSERT INTO `post_comment` VALUES (147, 10, 14, '选址确实很重要，有古风元素的地方拍出的效果更好', '2025-11-28 12:15:00', '2025-11-28 12:15:00');
INSERT INTO `post_comment` VALUES (148, 10, 15, '光线的选择很重要，清晨或傍晚的光线确实更柔和', '2025-11-28 12:30:00', '2025-11-28 12:30:00');
INSERT INTO `post_comment` VALUES (149, 10, 16, '姿势自然不做作，这一点很关键', '2025-11-28 12:45:00', '2025-11-28 12:45:00');

-- 帖子11的评论(16条)
INSERT INTO `post_comment` VALUES (150, 11, 2, '汉服游园会听起来很有趣，可惜没能参加', '2025-11-25 13:30:00', '2025-11-25 13:30:00');
INSERT INTO `post_comment` VALUES (151, 11, 4, '同袍们穿着各式汉服，仿佛穿越回古代，太有感觉了', '2025-11-25 13:45:00', '2025-11-25 13:45:00');
INSERT INTO `post_comment` VALUES (152, 11, 5, '来自各地的汉服爱好者齐聚一堂，这样的活动很有意义', '2025-11-25 14:00:00', '2025-11-25 14:00:00');
INSERT INTO `post_comment` VALUES (153, 11, 6, '一起赏花、品茶、吟诗，这样的活动很有文化底蕴', '2025-11-25 14:15:00', '2025-11-25 14:15:00');
INSERT INTO `post_comment` VALUES (154, 11, 7, '汉服游园会的精彩花絮看起来很热闹', '2025-11-25 14:30:00', '2025-11-25 14:30:00');
INSERT INTO `post_comment` VALUES (155, 11, 8, '这样的活动让汉服文化得到了很好的推广', '2025-11-25 14:45:00', '2025-11-25 14:45:00');
INSERT INTO `post_comment` VALUES (156, 11, 9, '期待下次的汉服游园会', '2025-11-25 15:00:00', '2025-11-25 15:00:00');
INSERT INTO `post_comment` VALUES (157, 11, 10, '同袍们穿着不同朝代的汉服，很有观赏性', '2025-11-25 15:15:00', '2025-11-25 15:15:00');
INSERT INTO `post_comment` VALUES (158, 11, 11, '这样的活动让我更加热爱汉服文化', '2025-11-25 15:30:00', '2025-11-25 15:30:00');
INSERT INTO `post_comment` VALUES (159, 11, 12, '汉服游园会的氛围一定很好', '2025-11-25 15:45:00', '2025-11-25 15:45:00');
INSERT INTO `post_comment` VALUES (160, 11, 13, '感谢分享这么精彩的花絮', '2025-11-25 16:00:00', '2025-11-25 16:00:00');
INSERT INTO `post_comment` VALUES (161, 11, 14, '这样的活动应该多举办', '2025-11-25 16:15:00', '2025-11-25 16:15:00');
INSERT INTO `post_comment` VALUES (162, 11, 15, '汉服文化需要这样的活动来传承', '2025-11-25 16:30:00', '2025-11-25 16:30:00');
INSERT INTO `post_comment` VALUES (163, 11, 16, '同袍们的汉服都很精美', '2025-11-25 16:45:00', '2025-11-25 16:45:00');
INSERT INTO `post_comment` VALUES (164, 11, 17, '这样的活动很有意义，希望能参加', '2025-11-25 17:00:00', '2025-11-25 17:00:00');
INSERT INTO `post_comment` VALUES (165, 11, 18, '汉服游园会的精彩花絮让我很向往', '2025-11-25 17:15:00', '2025-11-25 17:15:00');


-- ----------------------------
-- Table structure for post_like
-- ----------------------------
DROP TABLE IF EXISTS `post_like`;
CREATE TABLE `post_like`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_post_user`(`post_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `post_id`(`post_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `post_like_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `post_like_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 285 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '帖子点赞表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post_like
-- ----------------------------
-- 帖子1的点赞(25个，包含lay用户)
INSERT INTO `post_like` VALUES (1, 1, 2, '2025-12-20 10:30:00');
INSERT INTO `post_like` VALUES (2, 1, 4, '2025-12-20 11:00:00');
INSERT INTO `post_like` VALUES (3, 1, 5, '2025-12-20 11:30:00');
INSERT INTO `post_like` VALUES (4, 1, 6, '2025-12-20 12:00:00');
INSERT INTO `post_like` VALUES (5, 1, 7, '2025-12-20 12:30:00');
INSERT INTO `post_like` VALUES (6, 1, 8, '2025-12-20 13:00:00');
INSERT INTO `post_like` VALUES (7, 1, 9, '2025-12-20 13:30:00');
INSERT INTO `post_like` VALUES (8, 1, 10, '2025-12-20 14:00:00');
INSERT INTO `post_like` VALUES (9, 1, 11, '2025-12-20 14:30:00');
INSERT INTO `post_like` VALUES (10, 1, 12, '2025-12-20 15:00:00');
INSERT INTO `post_like` VALUES (11, 1, 13, '2025-12-20 15:30:00');
INSERT INTO `post_like` VALUES (12, 1, 14, '2025-12-20 16:00:00');
INSERT INTO `post_like` VALUES (13, 1, 15, '2025-12-20 16:30:00');
INSERT INTO `post_like` VALUES (14, 1, 16, '2025-12-20 17:00:00');
INSERT INTO `post_like` VALUES (15, 1, 17, '2025-12-20 17:30:00');
INSERT INTO `post_like` VALUES (16, 1, 18, '2025-12-20 18:00:00');
INSERT INTO `post_like` VALUES (17, 1, 19, '2025-12-20 18:30:00');
INSERT INTO `post_like` VALUES (18, 1, 20, '2025-12-20 19:00:00');
INSERT INTO `post_like` VALUES (19, 1, 21, '2025-12-20 19:30:00');
INSERT INTO `post_like` VALUES (20, 1, 22, '2025-12-20 20:00:00');
INSERT INTO `post_like` VALUES (21, 1, 23, '2025-12-20 20:30:00');
INSERT INTO `post_like` VALUES (22, 1, 24, '2025-12-20 21:00:00');
INSERT INTO `post_like` VALUES (23, 1, 25, '2025-12-20 21:30:00');
INSERT INTO `post_like` VALUES (24, 1, 26, '2025-12-20 22:00:00');
INSERT INTO `post_like` VALUES (25, 1, 27, '2025-12-20 22:30:00');

-- 帖子2的点赞(28个)
INSERT INTO `post_like` VALUES (26, 2, 2, '2025-12-18 15:00:00');
INSERT INTO `post_like` VALUES (27, 2, 5, '2025-12-18 15:30:00');
INSERT INTO `post_like` VALUES (28, 2, 6, '2025-12-18 16:00:00');
INSERT INTO `post_like` VALUES (29, 2, 7, '2025-12-18 16:30:00');
INSERT INTO `post_like` VALUES (30, 2, 8, '2025-12-18 17:00:00');
INSERT INTO `post_like` VALUES (31, 2, 9, '2025-12-18 17:30:00');
INSERT INTO `post_like` VALUES (32, 2, 10, '2025-12-18 18:00:00');
INSERT INTO `post_like` VALUES (33, 2, 11, '2025-12-18 18:30:00');
INSERT INTO `post_like` VALUES (34, 2, 12, '2025-12-18 19:00:00');
INSERT INTO `post_like` VALUES (35, 2, 13, '2025-12-18 19:30:00');
INSERT INTO `post_like` VALUES (36, 2, 14, '2025-12-18 20:00:00');
INSERT INTO `post_like` VALUES (37, 2, 15, '2025-12-18 20:30:00');
INSERT INTO `post_like` VALUES (38, 2, 16, '2025-12-18 21:00:00');
INSERT INTO `post_like` VALUES (39, 2, 17, '2025-12-18 21:30:00');
INSERT INTO `post_like` VALUES (40, 2, 18, '2025-12-18 22:00:00');
INSERT INTO `post_like` VALUES (41, 2, 19, '2025-12-18 22:30:00');
INSERT INTO `post_like` VALUES (42, 2, 20, '2025-12-19 08:00:00');
INSERT INTO `post_like` VALUES (43, 2, 21, '2025-12-19 08:30:00');
INSERT INTO `post_like` VALUES (44, 2, 22, '2025-12-19 09:00:00');
INSERT INTO `post_like` VALUES (45, 2, 23, '2025-12-19 09:30:00');
INSERT INTO `post_like` VALUES (46, 2, 24, '2025-12-19 10:00:00');
INSERT INTO `post_like` VALUES (47, 2, 25, '2025-12-19 10:30:00');
INSERT INTO `post_like` VALUES (48, 2, 26, '2025-12-19 11:00:00');
INSERT INTO `post_like` VALUES (49, 2, 27, '2025-12-19 11:30:00');
INSERT INTO `post_like` VALUES (50, 2, 28, '2025-12-19 12:00:00');
INSERT INTO `post_like` VALUES (51, 2, 29, '2025-12-19 12:30:00');
INSERT INTO `post_like` VALUES (52, 2, 30, '2025-12-19 13:00:00');
INSERT INTO `post_like` VALUES (53, 2, 31, '2025-12-19 13:30:00');

-- 帖子3的点赞(26个)
INSERT INTO `post_like` VALUES (54, 3, 2, '2025-12-15 11:00:00');
INSERT INTO `post_like` VALUES (55, 3, 4, '2025-12-15 11:30:00');
INSERT INTO `post_like` VALUES (56, 3, 5, '2025-12-15 12:00:00');
INSERT INTO `post_like` VALUES (57, 3, 6, '2025-12-15 12:30:00');
INSERT INTO `post_like` VALUES (58, 3, 7, '2025-12-15 13:00:00');
INSERT INTO `post_like` VALUES (59, 3, 8, '2025-12-15 13:30:00');
INSERT INTO `post_like` VALUES (60, 3, 9, '2025-12-15 14:00:00');
INSERT INTO `post_like` VALUES (61, 3, 10, '2025-12-15 14:30:00');
INSERT INTO `post_like` VALUES (62, 3, 11, '2025-12-15 15:00:00');
INSERT INTO `post_like` VALUES (63, 3, 12, '2025-12-15 15:30:00');
INSERT INTO `post_like` VALUES (64, 3, 13, '2025-12-15 16:00:00');
INSERT INTO `post_like` VALUES (65, 3, 14, '2025-12-15 16:30:00');
INSERT INTO `post_like` VALUES (66, 3, 15, '2025-12-15 17:00:00');
INSERT INTO `post_like` VALUES (67, 3, 16, '2025-12-15 17:30:00');
INSERT INTO `post_like` VALUES (68, 3, 17, '2025-12-15 18:00:00');
INSERT INTO `post_like` VALUES (69, 3, 18, '2025-12-15 18:30:00');
INSERT INTO `post_like` VALUES (70, 3, 19, '2025-12-15 19:00:00');
INSERT INTO `post_like` VALUES (71, 3, 20, '2025-12-15 19:30:00');
INSERT INTO `post_like` VALUES (72, 3, 21, '2025-12-15 20:00:00');
INSERT INTO `post_like` VALUES (73, 3, 22, '2025-12-15 20:30:00');
INSERT INTO `post_like` VALUES (74, 3, 23, '2025-12-15 21:00:00');
INSERT INTO `post_like` VALUES (75, 3, 24, '2025-12-15 21:30:00');
INSERT INTO `post_like` VALUES (76, 3, 25, '2025-12-15 22:00:00');
INSERT INTO `post_like` VALUES (77, 3, 26, '2025-12-15 22:30:00');
INSERT INTO `post_like` VALUES (78, 3, 27, '2025-12-15 23:00:00');
INSERT INTO `post_like` VALUES (79, 3, 28, '2025-12-16 08:00:00');

-- 帖子4的点赞(27个)
INSERT INTO `post_like` VALUES (80, 4, 4, '2025-12-12 10:00:00');
INSERT INTO `post_like` VALUES (81, 4, 5, '2025-12-12 10:30:00');
INSERT INTO `post_like` VALUES (82, 4, 6, '2025-12-12 11:00:00');
INSERT INTO `post_like` VALUES (83, 4, 7, '2025-12-12 11:30:00');
INSERT INTO `post_like` VALUES (84, 4, 8, '2025-12-12 12:00:00');
INSERT INTO `post_like` VALUES (85, 4, 9, '2025-12-12 12:30:00');
INSERT INTO `post_like` VALUES (86, 4, 10, '2025-12-12 13:00:00');
INSERT INTO `post_like` VALUES (87, 4, 11, '2025-12-12 13:30:00');
INSERT INTO `post_like` VALUES (88, 4, 12, '2025-12-12 14:00:00');
INSERT INTO `post_like` VALUES (89, 4, 13, '2025-12-12 14:30:00');
INSERT INTO `post_like` VALUES (90, 4, 14, '2025-12-12 15:00:00');
INSERT INTO `post_like` VALUES (91, 4, 15, '2025-12-12 15:30:00');
INSERT INTO `post_like` VALUES (92, 4, 16, '2025-12-12 16:00:00');
INSERT INTO `post_like` VALUES (93, 4, 17, '2025-12-12 16:30:00');
INSERT INTO `post_like` VALUES (94, 4, 18, '2025-12-12 17:00:00');
INSERT INTO `post_like` VALUES (95, 4, 19, '2025-12-12 17:30:00');
INSERT INTO `post_like` VALUES (96, 4, 20, '2025-12-12 18:00:00');
INSERT INTO `post_like` VALUES (97, 4, 21, '2025-12-12 18:30:00');
INSERT INTO `post_like` VALUES (98, 4, 22, '2025-12-12 19:00:00');
INSERT INTO `post_like` VALUES (99, 4, 23, '2025-12-12 19:30:00');
INSERT INTO `post_like` VALUES (100, 4, 24, '2025-12-12 20:00:00');
INSERT INTO `post_like` VALUES (101, 4, 25, '2025-12-12 20:30:00');
INSERT INTO `post_like` VALUES (102, 4, 26, '2025-12-12 21:00:00');
INSERT INTO `post_like` VALUES (103, 4, 27, '2025-12-12 21:30:00');
INSERT INTO `post_like` VALUES (104, 4, 28, '2025-12-12 22:00:00');
INSERT INTO `post_like` VALUES (105, 4, 29, '2025-12-12 22:30:00');
INSERT INTO `post_like` VALUES (106, 4, 30, '2025-12-13 08:00:00');
INSERT INTO `post_like` VALUES (107, 4, 31, '2025-12-13 08:30:00');

-- 帖子5的点赞(24个)
INSERT INTO `post_like` VALUES (108, 5, 4, '2025-12-10 17:00:00');
INSERT INTO `post_like` VALUES (109, 5, 5, '2025-12-10 17:30:00');
INSERT INTO `post_like` VALUES (110, 5, 6, '2025-12-10 18:00:00');
INSERT INTO `post_like` VALUES (111, 5, 7, '2025-12-10 18:30:00');
INSERT INTO `post_like` VALUES (112, 5, 8, '2025-12-10 19:00:00');
INSERT INTO `post_like` VALUES (113, 5, 9, '2025-12-10 19:30:00');
INSERT INTO `post_like` VALUES (114, 5, 10, '2025-12-10 20:00:00');
INSERT INTO `post_like` VALUES (115, 5, 11, '2025-12-10 20:30:00');
INSERT INTO `post_like` VALUES (116, 5, 12, '2025-12-10 21:00:00');
INSERT INTO `post_like` VALUES (117, 5, 13, '2025-12-10 21:30:00');
INSERT INTO `post_like` VALUES (118, 5, 14, '2025-12-10 22:00:00');
INSERT INTO `post_like` VALUES (119, 5, 15, '2025-12-10 22:30:00');
INSERT INTO `post_like` VALUES (120, 5, 16, '2025-12-10 23:00:00');
INSERT INTO `post_like` VALUES (121, 5, 17, '2025-12-10 23:30:00');
INSERT INTO `post_like` VALUES (122, 5, 18, '2025-12-11 08:00:00');
INSERT INTO `post_like` VALUES (123, 5, 19, '2025-12-11 08:30:00');
INSERT INTO `post_like` VALUES (124, 5, 20, '2025-12-11 09:00:00');
INSERT INTO `post_like` VALUES (125, 5, 21, '2025-12-11 09:30:00');
INSERT INTO `post_like` VALUES (126, 5, 22, '2025-12-11 10:00:00');
INSERT INTO `post_like` VALUES (127, 5, 23, '2025-12-11 10:30:00');
INSERT INTO `post_like` VALUES (128, 5, 24, '2025-12-11 11:00:00');
INSERT INTO `post_like` VALUES (129, 5, 25, '2025-12-11 11:30:00');
INSERT INTO `post_like` VALUES (130, 5, 26, '2025-12-11 12:00:00');
INSERT INTO `post_like` VALUES (131, 5, 27, '2025-12-11 12:30:00');

-- 帖子6的点赞(29个)
INSERT INTO `post_like` VALUES (132, 6, 4, '2025-12-08 12:00:00');
INSERT INTO `post_like` VALUES (133, 6, 5, '2025-12-08 12:30:00');
INSERT INTO `post_like` VALUES (134, 6, 7, '2025-12-08 13:00:00');
INSERT INTO `post_like` VALUES (135, 6, 8, '2025-12-08 13:30:00');
INSERT INTO `post_like` VALUES (136, 6, 9, '2025-12-08 14:00:00');
INSERT INTO `post_like` VALUES (137, 6, 10, '2025-12-08 14:30:00');
INSERT INTO `post_like` VALUES (138, 6, 11, '2025-12-08 15:00:00');
INSERT INTO `post_like` VALUES (139, 6, 12, '2025-12-08 15:30:00');
INSERT INTO `post_like` VALUES (140, 6, 13, '2025-12-08 16:00:00');
INSERT INTO `post_like` VALUES (141, 6, 14, '2025-12-08 16:30:00');
INSERT INTO `post_like` VALUES (142, 6, 15, '2025-12-08 17:00:00');
INSERT INTO `post_like` VALUES (143, 6, 16, '2025-12-08 17:30:00');
INSERT INTO `post_like` VALUES (144, 6, 17, '2025-12-08 18:00:00');
INSERT INTO `post_like` VALUES (145, 6, 18, '2025-12-08 18:30:00');
INSERT INTO `post_like` VALUES (146, 6, 19, '2025-12-08 19:00:00');
INSERT INTO `post_like` VALUES (147, 6, 20, '2025-12-08 19:30:00');
INSERT INTO `post_like` VALUES (148, 6, 21, '2025-12-08 20:00:00');
INSERT INTO `post_like` VALUES (149, 6, 22, '2025-12-08 20:30:00');
INSERT INTO `post_like` VALUES (150, 6, 23, '2025-12-08 21:00:00');
INSERT INTO `post_like` VALUES (151, 6, 24, '2025-12-08 21:30:00');
INSERT INTO `post_like` VALUES (152, 6, 25, '2025-12-08 22:00:00');
INSERT INTO `post_like` VALUES (153, 6, 26, '2025-12-08 22:30:00');
INSERT INTO `post_like` VALUES (154, 6, 27, '2025-12-08 23:00:00');
INSERT INTO `post_like` VALUES (155, 6, 28, '2025-12-09 08:00:00');
INSERT INTO `post_like` VALUES (156, 6, 29, '2025-12-09 08:30:00');
INSERT INTO `post_like` VALUES (157, 6, 30, '2025-12-09 09:00:00');
INSERT INTO `post_like` VALUES (158, 6, 31, '2025-12-09 09:30:00');
INSERT INTO `post_like` VALUES (159, 6, 32, '2025-12-09 10:00:00');
INSERT INTO `post_like` VALUES (160, 6, 33, '2025-12-09 10:30:00');
INSERT INTO `post_like` VALUES (161, 6, 34, '2025-12-09 11:00:00');

-- 帖子7的点赞(23个)
INSERT INTO `post_like` VALUES (162, 7, 4, '2025-12-05 15:00:00');
INSERT INTO `post_like` VALUES (163, 7, 5, '2025-12-05 15:30:00');
INSERT INTO `post_like` VALUES (164, 7, 6, '2025-12-05 16:00:00');
INSERT INTO `post_like` VALUES (165, 7, 7, '2025-12-05 16:30:00');
INSERT INTO `post_like` VALUES (166, 7, 8, '2025-12-05 17:00:00');
INSERT INTO `post_like` VALUES (167, 7, 9, '2025-12-05 17:30:00');
INSERT INTO `post_like` VALUES (168, 7, 10, '2025-12-05 18:00:00');
INSERT INTO `post_like` VALUES (169, 7, 11, '2025-12-05 18:30:00');
INSERT INTO `post_like` VALUES (170, 7, 12, '2025-12-05 19:00:00');
INSERT INTO `post_like` VALUES (171, 7, 13, '2025-12-05 19:30:00');
INSERT INTO `post_like` VALUES (172, 7, 14, '2025-12-05 20:00:00');
INSERT INTO `post_like` VALUES (173, 7, 15, '2025-12-05 20:30:00');
INSERT INTO `post_like` VALUES (174, 7, 16, '2025-12-05 21:00:00');
INSERT INTO `post_like` VALUES (175, 7, 17, '2025-12-05 21:30:00');
INSERT INTO `post_like` VALUES (176, 7, 18, '2025-12-05 22:00:00');
INSERT INTO `post_like` VALUES (177, 7, 19, '2025-12-05 22:30:00');
INSERT INTO `post_like` VALUES (178, 7, 20, '2025-12-05 23:00:00');
INSERT INTO `post_like` VALUES (179, 7, 21, '2025-12-05 23:30:00');
INSERT INTO `post_like` VALUES (180, 7, 22, '2025-12-06 08:00:00');
INSERT INTO `post_like` VALUES (181, 7, 23, '2025-12-06 08:30:00');
INSERT INTO `post_like` VALUES (182, 7, 24, '2025-12-06 09:00:00');
INSERT INTO `post_like` VALUES (183, 7, 25, '2025-12-06 09:30:00');
INSERT INTO `post_like` VALUES (184, 7, 26, '2025-12-06 10:00:00');

-- 帖子8的点赞(22个)
INSERT INTO `post_like` VALUES (185, 8, 4, '2025-12-03 11:00:00');
INSERT INTO `post_like` VALUES (186, 8, 5, '2025-12-03 11:30:00');
INSERT INTO `post_like` VALUES (187, 8, 6, '2025-12-03 12:00:00');
INSERT INTO `post_like` VALUES (188, 8, 8, '2025-12-03 12:30:00');
INSERT INTO `post_like` VALUES (189, 8, 9, '2025-12-03 13:00:00');
INSERT INTO `post_like` VALUES (190, 8, 10, '2025-12-03 13:30:00');
INSERT INTO `post_like` VALUES (191, 8, 11, '2025-12-03 14:00:00');
INSERT INTO `post_like` VALUES (192, 8, 12, '2025-12-03 14:30:00');
INSERT INTO `post_like` VALUES (193, 8, 13, '2025-12-03 15:00:00');
INSERT INTO `post_like` VALUES (194, 8, 14, '2025-12-03 15:30:00');
INSERT INTO `post_like` VALUES (195, 8, 15, '2025-12-03 16:00:00');
INSERT INTO `post_like` VALUES (196, 8, 16, '2025-12-03 16:30:00');
INSERT INTO `post_like` VALUES (197, 8, 17, '2025-12-03 17:00:00');
INSERT INTO `post_like` VALUES (198, 8, 18, '2025-12-03 17:30:00');
INSERT INTO `post_like` VALUES (199, 8, 19, '2025-12-03 18:00:00');
INSERT INTO `post_like` VALUES (200, 8, 20, '2025-12-03 18:30:00');
INSERT INTO `post_like` VALUES (201, 8, 21, '2025-12-03 19:00:00');
INSERT INTO `post_like` VALUES (202, 8, 22, '2025-12-03 19:30:00');
INSERT INTO `post_like` VALUES (203, 8, 23, '2025-12-03 20:00:00');
INSERT INTO `post_like` VALUES (204, 8, 24, '2025-12-03 20:30:00');
INSERT INTO `post_like` VALUES (205, 8, 25, '2025-12-03 21:00:00');
INSERT INTO `post_like` VALUES (206, 8, 26, '2025-12-03 21:30:00');

-- 帖子9的点赞(25个)
INSERT INTO `post_like` VALUES (207, 9, 4, '2025-12-01 16:00:00');
INSERT INTO `post_like` VALUES (208, 9, 5, '2025-12-01 16:30:00');
INSERT INTO `post_like` VALUES (209, 9, 6, '2025-12-01 17:00:00');
INSERT INTO `post_like` VALUES (210, 9, 7, '2025-12-01 17:30:00');
INSERT INTO `post_like` VALUES (211, 9, 8, '2025-12-01 18:00:00');
INSERT INTO `post_like` VALUES (212, 9, 9, '2025-12-01 18:30:00');
INSERT INTO `post_like` VALUES (213, 9, 10, '2025-12-01 19:00:00');
INSERT INTO `post_like` VALUES (214, 9, 11, '2025-12-01 19:30:00');
INSERT INTO `post_like` VALUES (215, 9, 12, '2025-12-01 20:00:00');
INSERT INTO `post_like` VALUES (216, 9, 13, '2025-12-01 20:30:00');
INSERT INTO `post_like` VALUES (217, 9, 14, '2025-12-01 21:00:00');
INSERT INTO `post_like` VALUES (218, 9, 15, '2025-12-01 21:30:00');
INSERT INTO `post_like` VALUES (219, 9, 16, '2025-12-01 22:00:00');
INSERT INTO `post_like` VALUES (220, 9, 17, '2025-12-01 22:30:00');
INSERT INTO `post_like` VALUES (221, 9, 18, '2025-12-01 23:00:00');
INSERT INTO `post_like` VALUES (222, 9, 19, '2025-12-01 23:30:00');
INSERT INTO `post_like` VALUES (223, 9, 20, '2025-12-02 08:00:00');
INSERT INTO `post_like` VALUES (224, 9, 21, '2025-12-02 08:30:00');
INSERT INTO `post_like` VALUES (225, 9, 22, '2025-12-02 09:00:00');
INSERT INTO `post_like` VALUES (226, 9, 23, '2025-12-02 09:30:00');
INSERT INTO `post_like` VALUES (227, 9, 24, '2025-12-02 10:00:00');
INSERT INTO `post_like` VALUES (228, 9, 25, '2025-12-02 10:30:00');
INSERT INTO `post_like` VALUES (229, 9, 26, '2025-12-02 11:00:00');
INSERT INTO `post_like` VALUES (230, 9, 27, '2025-12-02 11:30:00');
INSERT INTO `post_like` VALUES (231, 9, 28, '2025-12-02 12:00:00');

-- 帖子10的点赞(26个)
INSERT INTO `post_like` VALUES (232, 10, 4, '2025-11-28 10:00:00');
INSERT INTO `post_like` VALUES (233, 10, 5, '2025-11-28 10:30:00');
INSERT INTO `post_like` VALUES (234, 10, 6, '2025-11-28 11:00:00');
INSERT INTO `post_like` VALUES (235, 10, 7, '2025-11-28 11:30:00');
INSERT INTO `post_like` VALUES (236, 10, 9, '2025-11-28 12:00:00');
INSERT INTO `post_like` VALUES (237, 10, 10, '2025-11-28 12:30:00');
INSERT INTO `post_like` VALUES (238, 10, 11, '2025-11-28 13:00:00');
INSERT INTO `post_like` VALUES (239, 10, 12, '2025-11-28 13:30:00');
INSERT INTO `post_like` VALUES (240, 10, 13, '2025-11-28 14:00:00');
INSERT INTO `post_like` VALUES (241, 10, 14, '2025-11-28 14:30:00');
INSERT INTO `post_like` VALUES (242, 10, 15, '2025-11-28 15:00:00');
INSERT INTO `post_like` VALUES (243, 10, 16, '2025-11-28 15:30:00');
INSERT INTO `post_like` VALUES (244, 10, 17, '2025-11-28 16:00:00');
INSERT INTO `post_like` VALUES (245, 10, 18, '2025-11-28 16:30:00');
INSERT INTO `post_like` VALUES (246, 10, 19, '2025-11-28 17:00:00');
INSERT INTO `post_like` VALUES (247, 10, 20, '2025-11-28 17:30:00');
INSERT INTO `post_like` VALUES (248, 10, 21, '2025-11-28 18:00:00');
INSERT INTO `post_like` VALUES (249, 10, 22, '2025-11-28 18:30:00');
INSERT INTO `post_like` VALUES (250, 10, 23, '2025-11-28 19:00:00');
INSERT INTO `post_like` VALUES (251, 10, 24, '2025-11-28 19:30:00');
INSERT INTO `post_like` VALUES (252, 10, 25, '2025-11-28 20:00:00');
INSERT INTO `post_like` VALUES (253, 10, 26, '2025-11-28 20:30:00');
INSERT INTO `post_like` VALUES (254, 10, 27, '2025-11-28 21:00:00');
INSERT INTO `post_like` VALUES (255, 10, 28, '2025-11-28 21:30:00');
INSERT INTO `post_like` VALUES (256, 10, 29, '2025-11-28 22:00:00');
INSERT INTO `post_like` VALUES (257, 10, 30, '2025-11-28 22:30:00');

-- 帖子11的点赞(27个)
INSERT INTO `post_like` VALUES (258, 11, 2, '2025-11-25 14:00:00');
INSERT INTO `post_like` VALUES (259, 11, 4, '2025-11-25 14:30:00');
INSERT INTO `post_like` VALUES (260, 11, 5, '2025-11-25 15:00:00');
INSERT INTO `post_like` VALUES (261, 11, 6, '2025-11-25 15:30:00');
INSERT INTO `post_like` VALUES (262, 11, 7, '2025-11-25 16:00:00');
INSERT INTO `post_like` VALUES (263, 11, 8, '2025-11-25 16:30:00');
INSERT INTO `post_like` VALUES (264, 11, 9, '2025-11-25 17:00:00');
INSERT INTO `post_like` VALUES (265, 11, 10, '2025-11-25 17:30:00');
INSERT INTO `post_like` VALUES (266, 11, 11, '2025-11-25 18:00:00');
INSERT INTO `post_like` VALUES (267, 11, 12, '2025-11-25 18:30:00');
INSERT INTO `post_like` VALUES (268, 11, 13, '2025-11-25 19:00:00');
INSERT INTO `post_like` VALUES (269, 11, 14, '2025-11-25 19:30:00');
INSERT INTO `post_like` VALUES (270, 11, 15, '2025-11-25 20:00:00');
INSERT INTO `post_like` VALUES (271, 11, 16, '2025-11-25 20:30:00');
INSERT INTO `post_like` VALUES (272, 11, 17, '2025-11-25 21:00:00');
INSERT INTO `post_like` VALUES (273, 11, 18, '2025-11-25 21:30:00');
INSERT INTO `post_like` VALUES (274, 11, 19, '2025-11-25 22:00:00');
INSERT INTO `post_like` VALUES (275, 11, 20, '2025-11-25 22:30:00');
INSERT INTO `post_like` VALUES (276, 11, 21, '2025-11-25 23:00:00');
INSERT INTO `post_like` VALUES (277, 11, 22, '2025-11-25 23:30:00');
INSERT INTO `post_like` VALUES (278, 11, 23, '2025-11-26 08:00:00');
INSERT INTO `post_like` VALUES (279, 11, 24, '2025-11-26 08:30:00');
INSERT INTO `post_like` VALUES (280, 11, 25, '2025-11-26 09:00:00');
INSERT INTO `post_like` VALUES (281, 11, 26, '2025-11-26 09:30:00');
INSERT INTO `post_like` VALUES (282, 11, 27, '2025-11-26 10:00:00');
INSERT INTO `post_like` VALUES (283, 11, 28, '2025-11-26 10:30:00');
INSERT INTO `post_like` VALUES (284, 11, 29, '2025-11-26 11:00:00');

-- ----------------------------
-- Table structure for image
-- ----------------------------
DROP TABLE IF EXISTS `image`;
CREATE TABLE `image`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片路径',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片类别',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件名',
  `mime_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'MIME类型',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小',
  `entity_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '实体类型',
  `entity_id` bigint NULL DEFAULT NULL COMMENT '实体ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '状态',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_image_entity_type`(`entity_type` ASC) USING BTREE,
  INDEX `idx_image_entity_id`(`entity_id` ASC) USING BTREE,
  INDEX `idx_image_category`(`category` ASC) USING BTREE,
  INDEX `idx_image_path`(`path` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图片表' ROW_FORMAT = Dynamic;


SET FOREIGN_KEY_CHECKS = 1;