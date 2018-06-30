-- phpMyAdmin SQL Dump
-- version 4.1.12
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 30 Cze 2018, 18:18
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
-- Struktura tabeli dla tabeli `archiwum`
--

CREATE TABLE IF NOT EXISTS `archiwum` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tresc` varchar(1000) NOT NULL,
  `ilosc_pkt` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Zrzut danych tabeli `archiwum`
--

INSERT INTO `archiwum` (`id`, `tresc`, `ilosc_pkt`) VALUES
(1, 'pierwsze pytanie opisowe', 2),
(2, 'drugie pytanie opisowe', 2),
(3, 'pierwsze pytanie zamknietw', 1),
(4, 'drugie pytanie zamk', 2),
(5, '2+2', 2),
(6, '2+4', 3),
(7, '9+8', 1),
(8, 'Czy tak?', 5);

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Zrzut danych tabeli `odpowiedzi`
--

INSERT INTO `odpowiedzi` (`id`, `id_pytania`, `id_rozwiazania`, `id_wariantu`, `odpowiedz_otw`, `zdobyte_pkt`) VALUES
(1, 5, 1, NULL, 'ddd', 1),
(2, 6, 1, 2, 'null', 0),
(3, 7, 1, 6, 'null', 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pytania`
--

CREATE TABLE IF NOT EXISTS `pytania` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_testu` int(11) NOT NULL,
  `id_archiwum` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=16 ;

--
-- Zrzut danych tabeli `pytania`
--

INSERT INTO `pytania` (`id`, `id_testu`, `id_archiwum`) VALUES
(5, 2, 2),
(6, 2, 3),
(7, 2, 4),
(8, 3, 4),
(9, 3, 1),
(10, 3, 3),
(11, 4, 4),
(12, 6, 5),
(13, 6, 6),
(14, 6, 7),
(15, 6, 8);

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Zrzut danych tabeli `rozwiazania`
--

INSERT INTO `rozwiazania` (`id`, `id_testu`, `nazwa_uzutkownika`, `ilosc_zdobytych_pkt`, `ocena`, `czas_rozpoczecia`, `czas_zakonczenia`) VALUES
(1, 2, 'z', 1, 'nie zaliczony', '2018-06-20 20:02:29', '2018-06-20 20:10:17');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `testy`
--

CREATE TABLE IF NOT EXISTS `testy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(255) NOT NULL,
  `kierunek` varchar(255) NOT NULL,
  `czas_na_rozw_min` int(11) NOT NULL,
  `ilosc_pytan` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Zrzut danych tabeli `testy`
--

INSERT INTO `testy` (`id`, `nazwa`, `kierunek`, `czas_na_rozw_min`, `ilosc_pytan`) VALUES
(2, 'test z archiwum', 'Matematyka', 13, 0),
(3, 'losowy', 'Informatyka', 23, 0),
(4, 'recznie', 'Informatyka', 23, 0),
(5, 'ww', '', 43, 0),
(6, 'nowy', '', 12, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `test_studenta`
--

CREATE TABLE IF NOT EXISTS `test_studenta` (
  `nazwa_uzytkownika` varchar(255) NOT NULL,
  `id_testu` int(11) NOT NULL,
  UNIQUE KEY `nazwa_uzytkownika` (`nazwa_uzytkownika`,`id_testu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `test_studenta`
--

INSERT INTO `test_studenta` (`nazwa_uzytkownika`, `id_testu`) VALUES
('2222', 4),
('2222', 6),
('s', 4),
('undefined', 2),
('z', 2);

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
('2222', 'Marta', 'Kaszuba', '123456', 0, 2222, 'informatyka'),
('s', '\nStefan', 'Kolaska', 's', 0, 324, 'Fizyka'),
('w', 'wykladowca', 'wykladiwca', '1111', 1, NULL, NULL),
('z', 'Zenek', 'Martyniuk', 'z', 0, 1234, 'Informatyka');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `warianty`
--

CREATE TABLE IF NOT EXISTS `warianty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_archiwum` int(11) NOT NULL,
  `tresc` varchar(1000) NOT NULL,
  `czy_poprawny` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=15 ;

--
-- Zrzut danych tabeli `warianty`
--

INSERT INTO `warianty` (`id`, `id_archiwum`, `tresc`, `czy_poprawny`) VALUES
(1, 3, 'poprawny', 1),
(2, 3, 'nie', 0),
(3, 3, 'wcale', 0),
(4, 4, 'aaa', 1),
(5, 4, 'ddd', 0),
(6, 4, 'fff', 0),
(7, 6, '6', 1),
(8, 6, '1', 0),
(9, 6, '0', 0),
(10, 6, '4', 0),
(11, 7, '2', 0),
(12, 7, '3', 0),
(13, 7, '17', 1),
(14, 7, '10', 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
