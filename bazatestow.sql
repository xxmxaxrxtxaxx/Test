-- phpMyAdmin SQL Dump
-- version 4.1.12
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 19 Cze 2018, 07:18
-- Server version: 5.6.16
-- PHP Version: 5.5.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `bazatestow`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `odpowiedzi`
--

CREATE TABLE IF NOT EXISTS `odpowiedzi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pytania` int(11) NOT NULL,
  `id_rozwiazania` int(11) NOT NULL,
  `id_wariantu` int(11) DEFAULT NULL,
  `odpowiedz_otw` varchar(1000) DEFAULT NULL,
  `zdobyte_pkt` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=58 ;

--
-- Zrzut danych tabeli `odpowiedzi`
--

INSERT INTO `odpowiedzi` (`id`, `id_pytania`, `id_rozwiazania`, `id_wariantu`, `odpowiedz_otw`, `zdobyte_pkt`) VALUES
(41, 9, 49, NULL, '12', 2),
(42, 10, 49, 6, 'null', 0),
(43, 11, 50, NULL, '23', NULL),
(44, 12, 50, 9, 'null', NULL),
(45, 9, 51, NULL, 'tak', 2),
(46, 10, 51, 5, 'null', 2),
(47, 13, 52, 14, 'null', 2),
(48, 14, 52, 20, 'null', 3),
(49, 15, 52, 23, 'null', 0),
(50, 16, 53, NULL, 'rrrrr', 0),
(51, 17, 53, NULL, 'eeee', 0),
(52, 18, 53, NULL, 'ooooo', 0),
(53, 19, 54, NULL, 'dassd', 1),
(54, 20, 54, NULL, 'sfds', 1),
(55, 11, 55, NULL, 'null', 0),
(56, 12, 55, NULL, 'null', 0),
(57, 21, 56, 26, 'null', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pytania`
--

CREATE TABLE IF NOT EXISTS `pytania` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_testu` int(11) NOT NULL,
  `tresc` varchar(1000) NOT NULL,
  `ilosc_pkt` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=22 ;

--
-- Zrzut danych tabeli `pytania`
--

INSERT INTO `pytania` (`id`, `id_testu`, `tresc`, `ilosc_pkt`) VALUES
(9, 17, 'Czy 2+2=1', 2),
(10, 17, 'ile 1+1', 2),
(11, 18, '3+7', 4),
(12, 18, '2*9', 2),
(13, 19, '12121', 2),
(14, 19, 'sfsdf', 3),
(15, 19, 'khhhj', 3),
(16, 20, 'asassaas', 2),
(17, 20, '1+1', 1),
(18, 20, '4+4', 2),
(21, 22, '2+2', 6);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rozwiazania`
--

CREATE TABLE IF NOT EXISTS `rozwiazania` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_testu` int(11) NOT NULL,
  `nazwa_uzutkownika` varchar(255) NOT NULL,
  `ilosc_zdobytych_pkt` int(11) DEFAULT NULL,
  `ocena` varchar(255) DEFAULT NULL,
  `czas_rozpoczecia` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `czas_zakonczenia` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=57 ;

--
-- Zrzut danych tabeli `rozwiazania`
--

INSERT INTO `rozwiazania` (`id`, `id_testu`, `nazwa_uzutkownika`, `ilosc_zdobytych_pkt`, `ocena`, `czas_rozpoczecia`, `czas_zakonczenia`) VALUES
(51, 17, 'MK', 4, 'zaliczony', '2018-06-09 15:40:26', '2018-06-09 15:40:39'),
(52, 19, 'MK', 5, 'zaliczony', '2018-06-09 15:40:43', '2018-06-09 15:41:03'),
(53, 20, 'MK', 0, 'zaliczony', '2018-06-09 15:41:06', '2018-06-09 15:41:24'),
(54, 21, 'MK', 2, 'nie zaliczony', '2018-06-09 15:46:56', '2018-06-09 15:48:14'),
(55, 18, 'MK', 0, 'nie zaliczony', '2018-06-09 15:49:19', '2018-06-09 15:49:30'),
(56, 22, 'MK', NULL, NULL, '2018-06-18 17:28:21', '2018-06-18 17:28:56');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `testy`
--

CREATE TABLE IF NOT EXISTS `testy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(255) NOT NULL,
  `kierunek` varchar(255) NOT NULL,
  `czas_na_rozw_min` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=23 ;

--
-- Zrzut danych tabeli `testy`
--

INSERT INTO `testy` (`id`, `nazwa`, `kierunek`, `czas_na_rozw_min`) VALUES
(17, 'Test', 'Informatyka', 1),
(18, 'test_nie_rozwizany', 'Informatyka', 12),
(19, 'tylko zamkniete', 'Informatyka', 12),
(20, 'tylko otwarte', 'Informatyka', 10),
(22, 'test z przyry albo nie', 'Informatyka', 3);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uzytkownicy`
--

CREATE TABLE IF NOT EXISTS `uzytkownicy` (
  `nazwa` varchar(255) NOT NULL,
  `imie` varchar(100) NOT NULL,
  `nazwisko` varchar(100) NOT NULL,
  `haslo` varchar(255) NOT NULL,
  `czy_wykladowca` tinyint(1) NOT NULL DEFAULT '1',
  `numer_indeksu` int(11) DEFAULT NULL,
  `kierunek` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`nazwa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `uzytkownicy`
--

INSERT INTO `uzytkownicy` (`nazwa`, `imie`, `nazwisko`, `haslo`, `czy_wykladowca`, `numer_indeksu`, `kierunek`) VALUES
('AL', 'Anna', 'Lis', 'lis', 0, 987654, 'Matematyka'),
('EW', 'Ewa', 'Wnuk', 'wnuk', 0, 657483, 'Mechanika'),
('JN', 'Jan', 'Nowak', '123456', 1, NULL, NULL),
('KR', 'Krzysztof', 'Robak', 'robak', 1, NULL, NULL),
('MK', 'Marta', 'Kaszuba', 'qazzaq', 0, 111111, 'Informatyka'),
('PK', 'Piotr', 'Kowalski', 'kowalski', 0, 123456, 'Fizyka');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `warianty`
--

CREATE TABLE IF NOT EXISTS `warianty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pytania` int(11) NOT NULL,
  `tresc` varchar(1000) NOT NULL,
  `czy_poprawny` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=29 ;

--
-- Zrzut danych tabeli `warianty`
--

INSERT INTO `warianty` (`id`, `id_pytania`, `tresc`, `czy_poprawny`) VALUES
(5, 10, '2', 1),
(6, 10, '1', 0),
(7, 10, '0', 0),
(8, 10, '3', 0),
(9, 12, '18', 1),
(10, 12, '2', 0),
(11, 12, '11', 0),
(12, 12, '56', 0),
(13, 13, 'a', 0),
(14, 13, 'b', 1),
(15, 13, 'c', 0),
(16, 13, 'd', 0),
(17, 14, 'ww', 0),
(18, 14, 'eee', 0),
(19, 14, 'tt', 0),
(20, 14, 'yy', 1),
(21, 15, '21', 1),
(22, 15, '2', 0),
(23, 15, '3', 0),
(24, 15, '4', 0),
(25, 21, '1', 0),
(26, 21, '2', 0),
(27, 21, '3', 0),
(28, 21, '4', 1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
