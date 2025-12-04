' ===========================================================================
'  Programma: ALDUS INVASION  - VideoGame in Basic PDS         Versione 2.0
' ===========================================================================
' File Programma/Revisione : INVAD-AP.BAS - Rev.E / 22 Luglio 1994
' Autore                   : Aldo Prinzi
' Linguaggio               : MS/BC7-PDS
' Files                    : INVAD_AP.BAS
' Computer / Scheda Grafica: PC-Intel 80286 compatibile / VGA, EGA
' ===========================================================================
' Schermo     : &HE (13 Dec.) - Scheda VGA emulazione MCGA 256 colori
' Compilazione: Non Obbligatoria, funziona anche dall'interprete.
' Mouse       : NON previsto
' Memoria      SORGENTE  = RAM: min 500K - Massa: 43Kb circa
'    "         COMPILATO = RAM: min 256K - Massa: 92Kb circa
' ===========================================================================
' Note: Gli sprites sono  originali, come lo screenplay, ma la storia Љ presa
'       dall'originale INVADERS della TAITO apparso in Italia del 1980.
' ===========================================================================


DEFINT A-Z

'- - - - - - - - - -
'(@) Dichiarazione delle SUBS e delle FUNCTIONS.
'- - - - - - - - - -

DECLARE SUB Aiuto ()
DECLARE SUB Aiuto1 ()
DECLARE SUB Aspetta (DecSec!)
DECLARE SUB Compatta ()
DECLARE SUB DisegnaPezzi ()
DECLARE SUB GetTopTen (TTP$())
DECLARE SUB InsertTopTen (Pts)
DECLARE SUB Joke1 ()
DECLARE SUB Joke2 ()
DECLARE SUB Joke3 ()
DECLARE SUB Joke4 ()
DECLARE SUB NewLevel (NL%)
DECLARE SUB MostraTopTen (Inizia%)
DECLARE SUB Pausa ()
DECLARE SUB Presentazione (Flag%)
DECLARE SUB RocketExplosion (X%, Y%)
DECLARE SUB Suono (A!, B#)
DECLARE SUB Scompatta ()
DECLARE SUB VisuaLives (Lives%)
DECLARE FUNCTION INPNOME$ ()


A$ = COMMAND$
A$ = LTRIM$(RTRIM$(A$))
SCREEN 0, 0, 0
WIDTH 80
COLOR 7, 0
CLS
IF A$ <> "" THEN
    IF RIGHT$(A$, 1) = "?" THEN
        CALL Aiuto1: CALL Aiuto
    ELSEIF A$ = "/BASIC" THEN
        CALL Scompatta
    ELSEIF A$ = "/COM" THEN
        CALL Compatta
    ELSE
        CALL Aiuto
    END IF
    END
ELSE
    CALL Aiuto
END IF

'- - - - - - - - - -
'(@) Dichiarazione e impostazione dei vettori SHARED.
'- - - - - - - - - -

DIM SHARED Mostro!(0 TO 90, 0 TO 5, 0 TO 1)
DIM SHARED MSparo!(0 TO 15)
DIM SHARED Player!(0 TO 80, 0 TO 5)
DIM SHARED Razzo!(0 TO 120, 0 TO 2)
DIM SHARED RazzoBum!(0 TO 100, 0 TO 5)
DIM SHARED Sparo!(0 TO 20)
DIM SHARED Ufo!(0 TO 90, 0 TO 2, 0 TO 1)
DIM SHARED pac!(0 TO 80, 0 TO 9)
DIM SHARED PosTT@, FlagSuono

'- - - - - - - - - -
'(@) Dichiarazione e impostazione di altre variabili e dei vettori, anche SHARED.
'- - - - - - - - - -
DIM QMM(11)
DIM SHARED EDP, Musi$
DIM LINEA%(1 TO 5, 0 TO 9)
DIM ExVeMfi(1 TO 4), MFire(1 TO 4), OrMfi(1 TO 4), VeMfi(1 TO 4)
PosTT@ = 16799: FlagSuono = 1

KEY(11) ON
KEY(13) ON
KEY(12) ON

ON KEY(11) GOSUB Spara
ON KEY(13) GOSUB ADestra
ON KEY(12) GOSUB ASinistra

'KEY(0) ON

DisegnaPezzi
FlagGame = 1

GameOver:
IF FlagGame = 1 THEN
    Presentazione Flaag
    FlagGame = 0
    Level = 1: Pts = 0: Lives = 3
END IF

Ricomincia:

RANDOMIZE TIMER

CLS

'- - - - - - - - - -
'(@) Setting dei valori di start per tutte le variabili da inizializzare.
'- - - - - - - - - -

PosR = 100: FIRE = 0:  MaMM = 0:    MPos = 0: PoVeMo = 0: Turn = 0
LMaxR = 70: LMaxL = 1: Mdir = 5: VeGoal = 80:   LILI = 5: FlagUfo = 0
B = 0: Flaag = 0: MaMM = 0: ExMaMM = 0
VeCoM = 2: VeCoP! = 5.5
LEVDISC = 5 + ((Level - 1) * 2)
ExMdir = Mdir
FOR i = 1 TO 4: MFire(i) = 0: NEXT
SELECT CASE Level
    CASE 1
        QMM = 24: QMM(1) = 2: QMM(2) = 4: QMM(3) = 6: QMM(4) = 8: QMM(5) = 10: QMM(6) = 12: QMM(7) = 14: QMM(8) = 16: QMM(9) = 18: QMM(10) = 20: QMM(11) = 22
    CASE 2
        QMM = 20: QMM(1) = 2: QMM(2) = 3: QMM(3) = 5: QMM(4) = 6: QMM(5) = 8: QMM(6) = 9: QMM(7) = 12: QMM(8) = 14: QMM(9) = 13: QMM(10) = 15: QMM(11) = 18
    CASE 3
        QMM = 18: QMM(1) = 1: QMM(2) = 2: QMM(3) = 3: QMM(4) = 5: QMM(5) = 7: QMM(6) = 8: QMM(7) = 10: QMM(8) = 11: QMM(9) = 13: QMM(10) = 14: QMM(11) = 16
    CASE 4
        QMM = 16: QMM(1) = 1: QMM(2) = 2: QMM(3) = 3: QMM(4) = 4: QMM(5) = 5: QMM(6) = 6: QMM(7) = 7: QMM(8) = 8: QMM(9) = 10: QMM(10) = 12: QMM(11) = 14
    CASE 5
        QMM = 13: QMM(1) = 1: QMM(2) = 2: QMM(3) = 2: QMM(4) = 3: QMM(5) = 4: QMM(6) = 4: QMM(7) = 5: QMM(8) = 6: QMM(9) = 7: QMM(10) = 9: QMM(11) = 11
    CASE ELSE
        QMM = 11: QMM(1) = 1: QMM(2) = 2: QMM(3) = 2: QMM(4) = 3: QMM(5) = 3: QMM(6) = 4: QMM(7) = 4: QMM(8) = 5: QMM(9) = 6: QMM(10) = 8: QMM(11) = 10
END SELECT
'- - - - - - - - - -
'(@) Visualizzazione delle vite, della linea base, dei mostri e
'    dell'astronave del giocatore
'- - - - - - - - - -

LINE (0, 183)-(320, 185), 8, BF
PUT (PosR, 159), Razzo!(0, 0), PSET

PLAY "T170MSMB O2E2 P50 A3 B3 O3E10E10E10E10"
'PLAY "MSMB O2E3 P50 A6 B7 O3E6"
RESTORE KEYS
FOR i = 1 TO 17
    READ A$
    FOR j = 1 TO LEN(A$)
        C = VAL("&H" + MID$(A$, j, 1))
        PSET (j - 1, 183 + i), C
    NEXT
NEXT

RESTORE Lives
FOR i = 1 TO 14
    READ A$
    FOR j = 1 TO LEN(A$)
        C = VAL("&H" + MID$(A$, j, 1))
        PSET (215 + j, 185 + i), C
    NEXT
NEXT

FOR i = 0 TO 9
    FOR j = 1 TO 5
        LINEA%(j, i) = 1
        PUT ((i * 25) + 2, j * 15), Mostro!(0, j - 1, 0), PSET
    NEXT
NEXT

VisuaLives Lives
Invasion = 0

'- - - - - - - - - -
'(@) Inizio della routine del Game vera e propria
'- - - - - - - - - -

DO
    IF PO THEN
        PUT (PosR, 159), Razzo!(0, 0), XOR
        PosR = PosR + PO
        IF PosR > 300 THEN PosR = 300
        IF PosR < 2 THEN PosR = 2
        PUT (PosR, 159), Razzo!(0, 0), XOR
        PO = 0
    END IF
    A$ = "": A$ = INKEY$
    SELECT CASE A$
        CASE "P", "p": Pausa
        CASE "S", "s": IF FlagSuono = 1 THEN FlagSuono = 0 ELSE FlagSuono = 1
        CASE "R", "r": IF FlagRallenty = 1 THEN FlagRallenty = 0 ELSE FlagRallenty = 1
        CASE CHR$(27): EXIT DO
        CASE CHR$(32): IF FIRE = 0 THEN FIRE = 1
        CASE CHR$(0) + "H": IF FIRE = 0 THEN FIRE = 1
        CASE CHR$(0) + "M": PO = 6
        CASE CHR$(0) + "K": PO = -6
        CASE CHR$(0) + "P": Pausa
    END SELECT
    FOR NS = 1 TO 4
        IF MFire(NS) = 2 THEN
            PUT (OrMfi(NS), VeMfi(NS)), MSparo!(0), XOR
            ExMVeFi(NS) = VeMfi(NS)
            VeMfi(NS) = VeMfi(NS) + VeCoM
            PF = POINT(OrMfi(NS) + 1, VeMfi(NS) + 5)
            PF = PF + POINT(OrMfi(NS), VeMfi(NS) + 4)
            PF = PF + POINT(OrMfi(NS) + 2, VeMfi(NS) + 4)
            PUT (OrMfi(NS), VeMfi(NS)), MSparo!(0), XOR
            IF PF <> 0 THEN
                'PUT (OrMfi(NS), VeMfi(NS)), MSparo!(0), XOR
                MFire(NS) = 0
                IF VeMfi(NS) > 150 AND VeMfi(NS) < 177 THEN
                    PUT (OrMfi(NS), VeMfi(NS)), MSparo!(0), XOR
                    GOSUB ScoppiaRazzo
                    Lives = Lives - 1
                    VisuaLives Lives
                    PUT (PosR, 159), Razzo!(0, 0), XOR
                    PUT (PosR, 159), RazzoBum!(0, 5), XOR
                    IF Lives < 1 THEN EXIT DO
                ELSE
                    Suono 100, .2
                    IF VeMfi(NS) < 175 THEN
                        PUT (OrMfi(NS), VeMfi(NS)), MSparo!(0), XOR
                    END IF
                END IF
            END IF
            IF VeMfi(NS) >= 177 THEN
                PUT (OrMfi(NS), VeMfi(NS)), MSparo!(0), XOR
                MFire(NS) = 0
            END IF
        END IF
    NEXT

    MM = MM + 1
    IF MM >= QMM THEN
        MM = 0
        FOR i = 0 TO 9
            FOR j = 1 TO 5
                IF LINEA%(j, i) = 1 THEN
                    PUT ((i * 25) + 2 + MPos, j * 15 + PoVeMo), Mostro!(0, j - 1, B), XOR
                END IF
            NEXT
        NEXT
        LINE (1 + MPos, PoVeMo + VeGoal)-(10 + MPos, PoVeMo + VeGoal), 0
        MPos = MPos + Mdir: B = B + 1: IF B = 2 THEN B = 0
        IF FlagPoVe THEN PoVeMo = PoVeMo + LEVDISC: FlagPoVe = 0
        FOR i = 0 TO 9
            FOR j = 1 TO 5
                IF LINEA%(j, i) = 1 THEN
                    PUT ((i * 25) + 2 + MPos, j * 15 + PoVeMo), Mostro!(0, j - 1, B), XOR
                END IF
            NEXT
        NEXT
        FOR SC = 0 TO 1
            RANDOMIZE TIMER: AAA = INT(RND * 50) + 1
            IF (Level <= 2 AND (AAA > 21 AND AAA < 29)) OR (Level > 2 AND (AAA / 5 = INT(AAA / 5))) THEN
                NdS = NdS + 1: IF NdS > 4 THEN NdS = 4
                FOR NS = 1 TO NdS
                    IF MFire(NS) = 0 THEN MFire(NS) = 1: EXIT FOR
                NEXT
            END IF
        NEXT
        Suono 62, .2
    ELSEIF QMM <= 4 THEN
        IF FlagUfo = 1 THEN
            Aspetta .03
        ELSE
            Aspetta .04
        END IF
    ELSE
        Aspetta .004
    END IF
    IF QMM <= 1 AND Level < 4 THEN
        AAs = AAs + 1
        IF AAs >= 2 THEN
            W# = TIMER + .0001
            DO: LOOP WHILE W# > TIMER
            AAs = 0
        END IF
    END IF
    IF Turn > 1 THEN
        FOR NS = 1 TO 4
            IF LILI > 0 AND MFire(NS) = 1 THEN
                PPP = VeGoal
                F = INT((RND * 90) / 10)
                IF LINEA(LILI, F) = 0 THEN
                    FOR j = (LILI - 1) TO 1 STEP -1
                        PPP = PPP - 15
                        IF LINEA(j, F) = 1 THEN EXIT FOR
                    NEXT
                    IF j = 0 THEN
                        PPP = VeGoal
                        FOR F = 0 TO 9
                            IF LINEA(LILI, F) = 1 THEN EXIT FOR
                        NEXT
                    END IF
                END IF
                OF = (F * 25) + 8 + MPos
                FOR XX = 1 TO 4
                    IF MFire(XX) THEN
                        IF XX <> NS THEN
                            IF OrMfi(XX) = OF THEN MFire(NS) = 0
                        END IF
                    END IF
                NEXT
                IF MFire(NS) = 1 THEN
                    OrMfi(NS) = OF
                    VeMfi(NS) = 7 + PoVeMo + PPP
                    MFire(NS) = 2
                    PUT (OrMfi(NS), VeMfi(NS)), MSparo!(0), XOR
                    'PUT (OrMfi(NS), VeMfi(NS)), MSparo!(0), XOR
                END IF
            END IF
        NEXT
    END IF
    IF FIRE = 1 THEN
        OrFi = PosR + 6
        Vefi! = 148
        FIRE = 2
        PUT (OrFi, Vefi!), Sparo!(0), PSET
    END IF
    IF FIRE = 2 THEN
        PUT (OrFi, Vefi!), Sparo!(0), XOR
        ExVeFi! = Vefi!
        Vefi! = Vefi! - VeCoP!
        IF Vefi! < 5 THEN
            FIRE = 0
            PUT (OrFi, Vefi!), Sparo!(0), XOR
        ELSE
            PF = POINT(OrFi + 1, Vefi!)
            PF = PF + POINT(OrFi + 1, Vefi! + 3)
            PF = PF + POINT(OrFi, Vefi! + 1)
            PF = PF + POINT(OrFi + 2, Vefi! + 2)
            IF PF THEN
                PUT (OrFi, Vefi!), Sparo!(0), XOR
                FIRE = 0: ExMaMM = MaMM
                FOR i = 0 TO 9
                    FOR j = 1 TO 5
                        IF LINEA%(j, i) = 1 THEN
                            Col = 0
                            IF OrFi > (i * 25) + MPos AND OrFi < (i * 25) + 4 + MPos + 18 THEN Col = 1
                            IF Vefi! > j * 15 + PoVeMo - 1 AND Vefi! < (j * 15 + PoVeMo) + 12 THEN Col = Col + 1
                            IF Col = 2 THEN
                                LINEA%(j, i) = 0
                                PUT ((i * 25) + 2 + MPos, j * 15 + PoVeMo), Mostro!(0, j - 1, B), XOR
                                MaMM = MaMM + 1
                                Pts = Pts + 10
                                Suono 200, .5
                                IF MaMM > (25 - (Level * 3)) THEN Pts = Pts + (5 * Level)
                            END IF
                        END IF
                    NEXT
                NEXT
                IF ExMaMM = MaMM AND FlagUfo = 1 THEN
                    Col = 0
                    IF OrFi > PoOrUfo AND OrFi < PoOrUfo + 25 THEN Col = 1
                    IF Vefi! > 14 AND Vefi! < 25 THEN Col = Col + 1
                    IF Col = 2 THEN
                        PUT (OrFi, Vefi!), Sparo!(0), XOR
                        PUT (PoOrUfo, 15), Ufo!(0, TUfo, Nufo), XOR
                        FOR i = 1 TO 5
                            PUT (PoOrUfo, 15), Ufo!(0, TUfo, Nufo), XOR
                            PUT (PoOrUfo, 15), Ufo!(0, 2, Nufo), XOR
                            FOR j! = 60 TO 1000 STEP 50
                                IF FlagSuono THEN
                                    Suono 60, .1
                                    Suono j!, .2
                                    Suono 200, .1
                                ELSE
                                    AAs = AAs + 1: IF AAs >= 5 THEN Aspetta .001: AAs = 0
                                END IF
                                IF j! >= 500 THEN PUT (PoOrUfo, 15), Ufo!(0, TUfo, Nufo), XOR
                            NEXT
                            PUT (PoOrUfo, 15), Ufo!(0, 2, Nufo), XOR
                        NEXT
                        PUT (PoOrUfo, 15), Ufo!(0, TUfo, Nufo), XOR
                        PUT (OrFi, Vefi!), Sparo!(0), XOR
                        Pts = Pts + 200 + (Nufo * 150)
                        FlagUfo = 0
                    END IF
                    'PUT (OrFi, VeFi!), Sparo!(0), XOR
                END IF
                SELECT CASE MaMM
                    CASE IS > 48 - Level: QMM = QMM(1)
                    CASE IS > 45 - Level: QMM = QMM(2)
                    CASE IS > 40 - Level: QMM = QMM(3)
                    CASE IS > 30 - Level: QMM = QMM(4)
                    CASE IS > 25 - Level: QMM = QMM(5)
                    CASE IS > 20 - Level: QMM = QMM(6)
                    CASE IS > 15 - Level: QMM = QMM(7)
                    CASE IS > 10 - Level: QMM = QMM(8)
                    CASE IS > 8 - Level: QMM = QMM(9)
                    CASE IS > 5 - Level: QMM = QMM(10)
                    CASE IS > 3 - Level: QMM = QMM(11)
                END SELECT
                LMaxR = 70: LMaxL = 1: VeGoal = 80
                'controlla margine Destro
                FOR i = 0 TO 9
                    LL = 0: FOR j = 1 TO 5: LL = LL + LINEA(j, i): NEXT
                    IF LL = 0 THEN LMaxL = LMaxL - 25 ELSE EXIT FOR
                NEXT
                'controlla margine Sinistro
                FOR i = 9 TO 0 STEP -1
                    LL = 0: FOR j = 1 TO 5: LL = LL + LINEA(j, i): NEXT
                    IF LL = 0 THEN LMaxR = LMaxR + 25 ELSE EXIT FOR
                NEXT
                'controlla massima Altezza (invasion point)
                FOR LILI = 5 TO 1 STEP -1
                    LL = 0: FOR i = 0 TO 9: LL = LL + LINEA(LILI, i): NEXT
                    IF LL = 0 THEN VeGoal = VeGoal - 15 ELSE EXIT FOR
                NEXT
            END IF
        END IF
        PUT (OrFi, Vefi!), Sparo!(0), XOR
    ELSE
        ' non fare niente
    END IF

    ExMdir = Mdir
    IF MPos > LMaxR THEN Mdir = -5
    IF MPos < LMaxL THEN Mdir = 5
    IF Mdir <> ExMdir THEN FlagPoVe = 1
    IF MaMM >= 50 THEN EXIT DO
    COLOR 15
    IF PoVeMo + VeGoal >= 150 THEN GOSUB ScoppiaRazzo: SLEEP 2: Lives = 0: Invasion = 1: EXIT DO
    LOCATE 1, 1: PRINT USING "###,### Pts"; Pts
    COLOR 14
    LOCATE 1, 15: PRINT USING "LEVEL #"; Level
    IF PoVeMo >= 15 AND FlagUfo = 0 THEN
        IF Turn / 25 = INT(Turn / 25) THEN
            RANDOMIZE TIMER: AAA = INT(RND * 60) + 1
            IF (Level > 2 AND AAA = 25) OR (Level = 2 AND (AAA > 24 AND AAA < 29)) OR (Level = 1 AND (AAA > 19 AND AAA < 31)) THEN
                FlagUfo = 1
                RANDOMIZE TIMER: AAA = INT(RND * 50) + 1
                IF AAA / 2 = INT(AAA / 2) THEN
                    PoOrUfo = 290: DirUfo = -3
                ELSE
                    PoOrUfo = 5: DirUfo = 3
                END IF
                TUfo = 0: RANDOMIZE TIMER: Nufo = INT(RND * 10) + 1
                IF Nufo / 2 = INT(Nufo / 2) THEN Nufo = 0 ELSE Nufo = 1
                PUT (PoOrUfo, 15), Ufo!(0, TUfo, Nufo), PSET
            END IF
        END IF
    END IF
    Turn = Turn + 1: IF Turn > 10000 THEN Turn = 2
    IF FlagUfo THEN GOSUB Ufo
    IF FlagRallenty THEN Aspetta .5
LOOP
Turn = 0
Level = Level + 1
IF Level = 2 THEN VeCoM = 3: VeCoP! = 5.5
IF Level = 3 THEN VeCoM = 4: VeCoP! = 6.5
IF Level = 4 THEN VeCoM = 5: VeCoP! = 6
IF Level = 5 THEN VeCoM = 5: VeCoP! = 5.5
IF Level > 5 THEN VeCoM = 6: VeCoP! = 5
IF Lives < 1 THEN
    COLOR 14: LOCATE 10, 10: PRINT "GAME OVER!"
    FlagGame = 1: TopTen = 0
    IF DIR$("ALDINV-1.BIN") <> "" THEN
        OPEN "ALDINV-1.BIN" FOR BINARY AS #1
    ELSE
        OPEN "INVAD_AP.EXE" FOR BINARY AS #1
        PoPo@ = LOF(1)
        SEEK #1, (PoPo@ - 19@)
        A$ = SPACE$(8)
        GET #1, , A$
        PosPezzi@ = CVC(A$)
        PosTT@ = PosPezzi@ + 16799@
    END IF
        B = 0
        FOR i = 1 TO 10
            A$ = SPACE$(22)
            GET #1, PosTT@ + B, A$
            Punti! = CVS(LEFT$(A$, 4))
            IF Punti! < Pts THEN TopTen = 1: POTT = i: EXIT FOR
            B = B + 22
        NEXT
    CLOSE 1
    IF TopTen THEN
        InsertTopTen Pts
        MostraTopTen Flaag
    ELSE
        SLEEP 5
    END IF
ELSEIF Level = 2 AND A$ <> CHR$(27) THEN
    Aspetta 1
    ON PLAY(1) GOSUB ContMus
    IF FlagSuono THEN PLAY ON
    StartMus = 1
    Musi$ = "O2L10T48 CA CA "
    IF FlagSuono THEN PLAY "MB X" + VARPTR$(Musi$)
    Joke1
ELSEIF Level = 3 AND A$ <> CHR$(27) THEN
    Aspetta 1
    ON PLAY(1) GOSUB ContMus
    IF FlagSuono THEN PLAY ON
    StartMus = 1
    Musi$ = "T150MSL16P1P1P1P1P1P3O2C10P60O4C"
    IF FlagSuono THEN PLAY "MB X" + VARPTR$(Musi$)
    Joke2
ELSEIF Level = 4 AND A$ <> CHR$(27) THEN
    Aspetta 1
    ON PLAY(1) GOSUB ContMus
    IF FlagSuono THEN PLAY ON
    StartMus = 1
    Musi$ = "T145MSL8O2P20CACBCACBP25CP10"
    IF FlagSuono THEN PLAY "MB X" + VARPTR$(Musi$)
    Joke3
ELSEIF Level = 5 AND A$ <> CHR$(27) THEN
    Aspetta 1
    Joke4
END IF
IF Flaag THEN GOTO GameOver
IF A$ <> CHR$(27) THEN GOTO GameOver
END
'----------------------------------------------------------------------------
' SubRoutines inserite direttamente nel MAIN Program
'----------------------------------------------------------------------------

'- - - - - - - - - -
'(@) - Gestione del movimento dell'Ufo.
'- - - - - - - - - -

Ufo:
    PUT (PoOrUfo, 15), Ufo!(0, TUfo, Nufo), XOR
    PoOrUfo = PoOrUfo + DirUfo
    IF TUfo = 0 THEN TUfo = 1 ELSE TUfo = 0
    PUT (PoOrUfo, 15), Ufo!(0, TUfo, Nufo), XOR
    IF TUfo THEN
        Suono 1500, .1
    ELSE
        Suono 500, .2
        Suono 200, .1
    END IF
    IF PoOrUfo >= 290 OR PoOrUfo <= 5 THEN
        PUT (PoOrUfo, 15), Ufo!(0, TUfo, Nufo), XOR
        FlagUfo = 0
    END IF
RETURN

'- - - - - - - - - -
'(@) - Gestione dell'astronave del Player che esplode.
'      Compresa la cencellazione degli spari dei mostri attualmente in uso.
'- - - - - - - - - -

ScoppiaRazzo:
    PUT (PosR, 159), Razzo!(0, 0), XOR
    RocketExplosion PosR, 159
    FOR Msp = 1 TO 4
        IF MFire(Msp) = 2 THEN
            PUT (OrMfi(Msp), VeMfi(Msp)), MSparo!(0), XOR
        END IF
        MFire(Msp) = 0
    NEXT
RETURN

'- - - - - - - - - -
'(@) - Gestione dell'input movimenti con ON KEY - NON ATTIVA
'- - - - - - - - - -

ADestra:
    PO = 6
RETURN
ASinistra:
    PO = -6
RETURN
Spara:
    IF FIRE = 0 THEN FIRE = 1
RETURN

'- - - - - - - - - -
'(@) - Gestione dei dati della musica per i quadri JOKE.
'- - - - - - - - - -
ContMus:
    MUS$ = MID$(Musi$, StartMus, 15)
    StartMus = StartMus + 15
    PLAY "X" + VARPTR$(MUS$)
RETURN

'- - - - - - - - - -
'(@) - Immagine dell'astronave in piccolo (visualizzazione grafica delle vite).
'- - - - - - - - - -

MAstro:
DATA "   4   "
DATA "  414  "
DATA "  111  "
DATA "  111  "
DATA "  222  "
DATA " 2 2 2 "
DATA " 2 2 2 "

'- - - - - - - - - -
'(@) - Immagine della linea di base. Non usato come se fosse uno sprite.
'- - - - - - - - - -

KEYS:
DATA "88888                                                                           8                                                                               8                                                  888888"
DATA "88888  7  7  77777 7   7  7777       3   3  333  3   3 33333     4         4    8  3333   333  3   3  3333 33333    333  3   3      333  33333 33333     4444   8  33333 3   3 3333     3333  3333  3   3 33333    888888"
DATA "88888  7 7   7      7 7  7      7    33 33 3   3 3   3 3     3  4           4   8  3   3 3   3 3   3 3     3       3   3 33  3   3 3   3 3     3      3  4   4  8  3     33  3 3   3   3     3    3 33 33 3     3  888888"
DATA "88888  77    77777   7    777        3 3 3 3   3  3 3  3333    444444   444444  8  3   3 3   3 3   3  333  3333    3   3 3 3 3  3  3   3 3333  3333      4   4  8  3333  3 3 3 3   3   3  33 3    3 3 3 3 3333     888888"
DATA "88888  7 7   7       7       7  7    3   3 3   3  3 3  3     3  4           4   8  3333  33333 3   3     3 3       3   3 3  33 3   3   3 3     3      3  4444   8  3     3  33 3   3   3   3 333333 3   3 3     3  888888"
DATA "88888  7  7  77777   7   7777        3   3  333    3   33333     4         4    8  3     3   3  333  3333  33333    333  3   3      333  3     3         4      8  33333 3   3 3333     333  3    3 3   3 33333    888888"
DATA "88888                                                                           8                                                                               8                                                  888888"
DATA "88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888                                                  888888"
DATA "88888                                                                           8                                                                               8                                                  888888"
DATA "88888  33333 3 3333  33333     4                 4444 4444   444   444  44444   8   3333                       3    333  3   3      333  33333 33333      4444  8                44444  4444  444                  888888"
DATA "88888  3     3 3   3 3     3  444    333  3 33  4     4   4 4   4 4   4 4       8  3      333  3   3 3 33   33 3   3   3 33  3   3 3   3 3     3      3  4      8                4     4     4   4                 888888"
DATA "88888  3333  3 3   3 3333    4 4 4  3   3 33     444  4   4 4   4 4     4444    8   333  3   3 3   3 33  3 3  33   3   3 3 3 3  3  3   3 3333  3333       444   8                4444   444  4                     888888"
DATA "88888  3     3 3333  3     3   4    3   3 3         4 4444  44444 4   4 4       8      3 3   3 3  33 3   3 3  33   3   3 3  33 3   3   3 3     3      3      4  8                4         4 4   4                 888888"
DATA "88888  3     3 3   3 33333     4     333  3     4444  4     4   4  444  44444   8  3333   333   33 3 3   3  33 3    333  3   3      333  3     3         4444   8                44444 4444   444                  888888"
DATA "88888                                                                           8                                                                               8                                                  888888"
DATA "8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888"

Lives:
'- - - - - - - - - -
'(@) - Dicitura: "Lives:"
'- - - - - - - - - -

DATA "8833388333383888888883888883388333888"
DATA "8 3  3 3  8 3888888833888 3  3 3  388"
DATA "8 38 3 3338 3888888  3888 38 3 38 388"
DATA "8 3338 3 88 38888888 3888 3333 333888"
DATA "8 3 83 3333 3333838833383 3  3 3 8888"
DATA "8 88 8    8    8 88   8 8 88 8 888888"
DATA "8888888888888888888888888888888888888    3333     33                           "
DATA "2228228822282228288828828822882228288     33                                   "
DATA "2888282828882888288828282828282888288     33     333  33   33  3333   33333    "
DATA "2288282822882288282828282828282288288     33      33  33   33 33  33 33     33 "
DATA "2888228828882888228228222822882888888     22   2  22   22 22  222222  2222     "
DATA "2888282822282228288828282828282228288     22  22  22   22 22  22         22 22 "
DATA "8888888888888888888888888888888888888    2222222 2222   222    22222 22222     "
DATA "8888888888888888888888888888888888888"
'- - - - - - - - - -
'(@) - Immagine della linea dell'Autore. Non usato come se fosse uno sprite.
'      FREEWARE GAME WRITTEN by ALDO PRINZI
'- - - - - - - - - -

author:
DATA "                                                                                                                     BBBBB  BB     BBB           BBBBBB                                "
DATA " FFFF FFF  FFFF FFFF F   F  FF  FFF  FFFF    FFF  FF  F   F FFFF    7   7 777  777 777 777 7777 7   7   7           BB   BB BB     BB            BB   BB         BB                BB  "
DATA " B    B  B B    B    B   B B  B B  B B      E    E  E EE EE E       7   7 7  7  7   7   7  7    77  7   7           BB   BB BB     BB            BB   BB                               "
DATA " BBB  B  B BBB  BBB  B B B B  B B  B BBB    E EE E  E E E E EEE     7 7 7 7  7  7   7   7  777  7 7 7   777  7  7   BB   BB BB  BBBBB   BBBBB    BB   BB BB BBB  BB BB BBB  BBBBBB BB  "
DATA " 3    333  3    3    3 3 3 3333 333  3      6  6 6666 6   6 6       7 7 7 777   7   7   7  7    7  77   7  7 7  7   BB   BB BB BB  BB  BB   BB   BB   BB  BB  BB BB  BB  BB    BB  BB  "
DATA " 1    1  1 1111 1111  1 1  1  1 1  1 1111    44  4  4 4   4 4444     7 7  7  7 777  7   7  7777 7   7   777   77    BBBBBBB BB BB  BB  BB   BB   BBBBBB   BB     BB  BB  BB   BB   BB  "
DATA "                                                                                                            777     BB   BB BB  BBBBBB  BBBBB    BB       BB     BB  BB  BB BBBBBB BB  "

SUB Aiuto

SCREEN 0, 0, 0
WIDTH 80
COLOR 7, 0
CLS
PRINT "-------------------------------------------------------------------------------"
PRINT "              Gioco dell'INVASIONE di Aldo Prinzi, Con Sorgenti!.              "
PRINT "            Aldo Prinzi's FreeWare INVADER GAME, With Source Code!.            "
PRINT "-------------------------------------------------------------------------------"
PRINT " - Usare il seguente comando per ottenere un sorgente in MS/QBasic (quello"
PRINT "    distribuito con l'MS/DOS dalla v.5.00)."
PRINT " - Use the above switch  to obtain source code  in MS/QBasic (the standard"
PRINT "    version distributed with MS/DOS from v.5.00)."
COLOR 15, 0
PRINT "         INVAD_AP /BASIC";
COLOR 7, 0
PRINT " [Enter]"
PRINT
PRINT " - Successivamente, sul vostro disco troverete il file ALDINV-1.BAS."
PRINT "    Questa versione sorgente, cosi' come quella compilata, e' distribuibile"
PRINT "    gratuitamente a chiunque. E' comunque espressamente vietata la vendita."
COLOR 14, 0
PRINT "    Se questo programma Vi  sara' utile e volete concedermi  l'opportunita'"
PRINT "    di continuare il  mio  lavoro, potete  inviarmi L.20.000  all'indirizzo"
PRINT "    indicato in basso:"
COLOR 7, 0
PRINT " - After this operation you will discover, on disk, the ALDINV-1.BAS file."
PRINT "    This  source version,  like the .EXE  version, is freeware  and you can"
PRINT "    distribute it freely. Is expressly prohibited every type of sell."
COLOR 14, 0
PRINT "    If found usefull this program or if you want to give me the opportunity"
PRINT "    of continuing to do my job, you can send me $15 at the above address:"
COLOR 11, 0
PRINT
PRINT "       Aldo Prinzi, Via Giuseppe La Farina N.11, 90141 - Palermo (Italy)"
COLOR 7, 0
PRINT "             Grazie!.                       Thank You in advance."
DO: A$ = INKEY$: LOOP WHILE A$ = ""
WHILE A$ <> CHR$(13): A$ = INKEY$: WEND
END SUB

SUB Aiuto1
SCREEN 0, 0, 0
WIDTH 80
COLOR 7, 0
CLS
PRINT "              Gioco dell'INVASIONE di Aldo Prinzi, Con Sorgenti!.              "
PRINT "            Aldo Prinzi's FreeWare INVADER GAME, With Source Code!.            "
PRINT
PRINT "Questo gioco e' assoultamente  gratuito. L'ho  scritto per permettere una buona"
PRINT "conoscenza del sistema usato per animare gli sprites con un linguaggio ritenuto"
PRINT "troppo poco potente o non molto utilizzabile."
PRINT "Chiunque entri in possesso  di questa copia e' pregato di distribuirla con ogni"
PRINT "mezzo in modo gratuito (regali ad amici, BBS, ecc.), solo in questo modo potra'"
PRINT "raggiungere coloro che lo aspettano. E' altresi' permessa  la pubblicazione del"
PRINT "sorgente su qualsiasi rivista, ma senza  che le indicazioni sul sorgente stesso"
PRINT "siano modificate."
PRINT "Per l'utilizzo di questo gioco avete bisogno di un personal computer con proces-"
PRINT "sore Intel  o compatibile  80X86, di  una scheda  grafica EGA o VGA e di almeno"
PRINT "400Kb di memoria RAM disponibile. - BUON DIVERTIMENTO!."
PRINT
PRINT "This is an absolutely free game that I have written to permit a good known of a"
PRINT "system to animate sprite with the base high-level language MS/QBasic."
PRINT "Everyone  who found  this program must  expressly  distribute it, in  any form,"
PRINT "(like present or by BBS, etc.) without  selling it. This is the  only system to"
PRINT "reach peoples that  are expected for it. It is already  possible to print it in"
PRINT "any magazine, but without any modification into the source and remarks."
PRINT "For the use of this game you must have:a PC with Intel or compatible 80X86 CPU,"
PRINT "a graphic interface like EGA or VGA and at least 400Kb of free RAM - ENJOY IT!"
DO: A$ = INKEY$: LOOP WHILE A$ = ""
WHILE A$ <> CHR$(13): A$ = INKEY$: WEND

END SUB

SUB Aspetta (DecSec!)

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Subroutine    ASPETTA   di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Routine di attesa. Aspetta che siano passati DecSec! centesimi di secondo
' prima di ritonare il controllo al chiamante.
'-----------------------------------------------------------------------------

W# = TIMER + DecSec!
IF W# < TIMER THEN EXIT SUB: ' Correzione per la MezzaNotte!
WHILE W# > TIMER: WEND

END SUB

SUB Compatta
IF DIR$("Aldinv-1.Bin") <> "" THEN
    IF DIR$("Aldinv-1.Bas") <> "" THEN
        OPEN "INVAD_AP.EXE" FOR BINARY AS #1
            OPEN "Aldinv-1.Bas" FOR BINARY AS #2
                PoSo@ = LOF(1) + 10@: LenSo! = INT(LOF(2)): Flag = 0
                SEEK #1, PoSo@: Letto@ = 0: di = 10240
                DO
                    A$ = SPACE$(di)
                    GET #2, , A$
                    FOR i = 1 TO LEN(A$)
                        MID$(A$, i, 1) = CHR$(ASC(MID$(A$, i, 1)) XOR 128)
                    NEXT
                    PUT #1, , A$
                    Letto@ = Letto@ + di
                    IF Flag THEN EXIT DO
                    IF (Letto@ + 10240) > LenSo! THEN di = INT(LenSo! - CSNG(Letto@)): Flag = 1
                LOOP WHILE NOT (EOF(2))
            CLOSE #2
            OPEN "Aldinv-1.Bin" FOR BINARY AS #2
                PoSp@ = LOF(1): LenSp! = INT(LOF(2)): Flag = 0
                SEEK #1, PoSp@: Letto@ = 0: di = 10240
                DO
                    A$ = SPACE$(di)
                    GET #2, , A$
                    PUT #1, , A$
                    Letto@ = Letto@ + di
                    IF Flag THEN EXIT DO
                    IF (Letto@ + 10240) > LenSp! THEN di = INT(LenSp! - CSNG(Letto@)): Flag = 1
                LOOP WHILE NOT (EOF(2))
            CLOSE #2
            PoPo@ = LOF(1)
            SEEK #1, PoPo@
            A$ = MKC$(PoSp@)
            PUT #1, , A$
            A$ = MKC$(PoSo@)
            PUT #1, , A$
            A$ = MKS$(LenSo!)
            PUT #1, , A$
        CLOSE #1
    ELSE
        PRINT "Manca il file BAS"
    END IF
ELSE
    PRINT "Manca il file BIN"
END IF
END SUB

SUB DisegnaPezzi

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                 Subroutine    DISEGNAPEZZI di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Se il file esiste i dati sono automaticamente acquisiti da esso, altrimenti
' li cerca sull'EXE file, alla posizione letta dall'Header.
'-----------------------------------------------------------------------------

SCREEN 13, 0, 0

IF DIR$("ALDINV-1.BIN") <> "" THEN
    OPEN "ALDINV-1.BIN" FOR BINARY AS #1
ELSE
    OPEN "INVAD_AP.EXE" FOR BINARY AS #1
    PoPo@ = LOF(1)
    SEEK #1, (PoPo@ - 19@)
    A$ = SPACE$(8)
    GET #1, , A$
    PosPezzi@ = CVC(A$)
    PosTT@ = PosPezzi@ + 16799@
    SEEK #1, PosPezzi@
END IF

'---------------------------------------------------------
' LETTURA DA FILE E IMPORT DEGLI SPRITES
'---------------------------------------------------------
' Legge i dati scritti nel file "ALDINV-1.BIN" evitando
' di ridisegnare e GETare nuovamente tutti gli sprites.
' Automaticamente legge e inserisce i dati negli appositi
' vettori per la visualizzazione.
'---------------------------------------------------------

    FOR i = 0 TO 100
        A$ = SPACE$(4): GET #1, , A$: Razzo!(i, 0) = CVS(A$)
        A$ = SPACE$(4): GET #1, , A$: Razzo!(i, 1) = CVS(A$)
        A$ = SPACE$(4): GET #1, , A$: Razzo!(i, 2) = CVS(A$)
        FOR j = 0 TO 5
            A$ = SPACE$(4): GET #1, , A$: RazzoBum!(i, j) = CVS(A$)
        NEXT
    NEXT
    FOR i = 101 TO 120
        A$ = SPACE$(4): GET #1, , A$: Razzo!(i, 0) = CVS(A$)
        A$ = SPACE$(4): GET #1, , A$: Razzo!(i, 1) = CVS(A$)
        A$ = SPACE$(4): GET #1, , A$: Razzo!(i, 2) = CVS(A$)
    NEXT
    FOR i = 0 TO 90
        FOR j = 0 TO 1
            A$ = SPACE$(4): GET #1, , A$: Ufo!(i, 0, j) = CVS(A$)
            A$ = SPACE$(4): GET #1, , A$: Ufo!(i, 1, j) = CVS(A$)
            A$ = SPACE$(4): GET #1, , A$: Ufo!(i, 2, j) = CVS(A$)
            FOR K = 0 TO 5
                A$ = SPACE$(4): GET #1, , A$: Mostro!(i, K, j) = CVS(A$)
            NEXT
        NEXT
    NEXT
    FOR i = 0 TO 80
        FOR j = 0 TO 5
            A$ = SPACE$(4): GET #1, , A$: Player!(i, j) = CVS(A$)
        NEXT
    NEXT
    FOR i = 0 TO 15
        A$ = SPACE$(4): GET #1, , A$: Sparo!(i) = CVS(A$)
        A$ = SPACE$(4): GET #1, , A$: MSparo!(i) = CVS(A$)
    NEXT
    FOR i = 16 TO 20
        A$ = SPACE$(4): GET #1, , A$: Sparo!(i) = CVS(A$)
    NEXT
    FOR i = 0 TO 80
        FOR j = 0 TO 9
            A$ = SPACE$(4): GET #1, , A$: pac!(i, j) = CVS(A$)
        NEXT
    NEXT
CLOSE 1
END SUB

SUB GetTopTen (TTP$())

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Subroutine  GETTOPTEN   di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Legge la Top Ten da Disco.
'-----------------------------------------------------------------------------

REDIM TTP$(10)

IF DIR$("ALDINV-1.BIN") <> "" THEN
    OPEN "ALDINV-1.BIN" FOR BINARY AS #1
ELSE
    OPEN "INVAD_AP.EXE" FOR BINARY AS #1
    PoPo@ = LOF(1)
    SEEK #1, (PoPo@ - 19@)
    A$ = SPACE$(8)
    GET #1, , A$
    PosPezzi@ = CVC(A$)
    PosTT@ = PosPezzi@ + 16799@
END IF
    B = 0
    FOR i = 1 TO 10
        A$ = SPACE$(22)
        GET #1, PosTT@ + B, A$
        TTP$(i) = RIGHT$(A$, 18) + " ^ " + STR$(CVS(LEFT$(A$, 4)))
        B = B + 22
    NEXT
CLOSE 1

END SUB

FUNCTION INPNOME$


'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Funzione    INPNOME$    di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Routine di acquisizione del nome del vincitore se entra nella Top Ten.
'-----------------------------------------------------------------------------

COLOR 15
LOCATE 6, 6: PRINT "Please, ENTER your Name"
B$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.,-+/*?!()[] …Љ‚Ќ•—'" + CHR$(8)
VER = 8: ORI = 8: NC = 0: C$ = ""
DO
    COLOR 14: LOCATE VER, ORI, 1: PRINT C$;
    A$ = "": WHILE A$ = "": A$ = INKEY$: WEND
    IF A$ = CHR$(13) THEN EXIT DO
    IF INSTR(B$, A$) THEN
        IF A$ = CHR$(8) THEN
            IF NC > 0 THEN
                COLOR 0: LOCATE VER, ORI, 1: PRINT "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ";
                C$ = LEFT$(C$, LEN(C$) - 1)
                NC = NC - 1
            ELSE
                Suono 3000, .5
            END IF
            A$ = ""
        END IF
        IF A$ <> "" AND NC < 18 THEN
            C$ = C$ + A$: NC = NC + 1
        ELSEIF A$ <> "" THEN
            Suono 3000, .5
        END IF
    ELSE
        Suono 3000, .5
    END IF
LOOP
INPNOME$ = LEFT$(C$ + SPACE$(18), 18)

END FUNCTION

SUB InsertTopTen (Pts)

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Subroutine INSERTTOPTEN di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Inserisce un numinativo nella Top Ten. Scarica poi il tutto sul file.
'-----------------------------------------------------------------------------

REDIM TTP$(10)

LINE (0, 10)-(320, 155), 0, BF
A$ = "": XX! = 55: BB! = 1: XX = 55
DO
    Suono (8000 / (BB! / 2)), .09
    BB! = BB! + .5
    COLOR XX: LOCATE 4, 11: PRINT "You are QUALIFIED!"
    IF XX! >= 90 THEN XX! = 55
    Suono BB! * 100, .09
    XX! = XX! + .25
    XX = INT(XX!)
    A$ = INKEY$: IF A$ <> "" THEN EXIT DO
    Suono ((XX! * (BB! / XX!)) * 100), .09
LOOP WHILE BB! < 50
DO
    Suono 600, .5
    N$ = INPNOME$
LOOP WHILE LEN(LTRIM$(RTRIM$(N$))) = 0
GetTopTen TTP$()
FOR i = 1 TO 10
    PP = INSTR(TTP$(i), "^")
    Pdg = VAL(MID$(TTP$(i), PP + 1, LEN(TTP$(i)) - PP))
    IF Pts > Pdg THEN EXIT FOR
NEXT

IF DIR$("ALDINV-1.BIN") <> "" THEN
    OPEN "ALDINV-1.BIN" FOR BINARY AS #1
ELSE
    OPEN "INVAD_AP.EXE" FOR BINARY AS #1
    PoPo@ = LOF(1)
    SEEK #1, (PoPo@ - 19@)
    A$ = SPACE$(8)
    GET #1, , A$
    PosPezzi@ = CVC(A$)
    PosTT@ = PosPezzi@ + 16798@
END IF
    '
    ' 4 + 18
    '
    FOR K = 9 TO i STEP -1
        A$ = SPACE$(22): B = ((K - 1) * 22) + 1
        GET #1, PosTT@ + B, A$
        PUT #1, PosTT@ + B + 22, A$
    NEXT
    C$ = MKS$(Pts) + N$
    B = ((i - 1) * 22)
    PUT #1, PosTT@ + B + 1, C$
CLOSE 1

END SUB

SUB Joke1


'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine   JOKE1    di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Intermezzo divertente tra il Livello 1 ed il Livello 2.
'-----------------------------------------------------------------------------


REDIM MFire(1 TO 4), OrMfi(1 TO 4), VeMfi(1 TO 4)
CLS

Musi$ = "CACADEFFFEDD10DEFGFEG5E3P8CACAFEDCDFDCDFDP3  T250CACACACADEFFFEDD8DEFGFEG5 E3P10CACAFEDCDFDCDFD          "
        '|--------------|--------------|--------------|--------------|--------------|--------------|--------------
X = 10: Nm = 3: B = 0: XX = 290: Y! = 0: Colpo = 0: CS = 1: CF = 0
'PLAY STOP
COLOR 2: LOCATE 23, 16: PRINT "Intermezzo.";
DO
    LINE (0, 145)-(320, 150), 0, BF
    LINE (0, 150)-(320, 160), CS, BF
    LINE (0, 154)-(320, 154), CF, , &HF0F0
    X = X + 2
    PUT (X, 146), Mostro!(0, Nm, B), OR
    IF X = 24 THEN
         PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
    END IF
        IF X > 24 AND X < 68 THEN
            FOR j = 1 TO 2
                PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
                XX = XX - 6: Y! = Y! + (X / 50)
                u = u + 1: IF u = 2 THEN u = 0
                PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
                Aspetta .2
            NEXT
        ELSEIF (X >= 68 AND X < 88) OR (X >= 104) THEN
            FOR j = 1 TO 2
                IF X > 100 AND MFire(1) = 0 THEN OrMfi(1) = XX + 12: VeMfi(1) = 10 + Y! + 9: MFire(1) = 1: PUT (OrMfi(1), VeMfi(1)), MSparo!(0), PSET
                PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
                u = u + 1: IF u = 2 THEN u = 0
                PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
                IF MFire(1) = 0 THEN Aspetta .22 ELSE Aspetta .18
            NEXT
        ELSEIF X >= 88 AND X < 106 THEN
            FOR j = 1 TO 2
                PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
                XX = XX + 4: Y! = Y! + 2.5
                u = u + 1: IF u = 2 THEN u = 0
                PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
                Aspetta .2
            NEXT
        ELSE
            Aspetta .4
        END IF
        IF Colpo THEN
            FOR i = 1 TO 3
                GOSUB sparato
            NEXT
        ELSE
            Aspetta .01
            IF X >= 102 THEN Colpo = 1
        END IF
    IF X > 102 THEN EXIT DO
    B = B + 1: IF B > 1 THEN B = 0
LOOP
XX! = CSNG(XX)
DO
    GOSUB sparato
    IF X = 115 THEN OrMfi(2) = XX + 12: VeMfi(2) = 10 + Y! + 9: MFire(2) = 1: PUT (OrMfi(2), VeMfi(2)), MSparo!(0), PSET
    IF X = 144 THEN OrMfi(3) = XX + 12: VeMfi(3) = 10 + Y! + 9: MFire(3) = 1: PUT (OrMfi(3), VeMfi(3)), MSparo!(0), PSET
    IF X = 164 THEN OrMfi(4) = XX + 12: VeMfi(4) = 10 + Y! + 9: MFire(4) = 1: PUT (OrMfi(4), VeMfi(4)), MSparo!(0), PSET
    IF X = 174 THEN OrMfi(1) = XX + 12: VeMfi(1) = 10 + Y! + 9: MFire(1) = 1: PUT (OrMfi(1), VeMfi(1)), MSparo!(0), PSET
    IF X = 194 THEN OrMfi(2) = XX + 12: VeMfi(2) = 10 + Y! + 9: MFire(2) = 1: PUT (OrMfi(2), VeMfi(2)), MSparo!(0), PSET
    IF X = 204 THEN OrMfi(3) = XX + 12: VeMfi(3) = 10 + Y! + 9: MFire(3) = 1: PUT (OrMfi(3), VeMfi(3)), MSparo!(0), PSET
    IF X = 219 THEN OrMfi(4) = XX + 12: VeMfi(4) = 10 + Y! + 9: MFire(4) = 1: PUT (OrMfi(4), VeMfi(4)), MSparo!(0), PSET
    IF X = 229 THEN OrMfi(1) = XX + 12: VeMfi(1) = 10 + Y! + 9: MFire(1) = 1: PUT (OrMfi(1), VeMfi(1)), MSparo!(0), PSET
    IF X = 244 THEN OrMfi(2) = XX + 12: VeMfi(2) = 10 + Y! + 9: MFire(2) = 1: PUT (OrMfi(2), VeMfi(2)), MSparo!(0), PSET
    IF X = 259 THEN OrMfi(3) = XX + 12: VeMfi(3) = 10 + Y! + 9: MFire(3) = 1: PUT (OrMfi(3), VeMfi(3)), MSparo!(0), PSET
    IF X = 274 THEN OrMfi(4) = XX + 12: VeMfi(4) = 10 + Y! + 9: MFire(4) = 1: PUT (OrMfi(4), VeMfi(4)), MSparo!(0), PSET
    IF XX < 290 THEN
        PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
        XX! = XX! + 5.3: XX = INT(XX!): REM Y! = Y! + (X / 60)
        u = u + 1: IF u = 2 THEN u = 0
        PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
    ELSE
        IF Fflag = 0 THEN PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR: Fflag = 1
    END IF
    LINE (0, 145)-(320, 150), 0, BF
    LINE (0, 150)-(320, 160), CS, BF
    LINE (0, 154)-(320, 154), CF, , &HF0F0
    X = X + 5
    PUT (X, 146), Mostro!(0, Nm, B), OR
    Aspetta .08
    IF X > 294 THEN EXIT DO
    B = B + 1: IF B > 1 THEN B = 0
LOOP
PLAY OFF
NewLevel 2

SLEEP 1
EXIT SUB

sparato:
    FOR NS = 1 TO 4
        IF MFire(NS) THEN
            PUT (OrMfi(NS), VeMfi(NS)), MSparo!(0), XOR
            VeMfi(NS) = VeMfi(NS) + 5
            IF VeMfi(NS) > 150 THEN
                MFire(NS) = 0
            ELSE
                PUT (OrMfi(NS), VeMfi(NS)), MSparo!(0), XOR
            END IF
        END IF
    NEXT
RETURN

END SUB

SUB Joke2

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine   JOKE2    di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Intermezzo divertente tra il Livello 2 ed il Livello 3.
'-----------------------------------------------------------------------------

CLS

Musi$ = "O3P30GP30EO4P40CO3P30GP30EP10 O2C#10P60O4C#O3P30G#P30FO4P40 C#O3P30G#P30F  P10O2C10P60O4C O3P30GP30EO4P40CO3P30GP30EP10 O2L35CCCCCCCCCCL40EEEEEEEEEE  L45GGGGGGGGGGO3L50CCCCCCCCCCP3P5             "
        '|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------
Musi$ = Musi$ + "T180MSL18P5O1C9P8O3GP30EO4P40CO3P30GP30EP10O2C#10P60O4C#O3  P30G#P30FO4P40 C#O3P30G#P30F  P10O2C10P60O4C O3P30GP30EO4P40CO3P30GP30EP10 O2L35CCCCCCCCCCL40EEEEEEEEEE  L45GGGGGGGGGGO3L50CCCCCCCCCC  "
                '|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------

COLOR 2: LOCATE 23, 16: PRINT "Intermezzo.";



Xu = 10: NMu = 3: XXu! = 5
Bu = 0: FFu = 0: YYu! = 100
'DIM SHARED Ufo!(0 TO 90, 0 TO 2, 0 TO 1)
PUT (XXu!, 50 + YYu!), Ufo!(0, B, 1), XOR
DO
    Aspetta .1
    PUT (XXu!, 50 + YYu!), Ufo!(0, Bu, 1), XOR
    Bu = Bu + 1: IF Bu >= 2 THEN Bu = 0
    IF XXu! < 200 THEN XXu! = XXu! + 2.5
    YYu! = YYu! - .95
    PUT (XXu!, 50 + YYu!), Ufo!(0, Bu, 1), XOR
    IF YYu! < 21.2 THEN EXIT DO
LOOP

X = 10: Nm = 3: XX! = 5
B = 7: C = 5: FF = 0: XX2! = XX! - 40
OrMfi = 258: VeMfi! = 54: Flag = 0
PUT (XX!, 100), pac!(0, B), XOR
DO
    Aspetta .045
    IF XX! < 290 THEN PUT (XX!, 100), pac!(0, B), XOR
    IF XX2! > 5 THEN PUT (XX2!, 100), pac!(0, C), XOR
    PUT (XXu!, 50 + YYu!), Ufo!(0, Bu, 1), XOR
    Bu = Bu + 1: IF Bu >= 2 THEN Bu = 0
    B = B + 1: IF B = 10 THEN B = 7
    C = C + 1: IF C = 7 THEN C = 5
    XX! = XX! + 2.5: XX2! = XX2! + 2.6
    XXu! = XXu! + .5: YYu! = YYu! - .2
    IF XXu! > 248 AND Flag = 0 THEN Flag = 1: PUT (OrMfi, VeMfi!), MSparo!(0), XOR
    IF XXu! > 248 THEN GOSUB SparaBomba
    PUT (XXu!, 50 + YYu!), Ufo!(0, Bu, 1), XOR
    IF XX! < 290 THEN PUT (XX!, 100), pac!(0, B), XOR
    IF XX2! > 5 THEN PUT (XX2!, 100), pac!(0, C), XOR
    IF Flag > 1 THEN EXIT DO
LOOP
PUT (XX2!, 100), pac!(0, C), XOR
PUT (XX!, 100), pac!(0, B), XOR
X = 10: Nm = 3: 'XX! = 290
B = 0: C = 3: FF = 0: 'XX2! = XX! + 30
PUT (XX!, 100), pac!(0, B), XOR
PUT (XX2!, 100), pac!(0, C), XOR
DO
    Aspetta .045
    IF XXu! < 293 THEN PUT (XXu!, 50 + YYu!), Ufo!(0, Bu, 1), XOR
    IF XX! < 291 THEN PUT (XX!, 100), pac!(0, B), XOR
    IF XX2! > 5 THEN PUT (XX2!, 100), pac!(0, C), XOR
    Bu = Bu + 1: IF Bu >= 2 THEN Bu = 0
    B = B + 1: IF B = 3 THEN B = 0
    C = C + 1: IF C = 5 THEN C = 3
    XX2! = XX2! - 3.5: XX! = XX! - 3.65
    XXu! = XXu! + .5: YYu! = YYu! - .2
    IF XXu! < 293 THEN PUT (XXu!, 50 + YYu!), Ufo!(0, Bu, 1), XOR
    IF XX! < 291 THEN PUT (XX!, 100), pac!(0, B), XOR
    IF XX2! > 5 THEN PUT (XX2!, 100), pac!(0, C), XOR
    IF XX! <= 5 THEN EXIT DO
LOOP
PUT (XX!, 100), pac!(0, B), XOR
PLAY OFF
NewLevel 3
SLEEP 1

EXIT SUB

SparaBomba:
    IF Flag = 1 THEN
        PUT (OrMfi, VeMfi!), MSparo!(0), XOR
        VeMfi! = VeMfi! + 3.8
        IF VeMfi! < 106 THEN
            PUT (OrMfi, VeMfi!), MSparo!(0), XOR
        ELSE
            Flag = 2
        END IF
    END IF
RETURN

END SUB

SUB Joke3

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine   JOKE3    di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Intermezzo divertente tra il Livello 3 ed il Livello 4.
'-----------------------------------------------------------------------------
'

CLS

Musi$ = "CDP10DP5CACACACAP25CP10CDP3CACBCACBP25CP10CD P10DP8CACACACA P25CP10CDP5CACBCACBP25CP10CD  P10DP5CACACACA P25CP10CDP3CACBCACBP25CP10CD  P10DP5CACACACA P25CP10CDP3CACAP25CP10CDP10D  P10BFEP25CP25CDP10D           "
        '|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------
Musi$ = Musi$ + " L9T170P1CACBCACBP25CP10CDP10DP5CACACACAP25C P10CDP3CACBCACBP25CP10CDP10DP8CACACACAP25CP10CDP5CACBCACBP25CP10CDP10DP5CACACACAP25CP10CD P10BFEP25CP25CDP10D           "
                '|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|--------------

COLOR 2: LOCATE 23, 16: PRINT "Intermezzo.";

LINE (0, 163)-(320, 165), 8, BF
PUT (150, 139), Razzo!(0, 0), PSET

Xm = 10: Nm = 1: XXm! = 5: Bm = 0: YYm! = 20: XXr! = 150
PUT (XXm!, 50 + YYm!), Mostro!(0, 3, Bm), XOR
DO
    Aspetta .1
    FOR i = 1 TO Nm
        IF XXm! > 150 AND i = 3 THEN
            PUT (XXm1! - 36, 50 + YYm1!), Mostro!(0, 3, Bm), XOR
        ELSE
            PUT (XXm! - ((i - 1) * 18), 50 + YYm!), Mostro!(0, 3, Bm), XOR
        END IF
    NEXT
    PUT (XXr!, 139), Razzo!(0, 0), XOR
    Bm = Bm + 1: IF Bm >= 2 THEN Bm = 0
    IF XXm! < 200 THEN XXm! = XXm! + 2.5: XXr! = XXr! - 1.2 ELSE YYm! = YYm! + .6
    IF XXm! > 150 THEN : XXr! = XXr! + .5
    IF Flag = 2 THEN XXm1! = XXm1! - 2: 'YYm1! = YYm1! - .05
    IF Flag = 1 THEN YYm1! = YYm1! - .5: XXm1! = XXm1! - .5: IF YYm1! < -7 THEN Flag = 2
    IF XXm! > 150 AND Flag = 0 THEN Flag = 1: XXm1! = XXm!: YYm1! = YYm!
    IF XXm! > 80 THEN : XXr! = XXr! + 2
    IF YYm1! < 15 AND XXm1! > 1 THEN : XXr! = XXr! - 4
    IF YYm1! < -6 AND XXm1! > 1 THEN : XXr! = XXr! + 6
    IF YYm! > 60 THEN : XXr! = XXr! - 4: YYm1! = YYm1! + .2: XXm1! = XXm1! + 3.2
    IF YYm! > 80 THEN : XXr! = XXr! + 6: YYm1! = YYm1! + .6
    IF XXm! > 18 THEN Nm = 2
    IF XXm! > 36 THEN Nm = 3
    IF (XXr! < 120 AND FlagRS = 0) OR (XXr! < 95 AND FlagRS = 2) OR (XXr! > 134 AND FlagRS = 2) THEN
        FlagRS = 1
        OrFi = INT(XXr! + 10): Vefi! = 129
        PUT (OrFi, Vefi!), Sparo!(0), XOR
    END IF
    IF FlagRS = 1 THEN GOSUB SpaRaz
    PUT (XXr!, 139), Razzo!(0, 0), XOR
    FOR i = 1 TO Nm
        IF XXm! > 150 AND i = 3 THEN
            PUT (XXm1! - 36, 50 + YYm1!), Mostro!(0, 3, Bm), XOR
        ELSE
            PUT (XXm! - ((i - 1) * 18), 50 + YYm!), Mostro!(0, 3, Bm), XOR
        END IF
    NEXT
    IF YYm! > 91 THEN EXIT DO
LOOP
PUT (OrFi, Vefi!), Sparo!(0), XOR
PUT (XXm1! - 36, 50 + YYm1!), Mostro!(0, 3, Bm), XOR
DO
    Aspetta .1
    FOR i = 1 TO 2
        PUT (XXm! - ((i - 1) * 18), 50 + YYm!), Mostro!(0, 3, Bm), XOR
    NEXT
    PUT (XXr!, 139), Razzo!(0, 0), XOR
    Bm = Bm + 1: IF Bm >= 2 THEN Bm = 0
    YYm! = YYm! + .7
    XXr! = XXr! + 2.5
    PUT (XXr!, 139), Razzo!(0, 0), XOR
    FOR i = 1 TO 2
        PUT (XXm! - ((i - 1) * 18), 50 + YYm!), Mostro!(0, 3, Bm), XOR
    NEXT
    IF YYm! > 101 THEN EXIT DO
LOOP
XXm1! = XXm!: XXm2! = XXm! - 18: YYm1! = YYm!: YYm2! = YYm!: Flag = 0
Xu! = 290: Yu! = 30: Bu = 0: Flag = 0
DO
    Aspetta .1
    IF Flag = 2 THEN
        PUT (Xu!, Yu!), Ufo!(0, Bu, 1), XOR
        Xu! = Xu! - 2.5: Yu! = Yu! + .4
    END IF
    IF Flag OR (XXm1! < 302) THEN PUT (XXm1!, 50 + YYm1!), Mostro!(0, 3, Bm), XOR
    PUT (XXm2!, 50 + YYm2!), Mostro!(0, 3, Bm), XOR
    PUT (XXr!, 139), Razzo!(0, 0), XOR
    Bu = Bu + 1: IF Bu >= 2 THEN Bu = 0
    Bm = Bm + 1: IF Bm >= 2 THEN Bm = 0
    IF Flag OR (XXm1! < 302) THEN XXm1! = XXm1! + 2.5
    XXm2! = XXm2! - 1.1
    IF XXm2! > 169 THEN XXr! = XXr! + 2.1 ELSE XXr! = XXr! - 1.1
    PUT (XXr!, 139), Razzo!(0, 0), XOR
    PUT (XXm2!, 50 + YYm2!), Mostro!(0, 3, Bm), XOR
    IF Flag = 0 AND XXm2! < 112 THEN
        XXm1! = 1
        Flag = 1
    END IF
    IF Flag OR (XXm1! < 302) THEN PUT (XXm1!, 50 + YYm1!), Mostro!(0, 3, Bm), XOR
    IF Flag = 2 AND XXm1! > 55 THEN EXIT DO
    IF Flag = 1 AND XXm1! > 15 THEN Flag = 2: ' PUT (Xu!, Yu!), Ufo!(0, Bu, 1), XOR
    IF Flag = 2 THEN
        PUT (Xu!, Yu!), Ufo!(0, Bu, 1), XOR
    END IF
LOOP
Flag = 0: FlagP = 0: PUT (Xu!, Yu!), Ufo!(0, Bu, 1), XOR
Yp! = 141: Xp! = 67
DO
    Aspetta .1
    IF FlagP THEN PUT (Xp!, Yp!), Player!(0, Bu), XOR
    PUT (Xu!, Yu!), Ufo!(0, Bu, 1), XOR
    PUT (XXm1!, 50 + YYm1!), Mostro!(0, 3, Bm), XOR
    PUT (XXm2!, 50 + YYm2!), Mostro!(0, 3, Bm), XOR
    Bu = Bu + 1: IF Bu >= 2 THEN Bu = 0
    Bm = Bm + 1: IF Bm >= 2 THEN Bm = 0
    IF FlagP AND (Xp! < 53) AND (Yp! < 151) THEN
        Yp! = Yp! + 3.5
    END IF
    IF FlagP THEN Xp! = Xp! - 2.5
    IF Xu! > 65 THEN Xu! = Xu! - 2.5: Yu! = Yu! + .4 ELSE IF Flag = 0 THEN Flag = 1
    IF Xp! < 1 THEN FlagP = 0
    IF Flag = 1 THEN Yu! = Yu! + .8
    IF Xp! > 1 AND Yu! > 80 AND FlagP = 0 THEN
        FlagP = 1
    END IF
    IF Xp! < 10 AND FlagSm = 0 THEN
        FlagSm = 1
        OrMfi = Xu! + 12: VeMfi! = Yu! + 10
        PUT (OrMfi, VeMfi!), MSparo!(0), XOR
    END IF
    IF FlagSm = 1 THEN GOSUB SpaUfo
    IF Yu! > 90 AND Flag = 1 THEN Flag = 2
    IF FlagP THEN PUT (Xp!, Yp!), Player!(0, Bu), XOR
    PUT (Xu!, Yu!), Ufo!(0, Bu, 1), XOR
    PUT (XXm1!, 50 + YYm1!), Mostro!(0, 3, Bm), XOR
    PUT (XXm2!, 50 + YYm2!), Mostro!(0, 3, Bm), XOR
    IF FlagSm = 2 THEN EXIT DO
LOOP
PUT (XXr!, 139), Razzo!(0, 0), XOR
X = INT(XXr!)
RocketExplosion X, 139
Aspetta .5
PLAY OFF
NewLevel 3

EXIT SUB
SpaRaz:
    PUT (OrFi, Vefi!), Sparo!(0), XOR
    Vefi! = Vefi! - 4.3
    IF Vefi! < 10 THEN FlagRS = 2: RETURN
    PUT (OrFi, Vefi!), Sparo!(0), XOR
RETURN
SpaUfo:
    PUT (OrMfi, VeMfi!), MSparo!(0), XOR
    VeMfi! = VeMfi! + 3.8
    IF VeMfi! < 136 THEN
        PUT (OrMfi, VeMfi!), MSparo!(0), XOR
    ELSE
        FlagSm = 2
    END IF
RETURN

END SUB

SUB Joke4

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine   JOKE4    di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Intermezzo divertente tra il Livello 4 ed il Livello 5.
'-----------------------------------------------------------------------------
'
CLS

NewLevel 4

END SUB

SUB MostraTopTen (Inizia)

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Subroutine MOSTRATOPTEN di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Legge e visualizza i dati della Top Ten
'-----------------------------------------------------------------------------

CLS
XX! = 55: TT = 0: Inizia = 0
REDIM TTP$(10)

GetTopTen TTP$()
FOR TT = 1 TO 10
    COLOR 7: LOCATE 2 + (TT * 2), 6: PRINT USING "## "; TT; : PRINT TTP$(TT)
NEXT
TT = 0: LO = 1
DO
    XX! = XX! + 2.5: LO = LO + 1
    IF XX! > 90 THEN XX! = 55
    COLOR INT(XX!)
    LOCATE 1, 4: PRINT "ALDUS INVASION 1! - TOP TEN Players"
    TT = TT + 1
    IF TT > 10 THEN TT = 1
    FOR j! = 55! TO 99! STEP .5
        JJ = INT(j!)
        COLOR JJ: LOCATE 2 + (TT * 2), 6: PRINT USING "## "; TT; : PRINT TTP$(TT)
        B$ = INKEY$: IF B$ = CHR$(13) THEN Inizia = 1: EXIT FOR
    NEXT
    COLOR 7: LOCATE 2 + (TT * 2), 6: PRINT USING "## "; TT; : PRINT TTP$(TT)
    A$ = INKEY$: IF A$ = CHR$(13) OR A$ = CHR$(27) THEN Inizia = 1: EXIT DO
    IF Inizia THEN EXIT DO
LOOP WHILE LO < 50
IF Inizia = 0 THEN SLEEP 5

CLS

END SUB

SUB NewLevel (NL)

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine  NEWLEVEL  di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Visualizza la dicitura "You Have reached LEVEL nn"
'-----------------------------------------------------------------------------

CLS
NL$ = LTRIM$(RTRIM$(STR$(NL)))

XX = 2
DO
    LINE (0, 145)-(320, 150), 0, BF
    LINE (0, 150)-(320, 160), CS, BF
    LINE (0, 154)-(320, 154), CF, , &HF0F0
    COLOR 0: LOCATE XX - 1, 8: PRINT "You have reached LEVEL "; NL$; "!"
    COLOR XX: LOCATE XX, 8: PRINT "You have reached LEVEL "; NL$; "!"
    SoloFlag = 1
    'GOSUB sparato
    Aspetta .14
    IF XX = 11 THEN EXIT DO
    XX = XX + 1
    B$ = INKEY$
LOOP
A$ = "": XX! = 55: BB! = 1: XX = 55
DO
    Suono (8000 / (BB! / 2)), .09
    BB! = BB! + .5
    COLOR XX: LOCATE 11, 8: PRINT "You have reached LEVEL "; NL$; "!"
    IF XX! >= 90 THEN XX! = 55
    Suono BB! * 100, .09
    XX! = XX! + .25
    XX = INT(XX!)
    A$ = INKEY$: IF A$ <> "" THEN EXIT DO
    Suono ((XX! * (BB! / XX!)) * 100), .09
LOOP WHILE BB! < 150
SLEEP 1


END SUB

SUB Pausa

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine   PAUSA    di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Usata per attivare una pausa quando si preme P durante il gioco.
'-----------------------------------------------------------------------------

X! = 300: Y = 169: B = 3
DO
    PUT (X!, Y), Player!(0, B), XOR
    Aspetta .09
    PUT (X!, Y), Player!(0, B), XOR
    X! = X! - 2.2
    B = B + 1: IF B = 6 THEN B = 3
    A$ = INKEY$: IF UCASE$(A$) = "P" THEN EXIT DO
    IF A$ = CHR$(0) + "P" THEN EXIT DO
    IF X! < 3 THEN X! = 300: B = 3: Aspetta 1
LOOP

END SUB

SUB Presentazione (Inizia)


'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                 Subroutine  PRESENTAZIONE  di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Routine di presentazione del programma. Presenta tutti gli elementi sprites
' tranne gli spari e le esplosioni.
'-----------------------------------------------------------------------------

Inizia = 0
StartPresentazione:
CLS
LINE (0, 197)-(320, 200), 8, BF
C = 0: B = 0: FlagP = 1
D = 150: P! = 310: PP! = 1.4: PPP = 0
Hufo = 110: Oufo! = 0: IncUfo! = 2
PUT (5 + Oufo!, Hufo), Ufo!(0, 1, 0), PSET
RESTORE author
FOR i = 1 TO 7
    READ A$
    FOR j = 1 TO LEN(A$)
        C = VAL("&H" + MID$(A$, j, 1))
        PSET (45 + j, 10 + i), C
    NEXT
NEXT

DO
    PUT (5 + Oufo!, Hufo), Ufo!(0, 1, 0), XOR
    IF T > 30 THEN Hufo = Hufo - 2
    Oufo! = Oufo! + IncUfo!
    PUT (5 + Oufo!, Hufo), Ufo!(0, 0, 0), XOR
    IF FlagP THEN
        IF PPP THEN
            PUT (P!, 186), Player!(0, 2), XOR
            P! = P! - PP!
        END IF
        PUT (P!, 186), Player!(0, 0), XOR
    END IF
    PPP = 1
    IF C! >= 0 THEN
        Suono 60 + D, .05
        PUT (50, C!), Razzo!(0, 1), XOR
        Suono 60 + D - .2, .05
        Aspetta .1
        Suono 60 + D, .1
        PUT (50, C!), Razzo!(0, 1), XOR
        Suono 60 + D - .4, .05
        PUT (50, C!), Razzo!(0, 2), XOR
        Suono 60 + D - .6, .05
        IF FlagP THEN
            PUT (P!, 186), Player!(0, 0), XOR
            P! = P! - PP!
            PUT (P!, 186), Player!(0, 1), XOR
        END IF
        PUT (5 + Oufo!, Hufo), Ufo!(0, 0, 0), XOR
        Oufo! = Oufo! + IncUfo!
        PUT (5 + Oufo!, Hufo), Ufo!(0, 1, 0), XOR
        Aspetta .1
        Suono 60 + D - .8, .05
        PUT (50, C!), Razzo!(0, 2), XOR
        Suono 60 + D - .9, .05
        C! = C! + 4
        IF C! > 170 THEN
            C! = -1
            PUT (50, 174), Razzo!(0, 0)
        END IF
    ELSE
        e = e + 1: IF e > 7 THEN e = 1
        COLOR e
        LOCATE 24, 18: PRINT "<--- PLAYER";
        LOCATE 1, 1, 0
        Aspetta .1
        IF FlagP THEN
            PUT (P!, 186), Player!(0, 0), XOR
            P! = P! - PP!
            PUT (P!, 186), Player!(0, 1), XOR
        END IF
        PUT (5 + Oufo!, Hufo), Ufo!(0, 0, 0), XOR
        Oufo! = Oufo! + IncUfo!
        PUT (5 + Oufo!, Hufo), Ufo!(0, 1, 0), XOR

        Aspetta .1
    END IF
    D = D - 3
    A$ = INKEY$
    IF A$ = CHR$(13) THEN Inizia = 1: EXIT DO
    IF A$ = CHR$(27) THEN SCREEN 0, 0, 0: WIDTH 80: COLOR 7, 0: CLS : END
    PUT (90, 28), Mostro!(0, 0, B), PSET
    PUT (90, 60), Mostro!(0, 1, B), PSET
    PUT (90, 92), Mostro!(0, 2, B), PSET
    PUT (90, 124), Mostro!(0, 3, B), PSET
    PUT (90, 156), Mostro!(0, 4, B), PSET
    B = B + 1: IF B = 2 THEN B = 0
    Suono 60, .1
    IF FlagP THEN
        PUT (P!, 186), Player!(0, 1), XOR
        P! = P! - PP!
        PUT (P!, 186), Player!(0, 2), XOR
    END IF
    IF INT(C!) >= 30 AND INT(C!) <= 35 THEN
        LOCATE 5, 15: PRINT "Giacomo  "
    END IF
    IF INT(C!) >= 60 AND INT(C!) <= 65 THEN
        LOCATE 9, 15: PRINT "Giovanni "
    END IF
    IF INT(C!) >= 90 AND INT(C!) <= 95 THEN
        LOCATE 13, 15: PRINT "Vincenzo "
    END IF
    IF INT(C!) >= 125 AND INT(C!) <= 130 THEN
        LOCATE 17, 15: PRINT "Aldo     "
    END IF
    IF INT(C!) >= 155 AND INT(C!) <= 160 THEN
        LOCATE 21, 15: PRINT "Vicky "
    END IF
    e! = e! + .5: IF e! > 7 THEN e! = 1
    COLOR INT(e!)
    LOCATE 1, 10: PRINT "ALDUS INVASION 1 !"
    IF P! <= 66 AND FlagP = 1 THEN
        PUT (P!, 186), Player!(0, 2), XOR
        FlagP = 0
        PUT (65, 186), Player!(0, 2), PSET
        PUT (50, 174), Razzo!(0, 0), OR
    END IF
    T = T + 1: IF T = 70 THEN EXIT DO
LOOP WHILE A$ = ""
IF Inizia THEN EXIT SUB
SLEEP 2
Flagg = 0: MostraTopTen Flagg
IF Flagg THEN EXIT SUB
GOTO StartPresentazione

CLS
END SUB

SUB RocketExplosion (X, Y)

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'               Subroutine ROCKETEXPLOSION di INVAD_AP.BAS
'-----------------------------------------------------------------------------
'        Visualizza e fa sentire l'esplosione del rocket del player
'-----------------------------------------------------------------------------

    PUT (X, Y), RazzoBum!(0, 0), XOR
    FOR i = 100 TO 1 STEP -1
        IF i / 20 = INT(i / 20) THEN
            NF = 6 - (i / 20)
            PUT (X, Y), RazzoBum!(0, (NF - 1)), XOR
            PUT (X, Y), RazzoBum!(0, NF), XOR
        END IF
        IF FlagSuono THEN
            S = INT(RND * 100)
            Suono 100 + S, .2
            Suono ((i * 5) + 60 + S), .1
            Suono 200 + S, .2
        ELSE
            AAs = AAs + 1: IF AAs >= 5 THEN Aspetta .001: AAs = 0
        END IF
    NEXT

END SUB

SUB Scompatta
SCREEN 0, 0, 0
WIDTH 80
COLOR 7, 0
CLS
PRINT "-------------------------------------------------------------------------------"
PRINT "              Gioco dell'INVASIONE di Aldo Prinzi, Con Sorgenti!.              "
PRINT "            Aldo Prinzi's FreeWare INVADER GAME, With Source Code!.            "
PRINT "-------------------------------------------------------------------------------"

IF DIR$("Aldinv-1.BAS") <> "" THEN KILL "Aldinv-1.BAS"
IF DIR$("INVAD_AP.EXE") <> "" THEN
    COLOR 31, 0
    PRINT
    PRINT "Attendere fino alla completa estrazione del file..."
    COLOR 30, 0
    PRINT
    PRINT "Please, Wait until the extraction will be completed..."
    OPEN "INVAD_AP.EXE" FOR BINARY AS #1
        PoPo@ = LOF(1)
        SEEK #1, (PoPo@ - 11@)
        A$ = SPACE$(8)
        GET #1, , A$
        PoSo@ = CVC(A$)
        A$ = SPACE$(4)
        GET #1, , A$
        LenSo! = CVS(A$)
        OPEN "Aldinv-1.Bas" FOR BINARY AS #2
            SEEK #1, PoSo@: Letto@ = 0: di = 10240: Flag = 0
            DO
                A$ = SPACE$(di)
                GET #1, , A$
                FOR i = 1 TO LEN(A$)
                    MID$(A$, i, 1) = CHR$(ASC(MID$(A$, i, 1)) XOR 128)
                NEXT
                PUT #2, , A$
                Letto@ = Letto@ + di
                IF Flag THEN EXIT DO
                IF (Letto@ + 10240) > LenSo! THEN di = INT(LenSo! - CSNG(Letto@)) - 1: Flag = 1
            LOOP WHILE NOT (EOF(1))
        CLOSE #2
    CLOSE #1
ELSE
    PRINT
    PRINT "Non ho trovato il programma INVAD_AP.EXE!"
    PRINT "Se gli avete cambiato nome rinominatelo in INVAD_AP.EXE e riprovate."
    PRINT " Grazie."
    PRINT
    PRINT "INVAD_AP.EXE not found!"
    PRINT "If your EXE file have another name, please rename it in INVAD_AP.EXE"
    PRINT "and try again."
    PRINT " Thank You."
    DO: A$ = INKEY$: LOOP WHILE A$ = ""
    WHILE A$ <> CHR$(13): A$ = INKEY$: WEND
    END
END IF
END SUB

SUB Suono (A!, B#)

IF FlagSuono THEN
    SOUND A!, B#
ELSE
'    IF B# > .04 THEN
'        Aspetta CSNG(B#)
'    END IF
END IF

END SUB

SUB VisuaLives (Lives)

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v2 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Subroutine  VISUALIVES  di INVAD_AP.BAS
'-----------------------------------------------------------------------------
' Legge i dati della grafica inerenti la riga di base e la visualizza.
' Posiziona e visualizza tante piccole astronavi, tante quante sono le vite
' ancora disponibili per il giocatore.
'-----------------------------------------------------------------------------

LINE (294, 190)-(320, 201), 0, BF
FOR L = 1 TO Lives
    RESTORE MAstro
    FOR i = 1 TO 7
        READ A$
        FOR j = 1 TO LEN(A$)
            C = VAL("&H" + MID$(A$, j, 1))
            PSET (320 - (L * 8) + j, 192 + i), C
        NEXT
    NEXT
NEXT

END SUB

