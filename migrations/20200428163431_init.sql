-- +goose Up
-- SQL in this section is executed when the migration is applied.

--
-- Table structure for table `orders_address_coords`
--

DROP TABLE IF EXISTS `orders_address_coords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_address_coords` (
    `order_id` int(7) unsigned NOT NULL,
    `lat` double DEFAULT NULL,
    `long` double DEFAULT NULL,
    `point` point NOT NULL DEFAULT '',
    `address` text,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`order_id`),
    UNIQUE KEY `order_id_unique` (`order_id`),
    KEY `point` (`point`(25)) USING BTREE,
    KEY `lat` (`lat`),
    KEY `updated_at` (`updated_at`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO orders_address_coords (order_id, lat, `long`, point, address, updated_at) VALUES (1, 53.20611, 45.011093, 0x000000000101000000761BD47E6B81464075B0FECF619A4A40, 'Tmp address', '2020-03-06 10:23:12');
INSERT INTO orders_address_coords (order_id, lat, `long`, point, address, updated_at) VALUES (267360, 53.20611, 45.011093, 0x000000000101000000761BD47E6B81464075B0FECF619A4A40, 'Tmp address', '2020-02-28 09:27:30');


-- +goose Down
-- SQL in this section is executed when the migration is rolled back.

drop table orders_address_coords;