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

--Tabelle Mitarbeiter
CREATE TABLE Mitarbeiter(
    MitarbeiterID INT PRIMARY KEY NOT NULL IDENTITY,
    Vorname VARCHAR(50) NOT NULL,
    Nachname VARCHAR(50) NOT NULL,
    Adresse VARCHAR(60),
    Gehalt MONEY,
    IBAN VARCHAR(40),
    --Referenz zum Lager
    FK_Mitarbeiter_Lager INT FOREIGN KEY REFERENCES Lager(LagerID),
    --Referenz zur Filiale
    FK_Mitarbeiter_Filiale INT FOREIGN KEY REFERENCES Filiale(FilialID),
    --Referenz für Filialleiter
    FK_Filialleiter_Von_Filiale INT FOREIGN KEY REFERENCES Filiale(FilialID));







--Testen
INSERT INTO Lager VALUES ('Hauptlager','Klagenfurt');
INSERT INTO Filiale VALUES ('Test','Graz');
SELECT * FROM Filiale;
SELECT * FROM Mitarbeiter;

INSERT INTO Mitarbeiter(Vorname,Nachname,Adresse,Gehalt,IBAN,FK_Mitarbeiter_Filiale) VALUES ('Stefan','Ulbel','Graz',200.00,'AT 342',1);
INSERT INTO Mitarbeiter(Vorname,Nachname,Adresse,Gehalt,IBAN,FK_Mitarbeiter_Filiale,FK_Filialleiter_Von_Filiale) VALUES ('Marcel','Koschu','Graz',200.00,'AT 342',1,1);

SELECT * FROM Mitarbeiter WHERE FK_Filialleiter_Von_Filiale IS NOT NULL;
SELECT Vorname FROM Mitarbeiter WHERE FK_Filialleiter_Von_Filiale = (SELECT FilialID FROM Filiale WHERE Adresse = 'Graz');







