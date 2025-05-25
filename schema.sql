-- The plants table is to store the names of all the different types of plants along with a unique id for each one and,
-- The status of the plant either active(still growing) or inactive(died or no longer taken care of).
CREATE TABLE `plants` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    PRIMARY KEY(`id`)
);

-- The Soil table is to store the different types of soil that can be used for plants,
-- ex. Clay, Silt, Loamy, Sand, Chalk, Peat, etc.
CREATE TABLE `soil` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL UNIQUE,
    PRIMARY KEY(`id`)
);

-- The water table is to store the differnt types of water that can be used for plants.
CREATE TABLE `water` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `type` ENUM(
        'Tap Water', 
        'Well Water', 
        'Mineral Water', 
        'Spring Water', 
        'Distilled Water', 
        'Alkaline Water', 
        'Purified Water'
    ) NOT NULL,
    PRIMARY KEY(`id`)
);

-- The plant_log table is a grow log for all the plants and its day to day conditions.
CREATE TABLE `plant_log` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Date and time of the log entry
    `plant_id` INT UNSIGNED NOT NULL, -- Plant id as per the plants table
    `soil_id` INT UNSIGNED NOT NULL, -- Soil type as per the soil table
    `water_id` INT UNSIGNED NOT NULL, -- Water type as per the water table
    `water_amount` DECIMAL(8,2), -- Amount of water recevied measured in milliliters(mL)
    `soil_temperature` DECIMAL(5,2), -- Soil temperature measured in celcius
    `humidity` TINYINT, -- Humidity measured in %
    `light_duration` TIME, -- Duration of light the plant recieves
    `soil_pH` DECIMAL(3,1), -- Soil pH
    `moisture_level` TINYINT, -- Moisture level of soil measured in %
    `electrical_conductivity` DECIMAL(3,1), -- EC measured in millisiemens per centimeter (mS/cm)
    `nitrogen_level` DECIMAL(3,1), -- Nitrogen level measured in %
    `phosphorus_level` DECIMAL(3,1), -- Phosphorus level measured in %
    `potassium_level` DECIMAL(3,1), -- potassium level measured in %
    `calcium_level` DECIMAL(3,1), -- Calcium level measured in %
    `magnesium_level` DECIMAL(3,1), -- Magnesium level measured in %
    `leaf_color` VARCHAR(32), -- Leaf color of the plant
    `height` MEDIUMINT, -- Height of the plant measured in centimeters(cm)
    `stem_thickness` DECIMAL(4,1), -- Stem thickness measured in millimeter(mm)
    `stage` ENUM(
        'Germination', 
        'Seedling', 
        'Vegetative', 
        'Transition', 
        'Flowering', 
        'Fruiting', 
        'Ripening', 
        'Senescence', 
        'Dormancy', 
        'Post-Harvest'
    ) NOT NULL, -- Stage the plant is in
    `pests` VARCHAR(64) DEFAULT 'None', -- Any signs of pests
    `signs_of_disease` VARCHAR(64) DEFAULT 'None', -- Any signs of disease
    `general_condition` TEXT NOT NULL, -- General condition of the plant
    `notes` TEXT, -- Any notes that can be added
    PRIMARY KEY(`id`),
    FOREIGN KEY(`plant_id`) REFERENCES `plants`(`id`),
    FOREIGN KEY(`soil_id`) REFERENCES `soil`(`id`),
    FOREIGN KEY(`water_id`) REFERENCES `water`(`id`)
);

-- The produce table is to record all the results of the plants that were grown it records the type of produce e.g fruits, 
-- and the total yield measured in grams.
CREATE TABLE `produce` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `plant_id` INT UNSIGNED NOT NULL,
    `type` VARCHAR(64) NOT NULL,
    `total_yield` MEDIUMINT UNSIGNED NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`plant_id`) REFERENCES `plants`(`id`)
);

-- The active_plant_log view shows all active plants and each of their logs
CREATE VIEW `active_plant_log` AS 
SELECT 
    `name`, 
    `status`, 
    `plant_log`.`id` AS 'plant_log_id', 
    `datetime`, 
    `plant_id`, 
    `soil_id`, 
    `water_id`, 
    `water_amount`, 
    `soil_temperature`, 
    `humidity`, 
    `light_duration`, 
    `soil_pH`,
    `moisture_level`,
    `electrical_conductivity`,
    `nitrogen_level`,
    `phosphorus_level`,
    `potassium_level`,
    `calcium_level`,
    `magnesium_level`,
    `leaf_color`,
    `height`,
    `stem_thickness`,
    `stage`,
    `pests`,
    `signs_of_disease`,
    `general_condition`,
    `notes` 
FROM `plants`
JOIN `plant_log` ON `plant_log`.`plant_id` = `plants`.`id`
WHERE `status` = 'active';

-- The plants_produce view shows the plant info along with the produce info for that plant.
CREATE VIEW `plants_produce` AS 
SELECT 
    `name`,
    `status`,
    `produce`.`id` AS 'produce_id',
    `date`,
    `plant_id`,
    `type`,
    `total_yield`
FROM `plants`
JOIN `produce` ON `plants`.`id` = `produce`.`plant_id`;

-- The plant_log_ids index is to optimize querying for plant_id or id in the plant_log table
CREATE INDEX `plant_log_ids`
ON `plant_log` (`id`, `plant_id`);

-- The plant_name_status index is to optimize the entire plants table when querying
CREATE INDEX `plant_name_status`
ON `plants` (`id`, `name`, `status`);

-- The produce_ids index is to optimize the ids in the produce table
CREATE INDEX `produce_ids`
ON `produce` (`id`, `plant_id`);

-- The water_types index is to optimize the entire water table when querying
CREATE INDEX `water_types`
ON `water` (`id`, `type`);

-- The soil_names index is to optimize the ids and names in the soil table
CREATE INDEX `soil_names`
ON `soil` (`id`, `name`);
