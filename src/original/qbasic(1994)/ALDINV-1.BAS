' =============================[aldinv-1.bas]================================
'  Programma: ALDUS INVASION  - VideoGame in MS/Q-Basic        Versione 1.0
' ===========================================================================
' File Programma/Revisione : ALDINV-1.BAS - Rev.D / 14 Luglio 1994
' Autore                   : Aldo Prinzi
' Linguaggio               : MS/Q-Basic standard (distribuito con MS-DOS)
' Files                    : ALDINV-1.BAS - ALDINV-1.BIN
' Computer / Scheda Grafica: PC-Intel 80286 compatibile / VGA, EGA
' ===========================================================================
' Schermo     : &HE (13 Dec.) - Scheda VGA emulazione MCGA 256 colori
' Compilazione: Non Obbligatoria, funziona anche dall'interprete.
' Mouse       : NON previsto
' Memoria      SORGENTE  = RAM: min 500K - Massa: 43Kb circa
'    "         COMPILATO = RAM: min 256K - Massa: 92Kb circa
' ===========================================================================
' Note: Gli sprites sono  originali, come lo screenplay, ma la storia ä presa
'       dall'originale INVADERS della TAITO apparso in Italia del 1980.
' ===========================================================================
'
'
'   D I S C L A I M E R
'
' ===========================================================================
' Questo  programma  sorgente non contiene alcuna routine  che non  sia stata
' completamente inventata dall'autore stesso.
' E' distribuito  cosç come  ä (AS-IS)  e non  ä imputabile all'autore alcuna
' forma di  risarcimento per il  non funzionamento o per  eventuali errori di
' battitura dovuti alla pubblicazione o per qualsiasi  altro problema dovesse
' causare il suo uso su un qualsiasi computer.
'
' E' espressamente PERMESSA la libera distribuzione  del sorgente o compilato
' come SHAREWARE o FREEWARE o la pubblicazione INTEGRALE su qualsiasi rivista
' di informatica o Bullettin Board System (BBS) per uso DIDATTICO o LUDICO.
'
' E' espressamente VIETATA la distribuzione con qualsiasi titolo di credito o
' con l'indicazione di qualsiasi titolo di CopyRight.
'
' Tutte le copie distribuite, come  sorgente o compilato, devono  riportare i
' seguenti dati dell'autore:
'
'               Aldo Prinzi - Palermo, Via G. La Farina  Nß 11
'                             I t a l i a
'
' e la dicitura: " SHAREWARE GAME Written by ALDO PRINZI. "
'
'
'                                                    l'Autore
'                                                  Aldo Prinzi.
'
'                                       Tel.(091) 6251289-532928-6517582(fax)
' ===========================================================================
'
'   MS-DOS e MS-QBasic sono prodotti della  Microsoft Inc - Redmond (USA).
'   Microsoft ä un marchio registrato dalla Microsoft Inc - Redmond (USA).
'
'   Intel 80286 ä un prodotto della Intel Inc.            - USA
'   Intel ä un marchio registrato dalla Intel Inc.        - USA
'
'   TAITO ä un marchio registrato dalla TAITO Inc.        - Japan
'
' ===========================================================================

DEFINT A-Z

'- - - - - - - - - -
'(@) Dichiarazione delle SUBS e delle FUNCTIONS.
'- - - - - - - - - -

DECLARE SUB aspetta (DecSec!)
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
DECLARE SUB suono (A!, B#)
DECLARE SUB VisuaLives (Lives%)
DECLARE FUNCTION INPNOME$ ()

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
DIM SHARED PosTT#, FlagSuono

'- - - - - - - - - -
'(@) Dichiarazione e impostazione di altre variabili e dei vettori, anche SHARED.
'- - - - - - - - - -
DIM QMM(11)
DIM SHARED EDP, Musi$
DIM LINEA%(1 TO 5, 0 TO 9)
DIM ExVeMfi(1 TO 4), MFire(1 TO 4), OrMfi(1 TO 4), VeMfi(1 TO 4)
PosTT# = 16800: FlagSuono = 1

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
FOR I = 1 TO 4: MFire(I) = 0: NEXT
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
FOR I = 1 TO 17
    READ A$
    FOR j = 1 TO LEN(A$)
        C = VAL("&H" + MID$(A$, j, 1))
        PSET (j - 1, 183 + I), C
    NEXT
NEXT

RESTORE Lives
FOR I = 1 TO 14
    READ A$
    FOR j = 1 TO LEN(A$)
        C = VAL("&H" + MID$(A$, j, 1))
        PSET (215 + j, 185 + I), C
    NEXT
NEXT

FOR I = 0 TO 9
    FOR j = 1 TO 5
        LINEA%(j, I) = 1
        PUT ((I * 25) + 2, j * 15), Mostro!(0, j - 1, 0), PSET
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
                    suono 100, .2
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
        FOR I = 0 TO 9
            FOR j = 1 TO 5
                IF LINEA%(j, I) = 1 THEN
                    PUT ((I * 25) + 2 + MPos, j * 15 + PoVeMo), Mostro!(0, j - 1, B), XOR
                END IF
            NEXT
        NEXT
        LINE (1 + MPos, PoVeMo + VeGoal)-(10 + MPos, PoVeMo + VeGoal), 0
        MPos = MPos + Mdir: B = B + 1: IF B = 2 THEN B = 0
        IF FlagPoVe THEN PoVeMo = PoVeMo + LEVDISC: FlagPoVe = 0
        FOR I = 0 TO 9
            FOR j = 1 TO 5
                IF LINEA%(j, I) = 1 THEN
                    PUT ((I * 25) + 2 + MPos, j * 15 + PoVeMo), Mostro!(0, j - 1, B), XOR
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
        suono 62, .2
    ELSEIF QMM <= 4 THEN
        IF FlagUfo = 1 THEN
            aspetta .03
        ELSE
            aspetta .04
        END IF
    ELSE
        aspetta .004
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
                FOR I = 0 TO 9
                    FOR j = 1 TO 5
                        IF LINEA%(j, I) = 1 THEN
                            Col = 0
                            IF OrFi > (I * 25) + MPos AND OrFi < (I * 25) + 4 + MPos + 18 THEN Col = 1
                            IF Vefi! > j * 15 + PoVeMo - 1 AND Vefi! < (j * 15 + PoVeMo) + 12 THEN Col = Col + 1
                            IF Col = 2 THEN
                                LINEA%(j, I) = 0
                                PUT ((I * 25) + 2 + MPos, j * 15 + PoVeMo), Mostro!(0, j - 1, B), XOR
                                MaMM = MaMM + 1
                                Pts = Pts + 10
                                suono 200, .5
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
                        FOR I = 1 TO 5
                            PUT (PoOrUfo, 15), Ufo!(0, TUfo, Nufo), XOR
                            PUT (PoOrUfo, 15), Ufo!(0, 2, Nufo), XOR
                            FOR j! = 60 TO 1000 STEP 50
                                IF FlagSuono THEN
                                    suono 60, .1
                                    suono j!, .2
                                    suono 200, .1
                                ELSE
                                    AAs = AAs + 1: IF AAs >= 5 THEN aspetta .001: AAs = 0
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
                FOR I = 0 TO 9
                    LL = 0: FOR j = 1 TO 5: LL = LL + LINEA(j, I): NEXT
                    IF LL = 0 THEN LMaxL = LMaxL - 25 ELSE EXIT FOR
                NEXT
                'controlla margine Sinistro
                FOR I = 9 TO 0 STEP -1
                    LL = 0: FOR j = 1 TO 5: LL = LL + LINEA(j, I): NEXT
                    IF LL = 0 THEN LMaxR = LMaxR + 25 ELSE EXIT FOR
                NEXT
                'controlla massima Altezza (invasion point)
                FOR LILI = 5 TO 1 STEP -1
                    LL = 0: FOR I = 0 TO 9: LL = LL + LINEA(LILI, I): NEXT
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
    IF FlagRallenty THEN aspetta .5
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
    OPEN "ALDINV-1.BIN" FOR BINARY AS #1
        B = 0
        FOR I = 1 TO 10
            A$ = SPACE$(22)
            GET #1, PosTT# + B, A$
            Punti! = CVS(LEFT$(A$, 4))
            IF Punti! < Pts THEN TopTen = 1: POTT = I: EXIT FOR
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
    aspetta 1
    ON PLAY(1) GOSUB ContMus
    IF FlagSuono THEN PLAY ON
    StartMus = 1
    Musi$ = "O2L10T48 CA CA "
    IF FlagSuono THEN PLAY "MB X" + VARPTR$(Musi$)
    Joke1
ELSEIF Level = 3 AND A$ <> CHR$(27) THEN
    aspetta 1
    ON PLAY(1) GOSUB ContMus
    IF FlagSuono THEN PLAY ON
    StartMus = 1
    Musi$ = "T150MSL16P1P1P1P1P1P3O2C10P60O4C"
    IF FlagSuono THEN PLAY "MB X" + VARPTR$(Musi$)
    Joke2
ELSEIF Level = 4 AND A$ <> CHR$(27) THEN
    aspetta 1
    ON PLAY(1) GOSUB ContMus
    IF FlagSuono THEN PLAY ON
    StartMus = 1
    Musi$ = "T145MSL8O2P20CACBCACBP25CP10"
    IF FlagSuono THEN PLAY "MB X" + VARPTR$(Musi$)
    Joke3
ELSEIF Level = 5 AND A$ <> CHR$(27) THEN
    aspetta 1
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
        suono 1500, .1
    ELSE
        suono 500, .2
        suono 200, .1
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

'----------------------------------------------------------------------------
' Dati degli sprites usati nel gioco.
'----------------------------------------------------------------------------
' Possono essere facilmente modificatiu senza che comunque siano cambiati
' nä l'altezza nä la larghezza. Diversamente bisogna modificare la routine
' DisegnaPezzi, dopo avere cancellato il file AldInv-1.Bin se esiste.
'----------------------------------------------------------------------------

'- - - - - - - - - -
'(@) - Dati dello sprite dell'astronave del Giocatore (integra, volante, esplosione).
'- - - - - - - - - -

' parte dati
Razzo:
DATA "        4          "
DATA "        4          "
DATA "        4          "
DATA "       414         "
DATA "       414         "
DATA "      41314        "
DATA "     4137314       "
DATA "    413337314      "
DATA "    413337314      "
DATA "    411333114      "
DATA "    411111114      "
DATA "    441111144      "
DATA "    244424442      "
DATA "    211121112      "
DATA "   22111211122     "
DATA "   22111211122     "
DATA "   22111211122     "
DATA "  2225552555222    "
DATA "  2222  2  2222    "
DATA "  222   2   222    "
DATA " 222    2    222   "
DATA " 22     2     22   "
DATA " 2      2      2   "
razzoFire1:
DATA "        4          "
DATA "        4          "
DATA "        4          "
DATA "       414         "
DATA "       414         "
DATA "      41314        "
DATA "     4137314       "
DATA "    413337314      "
DATA "    413337314      "
DATA "    411333114      "
DATA "    411111114      "
DATA "    441111144      "
DATA "    244424442      "
DATA "    211121112      "
DATA "   22111211122     "
DATA "   22111211122     "
DATA "   22111211122     "
DATA "  2225552555222    "
DATA "  2222FF2FE2222    "
DATA "  222EEF2FE6222    "
DATA " 2226EEE26EE6222   "
DATA " 2226EEE26EE6222   "
DATA " 2   6DE2E6E   2   "
DATA "    6 D6ED6        "
DATA "       66E 6       "
DATA "        6 E        "
razzoFire2:
DATA "        4          "
DATA "        4          "
DATA "        4          "
DATA "       414         "
DATA "       414         "
DATA "      41314        "
DATA "     4137314       "
DATA "    413337314      "
DATA "    413337314      "
DATA "    411333114      "
DATA "    411111114      "
DATA "    441111144      "
DATA "    244424442      "
DATA "    211121112      "
DATA "   22111211122     "
DATA "   22111211122     "
DATA "   22111211122     "
DATA "  2225552555222    "
DATA "  2222EF2FF2222    "
DATA "  222EEF2FE6222    "
DATA " 22266EE26EE6222   "
DATA " 22 E6EE2EE66 22   "
DATA " 2  E6DF2E66   2   "
DATA "     DDFED6        "
DATA "    E E66          "
DATA "      E            "
Explosion0:
DATA "                   "
DATA "    E              "
DATA "        B          "
DATA "       4F4   E     "
DATA "       414         "
DATA "   E  413B4        "
DATA " 4  EE137EB4E E    "
DATA "  4 4E3E3DEB4E     "
DATA "  4 4BE3EDDEE 4  4 "
DATA "  E EEEEEEE14  E   "
DATA "   E4BFEEEEE4 44   "
DATA "   E44BEEEE444 E   "
DATA "   4F44EEE442   E  "
DATA "  E421EEE1E124     "
DATA "  422EB14FE122 E   "
DATA " E42EEE12444EEE    "
DATA "4 E2FF1BB11E22     "
DATA "  2E25DDDE544EE    "
DATA " 422E2  2EE4442 4  "
DATA "  2D2   2   4444   "
DATA " 244E E EE   222   "
DATA " D44    4    444   "
DATA " 2      2      2   "
Explosion1:
DATA "                   "
DATA "    E       4      "
DATA "         4         "
DATA "  E    4     E     "
DATA "      441E 4  6    "
DATA "4    441DB44 6     "
DATA "    EE1EEEE4E E    "
DATA "   44EDEDDEB4E 4  4"
DATA " 4 44BEEEDDEE66 E  "
DATA "    EEEDDDE14E     "
DATA " E E4BFEDEEEEE44   "
DATA "  4E4FFEDDE444     "
DATA "  44FFFDDED466 E   "
DATA "  E441EDEDE1446  4 "
DATA "  4EEEE1EFE1EE     "
DATA " E42EEE16444EEE  4 "
DATA "  EEFF1BB11E66     "
DATA "  4E25DDDE544EE    "
DATA " 422E4 44EE4442 4  "
DATA "  4D4  444  4444   "
DATA " E44E E EE   444   "
DATA " D44 E  44   444   "
DATA " 4      4      4   "
Explosion2:
DATA "                   "
DATA "                   "
DATA "  E        6       "
DATA "             E     "
DATA "     6F    4  6    "
DATA "       6E    6     "
DATA "    EE1E6666E E    "
DATA "   46E8ED8884E     "
DATA "   46BEE8D8EE66 8  "
DATA "    EFFD88E14E   4 "
DATA "   E4B68 88EEE44   "
DATA "  444F688DE444     "
DATA "  64666DF8DE66     "
DATA "  E44 DDEDE1E46    "
DATA "  6EFF61E8DE4E   48"
DATA " E62E6616E D6EE    "
DATA "  EEFF1B 11D86    8"
DATA "  6E25DDDE5448E    "
DATA " 622E4F 44E4442    "
DATA "  4D444444446844 8 "
DATA " E66E E EE64 884   "
DATA " D44 E 6 4 6 464   "
DATA " 4  6   4 6  444   "
Explosion3:
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "     6             "
DATA "                   "
DATA "    E  D           "
DATA "   4     88        "
DATA "       E8D8EE 6 8  "
DATA "     4FD88E14    4 "
DATA "    4B68888EEE     "
DATA "    4F688DE44      "
DATA "    666  8DE66     "
DATA "   44D88E8E1E      "
DATA "   E448888DE4E     "
DATA "    E6688 DD6E     "
DATA "    448B 86D86     "
DATA "  6E65486E86488    "
DATA "   2E46464848828   "
DATA "  4D446664646888   "
DATA " E86E8886 846888   "
DATA " D4888668486888888 "
DATA "888868668868844488 "
Explosion4:
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                4  "
DATA "                   "
DATA "      88 8 1     8 "
DATA "      8888D 4      "
DATA "     66888DD6E     "
DATA "    448 886D8688   "
DATA "  6E6868648 68888  "
DATA "  8864646 84 8688  "
DATA "  86446 668686888  "
DATA " 886E 686E8 6 6868 "
DATA "88488868 6868 8888 "
DATA "88686866886 8 66888"
Explosion5:
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "                   "
DATA "  6E6    48  8 88  "
DATA "  8 6    88  8 88  "
DATA " 8884 6  68 8 888  "
DATA "88867 8  8 6 68 888"
DATA "8888888 868 88 8888"
DATA "8868686888688866888"

'- - - - - - - - - -
'(@) - Dati degli sprite dei nemici (i mostri semoventi)
'- - - - - - - - - -

MOSTRO01:
DATA "  55  22222  55  "
DATA "    522222225    "
DATA "  2222228222222  "
DATA "  2227072227072  "
DATA "  2222228222222  "
DATA "  2232328232322  "
DATA "    333363333    "
DATA "     3336 333    "
DATA "   333  6  333   "
DATA " 333      333    "
MOSTRO02:
DATA " 5   222 222   5 "
DATA "  5552222222555  "
DATA "  2222228222222  "
DATA "  2707222707222  "
DATA "  2222228222222  "
DATA "   23238383232   "
DATA "    333343333    "
DATA "    333 4333     "
DATA "   333     333   "
DATA "    333      333 "
MOSTRO11:
DATA "        666      "
DATA "      6633366    "
DATA "  55663E333E36655"
DATA "  55663E333E36655"
DATA "     663333366   "
DATA "     663333366   "
DATA "      3631363    "
DATA "    66  66  66   "
DATA "   66  66  66    "
DATA "  66  66  66     "
MOSTRO12:
DATA "      666        "
DATA "    6633366      "
DATA "55663E333E36655  "
DATA "55663E333E36655  "
DATA "   663333366     "
DATA "   663333366     "
DATA "    3631363      "
DATA "   66  66  66    "
DATA "    66  66  66   "
DATA "     66  66  66  "

MOSTRO21:
DATA "  66         66  "
DATA "    6 35553 6    "
DATA "    355555553    "
DATA "  3577555577553  "
DATA " 355555555555553 "
DATA " 355555333555553 "
DATA "  3555555555553  "
DATA "    5   5   5    "
DATA "   5    5    5   "
DATA "    55     55    "
MOSTRO22:
DATA "        6        "
DATA "   66 35553 66   "
DATA "  6 355555553 6  "
DATA "  3557755557753  "
DATA " 355555535555553 "
DATA " 355555333555553 "
DATA "  3555553555553  "
DATA "   55   5   55   "
DATA "  5     5     5  "
DATA " 55    5 5    55 "
MOSTRO31:
DATA "       555 555   "
DATA " 77   57775      "
DATA "  7 177777771    "
DATA "  777E477E47777  "
DATA "    177777771 7  "
DATA "    177444771 77 "
DATA "      77777      "
DATA "     77   77     "
DATA "    77     77    "
DATA " 7777     7777   "
MOSTRO32:
DATA "   555 555       "
DATA "      57775   77 "
DATA "    377777773 7  "
DATA "  77774E774E777  "
DATA "  7 377777773    "
DATA " 77 377747773    "
DATA "      77777      "
DATA "     77   77     "
DATA "    77     77    "
DATA "   7777     7777 "
MOSTRO41:
DATA " 64           46 "
DATA "   44411111444   "
DATA "    111111111    "
DATA "   17331733111   "
DATA "   11111111111   "
DATA "  1111111111111  "
DATA "  11111EEE11111  "
DATA "   11111111111   "
DATA "   11     11     "
DATA "   1111   1111   "
MOSTRO42:
DATA "                 "
DATA "     4111114     "
DATA "   44111111144   "
DATA "  6 113371337 6  "
DATA "  1111111111111  "
DATA " 111111111111111 "
DATA " 111111E1E111111 "
DATA "  111111E111111  "
DATA "    11     11    "
DATA "   1111   1111   "

'- - - - - - - - - -
'(@) - Dati degli sprite degli ufo.
'- - - - - - - - - -

UFO01:
DATA "           6666           "
DATA "          600006          "
DATA "      6E66666666666E6     "
DATA "  6666633666666666336666  "
DATA " 644443333444444433334446 "
DATA "  6666633666666666336666  "
DATA "   66666666466466666666   "
DATA "          468864          "
UFO02:
DATA "           6666           "
DATA "          6BBBB6          "
DATA "      686666666666686     "
DATA "  6666633666666666336666  "
DATA " 644443333444444433334446 "
DATA "  6666633666666666336666  "
DATA "   66666666466466666666   "
DATA "         46611664         "
Ufo0Bum:
DATA "     FFFF  4444           "
DATA "    FF  FF44FFFF          "
DATA "      4FF44FF44FF44FFFF   "
DATA "  4444FF444FF44FF4FF44FF  "
DATA " 4444FF4444FF44FF4FF44FF4 "
DATA "  44FFFFFF4FF44FF4FF44FF  "
DATA "   444444444FFFF44FF44FF  "
DATA "         44444444  FFFF   "
UFO11:
DATA "            88            "
DATA "        2222222222        "
DATA "      22000222000222      "
DATA "22222222000222000222222222"
DATA "   64447774447774447776   "
DATA "222EE2222222222222222EE222"
DATA "          222222          "
DATA "      22222    22222      "
UFO12:
DATA "            EE            "
DATA "        2222222222        "
DATA "      22000222000222      "
DATA "22222222000222000222222222"
DATA "   67774447774447774446   "
DATA "22288222222222222222288222"
DATA "          222222          "
DATA "      22222    22222      "
Ufo1Bum:
DATA "            88            "
DATA "        888888888EEEE     "
DATA "      888EEEEEE8EE88EE    "
DATA "888EEEE88EE88888EE88EE8888"
DATA "  EE88EE88EEEE88EE88EE8   "
DATA "88888EE888888EE88EEEE88888"
DATA "  EE  EE EEEEE88          "
DATA "   EEEE8888    88888      "

'- - - - - - - - - -
'(@) - Dati dello sprite dell'omino che corre durante la presentazione
'- - - - - - - - - -

PLAYER1:
DATA "    633     "
DATA "    6663    "
DATA "     6      "
DATA "    676     "
DATA "    667     "
DATA "   76667    "
DATA "    66      "
DATA "    66      "
DATA "    6 66    "
DATA "   66  6    "
PLAYER2:
DATA "    6333    "
DATA "    6663    "
DATA "     6      "
DATA "    676     "
DATA "    6677    "
DATA "    666     "
DATA "    66      "
DATA "    666     "
DATA " 6 6   66   "
DATA "  6         "
PLAYER3:
DATA "    633     "
DATA "    6663    "
DATA "     6      "
DATA "    676     "
DATA "    667     "
DATA "    6767    "
DATA "    66      "
DATA "    66      "
DATA "     66     "
DATA "    666     "
PLAYER4:
DATA "           E44 44 "
DATA "          E4f4f4  "
DATA "          E4fff4  "
DATA "     22  E4f4f44  "
DATA "    DD22 E4ff44   "
DATA "     D  E4f444    "
DATA "    2727E74       "
DATA "    2277          "
DATA "   7222           "
DATA "    55            "
DATA "    55            "
DATA "    5 55          "
DATA "   55  5          "
PLAYER5:
DATA "           E44444 "
DATA "           E4fff4 "
DATA "          E4f4f44 "
DATA "    d222  E4fff44 "
DATA "    dd22 E4f4444  "
DATA "     D   E44444   "
DATA "    272 7E7       "
DATA "    2277          "
DATA "    222           "
DATA "    55            "
DATA "    555           "
DATA " 5 5   55         "
DATA "  5               "
PLAYER6:
DATA "          E44444  "
DATA "          E4fff4  "
DATA "          E4f4f44 "
DATA "    d22  E4fff44  "
DATA "    dd22 E4f4444  "
DATA "     D   E44444   "
DATA "    2727E7        "
DATA "    227           "
DATA "    2227          "
DATA "    55            "
DATA "    55            "
DATA "     55           "
DATA "    555           "

'- - - - - - - - - -
'(@) - Dati degli sprite dei colpi sparati sia dal player che dai nemici.
'- - - - - - - - - -

PSparo:
DATA " D "
DATA "D4D"
DATA " 4 "
DATA " 4 "
DATA " 4 "
DATA " 4 "
DATA "333"
DATA "3E3"
MSparo:
DATA "5E5"
DATA "555"
DATA " 5 "
DATA " 5 "
DATA " F "

'- - - - - - - - - -
'(@) - Sprite dell'astronave in piccolo (visualizzazione grafica delle vite).
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
'(@) - Sprite usati nell'intermezzo
'- - - - - - - - - -

PAC1:
DATA "         EEEE          "
DATA "      EEEEEEEEEE       "
DATA "    EEEEEEEEEEEEEE     "
DATA "   EEEEEEEEEEEEEEEE    "
DATA "   EEEEEEEEEEEEEEEE    "
DATA "  EEEEEEEEEEEEEEEEEE   "
DATA "           EEEEEEEEE   "
DATA "  EEEEEEEEEEEEEEEEEE   "
DATA "   EEEEEEEEEEEEEEEE    "
DATA "   EEEEEEEEEEEEEEEE    "
DATA "    EEEEEEEEEEEEEE     "
DATA "      EEEEEEEEEE       "
DATA "         EEEE          "
PAC2:
DATA "         EEEE          "
DATA "      EEEEEEEEEE       "
DATA "    EEEEEEEEEEEEEE     "
DATA "   EEEEEEEEEEEEEEEE    "
DATA "     EEEEEEEEEEEEEE    "
DATA "         EEEEEEEEEEE   "
DATA "           EEEEEEEEE   "
DATA "         EEEEEEEEEEE   "
DATA "     EEEEEEEEEEEEEE    "
DATA "   EEEEEEEEEEEEEEEE    "
DATA "    EEEEEEEEEEEEEE     "
DATA "      EEEEEEEEEE       "
DATA "         EEEE          "
Pac3:
DATA "         EEEE          "
DATA "      EEEEEEEEEE       "
DATA "    EEEEEEEEEEEEEE     "
DATA "     EEEEEEEEEEEEEE    "
DATA "       EEEEEEEEEEEE    "
DATA "         EEEEEEEEEEE   "
DATA "           EEEEEEEEE   "
DATA "         EEEEEEEEEEE   "
DATA "       EEEEEEEEEEEE    "
DATA "     EEEEEEEEEEEEEE    "
DATA "    EEEEEEEEEEEEEE     "
DATA "      EEEEEEEEEE       "
DATA "         EEEE          "
PAC4:
DATA "      77777      "
DATA "    777777777    "
DATA "  7777777777777  "
DATA " 777 7777777 777 "
DATA " 77   77777   77 "
DATA " 777 7777777 777 "
DATA " 777777777777777 "
DATA " 7777 7 7 7 7777 "
DATA " 777 7 7 7 7 777 "
DATA " 777777777777777 "
DATA "  7777 7777 7777 "
DATA "   77   77   77  "
PAC5:
DATA "      77777      "
DATA "    777777777    "
DATA "  7777777777777  "
DATA " 777 7777777 777 "
DATA " 77   77777   77 "
DATA " 777 7777777 777 "
DATA " 777777777777777 "
DATA " 7777 7 7 7 7777 "
DATA " 777 7 7 7 7 777 "
DATA " 777777777777777 "
DATA " 777 7777 7777   "
DATA " 77   77   77    "
PAC6:
DATA "      44444      "
DATA "    444444444    "
DATA "  4444444444444  "
DATA " 44fff44444fff44 "
DATA " 44ff044444ff044 "
DATA " 44fff44444fff44 "
DATA " 444444444444444 "
DATA " 444444444444444 "
DATA " 444444444444444 "
DATA " 444444444444444 "
DATA " 444 4444 4444   "
DATA " 44   44   44    "
Pac7:
DATA "      44444      "
DATA "    444444444    "
DATA "  4444444444444  "
DATA " 44fff44444fff44 "
DATA " 44ff044444ff044 "
DATA " 44fff44444fff44 "
DATA " 444444444444444 "
DATA " 444444444444444 "
DATA " 444444444444444 "
DATA " 444444444444444 "
DATA "  4444 4444 4444 "
DATA "   44   44   44  "

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

'- - - - - - - - - -
'(@) - Gestione dell'errore. Viene usato da DisegnaPezzi per controllare
'      l'esistenza del file AldInv-1.BIN.
'- - - - - - - - - -

GestERR:
EDP = ERR: RESUME NEXT

SUB aspetta (DecSec!)

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Subroutine    ASPETTA   di ALDINV-1.BAS
'-----------------------------------------------------------------------------
' Routine di attesa. Aspetta che siano passati DecSec! centesimi di secondo
' prima di ritonare il controllo al chiamante.
'-----------------------------------------------------------------------------

W# = TIMER + DecSec!
IF W# < TIMER THEN EXIT SUB: ' Correzione per la MezzaNotte!
WHILE W# > TIMER: WEND

END SUB

SUB DisegnaPezzi

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                 Subroutine    DISEGNAPEZZI di ALDINV-1.BAS
'-----------------------------------------------------------------------------
' Routine per la lettura dei dati degli sprites (da DATA o dal File) per
' il successivo utilizzo con il comando PUT grafico.
'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
' Se il file esiste i dati sono automaticamente acquisiti da esso, altrimenti
' ne viene creato uno adesso, dopo aver disegnato gli sprites a video.
'-----------------------------------------------------------------------------

ON ERROR GOTO GestERR
EDP = 0
OPEN "I", #1, "ALDINV-1.BIN"
CLOSE #1
ON ERROR GOTO 0

IF EDP THEN
    SCREEN 13, 0, 0
    '--------------------------------------------------------
    ' DISEGNO E IMPORT DEGLI SPRITES
    '--------------------------------------------------------
    ' Legge i dati dei disegni degli sprites
    ' e visualizza il pezzo.
    '--------------------------------------------------------
    RESTORE Razzo: NL = 23: X = 0: Y = 0: GOSUB DisePz
    RESTORE razzoFire1: NL = 26: X = 20: Y = 0: GOSUB DisePz
    RESTORE razzoFire2: NL = 26: X = 40: Y = 0: GOSUB DisePz
    RESTORE Explosion0: NL = 23: X = 60: Y = 0: GOSUB DisePz
    RESTORE Explosion1: NL = 23: X = 80: Y = 0: GOSUB DisePz
    RESTORE Explosion2: NL = 23: X = 100: Y = 0: GOSUB DisePz
    RESTORE Explosion3: NL = 23: X = 120: Y = 0: GOSUB DisePz
    RESTORE Explosion4: NL = 23: X = 140: Y = 0: GOSUB DisePz
    RESTORE Explosion5: NL = 23: X = 160: Y = 0: GOSUB DisePz
    RESTORE MOSTRO01: NL = 10: X = 0: Y = 50: GOSUB DisePz
    RESTORE MOSTRO02: NL = 10: X = 20: Y = 50: GOSUB DisePz
    RESTORE MOSTRO11: NL = 10: X = 40: Y = 50: GOSUB DisePz
    RESTORE MOSTRO12: NL = 10: X = 60: Y = 50: GOSUB DisePz
    RESTORE MOSTRO21: NL = 10: X = 80: Y = 50: GOSUB DisePz
    RESTORE MOSTRO22: NL = 10: X = 100: Y = 50: GOSUB DisePz
    RESTORE MOSTRO31: NL = 10: X = 120: Y = 50: GOSUB DisePz
    RESTORE MOSTRO32: NL = 10: X = 140: Y = 50: GOSUB DisePz
    RESTORE MOSTRO41: NL = 10: X = 160: Y = 50: GOSUB DisePz
    RESTORE MOSTRO42: NL = 10: X = 180: Y = 50: GOSUB DisePz
    RESTORE PLAYER1: NL = 10: X = 0: Y = 100: GOSUB DisePz
    RESTORE PLAYER2: NL = 10: X = 10: Y = 100: GOSUB DisePz
    RESTORE PLAYER3: NL = 10: X = 20: Y = 100: GOSUB DisePz
    RESTORE PLAYER4: NL = 13: X = 40: Y = 100: GOSUB DisePz
    RESTORE PLAYER5: NL = 13: X = 60: Y = 100: GOSUB DisePz
    RESTORE PLAYER6: NL = 13: X = 80: Y = 100: GOSUB DisePz
    RESTORE PSparo: NL = 8: X = 30: Y = 100: GOSUB DisePz
    RESTORE MSparo: NL = 5: X = 35: Y = 100: GOSUB DisePz
    RESTORE UFO01: NL = 8: X = 0: Y = 120: GOSUB DisePz
    RESTORE UFO02: NL = 8: X = 40: Y = 120: GOSUB DisePz
    RESTORE Ufo0Bum: NL = 8: X = 80: Y = 120: GOSUB DisePz
    RESTORE UFO11: NL = 8: X = 120: Y = 120: GOSUB DisePz
    RESTORE UFO12: NL = 8: X = 160: Y = 120: GOSUB DisePz
    RESTORE Ufo1Bum: NL = 8: X = 200: Y = 120: GOSUB DisePz
    RESTORE PAC1: NL = 13: X = 0: Y = 150: GOSUB DisePz
    RESTORE PAC2: NL = 13: X = 35: Y = 150: GOSUB DisePz
    RESTORE Pac3: NL = 13: X = 70: Y = 150: GOSUB DisePz
    RESTORE PAC4: NL = 12: X = 105: Y = 151: GOSUB DisePz
    RESTORE PAC5: NL = 12: X = 140: Y = 151: GOSUB DisePz
    RESTORE PAC6: NL = 12: X = 175: Y = 151: GOSUB DisePz
    RESTORE Pac7: NL = 12: X = 210: Y = 151: GOSUB DisePz
    '--------------------------------------------------------
    ' DISEGNO E IMPORT DEGLI SPRITES
    '--------------------------------------------------------
    ' Importa i disegni visulaizzati negli appositi
    ' vettori per la successiva visualizzazione
    '--------------------------------------------------------
    GET (1, 1)-(17, 24), Razzo!(0, 0)
    GET (21, 1)-(37, 26), Razzo!(0, 1)
    GET (41, 1)-(57, 26), Razzo!(0, 2)
    GET (61, 1)-(77, 23), RazzoBum!(0, 0)
    GET (81, 1)-(97, 23), RazzoBum!(0, 1)
    GET (101, 1)-(117, 23), RazzoBum!(0, 2)
    GET (121, 1)-(137, 23), RazzoBum!(0, 3)
    GET (141, 1)-(157, 23), RazzoBum!(0, 4)
    GET (161, 1)-(177, 23), RazzoBum!(0, 5)
    GET (1, 50)-(16, 60), Mostro!(0, 0, 0)
    GET (21, 50)-(36, 60), Mostro!(0, 0, 1)
    GET (41, 50)-(56, 60), Mostro!(0, 1, 0)
    GET (61, 50)-(76, 60), Mostro!(0, 1, 1)
    GET (81, 50)-(96, 60), Mostro!(0, 2, 0)
    GET (101, 50)-(116, 60), Mostro!(0, 2, 1)
    GET (121, 50)-(136, 60), Mostro!(0, 3, 0)
    GET (141, 50)-(156, 60), Mostro!(0, 3, 1)
    GET (161, 50)-(176, 60), Mostro!(0, 4, 0)
    GET (181, 50)-(196, 60), Mostro!(0, 4, 1)
    GET (1, 100)-(9, 110), Player!(0, 0)
    GET (11, 100)-(19, 110), Player!(0, 1)
    GET (21, 100)-(29, 110), Player!(0, 2)
    GET (31, 100)-(33, 108), Sparo!(0)
    GET (36, 100)-(38, 105), MSparo!(0)
    GET (41, 100)-(59, 114), Player!(0, 3)
    GET (61, 100)-(79, 114), Player!(0, 4)
    GET (81, 100)-(99, 114), Player!(0, 5)
    GET (1, 120)-(28, 128), Ufo!(0, 0, 0)
    GET (41, 120)-(68, 128), Ufo!(0, 1, 0)
    GET (81, 120)-(108, 128), Ufo!(0, 2, 0)
    GET (121, 120)-(148, 128), Ufo!(0, 0, 1)
    GET (161, 120)-(188, 128), Ufo!(0, 1, 1)
    GET (201, 120)-(228, 128), Ufo!(0, 2, 1)
    GET (2, 150)-(21, 163), pac!(0, 0)
    GET (36, 150)-(56, 163), pac!(0, 1)
    GET (71, 150)-(91, 163), pac!(0, 2)
    GET (106, 151)-(122, 163), pac!(0, 3)
    GET (141, 151)-(156, 163), pac!(0, 4)
    GET (176, 151)-(191, 163), pac!(0, 5)
    GET (211, 151)-(226, 163), pac!(0, 6)
    FOR k = 1 TO 3
        IF k = 1 THEN RESTORE PAC1: NL = 13: X = 0: Y = 150
        IF k = 2 THEN RESTORE PAC2: NL = 13: X = 35: Y = 150
        IF k = 3 THEN RESTORE Pac3: NL = 13: X = 70: Y = 150
        FOR I = 1 TO NL
            READ A$
            FOR j = 1 TO LEN(A$)
                C = VAL("&H" + MID$(A$, j, 1))
                PSET (X + LEN(A$) - j, Y + I), C
            NEXT
        NEXT
    NEXT
    GET (2, 150)-(21, 163), pac!(0, 7)
    GET (36, 150)-(56, 163), pac!(0, 8)
    GET (71, 150)-(91, 163), pac!(0, 9)
    '--------------------------------------------------------
    ' DISEGNO E IMPORT DEGLI SPRITES
    '--------------------------------------------------------
    ' Salva i dati acquisiti nel file "ALDINV-1.BIN" per
    ' poi poterli leggere alla successiva utilizzazione
    '--------------------------------------------------------
    OPEN "ALDINV-1.BIN" FOR BINARY AS #1
        FOR I = 0 TO 100
            A$ = MKS$(Razzo!(I, 0)): PUT #1, , A$
            A$ = MKS$(Razzo!(I, 1)): PUT #1, , A$
            A$ = MKS$(Razzo!(I, 2)): PUT #1, , A$
            FOR j = 0 TO 5
                A$ = MKS$(RazzoBum!(I, j)): PUT #1, , A$
            NEXT
        NEXT
        FOR I = 101 TO 120
            A$ = MKS$(Razzo!(I, 0)): PUT #1, , A$
            A$ = MKS$(Razzo!(I, 1)): PUT #1, , A$
            A$ = MKS$(Razzo!(I, 2)): PUT #1, , A$
        NEXT
        FOR I = 0 TO 90
            FOR j = 0 TO 1
                A$ = MKS$(Ufo!(I, 0, j)): PUT #1, , A$
                A$ = MKS$(Ufo!(I, 1, j)): PUT #1, , A$
                A$ = MKS$(Ufo!(I, 2, j)): PUT #1, , A$
                FOR k = 0 TO 5
                    A$ = MKS$(Mostro!(I, k, j)): PUT #1, , A$
                NEXT
            NEXT
        NEXT
        FOR I = 0 TO 80
            FOR j = 0 TO 5
                A$ = MKS$(Player!(I, j)): PUT #1, , A$
            NEXT
        NEXT
        FOR I = 0 TO 15
            A$ = MKS$(Sparo!(I)): PUT #1, , A$
            A$ = MKS$(MSparo!(I)): PUT #1, , A$
        NEXT
        FOR I = 16 TO 20
            A$ = MKS$(Sparo!(I)): PUT #1, , A$
        NEXT
        FOR I = 0 TO 80
            FOR j = 0 TO 9
                A$ = MKS$(pac!(I, j)): PUT #1, , A$
            NEXT
        NEXT
        '--------------------------------
        ' ZONA DATI HIGH SCORES (top ten)
        '--------------------------------
        A$ = MKS$(1000) + "Aldus Prinzimaker!": B = 0
        FOR I = 1 TO 10
            PUT #1, PosTT# + B, A$
            B = B + 22
        NEXT
    CLOSE 1
ELSE
    SCREEN 13, 0, 0
    '---------------------------------------------------------
    ' LETTURA DA FILE E IMPORT DEGLI SPRITES
    '---------------------------------------------------------
    ' Legge i dati scritti nel file "ALDINV-1.BIN" evitando
    ' di ridisegnare e GETare nuovamente tutti gli sprites.
    ' Automaticamente legge e inserisce i dati negli appositi
    ' vettori per la visualizzazione.
    '---------------------------------------------------------
    OPEN "ALDINV-1.BIN" FOR BINARY AS #1
        FOR I = 0 TO 100
            A$ = SPACE$(4): GET #1, , A$: Razzo!(I, 0) = CVS(A$)
            A$ = SPACE$(4): GET #1, , A$: Razzo!(I, 1) = CVS(A$)
            A$ = SPACE$(4): GET #1, , A$: Razzo!(I, 2) = CVS(A$)
            FOR j = 0 TO 5
                A$ = SPACE$(4): GET #1, , A$: RazzoBum!(I, j) = CVS(A$)
            NEXT
        NEXT
        FOR I = 101 TO 120
            A$ = SPACE$(4): GET #1, , A$: Razzo!(I, 0) = CVS(A$)
            A$ = SPACE$(4): GET #1, , A$: Razzo!(I, 1) = CVS(A$)
            A$ = SPACE$(4): GET #1, , A$: Razzo!(I, 2) = CVS(A$)
        NEXT
        FOR I = 0 TO 90
            FOR j = 0 TO 1
                A$ = SPACE$(4): GET #1, , A$: Ufo!(I, 0, j) = CVS(A$)
                A$ = SPACE$(4): GET #1, , A$: Ufo!(I, 1, j) = CVS(A$)
                A$ = SPACE$(4): GET #1, , A$: Ufo!(I, 2, j) = CVS(A$)
                FOR k = 0 TO 5
                    A$ = SPACE$(4): GET #1, , A$: Mostro!(I, k, j) = CVS(A$)
                NEXT
            NEXT
        NEXT
        FOR I = 0 TO 80
            FOR j = 0 TO 5
                A$ = SPACE$(4): GET #1, , A$: Player!(I, j) = CVS(A$)
            NEXT
        NEXT
        FOR I = 0 TO 15
            A$ = SPACE$(4): GET #1, , A$: Sparo!(I) = CVS(A$)
            A$ = SPACE$(4): GET #1, , A$: MSparo!(I) = CVS(A$)
        NEXT
        FOR I = 16 TO 20
            A$ = SPACE$(4): GET #1, , A$: Sparo!(I) = CVS(A$)
        NEXT
        FOR I = 0 TO 80
            FOR j = 0 TO 9
                A$ = SPACE$(4): GET #1, , A$: pac!(I, j) = CVS(A$)
            NEXT
        NEXT
    CLOSE 1
END IF

EXIT SUB

DisePz:
    FOR I = 1 TO NL
        READ A$
        FOR j = 1 TO LEN(A$)
            C = VAL("&H" + MID$(A$, j, 1))
            PSET (X + j, Y + I), C
        NEXT
    NEXT
RETURN

END SUB

SUB GetTopTen (TTP$())

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Subroutine  GETTOPTEN   di ALDINV-1.BAS
'-----------------------------------------------------------------------------
' Legge la Top Ten da Disco.
'-----------------------------------------------------------------------------

REDIM TTP$(10)

OPEN "ALDINV-1.BIN" FOR BINARY AS #1
    B = 0
    FOR I = 1 TO 10
        A$ = SPACE$(22)
        GET #1, PosTT# + B, A$
        TTP$(I) = RIGHT$(A$, 18) + " ^ " + STR$(CVS(LEFT$(A$, 4)))
        B = B + 22
    NEXT
CLOSE 1

END SUB

FUNCTION INPNOME$


'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Funzione    INPNOME$    di ALDINV-1.BAS
'-----------------------------------------------------------------------------
' Routine di acquisizione del nome del vincitore se entra nella Top Ten.
'-----------------------------------------------------------------------------

COLOR 15
LOCATE 6, 6: PRINT "Please, ENTER your Name"
B$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.,-+/*?!()[] ÖäÇçïó'" + CHR$(8)
VER = 8: ORI = 8: NC = 0: C$ = ""
DO
    COLOR 14: LOCATE VER, ORI, 1: PRINT C$;
    A$ = "": WHILE A$ = "": A$ = INKEY$: WEND
    IF A$ = CHR$(13) THEN EXIT DO
    IF INSTR(B$, A$) THEN
        IF A$ = CHR$(8) THEN
            IF NC > 0 THEN
                COLOR 0: LOCATE VER, ORI, 1: PRINT "€€€€€€€€€€€€€€€€€€";
                C$ = LEFT$(C$, LEN(C$) - 1)
                NC = NC - 1
            ELSE
                suono 3000, .5
            END IF
            A$ = ""
        END IF
        IF A$ <> "" AND NC < 18 THEN
            C$ = C$ + A$: NC = NC + 1
        ELSEIF A$ <> "" THEN
            suono 3000, .5
        END IF
    ELSE
        suono 3000, .5
    END IF
LOOP
INPNOME$ = LEFT$(C$ + SPACE$(18), 18)

END FUNCTION

SUB InsertTopTen (Pts)

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Subroutine INSERTTOPTEN di ALDINV-1.BAS
'-----------------------------------------------------------------------------
' Inserisce un numinativo nella Top Ten. Scarica poi il tutto sul file.
'-----------------------------------------------------------------------------

REDIM TTP$(10)

LINE (0, 10)-(320, 155), 0, BF
A$ = "": XX! = 55: BB! = 1: XX = 55
DO
    suono (8000 / (BB! / 2)), .09
    BB! = BB! + .5
    COLOR XX: LOCATE 4, 11: PRINT "You are QUALIFIED!"
    IF XX! >= 90 THEN XX! = 55
    suono BB! * 100, .09
    XX! = XX! + .25
    XX = INT(XX!)
    A$ = INKEY$: IF A$ <> "" THEN EXIT DO
    suono ((XX! * (BB! / XX!)) * 100), .09
LOOP WHILE BB! < 100
DO
    suono 600, .5
    N$ = INPNOME$
LOOP WHILE LEN(LTRIM$(RTRIM$(N$))) = 0
GetTopTen TTP$()
FOR I = 1 TO 10
    PP = INSTR(TTP$(I), "^")
    Pdg = VAL(MID$(TTP$(I), PP + 1, LEN(TTP$(I)) - PP))
    IF Pts > Pdg THEN EXIT FOR
NEXT

OPEN "ALDINV-1.BIN" FOR BINARY AS #1
    FOR k = 9 TO I STEP -1
        A$ = SPACE$(22): B = ((k - 1) * 22) + 1
        GET #1, PosTT# + B, A$
        PUT #1, PosTT# + B + 22, A$
    NEXT
    C$ = MKS$(Pts) + N$
    B = ((I - 1) * 22)
    PUT #1, PosTT# + B, C$
CLOSE 1

END SUB

SUB Joke1


'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine   JOKE1    di ALDINV-1.BAS
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
                aspetta .2
            NEXT
        ELSEIF (X >= 68 AND X < 88) OR (X >= 104) THEN
            FOR j = 1 TO 2
                IF X > 100 AND MFire(1) = 0 THEN OrMfi(1) = XX + 12: VeMfi(1) = 10 + Y! + 9: MFire(1) = 1: PUT (OrMfi(1), VeMfi(1)), MSparo!(0), PSET
                PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
                u = u + 1: IF u = 2 THEN u = 0
                PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
                IF MFire(1) = 0 THEN aspetta .22 ELSE aspetta .18
            NEXT
        ELSEIF X >= 88 AND X < 106 THEN
            FOR j = 1 TO 2
                PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
                XX = XX + 4: Y! = Y! + 2.5
                u = u + 1: IF u = 2 THEN u = 0
                PUT (XX, 10 + Y!), Ufo!(0, u, Nufo), XOR
                aspetta .2
            NEXT
        ELSE
            aspetta .4
        END IF
        IF Colpo THEN
            FOR I = 1 TO 3
                GOSUB sparato
            NEXT
        ELSE
            aspetta .01
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
    aspetta .08
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
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine   JOKE2    di ALDINV-1.BAS
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
    aspetta .1
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
    aspetta .045
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
    aspetta .045
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
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine   JOKE3    di ALDINV-1.BAS
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
    aspetta .1
    FOR I = 1 TO Nm
        IF XXm! > 150 AND I = 3 THEN
            PUT (XXm1! - 36, 50 + YYm1!), Mostro!(0, 3, Bm), XOR
        ELSE
            PUT (XXm! - ((I - 1) * 18), 50 + YYm!), Mostro!(0, 3, Bm), XOR
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
    FOR I = 1 TO Nm
        IF XXm! > 150 AND I = 3 THEN
            PUT (XXm1! - 36, 50 + YYm1!), Mostro!(0, 3, Bm), XOR
        ELSE
            PUT (XXm! - ((I - 1) * 18), 50 + YYm!), Mostro!(0, 3, Bm), XOR
        END IF
    NEXT
    IF YYm! > 91 THEN EXIT DO
LOOP
PUT (OrFi, Vefi!), Sparo!(0), XOR
PUT (XXm1! - 36, 50 + YYm1!), Mostro!(0, 3, Bm), XOR
DO
    aspetta .1
    FOR I = 1 TO 2
        PUT (XXm! - ((I - 1) * 18), 50 + YYm!), Mostro!(0, 3, Bm), XOR
    NEXT
    PUT (XXr!, 139), Razzo!(0, 0), XOR
    Bm = Bm + 1: IF Bm >= 2 THEN Bm = 0
    YYm! = YYm! + .7
    XXr! = XXr! + 2.5
    PUT (XXr!, 139), Razzo!(0, 0), XOR
    FOR I = 1 TO 2
        PUT (XXm! - ((I - 1) * 18), 50 + YYm!), Mostro!(0, 3, Bm), XOR
    NEXT
    IF YYm! > 101 THEN EXIT DO
LOOP
XXm1! = XXm!: XXm2! = XXm! - 18: YYm1! = YYm!: YYm2! = YYm!: Flag = 0
Xu! = 290: Yu! = 30: Bu = 0: Flag = 0
DO
    aspetta .1
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
    aspetta .1
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
aspetta .5
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
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine   JOKE4    di ALDINV-1.BAS
'-----------------------------------------------------------------------------
' Intermezzo divertente tra il Livello 4 ed il Livello 5.
'
' QUESTO METTETECELO VOI!
'-----------------------------------------------------------------------------

CLS

NewLevel 4

END SUB

SUB MostraTopTen (Inizia)

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Subroutine MOSTRATOPTEN di ALDINV-1.BAS
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
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine  NEWLEVEL  di ALDINV-1.BAS
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
    aspetta .14
    IF XX = 11 THEN EXIT DO
    XX = XX + 1
    B$ = INKEY$
LOOP
A$ = "": XX! = 55: BB! = 1: XX = 55
DO
    suono (8000 / (BB! / 2)), .09
    BB! = BB! + .5
    COLOR XX: LOCATE 11, 8: PRINT "You have reached LEVEL "; NL$; "!"
    IF XX! >= 90 THEN XX! = 55
    suono BB! * 100, .09
    XX! = XX! + .25
    XX = INT(XX!)
    A$ = INKEY$: IF A$ <> "" THEN EXIT DO
    suono ((XX! * (BB! / XX!)) * 100), .09
LOOP WHILE BB! < 300
SLEEP 1


END SUB

SUB Pausa

'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                   Subroutine   PAUSA    di ALDINV-1.BAS
'-----------------------------------------------------------------------------
' Usata per attivare una pausa quando si preme P durante il gioco.
'-----------------------------------------------------------------------------

X! = 300: Y = 169: B = 3
DO
    PUT (X!, Y), Player!(0, B), XOR
    aspetta .09
    PUT (X!, Y), Player!(0, B), XOR
    X! = X! - 2.2
    B = B + 1: IF B = 6 THEN B = 3
    A$ = INKEY$: IF UCASE$(A$) = "P" THEN EXIT DO
    IF A$ = CHR$(0) + "P" THEN EXIT DO
    IF X! < 3 THEN X! = 300: B = 3: aspetta 1
LOOP

END SUB

SUB Presentazione (Inizia)


'-----------------------------------------------------------------------------
'
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                 Subroutine  PRESENTAZIONE  di ALDINV-1.BAS
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
FOR I = 1 TO 7
    READ A$
    FOR j = 1 TO LEN(A$)
        C = VAL("&H" + MID$(A$, j, 1))
        PSET (45 + j, 10 + I), C
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
        suono 60 + D, .05
        PUT (50, C!), Razzo!(0, 1), XOR
        suono 60 + D - .2, .05
        aspetta .1
        suono 60 + D, .1
        PUT (50, C!), Razzo!(0, 1), XOR
        suono 60 + D - .4, .05
        PUT (50, C!), Razzo!(0, 2), XOR
        suono 60 + D - .6, .05
        IF FlagP THEN
            PUT (P!, 186), Player!(0, 0), XOR
            P! = P! - PP!
            PUT (P!, 186), Player!(0, 1), XOR
        END IF
        PUT (5 + Oufo!, Hufo), Ufo!(0, 0, 0), XOR
        Oufo! = Oufo! + IncUfo!
        PUT (5 + Oufo!, Hufo), Ufo!(0, 1, 0), XOR
        aspetta .1
        suono 60 + D - .8, .05
        PUT (50, C!), Razzo!(0, 2), XOR
        suono 60 + D - .9, .05
        C! = C! + 4
        IF C! > 170 THEN
            C! = -1
            PUT (50, 174), Razzo!(0, 0)
        END IF
    ELSE
        E = E + 1: IF E > 7 THEN E = 1
        COLOR E
        LOCATE 24, 18: PRINT "<--- PLAYER";
        LOCATE 1, 1, 0
        aspetta .1
        IF FlagP THEN
            PUT (P!, 186), Player!(0, 0), XOR
            P! = P! - PP!
            PUT (P!, 186), Player!(0, 1), XOR
        END IF
        PUT (5 + Oufo!, Hufo), Ufo!(0, 0, 0), XOR
        Oufo! = Oufo! + IncUfo!
        PUT (5 + Oufo!, Hufo), Ufo!(0, 1, 0), XOR

        aspetta .1
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
    suono 60, .1
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
    E! = E! + .5: IF E! > 7 THEN E! = 1
    COLOR INT(E!)
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
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'               Subroutine ROCKETEXPLOSION di ALDINV-1.BAS
'-----------------------------------------------------------------------------
'        Visualizza e fa sentire l'esplosione del rocket del player
'-----------------------------------------------------------------------------

    PUT (X, Y), RazzoBum!(0, 0), XOR
    FOR I = 100 TO 1 STEP -1
        IF I / 20 = INT(I / 20) THEN
            NF = 6 - (I / 20)
            PUT (X, Y), RazzoBum!(0, (NF - 1)), XOR
            PUT (X, Y), RazzoBum!(0, NF), XOR
        END IF
        IF FlagSuono THEN
            S = INT(RND * 100)
            suono 100 + S, .2
            suono ((I * 5) + 60 + S), .1
            suono 200 + S, .2
        ELSE
            AAs = AAs + 1: IF AAs >= 5 THEN aspetta .001: AAs = 0
        END IF
    NEXT

END SUB

SUB suono (A!, B#)

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
'          ALDUS INVASION v1 - Written by Aldo Prinzi - Luglio 1994
'
'-----------------------------------------------------------------------------
'                  Subroutine  VISUALIVES  di ALDINV-1.BAS
'-----------------------------------------------------------------------------
' Legge i dati della grafica inerenti la riga di base e la visualizza.
' Posiziona e visualizza tante piccole astronavi, tante quante sono le vite
' ancora disponibili per il giocatore.
'-----------------------------------------------------------------------------

LINE (294, 190)-(320, 201), 0, BF
FOR L = 1 TO Lives
    RESTORE MAstro
    FOR I = 1 TO 7
        READ A$
        FOR j = 1 TO LEN(A$)
            C = VAL("&H" + MID$(A$, j, 1))
            PSET (320 - (L * 8) + j, 192 + I), C
        NEXT
    NEXT
NEXT

END SUB

