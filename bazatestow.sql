-- phpMyAdmin SQL Dump
-- version 4.8.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 20 Cze 2018, 21:07
-- Wersja serwera: 10.1.32-MariaDB
-- Wersja PHP: 7.2.5

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
-- Struktura tabeli dla tabeli `archiwum`
--

CREATE TABLE `archiwum` (
  `id` int(11) NOT NULL,
  `tresc` varchar(1000) NOT NULL,
  `ilosc_pkt` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `archiwum`
--

INSERT INTO `archiwum` (`id`, `tresc`, `ilosc_pkt`) VALUES
(1, 'pierwsze pytanie opisowe', 2),
(2, 'drugie pytanie opisowe', 2),
(3, 'pierwsze pytanie zamknietw', 1),
(4, 'drugie pytanie zamk', 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `odpowiedzi`
--

CREATE TABLE `odpowiedzi` (
  `id` int(11) NOT NULL,
  `id_pytania` int(11) NOT NULL,
  `id_rozwiazania` int(11) NOT NULL,
  `id_wariantu` int(11) DEFAULT NULL,
  `odpowiedz_otw` varchar(1000) DEFAULT NULL,
  `zdobyte_pkt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

CREATE TABLE `pytania` (
  `id` int(11) NOT NULL,
  `id_testu` int(11) NOT NULL,
  `id_archiwum` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
(11, 4, 4);

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

--
-- Zrzut danych tabeli `rozwiazania`
--

INSERT INTO `rozwiazania` (`id`, `id_testu`, `nazwa_uzutkownika`, `ilosc_zdobytych_pkt`, `ocena`, `czas_rozpoczecia`, `czas_zakonczenia`) VALUES
(1, 2, 'z', 1, 'nie zaliczony', '2018-06-20 20:02:29', '2018-06-20 20:10:17');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `testy`
--

CREATE TABLE `testy` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `kierunek` varchar(255) NOT NULL,
  `czas_na_rozw_min` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `testy`
--

INSERT INTO `testy` (`id`, `nazwa`, `kierunek`, `czas_na_rozw_min`) VALUES
(2, 'test z archiwum', 'Matematyka', 13),
(3, 'losowy', 'Informatyka', 23),
(4, 'recznie', 'Informatyka', 23);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `test_studenta`
--

CREATE TABLE `test_studenta` (
  `nazwa_uzytkownika` varchar(255) NOT NULL,
  `id_testu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `test_studenta`
--

INSERT INTO `test_studenta` (`nazwa_uzytkownika`, `id_testu`) VALUES
('undefined', 2),
('z', 2);

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
  `numer_indeksu` int(11) DEFAULT NULL,
  `kierunek` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `uzytkownicy`
--

INSERT INTO `uzytkownicy` (`nazwa`, `imie`, `nazwisko`, `haslo`, `czy_wykladowca`, `numer_indeksu`, `kierunek`) VALUES
('s', '\nStefan', 'Kolaska', 's', 0, 324, 'Fizyka'),
('z', 'Zenek', 'Martyniuk', 'z', 0, 1234, 'Informatyka');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `warianty`
--

CREATE TABLE `warianty` (
  `id` int(11) NOT NULL,
  `id_archiwum` int(11) NOT NULL,
  `tresc` varchar(1000) NOT NULL,
  `czy_poprawny` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `warianty`
--

INSERT INTO `warianty` (`id`, `id_archiwum`, `tresc`, `czy_poprawny`) VALUES
(1, 3, 'poprawny', 1),
(2, 3, 'nie', 0),
(3, 3, 'wcale', 0),
(4, 4, 'aaa', 1),
(5, 4, 'ddd', 0),
(6, 4, 'fff', 0);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `archiwum`
--
ALTER TABLE `archiwum`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT dla tabeli `archiwum`
--
ALTER TABLE `archiwum`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `odpowiedzi`
--
ALTER TABLE `odpowiedzi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT dla tabeli `pytania`
--
ALTER TABLE `pytania`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT dla tabeli `rozwiazania`
--
ALTER TABLE `rozwiazania`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `testy`
--
ALTER TABLE `testy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `warianty`
--
ALTER TABLE `warianty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
