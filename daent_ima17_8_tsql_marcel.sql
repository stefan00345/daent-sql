/*
##########################################################################################
#                                                                                        #
#       Projekt DAENT | IMA17 | WS18/19                       							 #
#                                                                                        #
#       Gruppe 8								                                         #
#                                                                                        #
#       Gruppenmitglieder:  Ulbel Stefan                                                 #
#                           Koschu Marcel                                                #
#                           NN Nadja                                                     #
#                                                                                        #
#       Thema: Datenverwaltung für einen Baumarkt                                        #
#                                                                                        #
########################################################################################## */



-- #######################################################################################
--  Tabellen
-- #######################################################################################

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

--Tabelle Einkaufsstatus
CREATE TABLE Einkaufsstatus(
    StatusID INT PRIMARY KEY NOT NULL,
    Bezeichnung VARCHAR(20) NOT NULL);

--Tabelle Einkauf
CREATE TABLE Einkauf(
    Einkaufsnummer INT IDENTITY PRIMARY KEY NOT NULL,
    Zahlungsmethode VARCHAR(20),
    Datum DATE DEFAULT SYSDATETIME() NOT NULL,
    FK_Einkauf_Rabatt INT FOREIGN KEY REFERENCES Rabatt(RabattID),
    FK_Einkauf_Kunde INT FOREIGN KEY REFERENCES Kunden(KundenID) NOT NULL,
    FK_Einkauf_Status INT FOREIGN KEY REFERENCES Einkaufsstatus(StatusID) NOT NULL DEFAULT 1);

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




-- Tabelle Stellenposition - INSERTS
INSERT INTO Stellenposition VALUES(1,'Filialleiter');
INSERT INTO Stellenposition VALUES(2,'Kassierer');
INSERT INTO Stellenposition VALUES(3,'Allgemein');
INSERT INTO Stellenposition VALUES(4,'Reinigung'); 
INSERT INTO Stellenposition VALUES(5,'Sekretariat');
INSERT INTO Stellenposition VALUES(6,'Berater');

--Tabelle Einkaufsstatus - INSERTS
INSERT INTO Einkaufsstatus VALUES (1,'Neu');
INSERT INTO Einkaufsstatus VALUES (2,'In Bearbeitung');
INSERT INTO Einkaufsstatus VALUES (3,'Wartend');
INSERT INTO Einkaufsstatus VALUES (4,'Storniert');

--Tabelle Mitarbeiter - INSERTS
INSERT INTO Mitarbeiter(Vorname,Nachname,Adresse,Gehalt,IBAN,FK_Mitarbeiter_Filiale) VALUES ('Stefan','Ulbel','Graz',200.00,'AT 342',1);
INSERT INTO Mitarbeiter(Vorname,Nachname,Adresse,Gehalt,IBAN,FK_Mitarbeiter_Filiale,FK_Filialleiter_Von_Filiale) VALUES ('Marcel','Koschu','Graz',200.00,'AT 342',1,1);

--Tabelle Produkte - INSERTS
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Holzstange', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Holzbohrer', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Leim', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Feile', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Schleifpapier', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Kanister', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Handschuhe', 10, 10, 0, 1.0)
INSERT INTO Produkte(Bezeichnung,UVP,Verkaufspreis,Status,Gewicht) VALUES ('Sicherheitsschuhe', 10, 10, 0, 1.0)

--Tabelle Lager - INSERTS
INSERT INTO Lager(LagerID,Lagername,Standort) VALUES (0, 'Hauptlager Graz', 'Graz')
INSERT INTO Lager(LagerID,Lagername,Standort) VALUES (1, 'Hauptlager Wien', 'Wien')
INSERT INTO Lager(Lagername,Standort) VALUES ('Hauptlager Linz', 'Linz')
--Neu
INSERT INTO Lager(Lagername,Standort) VALUES ('Nebenlager Villach','Villach');

--Tabelle Lagerbestand - INSERTS
INSERT INTO Lagerbestand(Menge,FK_Bestand_Produkt,FK_Bestand_Lager) VALUES (4, 1, 1)
INSERT INTO Lagerbestand(Menge,FK_Bestand_Produkt,FK_Bestand_Lager) VALUES (5, 2, 1)
INSERT INTO Lagerbestand(Menge,FK_Bestand_Produkt,FK_Bestand_Lager) VALUES (6, 3, 1)
INSERT INTO Lagerbestand(Menge,FK_Bestand_Produkt,FK_Bestand_Lager) VALUES (6, 1, 2)
INSERT INTO Lagerbestand(Menge,FK_Bestand_Produkt,FK_Bestand_Lager) VALUES (7, 2, 2)
INSERT INTO Lagerbestand(Menge,FK_Bestand_Produkt,FK_Bestand_Lager) VALUES (8, 3, 2)
INSERT INTO Lagerbestand(Menge,FK_Bestand_Produkt,FK_Bestand_Lager) VALUES (9, 1, 3)
INSERT INTO Lagerbestand(Menge,FK_Bestand_Produkt,FK_Bestand_Lager) VALUES (10, 2, 3)
INSERT INTO Lagerbestand(Menge,FK_Bestand_Produkt,FK_Bestand_Lager) VALUES (11, 3, 3)



-- #######################################################################################
--  Trigger
-- #######################################################################################


--Trigger für Eingabeprüfung:
--Validierung Kundentabelle: Bei hinzufügen oder updaten von
--der „Kunde“-Tabelle, werden alle Eingaben validiert. Es wird überprüft,
--ob die Telefonnummer oder E-Mail bereits irgendwo existieren und ob sie gültig sind.

-- KundeID, Vorname, Nachname, Geburtsdatum, Telefonnummer
-- E-Mail, Adresse

CREATE TRIGGER dbo.kunden_eingabe_iu
    ON dbo.kunden
    AFTER insert, update
AS
BEGIN
   SET NOCOUNT ON;
   IF EXISTS ( SELECT * FROM dbo.kunden k
                INNER JOIN inserted i on i.vorname = k.vorname AND
                i.nachname = k.nachname AND i.geburtsdatum = k.geburtsdatum
                AND i.kunde_id <> k.kunde_id )

    BEGIN
        ROLLBACK
        THROW 50000, 'Fehler: Ein Kunde mit gleichen Daten existiert bereits', 1;
    END

END
GO


-- Testaufrufe



-- Reset



--==============================================================================================================================

-- Trigger für Eingabeprüfung – tabellenübergreifend:
-- Vergleich der Menge Lager <--> Einkaufsposition: Wenn ein neuer Einkauf mit
-- Einkaufspositionen hinzugefügt wird, wird überprüft, ob die Produkte in der
-- gekauften Menge in einem Lager oder verteilt in max. 2 Lagern existieren.
-- Dadurch können keine falschen Mengen bei Einkäufen angegeben werden.
-- Ist die geforderte Menge nur durch Aufsummieren der Bestände von mehr als 2 Lagern verfügbar,
-- ist das Produkt nicht ausreichend lagernd.

GO
ALTER TRIGGER dbo.einkaufsposition_iu
    ON dbo.Einkaufsposition
    AFTER insert, update
AS
BEGIN
   SET NOCOUNT ON;

   DECLARE @anzahl_vorhanden int = 0
   DECLARE @anzahl_nachgefragt int = (SELECT menge FROM inserted)

   SET @anzahl_vorhanden = (
   SELECT SUM(x.menge) FROM (SELECT TOP 2 lb.Menge as "menge" FROM Lagerbestand lb
   INNER JOIN inserted i ON i.FK_Pos_Produkt = lb.FK_Bestand_Produkt
   where lb.Menge > 0
   ORDER BY lb.Menge DESC) x);

      IF @anzahl_vorhanden < @anzahl_nachgefragt
   BEGIN
       ROLLBACK;
       THROW 50001, 'Fehler: Für diesen Einkauf gibt es nicht genug Produkte im Lager', 1;
   END

END
GO


-- Testaufrufe
INSERT INTO Einkaufsposition(FK_Pos_Einkauf,FK_Pos_Produkt,Menge) VALUES (1,1,19) --Funktioniert nicht (Produkt nicht ausreichend lagernd)
INSERT INTO Einkaufsposition(FK_Pos_Einkauf,FK_Pos_Produkt,Menge) VALUES (1,1,14) -- Funktioniert


-- Reset

--==============================================================================================================================
-- Noch nicht getestet
-- Trigger für weiterführende Aktion - Ändern von Kundendaten bei nicht abgeschlossener Bestellung:
GO
CREATE TRIGGER dbo.kunden_ud
    ON dbo.Kunden
    AFTER update, delete
AS
BEGIN
   SET NOCOUNT ON;

   IF EXISTS ( SELECT * FROM dbo.kunden k
                INNER JOIN deleted d on d.KundenID = k.KundenID
				INNER JOIN <bestelltabelle> b ON b.KundenID = d.KundenID
                WHERE (b.status = 1 OR b.status = 2) --1 und 2 nicht spezifiziert, tabelle???

    BEGIN
        ROLLBACK;
        THROW 50002, 'Fehler: Dieser Kunde hat noch eine offene oder nicht bearbeitete Bestellung', 1;
    END

END
GO








-- #######################################################################################
--  Prozeduren
-- #######################################################################################



-- Prozedur 1
-- Kurzbeschreibung: XXXXXXXXXX
/*
Eine Prozedur die Punkte für jeden Einkauf gutschreibt und anhand der gesammelten Punkte einen Rabattwert berechnet und zurückgibt. Zuerst wird geprüft, ob die Kundennummer eine gültige KartenID besitzt, anschließend werden die Bonuspunkte (aus dem Einkaufswert berechnet) gutgeschrieben.
Aufruf: Kundennummer
Rückgabewerte (Integer):
1: Kein Fehler aber es besteht kein Anspruch auf Rabatt 
10: Es besteht Anspruch auf 10% Rabatt
20: Es besteht Anspruch auf 20% Rabatt
40: Es besteht Anspruch auf 40% Rabatt
-1: Unbekannte Kundennummer 
-2: Sonstiger Fehler
*/
ALTER PROCEDURE sp_calculateDiscount
@KundenID INT

AS
BEGIN
SET NOCOUNT ON;
DECLARE @gesamtpunkte AS INT;
IF((SELECT COUNT(*) FROM Kunden WHERE KundenID = @KundenID) = 0)
    RETURN -1;
IF((SELECT COUNT(*) FROM Kundenkarte WHERE KundenID = @KundenID) = 0)
    RETURN 1;

SET @gesamtpunkte = (SELECT SUM(Punktestand) FROM Kundenkarte WHERE KundenID = @KundenID);
IF(@gesamtpunkte >= 40)
    RETURN 40;
ELSE IF(@gesamtpunkte >= 20)
    RETURN 20;
ELSE IF(@gesamtpunkte >= 10)
    RETURN 10;
ELSE IF(@gesamtpunkte >= 0)
    RETURN 1;
ELSE
    RETURN -2;

END

-- Testaufrufe
DECLARE @erg INT;
EXEC @erg = sp_calculateDiscount 1;
SELECT @erg AS Ergebnis;




-- Reset
GO

-- ...
/*
Prozedur „Lieferung einordnen“:
Eine Lieferung kommt in einem Lager an. Die gelieferten Waren werden dem jeweiligen Lager/Lagerbestand zugeordnet. Sollte das Lager unbekannt sein, wird ein Fehler geworfen. Sollte ein unbekanntes Produkt in der Lieferung sein, wird ein Fehler geworfen. Die Menge kann nicht negativ sein. Waren alle Aktionen erfolgreich, wird true zurückgegeben; wenn nicht, false.
Übergebene Parameter: ProduktID, LagerID, Menge.
Rückgabewerte (Integer):
1 Alles wurde korrekt verarbeitet 
-1: Ungültige ProduktID
-2: Ungültige LagerID
-3: Ungültige Menge
-4: Sonstiger Fehler
*/

ALTER PROCEDURE sp_insertDelivery
@ProduktID INT,
@LagerID INT,
@Menge INT
AS
BEGIN
SET NOCOUNT ON;
IF((SELECT COUNT(*) FROM Produkte WHERE ProduktID = @ProduktID) = 0)
    RETURN -1;
IF((SELECT COUNT(*) FROM Lager WHERE LagerID = @LagerID) = 0)
    RETURN -2;
IF(@Menge <= 0)
    RETURN -3;
BEGIN TRANSACTION
DECLARE @current INT;
    BEGIN TRY
        SET @current = (SELECT Menge FROM Lagerbestand WHERE FK_Bestand_Produkt = @ProduktID AND FK_Bestand_Lager = @LagerID);
        IF(ISNULL(@current,0) = 0)
            INSERT INTO Lagerbestand(FK_Bestand_Produkt,FK_Bestand_Lager,Menge) VALUES (@ProduktID,@LagerID,@Menge);
        ELSE
            UPDATE Lagerbestand SET Menge = (@Menge + @current) WHERE FK_Bestand_Produkt = @ProduktID AND FK_Bestand_Lager = @LagerID;
        COMMIT TRANSACTION;
        RETURN 1;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        RETURN -4;
    END CATCH

END


-- Testaufrufe
DECLARE @erg INT;
EXEC @erg = sp_insertDelivery 1,100,-200;
SELECT @erg AS "Ergebnis";

-- Reset

---------------------------------------------------------------------------------
/*
Produkte werden von Lager A zu Lager B transferiert:
Aufruf: LagerID von A (Sender-Lager), LagerID von B (Empfänger-Lager), ProduktID, Menge.
Es werden entsprechende Änderungen in den Tabellen vorgenommen. Das Produkt muss existieren, beide Lager müssen existieren, und das Produkt muss mindestens in der Menge im Lager A existieren.
Rückgabewerte (Integer):
1: Alles hat funktioniert
-1: LagerID von A unbekannt 
-2: LagerID von B unbekannt 
-3: ProduktID unbekannt
-4: Produkt nicht in ausreichender Menge vorhanden 
-5: Sonstiger Fehler
*/
GO

ALTER PROCEDURE sp_transferProduct
@AltesLager INT,
@NeuesLager INT,
@ProduktID INT,
@Menge INT
AS
BEGIN
SET NOCOUNT ON;
IF((SELECT COUNT(*) FROM Lager WHERE LagerID = @AltesLager) = 0)
    RETURN -1;
IF((SELECT COUNT(*) FROM Lager WHERE LagerID = @NeuesLager) = 0)
    RETURN -2;
IF((SELECT COUNT(*) FROM Produkte WHERE ProduktID = @ProduktID) = 0)
    RETURN -3;
IF(ISNULL((SELECT Menge FROM Lagerbestand WHERE FK_Bestand_Produkt = @ProduktID AND FK_Bestand_Lager = @AltesLager),-1) < @Menge OR @Menge < 0)
    RETURN -4;
BEGIN TRY
BEGIN TRANSACTION
    UPDATE Lagerbestand SET Menge = (Menge - @Menge) WHERE FK_Bestand_Lager = @AltesLager AND FK_Bestand_Produkt = @ProduktID;
    IF((SELECT COUNT(*) FROM Lagerbestand WHERE FK_Bestand_Lager = @NeuesLager AND FK_Bestand_Produkt = @ProduktID) = 0)
    BEGIN
        INSERT INTO Lagerbestand(FK_Bestand_Produkt,FK_Bestand_Lager,Menge) VALUES(@ProduktID,@NeuesLager,@Menge);
        COMMIT;
        RETURN 1;
    END
    ELSE
    BEGIN
        UPDATE Lagerbestand SET Menge = (Menge + @Menge) WHERE FK_Bestand_Lager = @NeuesLager AND FK_Bestand_Produkt = @ProduktID;
        COMMIT;
        RETURN 1;
    END
END TRY
BEGIN CATCH
    ROLLBACK;
    RETURN -5;
END CATCH
END

--Testen
SELECT * FROM Lagerbestand;
SELECT * From Lager;
DECLARE @wert INT;
EXEC @wert = sp_transferProduct 1,4,1,-20
SELECT @wert AS "Ergebnis";
