DROP SCHEMA IF EXISTS user_db;
DROP SCHEMA IF EXISTS system_db;
DROP SCHEMA IF EXISTS nursery_db;
DROP SCHEMA IF EXISTS fixed_db;
CREATE SCHEMA user_db;
CREATE SCHEMA system_db;
CREATE SCHEMA nursery_db;
CREATE SCHEMA fixed_db;

-- 既存の場合、CREATEできない
CREATE USER IF NOT EXISTS 'yzmw1213'@'%' IDENTIFIED BY 'fga%45ng2eBj9d';
GRANT ALL ON user_db.* TO 'yzmw1213'@'%';
GRANT ALL ON system_db.* TO 'yzmw1213'@'%';
GRANT ALL ON nursery_db.* TO 'yzmw1213'@'%';
GRANT ALL ON fixed_db.* TO 'yzmw1213'@'%';

DROP TABLE IF EXISTS user_db.users;
DROP TABLE IF EXISTS system_db.system_users;
DROP TABLE IF EXISTS nursery_db.familys;
DROP TABLE IF EXISTS nursery_db.family_users;
DROP TABLE IF EXISTS nursery_db.nursery_facilitys;
DROP TABLE IF EXISTS nursery_db.nursery_users;
DROP TABLE IF EXISTS nursery_db.nursery_childs;
DROP TABLE IF EXISTS fixed_db.allergic_foods;
DROP TABLE IF EXISTS fixed_db.menus;
DROP TABLE IF EXISTS fixed_db.school_meal_menu_allergic_uses;
DROP TABLE IF EXISTS nursery_db.allergic_food_intake_results;
DROP TABLE IF EXISTS nursery_db.nursery_lunch_menus;
DROP TABLE IF EXISTS nursery_db.nursery_lunch_menu_alter_supply_results;
DROP TABLE IF EXISTS nursery_db.nursery_lunch_menu_alter_supply_reasons;

CREATE TABLE user_db.users
(
    user_id int(255) NOT NULL AUTO_INCREMENT COMMENT 'ユーザーID',
    name varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '名前',
    email varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'メールアドレス',
    firebase_uid varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'uid',
    authority varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '権限',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `uk_uu_1` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ユーザー';

CREATE TABLE system_db.system_users
(
    system_user_id int(255) NOT NULL AUTO_INCREMENT COMMENT 'システム管理ユーザーID',
    user_id int(255) NOT NULL DEFAULT '0' COMMENT 'ユーザーID',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`system_user_id`),
    FOREIGN KEY `fk_su_1` (`user_id`) REFERENCES `user_db` . `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='システム管理ユーザー';

CREATE TABLE nursery_db.familys
(
    family_id int(255) NOT NULL AUTO_INCREMENT COMMENT '家庭ID',
    tel varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '電話番号',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`family_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='家庭';

CREATE TABLE nursery_db.family_users
(
    family_user_id int(255) NOT NULL AUTO_INCREMENT COMMENT '家庭ユーザーID',
    family_id int(255) NOT NULL DEFAULT '0' COMMENT '家庭ID',
    user_id int(255) NOT NULL DEFAULT '0' COMMENT 'ユーザーID',
    name_first varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '名',
    name_last varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '姓',
    tel varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '電話番号',
    relationship varchar(20) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '続柄',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`family_user_id`),
    FOREIGN KEY `fk_fu_1` (`family_id`) REFERENCES `nursery_db` . `familys` (`family_id`) ON DELETE CASCADE,
    FOREIGN KEY `fk_fu_2` (`user_id`) REFERENCES `user_db` . `users` (`user_id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_fu` (`family_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='家庭ユーザー';

CREATE TABLE nursery_db.nursery_facilitys
(
    nursery_facility_id int(255) NOT NULL AUTO_INCREMENT COMMENT '保育施設ID',
    name varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '名前',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`nursery_facility_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='保育施設';

CREATE TABLE nursery_db.nursery_users
(
    nursery_user_id int(255) NOT NULL AUTO_INCREMENT COMMENT '保育施設職員ユーザーID',
    nursery_facility_id int(255) NOT NULL DEFAULT '0' COMMENT '保育施設ID',
    user_id int(255) NOT NULL DEFAULT '0' COMMENT 'ユーザーID',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`nursery_user_id`),
    FOREIGN KEY `fk_nu_1` (`user_id`) REFERENCES `user_db` . `users` (`user_id`) ON DELETE CASCADE,
    FOREIGN KEY `fk_nu_2` (`nursery_facility_id`) REFERENCES `nursery_db` . `nursery_facilitys` (`nursery_facility_id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_nu` (`user_id`, `nursery_facility_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='保育施設職員ユーザー';

CREATE TABLE nursery_db.nursery_childs
(
    nursery_child_id int(255) NOT NULL AUTO_INCREMENT COMMENT '園児ID',
    family_id int(255) NOT NULL DEFAULT '0' COMMENT '家庭ID',
    name_first varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '名',
    name_last varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '姓',
    gender varchar(2) NOT NULL DEFAULT '0' COMMENT '性別',
    birth_date date NOT NULL DEFAULT '0001-01-01' COMMENT '生年月日',
    entrance_date date NOT NULL DEFAULT '0001-01-01' COMMENT '入園日',
    graduate_date date NOT NULL DEFAULT '0001-01-01' COMMENT '卒園日',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`nursery_child_id`),
    FOREIGN KEY `fk_nc_1` (`family_id`) REFERENCES `nursery_db` . `familys` (`family_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='家庭ユーザー';

CREATE TABLE fixed_db.allergic_foods
(
    allergic_food_id int(255) NOT NULL AUTO_INCREMENT COMMENT 'アレルギー食材ID',
    name varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '名前',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`allergic_food_id`),
    UNIQUE KEY `uk_af` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='アレルギー食材';

CREATE TABLE fixed_db.menus
(
    menu_id int(255) NOT NULL AUTO_INCREMENT COMMENT '献立メニューID',
    name varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '名前',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`menu_id`),
    UNIQUE KEY `uk_fm` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='献立メニュー';

CREATE TABLE fixed_db.school_meal_menu_allergic_uses
(
    menu_allergic_use_id int(255) NOT NULL AUTO_INCREMENT COMMENT '献立アレルギー使用ID',
    menu_id int(255) NOT NULL DEFAULT '0' COMMENT '献立ID',
    allergic_food_id int(255) NOT NULL DEFAULT '0' COMMENT 'アレルギー食材ID',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`menu_allergic_use_id`),
    FOREIGN KEY `fk_smmau_1` (`menu_id`) REFERENCES `fixed_db` . `menus` (`menu_id`) ON DELETE CASCADE,
    FOREIGN KEY `fk_smmau_2` (`allergic_food_id`) REFERENCES `fixed_db` . `allergic_foods` (`allergic_food_id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_smmau` (`menu_id`, `allergic_food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='献立アレルギー使用';

CREATE TABLE nursery_db.allergic_food_intake_results
(
    allergic_food_intake_result_id int(255) NOT NULL AUTO_INCREMENT COMMENT 'アレルギー食品摂取実績ID',
    nursery_child_id int(255) NOT NULL DEFAULT '0' COMMENT '園児ID',
    allergic_food_id int(255) NOT NULL DEFAULT '0' COMMENT 'アレルギー食材ID',
    result int(255) NOT NULL DEFAULT '0' COMMENT '結果',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`allergic_food_intake_result_id`),
    FOREIGN KEY `fk_afir_1` (`nursery_child_id`) REFERENCES `nursery_db` . `nursery_childs` (`nursery_child_id`) ON DELETE CASCADE,
    FOREIGN KEY `fk_afir_2` (`allergic_food_id`) REFERENCES `fixed_db` . `allergic_foods` (`allergic_food_id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_afir` (`nursery_child_id`, `allergic_food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='アレルギー食品摂取実績';

CREATE TABLE nursery_db.nursery_lunch_menus
(
    nursery_lunch_menu_id int(255) NOT NULL AUTO_INCREMENT COMMENT '保育園献立ID',
    nursery_facility_id int(255) NOT NULL DEFAULT '0' COMMENT '保育施設ID',
    menu_id int(255) NOT NULL DEFAULT '0' COMMENT '献立メニューID',
    supply_date date NOT NULL DEFAULT '0001-01-01' COMMENT '提供日',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`nursery_lunch_menu_id`),
    FOREIGN KEY `fk_nlm_1` (`nursery_facility_id`) REFERENCES `nursery_db` . `nursery_facilitys` (`nursery_facility_id`) ON DELETE CASCADE,
    FOREIGN KEY `fk_nlm_2` (`menu_id`) REFERENCES `fixed_db` . `menus` (`menu_id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_nlm` (`nursery_facility_id`, `menu_id`, `supply_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='保育園献立ID';

CREATE TABLE nursery_db.nursery_lunch_menu_alter_supply_results
(
    nursery_lunch_menu_alter_supply_result_id int(255) NOT NULL AUTO_INCREMENT COMMENT '献立代替提供結果ID',
    nursery_child_id int(255) NOT NULL DEFAULT '0' COMMENT '園児ID',
    nursery_lunch_menu_id int(255) NOT NULL DEFAULT '0' COMMENT '保育園献立ID',
    result int(2) NOT NULL DEFAULT '0' COMMENT '結果（1:提供しなかった,2:一部材料を代替して提供）',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`nursery_lunch_menu_alter_supply_result_id`),
    FOREIGN KEY `fk_nlmasr_1` (`nursery_child_id`) REFERENCES `nursery_db` . `nursery_childs` (`nursery_child_id`) ON DELETE CASCADE,
    FOREIGN KEY `fk_nlmasr_2` (`nursery_lunch_menu_id`) REFERENCES `nursery_db` . `nursery_lunch_menus` (`nursery_lunch_menu_id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_nlmasr` (`nursery_child_id`, `nursery_lunch_menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='献立代替提供結果';

CREATE TABLE nursery_db.nursery_lunch_menu_alter_supply_reasons
(
    nursery_lunch_menu_alter_supply_reason_id int(255) NOT NULL AUTO_INCREMENT COMMENT '献立代替提供理由ID',
    nursery_lunch_menu_alter_supply_result_id int(255) NOT NULL DEFAULT '0' COMMENT '献立代替提供結果ID',
    reason_allergic_food_id int(2) NOT NULL DEFAULT '0' COMMENT '代替提供原因アレルギー食品',
    delete_flag tinyint(1) NOT NULL DEFAULT '0' COMMENT '削除フラグ',
    update_user_id int(255) NOT NULL DEFAULT '0' COMMENT '更新ユーザーID',
    updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
    PRIMARY KEY (`nursery_lunch_menu_alter_supply_reason_id`),
    FOREIGN KEY `fk_nlmasre_1` (`nursery_lunch_menu_alter_supply_result_id`) REFERENCES `nursery_db` . `nursery_lunch_menu_alter_supply_results` (`nursery_lunch_menu_alter_supply_result_id`) ON DELETE CASCADE,
    FOREIGN KEY `fk_nlmasre_2` (`reason_allergic_food_id`) REFERENCES `fixed_db` . `allergic_foods` (`allergic_food_id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_nlmasre` (`nursery_lunch_menu_alter_supply_result_id`, `reason_allergic_food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='献立代替提供理由';

DELETE FROM fixed_db.allergic_foods;
INSERT INTO fixed_db.allergic_foods
(name, update_user_id) VALUES
('小麦粉', 1),
('卵', 1),
('鶏肉', 1),
('牛肉', 1),
('豚肉', 1),
('大豆', 1),
('乳製品', 1),
('ナッツ類', 1),
('エビ', 1),
('カニ', 1),
('あわび', 1),
('いか', 1),
('いくら', 1),
('さけ', 1),
('さば', 1),
('たこ', 1),
('ちくわ', 1),
('つぶ貝', 1),
('てんぷら', 1),
('とり貝', 1),
('なまこ', 1),
('にしん', 1),
('ひらめ', 1),
('ぶり', 1),
('めだか', 1),
('やりいか', 1),
('うなぎ', 1),
('おおあわび', 1),
('かに', 1),
('きす', 1),
('くるまえび', 1),
('こはだ', 1),
('しいたけ', 1),
('ししゃも', 1),
('ずわいがに', 1),
('たい', 1),
('たら', 1),
('ちりめんじゃこ', 1),
('ふぐ', 1),
('めばる', 1),
('わかめ', 1),
('アーモンド', 1),
('イカ', 1),
('ウナギ', 1),
('エノキダケ', 1),
('オイスター', 1),
('カツオ', 1),
('カボチャ', 1),
('キクラゲ', 1),
('クジラ', 1),
('コーヒー', 1),
('ゴボウ', 1),
('サバ', 1),
('サケ', 1),
('シジミ', 1),
('スッポン', 1),
('ゼラチン', 1),
('タイ', 1),
('チーズ', 1),
('チョコレート', 1),
('テンプラ', 1),
('トリ貝', 1),
('ナマコ', 1),
('ニシン', 1),
('ニンニク', 1),
('ネギ', 1),
('ノリ', 1),
('バター', 1),
('パイナップル', 1),
('ピーナッツ', 1),
('プリン', 1),
('ベーコン', 1),
('ホタテ', 1),
('マヨネーズ', 1),
('ミルク', 1),
('ユズ', 1);
