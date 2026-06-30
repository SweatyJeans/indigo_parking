
DROP TABLE IF EXISTS `persistent_vehicles`;

CREATE TABLE `persistent_vehicles` (
    `plate` VARCHAR(20) NOT NULL,
    `owner` VARCHAR(80) NOT NULL,
    `model` VARCHAR(100) NOT NULL,
    `fuel` FLOAT DEFAULT 100,
    `x` DOUBLE NOT NULL,
    `y` DOUBLE NOT NULL,
    `z` DOUBLE NOT NULL,
    `heading` FLOAT NOT NULL,
    
    PRIMARY KEY (`plate`),
    INDEX `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;   