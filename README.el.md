# Swim College - Σύστημα Online Κρατήσεων

Μια σύγχρονη εφαρμογή web για τη διαχείριση κρατήσεων μαθημάτων κολύμβησης στο Swim College. Αυτό το project παρέχει ένα Node.js API wrapper για το σύστημα κρατήσεων ASP.NET του Swim College, με responsive web interface για τα μέλη.

## Χαρακτηριστικά

- **Ασφαχής Πιστοποίηση** - Σύνδεση με τους υπάρχοντες κωδικούς του Swim College
- **Πίνακας Ελέγχου** - Επισκόπηση κατάστασης μέλους, επερχόμενων μαθημάτων και υπολοίπου
- **Online Κράτηση** - Κράτηση μαθημάτων κολύμβησης με διαδραστικό ημερολόγιο
- **Διαχείριση Μαθημάτων** - Προβολή διαθέσιμων μαθημάτων κολύμβησης (Baby, A1, A2, E1, E2, Personal, Rehab, Aerobics, School, Yoga/Pilates)
- **Συνδρομές** - Προβολή ενεργών συνδρομών μέλους
- **Ιστορικό Παρουσιών** - Καταγραφή παρουσιών σε μαθήματα
- **Λίστα Αναμονής** - Παρακολούθηση μαθημάτων σε αναμονή
- **Ακυρώσεις** - Προβολή ιστορικού ακυρώσεων
- **Ψηφιακό Barcode** - Πρόσβαση στο barcode μέλους για είσοδο στις εγκαταστάσεις

## Τεχνολογίες

- **Backend**: Node.js, Express.js
- **Frontend**: Vanilla JavaScript, HTML5, CSS3
- **External API**: Σύστημα κρατήσεων ASP.NET Swim College

## Ξεκινώντας

### Προαπαιτούμενα

- Node.js 18+
- npm ή yarn
- Ενεργός λογαριασμός Swim College

### Εγκατάσταση

```bash
# Κλωνοποίηση του repository
git clone https://github.com/orestislef/swim.git
cd swim

# Εγκατάσταση εξαρτήσεων
npm install

# Διαμόρφωση μεταβλητών περιβάλλοντος
# Επεξεργαστείτε το αρχείο .env με τους κωδικούς σας στο Swim College
```

### Διαμόρφωση

Δημιουργήστε ένα αρχείο `.env` στο root directory:

```env
SWIM_API_BASE_URL=https://www.my-cloud.gr/www.swimcollege.gr
SWIM_LOGIN_URL=https://www.my-cloud.gr/www.swimcollege.gr/login.aspx
PORT=3000
```

### Εκτέλεση

```bash
# Εκκίνηση development server με auto-reload
npm run dev

# Ή εκκίνηση production server
npm start
```

Η εφαρμογή θα είναι διαθέσιμη στο `http://localhost:3000`

## API Endpoints

| Endpoint | Μέθοδος | Περιγραφή |
|----------|---------|-----------|
| `/api/auth/login` | POST | Σύνδεση χρήστη |
| `/api/auth/logout` | POST | Αποσύνδεση χρήστη |
| `/api/auth/status` | GET | Έλεγχος κατάστασης πιστοποίησης |
| `/api/dashboard` | GET | Λήψη δεδομένων πίνακα ελέγχου |
| `/api/bookings` | GET | Λήψη όλων των κρατήσεων |
| `/api/booking/book` | POST | Δημιουργία νέας κράτησης |
| `/api/booking/cancel` | POST | Ακύρωση κράτησης |
| `/api/courses` | GET | Λήψη διαθέσιμων μαθημάτων |
| `/api/subscriptions` | GET | Λήψη συνδρομών χρήστη |
| `/api/attendances` | GET | Λήψη ιστορικού παρουσιών |
| `/api/waitlist` | GET | Λήψη στοιχείων λίστας αναμονής |
| `/api/cancellations` | GET | Λήψη ιστορικού ακυρώσεων |
| `/api/barcode` | GET | Λήψη barcode μέλους |
| `/api/users` | GET | Λήψη προφίλ χρήστη |

## Δομή Project

```
swim/
├── server.js              # Σημείο εισόδου Express server
├── routes/
│   ├── api.js            # Διαμόρφωση API routes
│   ├── auth.js           # Routes πιστοποίησης
│   ├── dashboard.js      # Routes δεδομένων πίνακα ελέγχου
│   ├── bookings.js       # Routes κρατήσεων
│   ├── booking.js        # Routes ενεργειών κράτησης
│   ├── courses.js        # Routes μαθημάτων
│   ├── subscriptions.js  # Routes συνδρομών
│   ├── attendances.js    # Routes παρουσιών
│   ├── waitlist.js       # Routes λίστας αναμονής
│   ├── cancellations.js  # Routes ακυρώσεων
│   ├── barcode.js        # Routes barcode
│   └── users.js          # Routes χρηστών
├── services/
│   └── swimCollegeService.js  # Wrapper API Swim College
├── www/                  # Στατικά αρχεία web
│   ├── index.html        # Κύριο HTML εφαρμογής
│   ├── css/
│   │   └── styles.css   # Styles εφαρμογής
│   ├── js/
│   │   └── app.js       # Frontend JavaScript
│   └── images/
│       └── logo.png      # Logo Swim College
├── .env                  # Μεταβλητές περιβάλλοντος
├── .gitignore           # Κανόνες αγνόησης Git
└── package.json         # npm εξαρτήσεις
```

## Υποστήριξη Γλωσσών

Αυτή η εφαρμογή υποστηρίζει **Ελληνικά (Greek)** και **Αγγλικά (English)**.

- Προεπιλεγμένη γλώσσα: **Ελληνικά**
- Αλλαγή γλώσσας μέσω του επιλογέα γλώσσας στην πάνω πλοήγηση

## Άδεια

ISC License

## Συνεισφορά

1. Κάντε fork το repository
2. Δημιουργήστε το branch σας (`git checkout -b feature/θαυμαστικό-χαρακτηριστικό`)
3. Κάντε commit τις αλλαγές σας (`git commit -m 'Προσθήκη θαυμαστικού χαρακτηριστικού'`)
4. Push στο branch (`git push origin feature/θαυμαστικό-χαρακτηριστικό`)
5. Ανοίξτε ένα Pull Request

## Υποστήριξη

Για ζητήματα που αφορούν το σύστημα κρατήσεων του Swim College, επικοινωνήστε απευθείας με το Swim College.
Για ζητήματα με αυτό το wrapper, ανοίξτε ένα issue στο GitHub.
