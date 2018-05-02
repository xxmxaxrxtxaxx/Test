-- phpMyAdmin SQL Dump
-- version 4.8.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 02 Maj 2018, 00:42
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
-- Baza danych: `strona`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `odpotw_studenta`
--

CREATE TABLE `odpotw_studenta` (
  `id` int(11) NOT NULL,
  `id_pytania` int(11) NOT NULL,
  `tresc` text COLLATE utf8_polish_ci NOT NULL,
  `nr_indeksu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `odpzam_studenta`
--

CREATE TABLE `odpzam_studenta` (
  `id` int(11) NOT NULL,
  `id_pytania` int(11) NOT NULL,
  `odp_studenta` text COLLATE utf8_polish_ci NOT NULL,
  `nr_indeksu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pytania_otw`
--

CREATE TABLE `pytania_otw` (
  `id` int(11) NOT NULL,
  `id_testu` int(11) NOT NULL,
  `tresc` text COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pytania_zam`
--

CREATE TABLE `pytania_zam` (
  `id` int(11) NOT NULL,
  `id_testu` int(11) NOT NULL,
  `tresc` text COLLATE utf8_polish_ci NOT NULL,
  `odpa` text COLLATE utf8_polish_ci NOT NULL,
  `odpb` text COLLATE utf8_polish_ci NOT NULL,
  `odpc` text COLLATE utf8_polish_ci NOT NULL,
  `odpd` text COLLATE utf8_polish_ci NOT NULL,
  `poprawda_odp` text COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `studenci`
--

CREATE TABLE `studenci` (
  `id` int(11) NOT NULL,
  `imie` text CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `nazwisko` text CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `nr_indeksu` int(11) NOT NULL,
  `kierunek` text CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `testy`
--

CREATE TABLE `testy` (
  `id` int(11) NOT NULL,
  `nazwa` text COLLATE utf8_polish_ci NOT NULL,
  `kierunek` text COLLATE utf8_polish_ci NOT NULL,
  `czas_na_rozw_min` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `wykladowcy`
--

CREATE TABLE `wykladowcy` (
  `id` int(11) NOT NULL,
  `tytul` text CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `imie` text CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `nazwisko` text CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `wynik`
--

CREATE TABLE `wynik` (
  `id` int(11) NOT NULL,
  `id_testu` int(11) NOT NULL,
  `nr_indeksu` int(11) NOT NULL,
  `ilosc_pkt` int(11) NOT NULL,
  `ocena` varchar(3) COLLATE utf8_polish_ci NOT NULL,
  `czas_rozp` datetime NOT NULL,
  `czas_zakon` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `odpotw_studenta`
--
ALTER TABLE `odpotw_studenta`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nr_indeksu` (`nr_indeksu`) USING BTREE;

--
-- Indeksy dla tabeli `odpzam_studenta`
--
ALTER TABLE `odpzam_studenta`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_pytania` (`id_pytania`) USING BTREE,
  ADD UNIQUE KEY `nr_indeksu` (`nr_indeksu`) USING BTREE;

--
-- Indeksy dla tabeli `pytania_otw`
--
ALTER TABLE `pytania_otw`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_testu` (`id_testu`) USING BTREE;

--
-- Indeksy dla tabeli `pytania_zam`
--
ALTER TABLE `pytania_zam`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_testu` (`id_testu`) USING BTREE,
  ADD UNIQUE KEY `id` (`id`) USING BTREE;

--
-- Indeksy dla tabeli `studenci`
--
ALTER TABLE `studenci`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nr_indeksu` (`nr_indeksu`) USING BTREE;

--
-- Indeksy dla tabeli `testy`
--
ALTER TABLE `testy`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`) USING BTREE;

--
-- Indeksy dla tabeli `wykladowcy`
--
ALTER TABLE `wykladowcy`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `wynik`
--
ALTER TABLE `wynik`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_testu` (`id_testu`) USING BTREE,
  ADD UNIQUE KEY `nr_indeksu` (`nr_indeksu`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `odpotw_studenta`
--
ALTER TABLE `odpotw_studenta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `odpzam_studenta`
--
ALTER TABLE `odpzam_studenta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `pytania_otw`
--
ALTER TABLE `pytania_otw`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `pytania_zam`
--
ALTER TABLE `pytania_zam`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `studenci`
--
ALTER TABLE `studenci`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `testy`
--
ALTER TABLE `testy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `wykladowcy`
--
ALTER TABLE `wykladowcy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `wynik`
--
ALTER TABLE `wynik`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
