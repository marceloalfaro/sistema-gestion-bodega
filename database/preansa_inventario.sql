-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: preansa_inventario
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `asignacion`
--

DROP TABLE IF EXISTS `asignacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asignacion` (
  `id_asignacion` int NOT NULL AUTO_INCREMENT,
  `id_trabajador` int NOT NULL,
  `id_producto` int NOT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  `fecha_entrega` date NOT NULL,
  `fecha_devolucion` date DEFAULT NULL,
  `estado` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pendiente',
  `observacion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_asignacion`),
  KEY `id_trabajador` (`id_trabajador`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `asignacion_ibfk_1` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajador` (`id_trabajador`),
  CONSTRAINT `asignacion_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asignacion`
--

LOCK TABLES `asignacion` WRITE;
/*!40000 ALTER TABLE `asignacion` DISABLE KEYS */;
INSERT INTO `asignacion` VALUES (1,1,1,1.00,'2026-09-06','2026-09-30','Dañado',NULL),(4,2,6,1.00,'2026-09-07','2026-10-01','Devuelto',NULL),(6,4,7,1.00,'2026-09-08','2026-10-03','Devuelto',NULL),(7,5,16,20.00,'2026-10-01','2026-10-01','Dañado',''),(8,5,21,12.00,'2026-10-02',NULL,'Pendiente',NULL),(9,2,18,10.00,'2026-10-02',NULL,'Pendiente',NULL),(10,3,7,1.00,'2026-09-28','2026-09-30','Devuelto',NULL),(11,8,19,1.00,'2026-10-03','2026-10-03','Devuelto',NULL),(12,13,18,10.00,'2026-10-03',NULL,'Pendiente',NULL),(13,11,7,12.00,'2026-10-06','2026-10-10','Devuelto',NULL),(14,8,20,10.00,'2026-10-10',NULL,'Pendiente',NULL);
/*!40000 ALTER TABLE `asignacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrada`
--

DROP TABLE IF EXISTS `entrada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entrada` (
  `id_entrada` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `id_proveedor` int NOT NULL,
  `id_producto` int NOT NULL,
  `ndocumento` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_entrada`),
  KEY `id_proveedor` (`id_proveedor`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `entrada_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`),
  CONSTRAINT `entrada_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrada`
--

LOCK TABLES `entrada` WRITE;
/*!40000 ALTER TABLE `entrada` DISABLE KEYS */;
INSERT INTO `entrada` VALUES (1,'2026-09-01',1,6,'FAC-1001',5.00),(2,'2026-09-01',1,7,'FAC-1001',10.00),(3,'2026-09-03',2,1,'FAC-2050',20.00),(4,'2026-09-03',2,2,'FAC-2050',30.00),(5,'2026-09-03',2,3,'FAC-2050',15.00),(6,'2026-09-05',3,4,'GUIA-3001',500.00),(7,'2026-09-05',3,5,'GUIA-3001',200.00),(8,'2026-09-01',1,1,'FAC-1001',15.00),(9,'2026-09-01',1,2,'FAC-1001',50.00),(10,'2026-09-01',1,3,'FAC-1001',30.00),(11,'2026-09-03',2,4,'FAC-2030',20.00),(12,'2026-09-03',2,5,'FAC-2030',25.00),(13,'2026-09-03',2,6,'FAC-2030',40.00),(14,'2026-09-05',3,7,'GUIA-3010',120.00),(15,'2026-09-05',3,8,'GUIA-3010',10.00),(16,'2026-10-02',1,4,'GUIA-3010',20.00),(17,'2026-10-04',1,8,'GUIA-3010',500.00),(18,'2026-10-03',2,22,'GUIA-3010',3.00),(19,'2026-10-03',1,27,'GUIA-3010',2.00),(20,'2026-10-02',3,19,'GUIA-3010',10.00),(21,'2026-10-03',3,18,'GUIA-3010',200.00),(22,'2026-10-04',5,7,'GUIA-3010',20.00),(23,'2026-10-06',3,9,'GUIA-3010',200.00),(24,'2026-10-06',3,27,'GUIA-3010',3.00),(25,'2026-10-10',1,23,'GUIA-3010',5.00),(26,'2026-10-10',1,20,'GUIA-3010',20.00);
/*!40000 ALTER TABLE `entrada` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merma`
--

DROP TABLE IF EXISTS `merma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merma` (
  `id_merma` int NOT NULL AUTO_INCREMENT,
  `id_producto` int NOT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  `motivo` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` date NOT NULL,
  `observacion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_merma`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `merma_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merma`
--

LOCK TABLES `merma` WRITE;
/*!40000 ALTER TABLE `merma` DISABLE KEYS */;
INSERT INTO `merma` VALUES (1,2,2.00,'Daño','2026-09-10','Guantes rotos'),(2,4,25.00,'Humedad','2026-09-11','Sacos afectados'),(3,5,10.00,'Deterioro','2026-09-12','Cable inutilizable'),(4,27,1.00,'Daño','2026-10-03','Malo de fabrica'),(5,7,1.00,'Otro','2026-10-06','Malo de fabrica'),(6,27,1.00,'Pérdida','2026-10-06',''),(7,1,10.00,'Uso interno','2026-10-10','uso interno'),(8,8,20.00,'Daño','2026-10-10','Daño');
/*!40000 ALTER TABLE `merma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unidad` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stock_minimo` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `categoria_uso` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Material',
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto`
--

LOCK TABLES `producto` WRITE;
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
INSERT INTO `producto` VALUES (1,'Casco de seguridad','EPP','unidad',0.00,0.00,'Material'),(2,'Guantes de trabajo','EPP','par',0.00,0.00,'Material'),(3,'Chaleco reflectante','EPP','unidad',0.00,0.00,'Material'),(4,'Cemento','Material','kg',0.00,20.00,'Material'),(5,'Cable eléctrico','Material','metro',0.00,0.00,'Material'),(6,'Taladro','Herramienta','unidad',0.00,0.00,'Herramienta'),(7,'Martillo','Herramienta','unidad',0.00,0.00,'Herramienta'),(8,'Alambre MIG','Soldadura','kg',0.00,500.00,'Material'),(9,'Disco de corte 4.5','Abrasivo','unidad',0.00,0.00,'Material'),(10,'Disco de desbaste 4.5','Abrasivo','unidad',0.00,0.00,'Material'),(11,'Electrodo 6011','Soldadura','kg',0.00,0.00,'Material'),(12,'Electrodo 7018','Soldadura','kg',0.00,0.00,'Material'),(13,'Soldadura MIG ER70S-6','Soldadura','kg',0.00,0.00,'Material'),(14,'Perfil cuadrado 40x40','Acero','metro',0.00,0.00,'Material'),(15,'Plancha de acero 3 mm','Acero','unidad',0.00,0.00,'Material'),(16,'Perno 1/2','Fijacion','unidad',0.00,0.00,'Material'),(17,'Tuerca 1/2','Fijacion','unidad',0.00,0.00,'Material'),(18,'Broca 10 mm','Herramienta','unidad',0.00,0.00,'Material'),(19,'Esmeril angular','Herramienta','unidad',0.00,0.00,'Herramienta'),(20,'Disco Corte','Material','kg',0.00,0.00,'Material'),(21,'Espuma Expansiva','Material','unidad',30.00,0.00,'Material'),(22,'Sonda para hormigón','Herramienta','Unidad',1.00,3.00,'Herramienta'),(23,'Cango Martillo','Herramienta','Unidad',1.00,0.00,'Herramienta'),(24,'Máquina de soldar','Herramienta','Unidad',1.00,0.00,'Herramienta'),(25,'Generador','Herramienta','Unidad',1.00,0.00,'Herramienta'),(26,'Rotomartillo','Herramienta','Unidad',1.00,0.00,'Herramienta'),(27,'Demoledor','Herramienta','Unidad',1.00,2.00,'Herramienta'),(28,'Sierra circular','Herramienta','Unidad',1.00,0.00,'Herramienta');
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedor`
--

DROP TABLE IF EXISTS `proveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedor` (
  `id_proveedor` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contacto` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedor`
--

LOCK TABLES `proveedor` WRITE;
/*!40000 ALTER TABLE `proveedor` DISABLE KEYS */;
INSERT INTO `proveedor` VALUES (1,'Ferreteria Central','contacto@ferreteriacentral.cl'),(2,'Seguridad Industrial SPA','ventas@seguridadindustrial.cl'),(3,'Materiales del Norte','materiales@norte.cl'),(4,'Ferreteria Central','contacto@ferreteriacentral.cl'),(5,'Ferre Mario','movtran@norte.cl');
/*!40000 ALTER TABLE `proveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trabajador`
--

DROP TABLE IF EXISTS `trabajador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trabajador` (
  `id_trabajador` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `cargo` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Ayudante',
  PRIMARY KEY (`id_trabajador`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trabajador`
--

LOCK TABLES `trabajador` WRITE;
/*!40000 ALTER TABLE `trabajador` DISABLE KEYS */;
INSERT INTO `trabajador` VALUES (1,'Juan Perez',1,'Supervisor de pista'),(2,'Carlos Soto',1,'Ayudante'),(3,'Pedro Gonzalez',1,'Ayudante'),(4,'Luis Ramirez',1,'Ayudante'),(5,'Marcelo alfaro',1,'Ayudante'),(6,'Carlos Muñoz',1,'Ayudante'),(7,'Pedro Rojas',1,'Maestro primera'),(8,'Luis González',1,'Maestro segunda'),(9,'Jorge Soto',1,'Maestro senior'),(10,'Miguel Herrera',1,'Supervisor de pista'),(11,'Diego Fuentes',1,'Ayudante'),(12,'Rodrigo Silva',1,'Maestro primera'),(13,'Cristian Morales',1,'Maestro segunda'),(14,'Felipe Contreras',1,'Maestro senior'),(15,'Sebastián Vega',1,'Ayudante'),(16,'Juan Lopez',1,'Ayudante'),(17,'Jose Miranda',1,'Maestro segunda'),(18,'Humberto Suazo',1,'Supervisor de pista'),(19,'Jose Perez',1,'Supervisor de pista'),(20,'Antonio Montana',1,'Maestro segunda');
/*!40000 ALTER TABLE `trabajador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rol` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'admin','administrador'),(2,'bodega1','bodega');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-12 12:43:12
