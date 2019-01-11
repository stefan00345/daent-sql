USE projekt_ima17_08;

--Tabelle Kunden
CREATE TABLE Kunden(
    KundenID INT PRIMARY KEY NOT NULL IDENTITY,
    Vorname VARCHAR(50),
    Nachname VARCHAR(50),
    Geburtsdatum DATE,
    Telefonnummer VARCHAR(50),
    Email VARCHAR(50),
    Adresse VARCHAR(60));

--Tabelle Kundenkarte
CREATE TABLE Kundenkarte(
    KarteID INT PRIMARY KEY NOT NULL IDENTITY,
    Punktestand INT NOT NULL DEFAULT 0,
    Ausstellungsdatum DATE DEFAULT SYSDATETIME(),
    KundenID INT FOREIGN KEY REFERENCES dbo.Kunden(KundenID));

--Tabelle Mitarbeitergruppe
CREATE TABLE Mitarbeitergruppe(
    MAGruppeID INT PRIMARY KEY NOT NULL,
    Bezeichnung VARCHAR(30));

--Tabelle Lager
CREATE TABLE Lager(
    LagerID INT PRIMARY KEY IDENTITY NOT NULL,
    Lagername VARCHAR(50),
    Standort VARCHAR(50));

--Tabelle Filiale
CREATE TABLE Filiale(
    FilialID INT PRIMARY KEY NOT NULL IDENTITY,
    Bezeichnung VARCHAR(50) NOT NULL,
    Adresse VARCHAR(60));

--Tabelle Stellenposition
CREATE TABLE Stellenposition(
    StellenID INT PRIMARY KEY NOT NULL,
    Bezeichnung VARCHAR(20) NOT NULL);


--Tabelle Mitarbeiter
CREATE TABLE Mitarbeiter(
    MitarbeiterID INT PRIMARY KEY NOT NULL IDENTITY,
    Vorname VARCHAR(50) NOT NULL,
    Nachname VARCHAR(50) NOT NULL,
    Adresse VARCHAR(60),
    Gehalt MONEY,
    IBAN VARCHAR(40),
    --Referenz für Stelle
    FK_Mitarbeiter_Stelle INT NOT NULL FOREIGN KEY REFERENCES Stellenposition(StellenID),
    --Referenz zum Lager
    FK_Mitarbeiter_Lager INT FOREIGN KEY REFERENCES Lager(LagerID),
    --Referenz zur Filiale
    FK_Mitarbeiter_Filiale INT FOREIGN KEY REFERENCES Filiale(FilialID));

--Abschnitt Produkte
--Tabelle Produktgruppe
CREATE TABLE Produktgruppe(
    ID INT PRIMARY KEY NOT NULL,
    Bezeichnung VARCHAR(40) NOT NULL);

--Tabelle Lieferanten
CREATE TABLE Lieferanten(
    LieferantenID INT PRIMARY KEY NOT NULL IDENTITY,
    Name VARCHAR(50) NOT NULL,
    Adresse VARCHAR(60),
    IBAN VARCHAR(40));

--Tabelle Produkte
CREATE TABLE Produkte(
    ProduktID INT PRIMARY KEY NOT NULL IDENTITY,
    Bezeichnung VARCHAR(60) NOT NULL,
    UVP MONEY,
    Verkaufspreis MONEY,
    Status VARCHAR(20),
    Gewicht FLOAT);

--Tabelle Rabatttyp
CREATE TABLE Rabatttyp(
    TypID INT PRIMARY KEY NOT NULL,
    Bezeichnung VARCHAR(20) NOT NULL);

--Tabelle Rabatt
CREATE TABLE Rabatt(
    RabattID INT PRIMARY KEY NOT NULL,
    Rabattcode VARCHAR(40),
    Typ INT NOT NULL FOREIGN KEY REFERENCES Rabatttyp(TypID),
    Wert VARCHAR(10));

--Tabelle Lagerbestand
CREATE TABLE Lagerbestand(
    FK_Bestand_Produkt INT NOT NULL FOREIGN KEY REFERENCES Produkte(ProduktID),
    FK_Bestand_Lager INT NOT NULL FOREIGN KEY REFERENCES Lager(LagerID),
    Menge INT NOT NULL,
    PRIMARY KEY (FK_Bestand_Produkt,FK_Bestand_Lager));

--Tabelle Einkauf
CREATE TABLE Einkauf(
    Einkaufsnummer INT IDENTITY PRIMARY KEY NOT NULL,
    Zahlungsmethode VARCHAR(20),
    Datum DATE DEFAULT SYSDATETIME() NOT NULL,
    FK_Einkauf_Rabatt INT FOREIGN KEY REFERENCES Rabatt(RabattID),
    FK_Einkauf_Kunde INT FOREIGN KEY REFERENCES Kunden(KundenID) NOT NULL);

CREATE TABLE Einkaufsposition(
    FK_Pos_Einkauf INT NOT NULL REFERENCES Einkauf(Einkaufsnummer),
    FK_Pos_Produkt INT NOT NULL REFERENCES Produkte(ProduktID),
    Menge INT NOT NULL,
    PRIMARY KEY (FK_Pos_Einkauf,FK_Pos_Produkt));

--Lieferposition (Lieferanten liefern Produkte in bestimmten Mengen)
CREATE TABLE Lieferposition(
    FK_Pos_Produkt INT NOT NULL REFERENCES Produkte(ProduktID),
    FK_Pos_Lieferanten INT NOT NULL REFERENCES Lieferanten(LieferantenID),
    Menge INT NOT NULL,
    Einkaufspreis MONEY,
    Datum DATE DEFAULT SYSDATETIME());

--Inserts (Test)
INSERT INTO Kunden VALUES('Marcel','Koschu','02-06-1998',1234,'meinemail','meineadresse');

INSERT INTO Stellenposition VALUES(1,'Filialleiter');
INSERT INTO Stellenposition VALUES(2,'Kassierer');
INSERT INTO Stellenposition VALUES(3,'Allgemein');
INSERT INTO Stellenposition VALUES(4,'Reinigung'); -- Weitere Einträge wie CEO, Sekretariat, Berater usw.
SELECT * FROM Kunden;
SELECT * FROM Produkte;
SELECT * FROM Einkaufsposition;
SELECT * FROM Einkauf;
INSERT INTO Einkauf(Zahlungsmethode,FK_Einkauf_Kunde) VALUES('PayPal',1);
INSERT INTO Einkaufsposition(FK_Pos_Einkauf,FK_Pos_Produkt,Menge) VALUES (1,1,200);
INSERT INTO Einkaufsposition(FK_Pos_Einkauf,FK_Pos_Produkt,Menge) VALUES (1,2,300);


INSERT INTO dbo.Lagerbestand(FK_Bestand_Produkt,FK_Bestand_Lager,Menge) VALUES (5,1,3000);
INSERT INTO dbo.Lagerbestand(FK_Bestand_Produkt,FK_Bestand_Lager,Menge) VALUES (5,2,300);

SELECT * FROM Lager;
INSERT INTO Lager VALUES('Kleines Lager','Graz');

UPDATE Lagerbestand SET Menge = 500 WHERE FK_Bestand_Produkt = 5 AND FK_Bestand_Lager = 1;

SELECT * FROM Einkaufsposition;







--Testen
/*
INSERT INTO Lager VALUES ('Hauptlager','Klagenfurt');
INSERT INTO Filiale VALUES ('Test','Graz');
SELECT * FROM Filiale;
SELECT * FROM Mitarbeiter; */

INSERT INTO Mitarbeiter(Vorname,Nachname,Adresse,Gehalt,IBAN,FK_Mitarbeiter_Filiale) VALUES ('Stefan','Ulbel','Graz',200.00,'AT 342',1);
INSERT INTO Mitarbeiter(Vorname,Nachname,Adresse,Gehalt,IBAN,FK_Mitarbeiter_Filiale,FK_Filialleiter_Von_Filiale) VALUES ('Marcel','Koschu','Graz',200.00,'AT 342',1,1);

--SELECT * FROM Mitarbeiter WHERE FK_Filialleiter_Von_Filiale IS NOT NULL;
--SELECT Vorname FROM Mitarbeiter WHERE FK_Filialleiter_Von_Filiale = (SELECT FilialID FROM Filiale WHERE Adresse = 'Graz');

INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Holzstange', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Holzbohrer', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Leim', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Feile', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Schleifpapier', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Kanister', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Handschuhe', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Sicherheitsschuhe', 10, 10, 0, 1.0)

INSERT INTO Lager(LagerID,Lagername,Standort) VALUES (0, 'Hauptlager Graz', 'Graz')
INSERT INTO Lager(LagerID,Lagername,Standort) VALUES (1, 'Hauptlager Wien', 'Wien')
INSERT INTO Lager(LagerID,Lagername,Standort) VALUES (2, 'Hauptlager Linz', 'Linz')

INSERT INTO Lagerbestand(Menge,FK_ProduktID,FK_LagerID) VALUES (1, 0, 0)
INSERT INTO Lagerbestand(Menge,FK_ProduktID,FK_LagerID) VALUES (3, 1, 0)
INSERT INTO Lagerbestand(Menge,FK_ProduktID,FK_LagerID) VALUES (5, 2, 0)

INSERT INTO Lagerbestand(Menge,FK_ProduktID,FK_LagerID) VALUES (10, 0, 1)
INSERT INTO Lagerbestand(Menge,FK_ProduktID,FK_LagerID) VALUES (3, 1, 1)
INSERT INTO Lagerbestand(Menge,FK_ProduktID,FK_LagerID) VALUES (5, 2, 1)

INSERT INTO Lagerbestand(Menge,FK_ProduktID,FK_LagerID) VALUES (6, 5, 2)
INSERT INTO Lagerbestand(Menge,FK_ProduktID,FK_LagerID) VALUES (25, 4, 2)
INSERT INTO Lagerbestand(Menge,FK_ProduktID,FK_LagerID) VALUES (45, 2, 2)












