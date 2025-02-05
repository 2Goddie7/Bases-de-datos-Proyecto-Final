-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: proyecto_final
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aeropuertos`
--

DROP TABLE IF EXISTS `aeropuertos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aeropuertos` (
  `aeropuerto_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `pais` varchar(100) NOT NULL,
  PRIMARY KEY (`aeropuerto_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aeropuertos`
--

LOCK TABLES `aeropuertos` WRITE;
/*!40000 ALTER TABLE `aeropuertos` DISABLE KEYS */;
/*!40000 ALTER TABLE `aeropuertos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `avion`
--

DROP TABLE IF EXISTS `avion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avion` (
  `avion_id` int NOT NULL AUTO_INCREMENT,
  `modelo` varchar(50) NOT NULL,
  `capacidad` int NOT NULL,
  `aerolinea` varchar(100) NOT NULL,
  PRIMARY KEY (`avion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avion`
--

LOCK TABLES `avion` WRITE;
/*!40000 ALTER TABLE `avion` DISABLE KEYS */;
/*!40000 ALTER TABLE `avion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `cliente_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `documento_identidad` varchar(50) NOT NULL,
  PRIMARY KEY (`cliente_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `documento_identidad` (`documento_identidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `pago_id` int NOT NULL AUTO_INCREMENT,
  `reserva_id` int DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL,
  `metodo_pago` enum('tarjeta','efectivo','transferencia') NOT NULL,
  `estado` enum('completado','pendiente','fallido') NOT NULL,
  `fecha_pago` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`pago_id`),
  KEY `fk_pago_reserva` (`reserva_id`),
  CONSTRAINT `fk_pago_reserva` FOREIGN KEY (`reserva_id`) REFERENCES `reservas` (`reserva_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`reserva_id`) REFERENCES `reservas` (`reserva_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservas`
--

DROP TABLE IF EXISTS `reservas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservas` (
  `reserva_id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int DEFAULT NULL,
  `vuelo_id` int DEFAULT NULL,
  `fecha_reserva` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` enum('confirmada','cancelada','pendiente') NOT NULL,
  PRIMARY KEY (`reserva_id`),
  KEY `fk_reserva_cliente` (`cliente_id`),
  KEY `fk_reserva_vuelo` (`vuelo_id`),
  CONSTRAINT `fk_reserva_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`cliente_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reserva_vuelo` FOREIGN KEY (`vuelo_id`) REFERENCES `vuelos` (`vuelo_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`cliente_id`),
  CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`vuelo_id`) REFERENCES `vuelos` (`vuelo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservas`
--

LOCK TABLES `reservas` WRITE;
/*!40000 ALTER TABLE `reservas` DISABLE KEYS */;
/*!40000 ALTER TABLE `reservas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vuelos`
--

DROP TABLE IF EXISTS `vuelos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vuelos` (
  `vuelo_id` int NOT NULL AUTO_INCREMENT,
  `origen_id` int DEFAULT NULL,
  `destino_id` int DEFAULT NULL,
  `fecha_salida` datetime NOT NULL,
  `fecha_llegada` datetime NOT NULL,
  `avion_id` int DEFAULT NULL,
  PRIMARY KEY (`vuelo_id`),
  KEY `fk_vuelo_origen` (`origen_id`),
  KEY `fk_vuelo_destino` (`destino_id`),
  KEY `fk_vuelo_avion` (`avion_id`),
  CONSTRAINT `fk_vuelo_avion` FOREIGN KEY (`avion_id`) REFERENCES `avion` (`avion_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_vuelo_destino` FOREIGN KEY (`destino_id`) REFERENCES `aeropuertos` (`aeropuerto_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_vuelo_origen` FOREIGN KEY (`origen_id`) REFERENCES `aeropuertos` (`aeropuerto_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `vuelos_ibfk_1` FOREIGN KEY (`origen_id`) REFERENCES `aeropuertos` (`aeropuerto_id`),
  CONSTRAINT `vuelos_ibfk_2` FOREIGN KEY (`destino_id`) REFERENCES `aeropuertos` (`aeropuerto_id`),
  CONSTRAINT `vuelos_ibfk_3` FOREIGN KEY (`avion_id`) REFERENCES `avion` (`avion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vuelos`
--

LOCK TABLES `vuelos` WRITE;
/*!40000 ALTER TABLE `vuelos` DISABLE KEYS */;
/*!40000 ALTER TABLE `vuelos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'proyecto_final'
--

--
-- Dumping routines for database 'proyecto_final'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-04 19:52:32
