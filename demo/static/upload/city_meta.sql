/*
 Navicat Premium Data Transfer

 Source Server         : loc
 Source Server Type    : MySQL
 Source Server Version : 80011
 Source Host           : localhost
 Source Database       : qcs

 Target Server Type    : MySQL
 Target Server Version : 80011
 File Encoding         : utf-8

 Date: 08/07/2018 18:24:35 PM
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `city_meta`
-- ----------------------------
DROP TABLE IF EXISTS `city_meta`;
CREATE TABLE `city_meta` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `appkey` varchar(128) NOT NULL,
  `env` int(11) NOT NULL,
  `city_id` bigint(20) NOT NULL,
  `city_name` varchar(128) NOT NULL,
  `label` varchar(128) NOT NULL,
  `dim` varchar(128) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ctime` datetime DEFAULT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idu_cm_key` (`appkey`,`env`,`city_id`,`label`,`dim`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
