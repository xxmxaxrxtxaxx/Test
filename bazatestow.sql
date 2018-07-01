-- phpMyAdmin SQL Dump
-- version 4.8.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 01 Lip 2018, 18:14
-- Wersja serwera: 10.1.31-MariaDB
-- Wersja PHP: 7.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `bazatestow`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `odpowiedzi`
--

CREATE TABLE `odpowiedzi` (
  `id` int(11) NOT NULL,
  `id_rozwiazania` int(11) NOT NULL,
  `id_pytania` int(11) NOT NULL,
  `id_wariantu` int(11) DEFAULT NULL,
  `odpowiedz_otw` varchar(1000) DEFAULT NULL,
  `zdobyte_pkt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pytania`
--

CREATE TABLE `pytania` (
  `id` int(11) NOT NULL,
  `id_testu` int(11) NOT NULL,
  `ilosc_pkt` int(11) NOT NULL,
  `tresc` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rozwiazania`
--

CREATE TABLE `rozwiazania` (
  `id` int(11) NOT NULL,
  `id_testu` int(11) NOT NULL,
  `nazwa_uzutkownika` varchar(255) NOT NULL,
  `ilosc_zdobytych_pkt` int(11) DEFAULT NULL,
  `ocena` varchar(255) DEFAULT NULL,
  `czas_rozpoczecia` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `czas_zakonczenia` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `testy`
--

CREATE TABLE `testy` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `kierunek` varchar(255) NOT NULL,
  `czas_na_rozw_min` int(11) NOT NULL,
  `ilosc_pytan` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `test_studenta`
--

CREATE TABLE `test_studenta` (
  `nazwa_uzytkownika` varchar(255) NOT NULL,
  `id_testu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uzytkownicy`
--

CREATE TABLE `uzytkownicy` (
  `nazwa` varchar(255) NOT NULL,
  `imie` varchar(100) NOT NULL,
  `nazwisko` varchar(100) NOT NULL,
  `haslo` varchar(255) NOT NULL,
  `czy_wykladowca` tinyint(1) NOT NULL DEFAULT '1',
  `numer_indeksu` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `uzytkownicy`
--

INSERT INTO `uzytkownicy` (`nazwa`, `imie`, `nazwisko`, `haslo`, `czy_wykladowca`, `numer_indeksu`) VALUES
('admi', 'Administrator', '', 'admin', 1, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `warianty`
--

CREATE TABLE `warianty` (
  `id` int(11) NOT NULL,
  `id_pytania` int(11) NOT NULL,
  `tresc` varchar(1000) NOT NULL,
  `czy_poprawny` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `odpowiedzi`
--
ALTER TABLE `odpowiedzi`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `pytania`
--
ALTER TABLE `pytania`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `rozwiazania`
--
ALTER TABLE `rozwiazania`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `testy`
--
ALTER TABLE `testy`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `test_studenta`
--
ALTER TABLE `test_studenta`
  ADD UNIQUE KEY `nazwa_uzytkownika` (`nazwa_uzytkownika`,`id_testu`);

--
-- Indeksy dla tabeli `uzytkownicy`
--
ALTER TABLE `uzytkownicy`
  ADD PRIMARY KEY (`nazwa`);

--
-- Indeksy dla tabeli `warianty`
--
ALTER TABLE `warianty`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `odpowiedzi`
--
ALTER TABLE `odpowiedzi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `pytania`
--
ALTER TABLE `pytania`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `rozwiazania`
--
ALTER TABLE `rozwiazania`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `testy`
--
ALTER TABLE `testy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `warianty`
--
ALTER TABLE `warianty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
