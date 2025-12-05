# 👾 Aldus Invasion

### *In memoria di Giovanni Montesanti (1968–2018)*
### *Visionario, testimone di nozze, e l'amico che lanciò la sfida*

---

> *Un viaggio nel tempo dal 1994 a oggi: quando una sfida tra amici diventa, più di 30 anni dopo, un test per l'Intelligenza Artificiale*

---

## 🎮 Gioca Subito

**[▶️ GIOCA ORA]: scarica il repository https://raw.githubusercontent.com/prinzimaker/Space-Invaders/refs/heads/main/src/claude(opus4.5)/aldus-invasion.html, salvalo in un file html sul tuo PC e aprilo nel tuo browser.

---

## La Storia

Era il **1994**, e dovevo sottopormi a sette esami di certificazione Novell. La sede degli esami era a Milano, disponibile solo al sabato, e non era possibile sostenerne più d'uno al giorno — erano esami davvero tosti! Mi organizzai quindi per tre sabati consecutivi.

Il mio amico **Giovanni Montesanti** — che anni dopo sarebbe diventato il mio **testimone di nozze** — mi ospitò a casa sua insieme a **Vincenzo Criscuoli**, permettendomi di affrontare questo tour de force senza spendere un patrimonio in alberghi. Nel 1994 i B&B non esistevano ancora, e Giovanni stava completando il suo MBA alla **SDA Bocconi**: già allora si intuiva che avrebbe fatto strada.

Al superamento delle certificazioni da sistemista, prima di partire per tornare a Palermo, mi proposero una **sfida da programmatore**: creare un videogame in mezza giornata.

> *No, nel 1994 non era facile spiegare la differenza tra sistemista e programmatore...*

Io avevo in tasca un diploma del Liceo Artistico, ero appena diventato sistemista certificato, ma ero anche un discreto programmatore. **Accettai la sfida**.

Accesi il mio fido **Toshiba T3100**, avviai il cronometro e iniziai a programmare.

**Quattro ore dopo giocavamo ad "Aldus Invasion".**

Il sorgente lo avevo perso, ma è stato conservato da **David Papini** che me ne ha mandato copia recentemente.

🙏 **GRAZIE DAVID!!!**

---

## 💐 In Memoria di Giovanni Montesanti (1968–2018)

Questo progetto è dedicato alla memoria di **Giovanni Montesanti**, l'amico che quella sera del 1994 lanciò la sfida che diede vita a questo gioco.

Giovanni non era solo un amico: era il mio **testimone di nozze**. Era una di quelle persone rare che scegli per starti accanto nei momenti più importanti della vita.

Dopo la laurea *summa cum laude* all'**Università di Palermo** e l'MBA alla **SDA Bocconi**, Giovanni ha costruito una carriera internazionale straordinaria che lo ha portato ai vertici delle più grandi aziende del mondo:

- **Nokia** – Senior Director of Marketing, Asia Pacific (Singapore)
- **Philips** – VP Global Marketing & Strategy (Hong Kong)
- **Fox/News Corp** – Global CMO, Fox Mobile Group (Los Angeles)
- **Sky Italia** – VP Marketing & Product (Milano)
- **Ogilvy** – Lead Consultant, Asia Pacific (Bangkok)

Era un **visionario**. Chi lo conosceva sapeva che aveva la capacità di "vedere dietro l'angolo" — di anticipare trend che altri ignoravano, di connettere punti che sembravano distanti.

Ma soprattutto, Giovanni era un **amico generoso**. Nel 1994 aprì la sua casa a un amico che inseguiva certificazioni impossibili, e quella sera di luglio ebbe l'idea di una sfida che, trent'anni dopo, ha generato questo progetto.

Il suo nome è immortalato nel gioco: **"Giovanni"** è il secondo tipo di alieno, quello arancione con i tentacoli. Ogni volta che ne abbatti uno, ricordalo.

*"He was able to spot trends and connect the dots. He could see around the corner."*

**Mi manchi, Giovanni. Questa è per te.**

---

## 🕹️ Come Giocare

### Controlli

| Tasto | Azione |
|-------|--------|
| ← → | Muovi l'astronave |
| SPAZIO o ↑ | Spara |
| P o ↓ | Pausa |
| S | Attiva/Disattiva suoni |
| ESC | Esci dal gioco |

### Obiettivo

Difendi la Terra dall'invasione aliena! Distruggi tutti i 50 invasori prima che raggiungano il fondo dello schermo. Ogni livello completato aumenta la difficoltà.

### Punteggio

| Target | Punti |
|--------|-------|
| Alieno standard | 10 pts |
| Bonus (dopo 25+ kill) | +5 × livello |
| UFO (tipo 1) | 200 pts |
| UFO (tipo 2) | 350 pts |

---

## 👽 Gli Invasori

Gli alieni del gioco portano i nomi delle persone presenti quella sera a Milano:

| Riga | Nome | Descrizione |
|------|------|-------------|
| 1 | **Giacomo** | Alieni verdi con antenne |
| 2 | **Giovanni** | Creature arancioni tentacolari ✝️ |
| 3 | **Vincenzo** | Esseri grigi con ali |
| 4 | **Aldo** | Mostri gialli con occhi rossi |
| 5 | **Vicky** | Invasori bianchi in prima linea |

---

## 🎬 Gli Intermezzi (Jokes)

Tra un livello e l'altro, il gioco presenta delle scenette animate chiamate "Jokes" nel codice originale:

- **Joke 1** (dopo Livello 1): Un alieno insegue un UFO attraverso lo schermo
- **Joke 2** (dopo Livello 2): Pac-Man fa la sua apparizione inseguendo un UFO
- **Joke 3** (dopo Livello 3): Una drammatica scena con l'astronave del giocatore
- **Joke 4** (dopo Livello 4): *"QUESTO METTETECELO VOI!"* — Il placeholder originale con testo italiano

> *Joke 4 è stato volutamente lasciato come nell'originale, con il commento in italiano dell'autore.*

---

## La Sfida Oggi

> *Quale AI (LLM) sarà capace di trasformare un programma grafico scritto in QBASIC del 1994 in una routine JavaScript usabile attraverso una singola pagina HTML su browser?*

I sorgenti originali sono disponibili in questo repository. Puoi chiedere di partecipare o fare un fork per provare con il tuo LLM preferito!

**P.S.:** Claude (Opus 4.5) è stato fantastico! 🎉

---

## 🔧 Dettagli Tecnici della Conversione

### Sfide Affrontate

La conversione da QBasic a JavaScript ha richiesto di replicare fedelmente:

1. **Grafica MCGA 256 colori** → Canvas HTML5 con palette VGA
2. **Risoluzione 320×200** → Scalata 2× (640×400) per display moderni
3. **Sprite definiti come DATA** → Oggetti JavaScript con pixel art
4. **Comando PUT con XOR** → `globalCompositeOperation` su Canvas
5. **PLAY per musica** → Web Audio API per effetti sonori retro
6. **TIMER per timing** → `requestAnimationFrame` con delta time
7. **File .BIN per sprite** → Sprite embedded nel codice JS
8. **High scores su file** → `localStorage` per persistenza

### Caratteristiche Preservate

- ✅ Tutti e 5 i tipi di alieni con animazione a 2 frame
- ✅ Due tipi di UFO bonus con punteggi diversi
- ✅ Sistema di vite con visualizzazione grafica
- ✅ Progressione difficoltà su 6+ livelli
- ✅ Tutti e 4 gli intermezzi animati
- ✅ Effetto esplosione astronave (6 frame)
- ✅ Top Ten con persistenza
- ✅ Estetica CRT con scanlines e glow

### Stack Tecnologico

```
HTML5 + CSS3 + JavaScript (Vanilla)
├── Canvas API (rendering)
├── Web Audio API (suoni)
├── localStorage (high scores)
└── RequestAnimationFrame (game loop)
```

---

## 📝 Note sul Display

Il gioco è stato sviluppato usando il **monitor a gas plasma** del Toshiba T3100. Per ottenere le sfumature d'ambra caratteristiche di quel display, dovevo usare colorazioni contrastanti nel codice.

> *È questo il motivo per cui i colori sono così... particolari. Non ho voluto cambiare nulla per preservare l'autenticità del codice originale.*

---

## 📚 Contesto Storico

### Il Toshiba T3100 (1986)

Il **Toshiba T3100** era un computer portatile "luggable" rilasciato nel 1986, uno dei primi a combinare un processore **Intel 80286** con un fattore di forma a valigetta.

**Specifiche tecniche:**
- **CPU:** Intel 80286 a 8 MHz (switchabile a 4.77 MHz per compatibilità)
- **RAM:** 640 KB espandibili fino a 2.6 MB
- **Display:** Schermo al **plasma a gas** da 9.5" con risoluzione 640×400 pixel
- **Colore display:** Arancione/ambra su sfondo nero
- **Storage:** Floppy 3.5" da 720 KB + Hard Disk da 10-20 MB
- **Peso:** 6.6 kg

*BYTE Magazine lo definì "The King of Laptops".*

### Microsoft QBasic (1991)

**QBasic** è un dialetto del linguaggio BASIC sviluppato da Microsoft e incluso in MS-DOS 5.0 e versioni successive.

**Caratteristiche principali:**
- Basato su una versione semplificata di **QuickBASIC 4.5**
- IDE integrato con debugger avanzato per l'epoca
- Comandi grafici: `CIRCLE`, `LINE`, `PAINT`, `PSET`, `PUT`, `GET`

### Il Codice del 1994

Il repository include due versioni del sorgente originale:

| File | Versione | Note |
|------|----------|------|
| `ALDINV-1.BAS` | 1.0 (MS/QBasic) | Versione per interprete, include tutti i DATA degli sprite |
| `INVAD_AP.BAS` | 2.0 (BASIC PDS) | Versione per compilatore BC7, con utility di compattamento |

Entrambi datati **Luglio 1994**, scritti da **Aldo Prinzi** a Palermo.

---

## 🤝 Come Partecipare

1. **Fork** questo repository
2. Usa il tuo **LLM preferito** per convertire il codice QBASIC in JavaScript
3. Crea una **singola pagina HTML** giocabile nel browser
4. Apri una **Pull Request** con la tua implementazione
5. Documenta quale AI hai usato e come si è comportata

---

## 📁 Struttura del Repository

```
Aldus-Invasion/
├── src/
│   ├── ALDINV-1.BAS    # Sorgente QBasic v1.0 (1994)
│   └── INVAD_AP.BAS    # Sorgente BASIC PDS v2.0 (1994)
├── js/
│   └── index.html      # Conversione JavaScript (2025)
└── README.md
```

---

## 🔗 Link

- **Repository:** [github.com/prinzimaker/Space-Invaders](https://github.com/prinzimaker/Space-Invaders)
- **Giovanni Montesanti:** [Crunchbase](https://www.crunchbase.com/person/giovanni-montesanti)

---

## 👏 Crediti

| Ruolo | Nome |
|-------|------|
| **Autore originale (1994)** | Aldo Prinzi (Aldus) |
| **Conservazione del codice** | David Papini 🙏 |
| **La sfida che ha iniziato tutto** | Giovanni Montesanti ✝️ |
| **Conversione JS (2025)** | Claude (Anthropic – Opus 4.5) |

---

## Perchè due versioni?

Nel 1994 stavo ultimando il mio programma per la informatizzazione della cartella clinica di una importante casa di cura di Palermo. Avevo scritto anche la procedura che veniva essere usata dal personale del centralino per conoscere la stanza da collegare quando un parente del paziente chiamava. 
I centralinisti,al pari degli infermieri, erano costretti a fare i turni anche la notte. Per evitare che si addormentassero provai a creare diversi programmi per distrarli un po', e alla fine questo videogame diventò il loro passatempo: si sfidavano turno dopo turno per il posto di miglior giocatore. Sicchè diventò ufficialmente un _easter egg_ della "rubrica dei pazienti presenti" e fu riscritto in BC7.


---

## 📜 Licenza

Come indicato nel sorgente originale del 1994:

> *"È espressamente PERMESSA la libera distribuzione del sorgente o compilato come SHAREWARE o FREEWARE o la pubblicazione INTEGRALE su qualsiasi rivista di informatica o Bullettin Board System (BBS) per uso DIDATTICO o LUDICO."*

---

*"Dal liceo artistico alle certificazioni novell e poi Microsoft, passando per il QBASIC su un portatile al plasma: la programmazione è sempre stata una questione di sfide tra amici."*

*"E le sfide migliori sono quelle lanciate da amici come Giovanni — quelli che scegli come testimoni di nozze, quelli che non dimentichi mai."*

— Aldus the Prinzimaker