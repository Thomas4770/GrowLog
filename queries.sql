-- Insert a new plant into the plants table
INSERT INTO `plants` (`name`, `status`) 
VALUES ('Tomato', 'active');

-- Insert some soil types
INSERT INTO `soil` (`name`) VALUES
('Clay'),
('Silt'),
('Loamy'),
('Sand'),
('Peat');

-- Insert all the types of water
INSERT INTO `water` (`type`) VALUES
('Tap Water'),
('Well Water'),
('Mineral Water'),
('Spring Water'),
('Distilled Water'),
('Alkaline Water'), 
('Purified Water');

-- Insert a new log in the plant_log table for a specific plant
INSERT INTO `plant_log` (
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
) 
VALUES (
    '2025-03-22 08:00:00', 
    1, 
    1, 
    1, 
    500.00, 
    22.5, 60, 
    '12:00:00', 
    6.5, 
    30, 
    1.2, 
    1.5, 
    0.8, 
    1.2, 
    1.0, 
    0.5, 
    'Green', 
    45, 
    8.5, 
    'Seedling', 
    'None', 
    'None', 
    'Healthy', 
    'Grew 2 inches in the last week.'
);

-- Insert a new log in the produce table for a specific plant
INSERT INTO `produce` (`date`, `plant_id`, `type`, `total_yield`) 
VALUES ('2025-03-15 14:00:00', 1, 'Fruit', 336);

-- List all types of soil
SELECT * FROM `soil`;

-- Find the ID of a specific soil type
SELECT `id` FROM `soil`
WHERE `name` = 'Clay';

-- List all types of water
SELECT * FROM `water`;

-- Find the ID of a specific water type
SELECT `id` FROM `water`
WHERE `type` = 'Tap Water';

-- Get all the logs for a specific plant searching by name
SELECT * FROM `active_plant_log`
WHERE `name` = 'Tomato';

-- Get all the logs for a specific plant searching by ID
SELECT * 
FROM `plant_log`
WHERE `plant_id` = (
    SELECT `id`
    FROM `plants`
    WHERE `name` = 'Tomato'
);

-- Get all the logs for all the active plants
SELECT *
FROM `active_plant_log`;

-- Get a specific log for a specific plant searching by name
SELECT *
FROM `active_plant_log`
WHERE `name` = 'Tomato'
AND `plant_log_id` = 1;

-- Get a specific column for a specific log for a specific plant searching by name and date
SELECT `height`
FROM `active_plant_log`
WHERE `name` = 'Tomato'
AND `datetime` = '2025-03-22 08:00:00';

-- Get all the produce for a specific plant searching by name
SELECT *
FROM `plants_produce`
WHERE `name` = 'Tomato';

-- Get all the produce for a specific plant searching by ID
SELECT *
FROM `produce`
WHERE `plant_id` = (
    SELECT `id`
    FROM `plants`
    WHERE `name` = 'Tomato'
);

-- Get all the produce for all the active plants
SELECT *
FROM `plants_produce`;

-- Get the average total yield for a specific plant searching by name
SELECT AVG(`total_yield`) AS `average_yield`
FROM `plants_produce`
WHERE `name` = 'Tomato';

-- Get the average total yield for a specific plant searching by ID
SELECT AVG(`total_yield`) AS `average_yield`
FROM `produce`
WHERE `plant_id` = (
    SELECT `id`
    FROM `plants`
    WHERE `name` = 'Tomato'
);

-- Get the id of a specific plant searching by name
SELECT `id`
FROM `plants`
WHERE `name` = 'Tomato';

-- Get the most recent log for a specific plant searching by name
SELECT *
FROM `active_plant_log`
WHERE `name` = 'Tomato'
ORDER BY `datetime` DESC
LIMIT 1;

-- Get the most recent log for a specific plant searching by ID
SELECT *
FROM `plant_log`
WHERE `plant_id` = (
    SELECT `id`
    FROM `plants`
    WHERE `name` = 'Tomato'
)
ORDER BY `datetime` DESC
LIMIT 1;

-- Get the totatl yield for a specific plant searching by name
SELECT SUM(`total_yield`) AS `total_yield`
FROM `plants_produce`
WHERE `name` = 'Tomato';

-- Get the total yield for a specific plant searching by ID
SELECT SUM(`total_yield`) AS `total_yield`
FROM `produce`
WHERE `plant_id` = (
    SELECT `id`
    FROM `plants`
    WHERE `name` = 'Tomato'
);

-- Get the total number of logs for a specific plant searching by name
SELECT COUNT(*) AS `total_logs`
FROM `active_plant_log`
WHERE `name` = 'Tomato';

-- Get the total number of logs for a specific plant searching by ID
SELECT COUNT(*) AS `total_logs`
FROM `plant_log`
WHERE `plant_id` = (
    SELECT `id`
    FROM `plants`
    WHERE `name` = 'Tomato'
);

-- Get all logs or a specfic plant and a specific date range
SELECT *
FROM `active_plant_log`
WHERE `name` = 'Tomato'
AND `datetime` BETWEEN '2025-03-01 00:00:00' AND '2025-03-31 23:59:59';

-- Get all logs or a specific plant and a specific date range searching by ID
SELECT *
FROM `plant_log`
WHERE `plant_id` = (
    SELECT `id`
    FROM `plants`
    WHERE `name` = 'Tomato'
)
AND `datetime` BETWEEN '2025-03-01 00:00:00' AND '2025-03-31 23:59:59';

-- Get all plants that do not have any logs in the plant_log table
SELECT *
FROM `plants`
WHERE `id` NOT IN (
    SELECT DISTINCT `plant_id`
    FROM `plant_log`
);

-- Get all plants that do not have any produce in the produce table
SELECT *
FROM `plants`
WHERE `id` NOT IN (
    SELECT DISTINCT `plant_id`
    FROM `produce`
);

-- Get all plants that have a specific soil type
SELECT *
FROM `plants`
WHERE `id` IN (
    SELECT DISTINCT `plant_id`
    FROM `plant_log`
    WHERE `soil_id` = (
        SELECT `id`
        FROM `soil`
        WHERE `name` = 'Clay'
    )
);

-- Get all plants that have a specific water type
SELECT *
FROM `plants`
WHERE `id` IN (
    SELECT DISTINCT `plant_id`
    FROM `plant_log`
    WHERE `water_id` = (
        SELECT `id`
        FROM `water`
        WHERE `type` = 'Tap Water'
    )
);

-- Get all plants that have a specific stage
SELECT *
FROM `plants`
WHERE `id` IN (
    SELECT DISTINCT `plant_id`
    FROM `plant_log`
    WHERE `stage` = 'Seedling'
);

-- Get the most common soil type for all plants
SELECT `soil_id`, COUNT(*) AS `count`
FROM `plant_log`
GROUP BY `soil_id`
ORDER BY `count` DESC
LIMIT 1;

-- Get the most common water type for all plants
SELECT `water_id`, COUNT(*) AS `count`
FROM `plant_log`
GROUP BY `water_id`
ORDER BY `count` DESC
LIMIT 1;
