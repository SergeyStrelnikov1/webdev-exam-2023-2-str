-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: std-mysql    Database: std_2060_exam
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('a8b830ac8329');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `brief` text NOT NULL,
  `year` int(11) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `author` varchar(100) NOT NULL,
  `page_number` int(11) NOT NULL,
  `cover_id` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_books_cover_id_covers` (`cover_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (18,'Митина любовь','**Иван Бунин** -* первый русский Нобелевский лауреат, трижды был награжден Пушкинской премией, самый молодой академик Петербургской Российской академии. В ХХ веке продолжил традиции великой русской литературы ХIХ века, мастерство И. Бунина настолько тонко и отточено, \"...что все описанное - совсем не описанное, а просто- напросто существующее\", по мнению Ф. Степуна.*',1925,'Эксмо','Иван Бунин',544,'f3c9e9a6184fc21a05a74857ef7b40ce'),(19,'Горе от ума','**Толстый**\r\n*Италик*\r\n# Хэдэр\r\n',1822,'АСТ','Александр Грибоедов',1920,'87018bb727879389125c9f3d4278b0c4'),(20,'се','Та же обложка, что и у \"Митина любовь\"',2003,'сер','с',1,'f3c9e9a6184fc21a05a74857ef7b40ce'),(21,'Модератор','горы',2024,'талытфт','Красивейшие горы ЗИЛа',999,'3d7c026480613c691976250f5781ec7b');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_genres`
--

DROP TABLE IF EXISTS `books_genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books_genres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) DEFAULT NULL,
  `genre_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_books_genres_id_genre` (`genre_id`),
  KEY `fk_books_genres_id_book` (`book_id`),
  CONSTRAINT `fk_books_genres_id_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_books_genres_id_genre` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_genres`
--

LOCK TABLES `books_genres` WRITE;
/*!40000 ALTER TABLE `books_genres` DISABLE KEYS */;
INSERT INTO `books_genres` VALUES (38,18,1),(39,18,2),(40,18,4),(41,19,1),(42,19,2),(43,19,3),(44,19,4),(45,20,2),(49,21,2),(50,21,3),(51,21,4);
/*!40000 ALTER TABLE `books_genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `covers`
--

DROP TABLE IF EXISTS `covers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `covers` (
  `id` varchar(250) NOT NULL,
  `file` varchar(250) NOT NULL,
  `MIME` varchar(250) NOT NULL,
  `MD5` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `covers`
--

LOCK TABLES `covers` WRITE;
/*!40000 ALTER TABLE `covers` DISABLE KEYS */;
INSERT INTO `covers` VALUES ('15f3e31fb3963d2ee945fb973712867f','15f3e31fb3963d2ee945fb973712867f.png','image/png','15f3e31fb3963d2ee945fb973712867f'),('3d7c026480613c691976250f5781ec7b','3d7c026480613c691976250f5781ec7b.jpg','image/jpeg','3d7c026480613c691976250f5781ec7b'),('4921f65f49af5f4e15e2fcf947053893','4921f65f49af5f4e15e2fcf947053893.jpg','image/jpeg','4921f65f49af5f4e15e2fcf947053893'),('87018bb727879389125c9f3d4278b0c4','87018bb727879389125c9f3d4278b0c4.jpg','image/jpeg','87018bb727879389125c9f3d4278b0c4'),('f3c9e9a6184fc21a05a74857ef7b40ce','f3c9e9a6184fc21a05a74857ef7b40ce.jpg','image/jpeg','f3c9e9a6184fc21a05a74857ef7b40ce');
/*!40000 ALTER TABLE `covers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (1,'Роман'),(2,'Рассказ'),(3,'Фантастика'),(4,'Повесть');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  `text` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_reviews_book_id_books` (`book_id`),
  KEY `fk_reviews_user_id_users` (`user_id`),
  CONSTRAINT `fk_reviews_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviews_user_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (10,18,1,4,'* Хорошо\r\n* Отлично\r\n* Здорово','2023-09-16 23:45:50'),(11,18,2,0,'.','2023-09-16 23:47:00'),(12,18,3,5,'Jnkbxyj','2023-09-16 23:47:32');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Пользователь','П'),(2,'Модератор','М'),(3,'Администратор','А');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_name` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `login` varchar(100) NOT NULL,
  `password_hash` varchar(200) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_login` (`login`),
  KEY `fk_users_role_id_roles` (`role_id`),
  CONSTRAINT `fk_users_role_id_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Администратор','Сергей',NULL,'admin','pbkdf2:sha256:600000$eGDTgN4whbgRGseR$43816fae5f97491fc1536876e86688115c12f8bf20a99d58eebb1120895bfd30',3),(2,'Модератор','Сергей',NULL,'moder','pbkdf2:sha256:600000$kBxaDxUxFOmqjosB$602cc143c26e1d16b0a69251ec2239ff606ee98272fd114be326021c5b852251',2),(3,'Пользователь','Сергей',NULL,'user','pbkdf2:sha256:600000$BIsZJFj5JfnckpmH$45ab89f55fe784bf7e881488d8289f52ab4ce03f11d6d09d36173155921371d1',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-17  0:03:26
