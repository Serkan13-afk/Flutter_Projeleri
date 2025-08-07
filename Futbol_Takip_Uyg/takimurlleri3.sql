-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 07 Ağu 2025, 19:03:40
-- Sunucu sürümü: 10.4.32-MariaDB
-- PHP Sürümü: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `takimurlleri`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `takimurlleri3`
--

CREATE TABLE `takimurlleri3` (
  `id` int(11) NOT NULL,
  `tur` varchar(100) NOT NULL,
  `url` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `takimurlleri3`
--

INSERT INTO `takimurlleri3` (`id`, `tur`, `url`) VALUES
(1, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Galatasaray'),
(2, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Fenerbahçe'),
(3, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Beşiktaş'),
(4, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Trabazon'),
(5, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Başakşehir'),
(6, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Samsunspor'),
(7, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Eyüpspor'),
(8, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Kayserispor'),
(9, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Rizespor'),
(10, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Kasımpaşa'),
(11, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Sivasspor'),
(12, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Fatihkaragümrük'),
(13, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Konyaspor'),
(14, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Antalyaspor'),
(15, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Alanyaspor'),
(16, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Hatayspor'),
(17, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Rizespor'),
(18, '1', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Pendikspor'),
(19, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Arsenal'),
(20, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Manchester City'),
(21, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Liverpool'),
(22, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Everton'),
(23, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Chelsea'),
(24, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Manchester United'),
(25, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Tottenham Hotspur'),
(26, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Newcastle United'),
(27, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Aston Villa'),
(28, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Brighton'),
(29, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=West Ham United'),
(30, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Leicester City'),
(31, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Wolverhampton'),
(32, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Crystal Palace'),
(33, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Fulham'),
(34, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Brentford'),
(35, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Bournemouth'),
(36, '2', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Nottingham Forest'),
(37, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Real Madrid'),
(38, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Barcelona'),
(39, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Atletico Madrid'),
(40, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Real Sociedad'),
(41, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Athletic Club Bilbao'),
(42, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Villarreal'),
(43, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Real Betis'),
(44, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Sevilla'),
(45, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Girona'),
(46, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Getafe'),
(47, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Rayo Vallecano'),
(48, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Celta Vigo'),
(49, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Almeria'),
(50, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Mallorca'),
(51, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Osasuna'),
(52, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Las Palmas'),
(53, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Cadiz'),
(54, '3', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Deportivo Alaves'),
(55, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Bayern Münih'),
(56, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Dortmund'),
(57, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Leipzig'),
(58, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Bayer Leverkusen'),
(59, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Eintracht Frankfurt'),
(60, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Wolfsburg'),
(61, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Freiburg'),
(62, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Hoffenheim'),
(63, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Mönchengladbach'),
(64, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Union Berlin'),
(65, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Mainz'),
(66, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Augsburg'),
(67, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Bochum'),
(68, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Köln'),
(69, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Werder Bremen'),
(70, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Stuttgart'),
(71, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Düsseldorf'),
(72, '4', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Heidenheim'),
(73, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Inter'),
(74, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Milan'),
(75, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Juventus'),
(76, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Napoli'),
(77, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Roma'),
(78, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Rizespor'),
(79, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Lazio'),
(80, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Atalanta'),
(81, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Fiorentina'),
(82, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Torino'),
(83, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Bologna'),
(84, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Sassuolo'),
(85, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Udinese'),
(86, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Udinese'),
(87, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Monza'),
(88, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Genoa'),
(89, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Lecce'),
(90, '5', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Empoli'),
(91, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Lyon'),
(92, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Marsilya'),
(93, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Monaco'),
(94, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Rennes'),
(95, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Lens'),
(96, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Lille'),
(97, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Nice'),
(98, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Nantes'),
(99, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Montpellier'),
(100, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Metz'),
(101, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Strasbourg'),
(102, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Toulouse'),
(103, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Brest'),
(104, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Angers'),
(105, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Clermont'),
(106, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Reims'),
(107, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Lorient'),
(108, '6', 'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Psg');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `takimurlleri3`
--
ALTER TABLE `takimurlleri3`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `takimurlleri3`
--
ALTER TABLE `takimurlleri3`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
