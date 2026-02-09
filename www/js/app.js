const API_BASE = '/swim/api';

const translations = {
  el: {
    appTitle: 'Swim College - Online Booking',
    onlineBooking: 'Σύστημα Online Κρατήσεων',
    login: 'Σύνδεση',
    register: 'Εγγραφή',
    username: 'Όνομα χρήστη',
    password: 'Κωδικός',
    enterUsername: 'Εισάγετε όνομα χρήστη',
    enterPassword: 'Εισάγετε κωδικό',
    signIn: 'Σύνδεση',
    createAccount: 'Δημιουργία λογαριασμού',
    dashboard: 'Πίνακας Ελέγχου',
    myBookings: 'Οι Κρατήσεις μου',
    classes: 'Μαθήματα',
    subscriptions: 'Συνδρομές',
    attendance: 'Παρουσίες',
    waitlist: 'Λίστα Αναμονής',
    cancellations: 'Ακυρώσεις',
    myBarcode: 'Το Barcode μου',
    profile: 'Προφίλ',
    logout: 'Αποσύνδεση',
    welcomeBack: 'Καλώς ήρθατε!',
    overview: 'Εδώ είναι η επισκόπησή σας.',
    member: 'Μέλος',
    expires: 'Λήξη',
    balance: 'Υπόλοιπο',
    bookings: 'Κρατήσεις',
    upcomingClasses: 'Επερχόμενα Μαθήματα',
    allBookings: 'Όλες οι Κρατήσεις',
    bookClass: 'Κράτηση Μαθήματος',
    selectDateTime: 'Επιλέξτε ημερομηνία και ώρα για να κλείσετε το μάθημά σας',
    step1ChooseType: 'Βήμα 1: Επιλέξτε Τύπο Μαθήματος',
    step2SelectDate: 'Βήμα 2: Επιλέξτε Ημερομηνία',
    step3SelectTime: 'Βήμα 3: Επιλέξτε Ώρα',
    step4Confirm: 'Επιβεβαίωση Κράτησης',
    available: 'Διαθέσιμο',
    yourBooking: 'Η Κράτησή σας',
    noClasses: 'Χωρίς Μαθήματα',
    selectedDate: 'Επιλεγμένη Ημερομηνία',
    confirmBooking: 'Επιβεβαίωση Κράτησης',
    startOver: 'Νέα Κράτηση',
    mySubscriptions: 'Οι Συνδρομές μου',
    activeMemberships: 'Ενεργές Συνδρομές',
    attendanceHistory: 'Ιστορικό Παρουσιών',
    trackAttendance: 'Παρακολουθήστε τις παρουσίες σας',
    attendanceRecords: 'Αρχεία Παρουσιών',
    date: 'Ημερομηνία',
    time: 'Ώρα',
    waitlistTitle: 'Λίστα Αναμονής',
    waitlistSubtitle: 'Μαθήματα που περιμένετε',
    yourWaitlist: 'Η Λίστα Αναμονής σας',
    cancellationsTitle: 'Ακυρώσεις',
    cancellationsSubtitle: 'Ιστορικό ακυρωμένων μαθημάτων',
    cancellationHistory: 'Ιστορικό Ακυρώσεων',
    showAtEntrance: 'Δείξτε αυτό στην είσοδο',
    presentBarcode: 'Παρουσιάστε αυτό το barcode κατά την είσοδο',
    myProfile: 'Το Προφίλ μου',
    accountInfo: 'Στοιχεία λογαριασμού',
    fullName: 'Πλήρες Όνομα',
    programExpires: 'Λήξη Προγράμματος',
    accountBalance: 'Υπόλοιπο Λογαριασμού',
    noUpcomingClasses: 'Δεν υπάρχουν επερχόμενα μαθήματα',
    bookFirstClass: 'Κλείστε το πρώτο σας μάθημα',
    noBookings: 'Δεν βρέθηκαν κρατήσεις',
    startBooking: 'Ξεκινήστε κλείνοντας το πρώτο σας μάθημα',
    cancel: 'Ακύρωση',
    cancelBookingConfirm: 'Είστε σίγουροι ότι θέλετε να ακυρώσετε αυτή την κράτηση;',
    bookingCancelled: 'Η κράτηση ακυρώθηκε επιτυχώς!',
    bookingFailed: 'Η κράτηση απέτυχε: ',
    error: 'Σφάλμα: ',
    signInProgress: 'Σύνδεση...',
    processing: 'Επεξεργασία...',
    classType: 'Τύπος Μαθήματος',
    dateLabel: 'Ημερομηνία',
    timeLabel: 'Ώρα',
    bookingInfo: 'Αυτή η κράτηση θα επιβεβαιωθεί μετά την πληρωμή στη ρεσεψιόν.',
    bookingSuccess: 'Η κράτηση ήταν επιτυχής!',
    bookingSuccessDetails: 'Παρακαλώ πληρώστε στη ρεσεψιόν και δείξτε το barcode σας.',
    noCourses: 'Δεν υπάρχουν διαθέσιμα μαθήματα',
    spots: 'θέσεις',
    full: 'Γεμάτο',
    noActiveSubscriptions: 'Δεν υπάρχουν ενεργές συνδρομές',
    contactReception: 'Επικοινωνήστε με τη ρεσεψιόν για αγορά συνδρομής',
    noAttendance: 'Δεν υπάρχουν αρχεία παρουσιών',
    noWaitlist: 'Δεν υπάρχουν στοιχεία στη λίστα αναμονής',
    noWaitlistText: 'Δεν περιμένετε κανένα μάθημα',
    noCancellations: 'Δεν υπάρχουν ακυρώσεις',
    noCancellationsText: 'Δεν έχετε ακυρώσει κανένα μάθημα',
    barcodeNotAvailable: 'Το barcode δεν είναι διαθέσιμο',
    pleaseEnterBoth: 'Παρακαλώ εισάγετε όνομα χρήστη και κωδικό',
    invalidCredentials: 'Άκυρα στοιχεία σύνδεσης',
    connectionError: 'Σφάλμα σύνδεσης. Προσπαθήστε ξανά.',
    registrationComingSoon: 'Η εγγραφή θα είναι σύντομα διαθέσιμη!',
    activeMember: 'Ενεργό Μέλος',
    noData: '-',
    bookingStatusPending: 'Εκκρεμεί',
    bookingStatusConfirmed: 'Επιβεβαιωμένο',
    bookingStatusCancelled: 'Ακυρωμένο',
    bookingStatusActive: 'Ενεργή',
    bookingStatusCompleted: 'Ολοκληρωμένη',
    loading: 'Φόρτωση...',
    language: 'Γλώσσα',
    greek: 'Ελληνικά',
    english: 'English',
    addToCalendar: 'Ημερολόγιο',
    addAllToCalendar: 'Προσθήκη Όλων στο Ημερολόγιο',
    today: 'Σήμερα',
    tomorrow: 'Αύριο',
    inHours: 'σε %n ώρες',
    inDays: 'σε %n ημέρες',
    subscriptionName: 'Συνδρομή',
    subscriptionStart: 'Έναρξη',
    subscriptionEnd: 'Λήξη',
    subscriptionAttendances: 'Παρουσίες',
    past: 'Παρελθόν',
    dayShort: {
      'Κυρ': 'Κυρ', 'Δευ': 'Δευ', 'Τρι': 'Τρι', 'Τετ': 'Τετ',
      'Πεμ': 'Πεμ', 'Παρ': 'Παρ', 'Σαβ': 'Σαβ',
      'Sun': 'Sun', 'Mon': 'Mon', 'Tue': 'Tue', 'Wed': 'Wed',
      'Thu': 'Thu', 'Fri': 'Fri', 'Sat': 'Sat'
    }
  },
  en: {
    appTitle: 'Swim College - Online Booking',
    onlineBooking: 'Online Booking System',
    login: 'Login',
    register: 'Register',
    username: 'Username',
    password: 'Password',
    enterUsername: 'Enter username',
    enterPassword: 'Enter password',
    signIn: 'Sign In',
    createAccount: 'Create Account',
    dashboard: 'Dashboard',
    myBookings: 'My Bookings',
    classes: 'Classes',
    subscriptions: 'Subscriptions',
    attendance: 'Attendance',
    waitlist: 'Waitlist',
    cancellations: 'Cancellations',
    myBarcode: 'My Barcode',
    profile: 'Profile',
    logout: 'Logout',
    welcomeBack: 'Welcome back!',
    overview: "Here's your overview.",
    member: 'Member',
    expires: 'Expires',
    balance: 'Balance',
    bookings: 'Bookings',
    upcomingClasses: 'Upcoming Classes',
    allBookings: 'All Bookings',
    bookClass: 'Book a Class',
    selectDateTime: 'Select date and time to book your swim',
    step1ChooseType: 'Step 1: Choose Class Type',
    step2SelectDate: 'Step 2: Select Date',
    step3SelectTime: 'Step 3: Select Time Slot',
    step4Confirm: 'Confirm Booking',
    available: 'Available',
    yourBooking: 'Your Booking',
    noClasses: 'No Classes',
    selectedDate: 'Selected Date',
    confirmBooking: 'Confirm Booking',
    startOver: 'Start Over',
    mySubscriptions: 'My Subscriptions',
    activeMemberships: 'Active Subscriptions',
    attendanceHistory: 'Attendance History',
    trackAttendance: 'Track your class attendance',
    attendanceRecords: 'Attendance Records',
    date: 'Date',
    time: 'Time',
    waitlistTitle: 'Waitlist',
    waitlistSubtitle: "Classes you're waiting for",
    yourWaitlist: 'Your Waitlist',
    cancellationsTitle: 'Cancellations',
    cancellationsSubtitle: 'Cancelled class history',
    cancellationHistory: 'Cancellation History',
    showAtEntrance: 'Show this at the entrance',
    presentBarcode: 'Present this barcode when entering the facility',
    myProfile: 'My Profile',
    accountInfo: 'Account Information',
    fullName: 'Full Name',
    programExpires: 'Program Expires',
    accountBalance: 'Account Balance',
    noUpcomingClasses: 'No upcoming classes',
    bookFirstClass: 'Book your first class to get started',
    noBookings: 'No bookings found',
    startBooking: 'Start by booking your first class',
    cancel: 'Cancel',
    cancelBookingConfirm: 'Are you sure you want to cancel this booking?',
    bookingCancelled: 'Booking cancelled successfully!',
    bookingFailed: 'Booking failed: ',
    error: 'Error: ',
    signInProgress: 'Signing in...',
    processing: 'Processing...',
    classType: 'Class Type',
    dateLabel: 'Date',
    timeLabel: 'Time',
    bookingInfo: 'This booking will be confirmed after payment at reception.',
    bookingSuccess: 'Booking successful!',
    bookingSuccessDetails: 'Please pay at reception and show your barcode.',
    noCourses: 'No courses available',
    spots: 'spots',
    full: 'Full',
    noActiveSubscriptions: 'No active subscriptions',
    contactReception: 'Contact reception to purchase a subscription',
    noAttendance: 'No attendance records',
    noWaitlist: 'No items in waitlist',
    noWaitlistText: "You're not waiting for any classes",
    noCancellations: 'No cancellations',
    noCancellationsText: "You haven't cancelled any classes",
    barcodeNotAvailable: 'Barcode not available',
    pleaseEnterBoth: 'Please enter both username and password',
    invalidCredentials: 'Invalid credentials',
    connectionError: 'Connection error. Please try again.',
    registrationComingSoon: 'Registration coming soon!',
    activeMember: 'Active Member',
    noData: '-',
    bookingStatusPending: 'Pending',
    bookingStatusConfirmed: 'Confirmed',
    bookingStatusCancelled: 'Cancelled',
    bookingStatusActive: 'Active',
    bookingStatusCompleted: 'Completed',
    loading: 'Loading...',
    language: 'Language',
    greek: 'Ελληνικά',
    english: 'English',
    addToCalendar: 'Calendar',
    addAllToCalendar: 'Add All to Calendar',
    today: 'Today',
    tomorrow: 'Tomorrow',
    inHours: 'in %n hours',
    inDays: 'in %n days',
    subscriptionName: 'Subscription',
    subscriptionStart: 'Start',
    subscriptionEnd: 'End',
    subscriptionAttendances: 'Attendances',
    past: 'Past',
    dayShort: {
      'Κυρ': 'Sun', 'Δευ': 'Mon', 'Τρι': 'Tue', 'Τετ': 'Wed',
      'Πεμ': 'Thu', 'Παρ': 'Fri', 'Σαβ': 'Sat',
      'Sun': 'Sun', 'Mon': 'Mon', 'Tue': 'Tue', 'Wed': 'Wed',
      'Thu': 'Thu', 'Fri': 'Fri', 'Sat': 'Sat'
    }
  }
};

// Toast notification system
const Toast = {
  show(type, title, message, duration = 4000) {
    const container = document.getElementById('toast-container');
    if (!container) return;

    const icons = {
      success: 'fa-check',
      error: 'fa-times',
      warning: 'fa-exclamation',
      info: 'fa-info'
    };

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.innerHTML = `
      <div class="toast-icon"><i class="fas ${icons[type] || icons.info}"></i></div>
      <div class="toast-body">
        <div class="toast-title">${title}</div>
        ${message ? `<div class="toast-message">${message}</div>` : ''}
      </div>
      <button class="toast-close"><i class="fas fa-times"></i></button>
      <div class="toast-progress"><div class="toast-progress-bar" style="animation-duration: ${duration}ms;"></div></div>
    `;

    const close = () => {
      toast.classList.add('toast-out');
      setTimeout(() => toast.remove(), 400);
    };

    toast.querySelector('.toast-close').addEventListener('click', close);
    toast.addEventListener('click', (e) => {
      if (!e.target.closest('.toast-close')) close();
    });

    container.appendChild(toast);
    setTimeout(close, duration);
  },

  success(title, message) { this.show('success', title, message); },
  error(title, message) { this.show('error', title, message); },
  warning(title, message) { this.show('warning', title, message); },
  info(title, message) { this.show('info', title, message); }
};

const App = {
  currentUser: null,
  isAuthenticated: false,
  currentLanguage: 'el',
  cachedBookings: null,

  t(key) {
    return translations[this.currentLanguage][key] || translations['el'][key] || key;
  },

  translateDay(day) {
    const dayMap = this.t('dayShort');
    return dayMap[day] || day;
  },

  translateStatus(status) {
    const statusMap = {
      'confirmed': this.t('bookingStatusConfirmed'),
      'pending': this.t('bookingStatusActive'),
      'cancelled': this.t('bookingStatusCancelled'),
      'active': this.t('bookingStatusActive'),
      'completed': this.t('bookingStatusCompleted'),
      'Ενεργή': this.t('bookingStatusActive'),
      'Επιβεβαιωμένο': this.t('bookingStatusConfirmed'),
      'Εκκρεμεί': this.t('bookingStatusPending'),
      'Ακυρωμένο': this.t('bookingStatusCancelled'),
      'Ολοκληρωμένη': this.t('bookingStatusCompleted')
    };
    return statusMap[status] || status;
  },

  // Parse date from "Κυρ DD/MM/YYYY" format and time from "HH:MM HH:MM"
  parseBookingDateTime(dateStr, timeStr) {
    const dateMatch = dateStr.match(/(\d{1,2})\/(\d{1,2})\/(\d{4})/);
    if (!dateMatch) return null;
    const [, day, month, year] = dateMatch;
    const timeMatch = timeStr.match(/(\d{1,2}):(\d{2})/);
    const hours = timeMatch ? parseInt(timeMatch[1]) : 0;
    const minutes = timeMatch ? parseInt(timeMatch[2]) : 0;
    return new Date(parseInt(year), parseInt(month) - 1, parseInt(day), hours, minutes);
  },

  // Parse end time from "HH:MM HH:MM"
  parseEndTime(dateStr, timeStr) {
    const dateMatch = dateStr.match(/(\d{1,2})\/(\d{1,2})\/(\d{4})/);
    if (!dateMatch) return null;
    const [, day, month, year] = dateMatch;
    const timeMatch = timeStr.match(/\d{1,2}:\d{2}\s+(\d{1,2}):(\d{2})/);
    if (!timeMatch) return null;
    return new Date(parseInt(year), parseInt(month) - 1, parseInt(day), parseInt(timeMatch[1]), parseInt(timeMatch[2]));
  },

  // Get countdown text for a future date
  getCountdown(targetDate) {
    const now = new Date();
    const diff = targetDate - now;
    if (diff < 0) return null;

    const totalMinutes = Math.floor(diff / (1000 * 60));
    const hours = Math.floor(totalMinutes / 60);
    const days = Math.floor(hours / 24);

    if (days === 0 && hours === 0) {
      return this.currentLanguage === 'el' ? 'Σύντομα!' : 'Soon!';
    } else if (days === 0) {
      return this.t('inHours').replace('%n', hours);
    } else if (days === 1) {
      return this.t('tomorrow');
    } else {
      return this.t('inDays').replace('%n', days);
    }
  },

  // Generate ICS calendar content for a single booking
  generateICS(booking) {
    const start = this.parseBookingDateTime(booking.date, booking.time);
    const end = this.parseEndTime(booking.date, booking.time) ||
                new Date(start.getTime() + 60 * 60 * 1000);

    const pad = (n) => String(n).padStart(2, '0');
    const formatLocal = (d) =>
      `${d.getFullYear()}${pad(d.getMonth()+1)}${pad(d.getDate())}T${pad(d.getHours())}${pad(d.getMinutes())}00`;

    const uid = `swim-${booking.id}-${Date.now()}@swimcollege`;

    return [
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//Swim College//Booking//EN',
      'CALSCALE:GREGORIAN',
      'METHOD:PUBLISH',
      'BEGIN:VEVENT',
      `DTSTART;TZID=Europe/Athens:${formatLocal(start)}`,
      `DTEND;TZID=Europe/Athens:${formatLocal(end)}`,
      `SUMMARY:Swim College - ${booking.course}`,
      `DESCRIPTION:Booking ID: ${booking.id}\\nCourse: ${booking.course}`,
      'LOCATION:Swim College',
      `UID:${uid}`,
      `DTSTAMP:${formatLocal(new Date())}Z`,
      'END:VEVENT',
      'END:VCALENDAR'
    ].join('\r\n');
  },

  downloadICS(booking) {
    if (!booking) return;
    const ics = this.generateICS(booking);
    const blob = new Blob([ics], { type: 'text/calendar;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `swim-${booking.id}.ics`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  },

  downloadAllICS(bookings) {
    if (!bookings || bookings.length === 0) return;

    const pad = (n) => String(n).padStart(2, '0');
    const formatLocal = (d) =>
      `${d.getFullYear()}${pad(d.getMonth()+1)}${pad(d.getDate())}T${pad(d.getHours())}${pad(d.getMinutes())}00`;

    const events = bookings.map(b => {
      const start = this.parseBookingDateTime(b.date, b.time);
      if (!start) return '';
      const end = this.parseEndTime(b.date, b.time) ||
                  new Date(start.getTime() + 60 * 60 * 1000);
      const uid = `swim-${b.id}-${Date.now()}@swimcollege`;

      return [
        'BEGIN:VEVENT',
        `DTSTART;TZID=Europe/Athens:${formatLocal(start)}`,
        `DTEND;TZID=Europe/Athens:${formatLocal(end)}`,
        `SUMMARY:Swim College - ${b.course}`,
        `DESCRIPTION:Booking ID: ${b.id}\\nCourse: ${b.course}`,
        'LOCATION:Swim College',
        `UID:${uid}`,
        `DTSTAMP:${formatLocal(new Date())}Z`,
        'END:VEVENT'
      ].join('\r\n');
    }).filter(Boolean).join('\r\n');

    const ics = [
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//Swim College//Booking//EN',
      'CALSCALE:GREGORIAN',
      'METHOD:PUBLISH',
      events,
      'END:VCALENDAR'
    ].join('\r\n');

    const blob = new Blob([ics], { type: 'text/calendar;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'swim-all-upcoming.ics';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  },

  setLanguage(lang) {
    this.currentLanguage = lang;
    localStorage.setItem('language', lang);
    this.updateUILanguage();
  },

  updateUILanguage() {
    document.querySelectorAll('[data-i18n]').forEach(el => {
      const key = el.getAttribute('data-i18n');
      if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
        el.placeholder = this.t(key);
      } else {
        el.textContent = this.t(key);
      }
    });

    document.querySelectorAll('[data-i18n-title]').forEach(el => {
      el.title = this.t(el.getAttribute('data-i18n-title'));
    });

    document.querySelectorAll('[data-i18n-html]').forEach(el => {
      el.innerHTML = this.t(el.getAttribute('data-i18n-html'));
    });

    const langSelect = document.getElementById('lang-select');
    if (langSelect) langSelect.value = this.currentLanguage;
  },

  // Booking state
  bookingState: {
    selectedCourse: null,
    selectedDate: null,
    selectedTime: null,
    selectedSlotId: null,
    currentMonth: new Date().getMonth(),
    currentYear: new Date().getFullYear()
  },

  // Staggered animation helper
  animateChildren(parent, selector, delay = 80) {
    const children = parent.querySelectorAll(selector);
    children.forEach((child, i) => {
      child.classList.add('animate-in');
      child.style.animationDelay = `${i * delay}ms`;
    });
  },

  // Mobile menu
  toggleMobileMenu() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebar-overlay');
    const btn = document.getElementById('mobile-menu-btn');
    const isOpen = sidebar.classList.contains('open');

    if (!isOpen) {
      this._scrollY = window.scrollY;
      document.body.style.top = `-${this._scrollY}px`;
      document.body.classList.add('sidebar-open');
    } else {
      document.body.classList.remove('sidebar-open');
      document.body.style.top = '';
      window.scrollTo(0, this._scrollY || 0);
    }

    sidebar.classList.toggle('open', !isOpen);
    overlay.classList.toggle('active', !isOpen);
    btn.classList.toggle('active', !isOpen);
  },

  closeMobileMenu() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebar-overlay');
    const btn = document.getElementById('mobile-menu-btn');
    sidebar.classList.remove('open');
    overlay.classList.remove('active');
    btn.classList.remove('active');
    document.body.classList.remove('sidebar-open');
    document.body.style.top = '';
    window.scrollTo(0, this._scrollY || 0);
  },

  async init() {
    const savedLang = localStorage.getItem('language');
    if (savedLang && (savedLang === 'el' || savedLang === 'en')) {
      this.currentLanguage = savedLang;
    } else {
      const browserLang = navigator.language || navigator.userLanguage;
      this.currentLanguage = browserLang.startsWith('en') ? 'en' : 'el';
    }
    this.bindEvents();
    await this.checkAuth();
  },

  async checkAuth() {
    try {
      const response = await fetch(`${API_BASE}/auth/status`, { credentials: 'include' });
      const result = await response.json();

      if (result.authenticated) {
        this.isAuthenticated = true;
        document.body.classList.add('authenticated');
        document.getElementById('login-page').style.display = 'none';
        document.getElementById('app').classList.add('active');
        this.updateUILanguage();
        await this.loadDashboardData();
      }
    } catch (error) {
      console.error('Auth check error:', error);
    }
  },

  bindEvents() {
    document.getElementById('login-btn').addEventListener('click', () => this.login());
    document.getElementById('register-btn').addEventListener('click', () => {
      Toast.info(this.t('register'), this.t('registrationComingSoon'));
    });
    document.getElementById('logout-btn').addEventListener('click', () => this.logout());

    // Mobile menu
    document.getElementById('mobile-menu-btn').addEventListener('click', () => this.toggleMobileMenu());
    document.getElementById('sidebar-overlay').addEventListener('click', () => this.closeMobileMenu());

    // Navigation
    document.querySelectorAll('.nav-item').forEach(item => {
      item.addEventListener('click', (e) => {
        e.preventDefault();
        const screen = item.dataset.screen;
        this.switchScreen(screen);
        document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
        item.classList.add('active');
        this.closeMobileMenu();
      });
    });

    document.getElementById('password').addEventListener('keypress', (e) => {
      if (e.key === 'Enter') this.login();
    });
    document.getElementById('username').addEventListener('keypress', (e) => {
      if (e.key === 'Enter') document.getElementById('password').focus();
    });

    const langSelect = document.getElementById('lang-select');
    if (langSelect) {
      langSelect.addEventListener('change', (e) => this.setLanguage(e.target.value));
    }
  },

  async login() {
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value.trim();
    const errorMsg = document.getElementById('login-error');
    const errorText = document.getElementById('error-text');
    const loginBtn = document.getElementById('login-btn');

    if (!username || !password) {
      errorText.textContent = this.t('pleaseEnterBoth');
      errorMsg.classList.add('show');
      return;
    }

    errorMsg.classList.remove('show');
    loginBtn.disabled = true;
    loginBtn.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${this.t('signInProgress')}`;

    try {
      const response = await fetch(`${API_BASE}/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({ username, password })
      });

      const result = await response.json();

      if (result.success) {
        // Fix: userData is inside result.data
        this.currentUser = result.data?.userData || result.userData;
        this.isAuthenticated = true;

        // Smooth transition: fade out login, fade in app
        const loginPage = document.getElementById('login-page');
        loginPage.classList.add('fade-out');

        setTimeout(() => {
          loginPage.style.display = 'none';
          loginPage.classList.remove('fade-out');
          document.body.classList.add('authenticated');
          document.getElementById('app').classList.add('active');
          this.updateUILanguage();
          this.loadDashboardData();
        }, 500);
      } else {
        errorText.textContent = result.error || this.t('invalidCredentials');
        errorMsg.classList.add('show');
      }
    } catch (error) {
      errorText.textContent = this.t('connectionError');
      errorMsg.classList.add('show');
    } finally {
      loginBtn.disabled = false;
      loginBtn.innerHTML = `<i class="fas fa-sign-in-alt"></i> ${this.t('signIn')}`;
    }
  },

  logout() {
    fetch(`${API_BASE}/auth/logout`, {
      method: 'POST',
      credentials: 'include'
    }).finally(() => {
      this.currentUser = null;
      this.isAuthenticated = false;
      this.cachedBookings = null;
      document.body.classList.remove('authenticated');
      document.getElementById('app').classList.remove('active');
      document.getElementById('login-page').style.display = 'flex';
      document.getElementById('username').value = '';
      document.getElementById('password').value = '';
      document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
      document.querySelector('[data-screen="home"]').classList.add('active');
    });
  },

  switchScreen(screenName) {
    document.querySelectorAll('.screen').forEach(screen => screen.classList.remove('active'));
    const targetScreen = document.getElementById(`screen-${screenName}`);
    if (targetScreen) {
      targetScreen.classList.add('active');
      this.loadScreenData(screenName);
    }
  },

  async loadDashboardData() {
    try {
      // Load dashboard and bookings in parallel
      const [dashboardRes, bookingsRes] = await Promise.all([
        fetch(`${API_BASE}/dashboard`, { credentials: 'include' }),
        fetch(`${API_BASE}/bookings`, { credentials: 'include' })
      ]);

      const dashboard = await dashboardRes.json();
      const bookingsResult = await bookingsRes.json();

      if (dashboard.success && dashboard.data) {
        const name = dashboard.data.name || 'Member';
        const expiry = dashboard.data.expiry || '-';
        const balance = dashboard.data.balance || '-';

        document.getElementById('user-name').textContent = name;
        document.getElementById('stat-name').textContent = name.split(' ')[0] || name;
        document.getElementById('stat-expiry').textContent = expiry;
        document.getElementById('stat-balance').textContent = balance;
        document.getElementById('profile-name').textContent = name;
        document.getElementById('profile-expiry').textContent = expiry;
        document.getElementById('profile-balance').textContent = balance;
      }

      // Animate stat cards with stagger
      const statsGrid = document.querySelector('.stats-grid');
      if (statsGrid) this.animateChildren(statsGrid, '.stat-card', 100);

      if (bookingsResult.success && bookingsResult.data) {
        const allBookings = bookingsResult.data.bookings || [];
        const total = bookingsResult.data.total || allBookings.length;
        document.getElementById('stat-bookings').textContent = total;

        // Cache bookings for calendar export
        this.cachedBookings = allBookings;

        // Filter future bookings and sort by nearest first
        const now = new Date();
        const upcoming = allBookings
          .filter(b => {
            const dt = this.parseBookingDateTime(b.date, b.time);
            return dt && dt > now;
          })
          .sort((a, b) => {
            const da = this.parseBookingDateTime(a.date, a.time);
            const db = this.parseBookingDateTime(b.date, b.time);
            return da - db;
          });

        const container = document.getElementById('upcoming-list');

        if (upcoming.length > 0) {
          // Build header with "Add All to Calendar" button
          let headerHtml = '';
          if (upcoming.length > 1) {
            headerHtml = `
              <div style="display: flex; justify-content: flex-end; margin-bottom: 12px;">
                <button onclick="App.downloadAllICS(App.getUpcomingBookings())"
                        style="padding: 8px 16px; background: linear-gradient(135deg, #059669, #10b981); color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 6px; transition: all 0.2s;"
                        onmouseover="this.style.transform='translateY(-1px)';this.style.boxShadow='0 4px 12px rgba(5,150,105,0.3)'"
                        onmouseout="this.style.transform='';this.style.boxShadow=''">
                  <i class="fas fa-calendar-plus"></i> ${this.t('addAllToCalendar')}
                </button>
              </div>`;
          }

          container.innerHTML = headerHtml + upcoming.map(b => {
            const dt = this.parseBookingDateTime(b.date, b.time);
            const countdown = this.getCountdown(dt);
            const dayName = b.date.split(' ')[0] || '';

            return `
              <div class="booking-item ${b.status}">
                <div class="booking-icon"><i class="fas fa-swimmer"></i></div>
                <div class="booking-details">
                  <div class="booking-title">${b.course}</div>
                  <div class="booking-meta">
                    <i class="fas fa-calendar"></i> ${this.translateDay(dayName)} ${b.date.replace(/^\S+\s*/, '')} &nbsp;
                    <i class="fas fa-clock"></i> ${b.time}
                  </div>
                  ${countdown ? `<div style="margin-top: 4px; font-size: 13px; color: #059669; font-weight: 600;"><i class="fas fa-hourglass-half"></i> ${countdown}</div>` : ''}
                </div>
                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 6px;">
                  <span class="booking-status ${b.status}">${this.translateStatus(b.statusText)}</span>
                  <button onclick="App.downloadICS(App.getBookingById('${b.id}'))"
                          style="padding: 5px 10px; background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; border-radius: 6px; cursor: pointer; font-size: 11px; font-weight: 600; display: flex; align-items: center; gap: 4px; transition: all 0.2s;"
                          onmouseover="this.style.background='#1d4ed8';this.style.color='white'"
                          onmouseout="this.style.background='#eff6ff';this.style.color='#1d4ed8'">
                    <i class="fas fa-calendar-plus"></i> ${this.t('addToCalendar')}
                  </button>
                </div>
              </div>
            `;
          }).join('');
          this.animateChildren(container, '.booking-item', 100);
        } else {
          container.innerHTML = `
            <div class="empty-state">
              <div class="empty-state-icon"><i class="fas fa-calendar-times"></i></div>
              <div class="empty-state-title">${this.t('noUpcomingClasses')}</div>
              <div class="empty-state-text">${this.t('bookFirstClass')}</div>
            </div>
          `;
        }
      }
    } catch (error) {
      console.error('Dashboard load error:', error);
    }
  },

  getBookingById(id) {
    return (this.cachedBookings || []).find(b => b.id === id) || null;
  },

  getUpcomingBookings() {
    const now = new Date();
    return (this.cachedBookings || [])
      .filter(b => {
        const dt = this.parseBookingDateTime(b.date, b.time);
        return dt && dt > now;
      })
      .sort((a, b) => {
        const da = this.parseBookingDateTime(a.date, a.time);
        const db = this.parseBookingDateTime(b.date, b.time);
        return da - db;
      });
  },

  async loadScreenData(screenName) {
    try {
      switch (screenName) {
        case 'home': await this.loadDashboardData(); break;
        case 'bookings': await this.loadBookings(); break;
        case 'courses': await this.loadCourses(); break;
        case 'subscriptions': await this.loadSubscriptions(); break;
        case 'attendances': await this.loadAttendances(); break;
        case 'waitlist': await this.loadWaitlist(); break;
        case 'cancellations': await this.loadCancellations(); break;
        case 'barcode': await this.loadBarcode(); break;
      }
    } catch (error) {
      console.error(`Error loading ${screenName}:`, error);
    }
  },

  async loadBookings() {
    const container = document.getElementById('bookings-list');
    container.innerHTML = '<div class="loading"><div class="spinner"></div></div>';

    const response = await fetch(`${API_BASE}/bookings`, { credentials: 'include' });
    const result = await response.json();

    if (result.success && result.data?.bookings?.length > 0) {
      const now = new Date();
      this.cachedBookings = result.data.bookings;

      container.innerHTML = `<div>${result.data.bookings.map(b => {
        const dt = this.parseBookingDateTime(b.date, b.time);
        const isFuture = dt && dt > now;
        const countdown = isFuture ? this.getCountdown(dt) : null;
        const isPast = dt && dt <= now;

        return `
          <div class="booking-item ${b.status}" id="booking-${b.id}">
            <div class="booking-icon"><i class="fas fa-swimmer"></i></div>
            <div class="booking-details">
              <div class="booking-title">${b.course}</div>
              <div class="booking-meta">
                <span>ID: ${b.id}</span> |
                <span><i class="fas fa-calendar"></i> ${this.translateDay(b.date.split(' ')[0])} ${b.date.replace(/^\S+\s*/, '')}</span> |
                <span><i class="fas fa-clock"></i> ${b.time}</span>
              </div>
              ${countdown ? `<div style="margin-top: 4px; font-size: 13px; color: #059669; font-weight: 600;"><i class="fas fa-hourglass-half"></i> ${countdown}</div>` : ''}
              ${isPast ? `<div style="margin-top: 4px; font-size: 13px; color: #9ca3af; font-weight: 500;"><i class="fas fa-check-double"></i> ${this.t('bookingStatusCompleted')}</div>` : ''}
            </div>
            <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 6px;">
              <span class="booking-status ${b.status}">${this.translateStatus(b.statusText)}</span>
              ${isFuture ? `
                <button onclick="App.downloadICS(App.getBookingById('${b.id}'))"
                        style="padding: 5px 10px; background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; border-radius: 6px; cursor: pointer; font-size: 11px; font-weight: 600; display: flex; align-items: center; gap: 4px; transition: all 0.2s;"
                        onmouseover="this.style.background='#1d4ed8';this.style.color='white'"
                        onmouseout="this.style.background='#eff6ff';this.style.color='#1d4ed8'">
                  <i class="fas fa-calendar-plus"></i> ${this.t('addToCalendar')}
                </button>
              ` : ''}
              ${b.status === 'pending' && isFuture ? `
                <button onclick="App.cancelBooking('${b.id}')"
                        style="padding: 5px 10px; background: #fee2e2; color: #991b1b; border: none; border-radius: 6px; cursor: pointer; font-size: 11px; font-weight: 600; display: flex; align-items: center; gap: 4px; transition: all 0.2s;"
                        onmouseover="this.style.background='#ef4444';this.style.color='white'"
                        onmouseout="this.style.background='#fee2e2';this.style.color='#991b1b'">
                  <i class="fas fa-times"></i> ${this.t('cancel')}
                </button>
              ` : ''}
            </div>
          </div>
        `;
      }).join('')}</div>`;
      this.animateChildren(container, '.booking-item', 80);
    } else {
      container.innerHTML = `
        <div class="empty-state">
          <div class="empty-state-icon"><i class="fas fa-calendar-times"></i></div>
          <div class="empty-state-title">${this.t('noBookings')}</div>
          <div class="empty-state-text">${this.t('startBooking')}</div>
        </div>
      `;
    }
  },

  async cancelBooking(bookingId) {
    if (!confirm(this.t('cancelBookingConfirm'))) return;

    try {
      const response = await fetch(`${API_BASE}/booking/cancel`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({ bookingId })
      });

      const result = await response.json();

      if (result.success) {
        Toast.success(this.t('cancel'), this.t('bookingCancelled'));
        const bookingEl = document.getElementById(`booking-${bookingId}`);
        if (bookingEl) {
          bookingEl.style.transition = 'opacity 0.5s, transform 0.5s';
          bookingEl.style.opacity = '0.3';
          bookingEl.style.transform = 'translateX(-20px)';
        }
        setTimeout(() => {
          this.loadBookings();
          this.loadDashboardData();
        }, 1000);
      } else {
        Toast.error(this.t('error'), this.t('bookingFailed') + (result.error || ''));
      }
    } catch (error) {
      Toast.error(this.t('error'), error.message);
    }
  },

  async loadCourses() {
    const container = document.getElementById('booking-course-types');
    if (!container) return;
    container.innerHTML = '<div class="loading"><div class="spinner"></div></div>';

    const response = await fetch(`${API_BASE}/courses`, { credentials: 'include' });
    const result = await response.json();

    if (result.success && result.data?.courseTypes?.length > 0) {
      const courseIcons = {
        'BABY': 'fa-baby', 'A1': 'fa-swimmer', 'A2': 'fa-swimmer',
        'E1': 'fa-running', 'E2': 'fa-running', 'PERSONAL': 'fa-user',
        'REHAB': 'fa-heartbeat', 'AEROBICS': 'fa-dumbbell',
        'SCHOOL': 'fa-graduation-cap', 'YOGA/PILATES': 'fa-spa'
      };

      container.innerHTML = result.data.courseTypes.map(course => `
        <button onclick="App.selectCourseForBooking('${course}', this)"
                class="course-select-btn ${this.bookingState.selectedCourse === course ? 'selected' : ''}"
                style="padding: 16px 24px; border: 2px solid ${this.bookingState.selectedCourse === course ? '#004e92' : '#e5e7eb'}; border-radius: 12px; background: ${this.bookingState.selectedCourse === course ? '#f0f9ff' : 'white'}; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; gap: 12px; font-size: 16px; font-weight: 500;">
          <i class="fas ${courseIcons[course] || 'fa-swimmer'}" style="color: #004e92; font-size: 24px;"></i>
          <span>${course}</span>
        </button>
      `).join('');
    } else {
      container.innerHTML = `<p style="color: #6b7280;">${this.t('noCourses')}</p>`;
    }
  },

  selectCourseForBooking(course, btnEl) {
    this.bookingState.selectedCourse = course;
    this.bookingState.selectedDate = null;
    this.bookingState.selectedTime = null;
    this.bookingState.selectedSlotId = null;

    document.querySelectorAll('.course-select-btn').forEach(btn => {
      btn.style.borderColor = '#e5e7eb';
      btn.style.background = 'white';
    });
    if (btnEl) {
      btnEl.style.borderColor = '#004e92';
      btnEl.style.background = '#f0f9ff';
    }

    // Reset downstream sections
    document.getElementById('time-slots-section').style.display = 'none';
    document.getElementById('confirmation-section').style.display = 'none';

    document.getElementById('calendar-section').style.display = 'block';
    this.renderBookingCalendar();
    document.getElementById('calendar-section').scrollIntoView({ behavior: 'smooth' });
  },

  renderBookingCalendar() {
    const container = document.getElementById('booking-calendar');
    const monthNames = this.currentLanguage === 'el'
      ? ['Ιανουάριος', 'Φεβρουάριος', 'Μάρτιος', 'Απρίλιος', 'Μάιος', 'Ιούνιος', 'Ιούλιος', 'Αύγουστος', 'Σεπτέμβριος', 'Οκτώβριος', 'Νοέμβριος', 'Δεκέμβριος']
      : ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    const dayNames = this.currentLanguage === 'el'
      ? ['Κυρ', 'Δευ', 'Τρι', 'Τετ', 'Πεμ', 'Παρ', 'Σαβ']
      : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    document.getElementById('booking-calendar-month').textContent =
      `${monthNames[this.bookingState.currentMonth]} ${this.bookingState.currentYear}`;

    const year = this.bookingState.currentYear;
    const month = this.bookingState.currentMonth;
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const daysInPrevMonth = new Date(year, month, 0).getDate();

    let html = '';

    dayNames.forEach(day => {
      html += `<div style="text-align: center; font-weight: 600; color: #6b7280; padding: 8px; font-size: 12px;">${day}</div>`;
    });

    for (let i = firstDay - 1; i >= 0; i--) {
      html += `<div style="padding: 12px; text-align: center; color: #d1d5db; background: #f9fafb; border-radius: 8px;">${daysInPrevMonth - i}</div>`;
    }

    const today = new Date();
    for (let day = 1; day <= daysInMonth; day++) {
      const isToday = today.getDate() === day && today.getMonth() === month && today.getFullYear() === year;
      const isPast = new Date(year, month, day, 23, 59) < today;
      const isSelected = this.bookingState.selectedDate &&
                        this.bookingState.selectedDate.getDate() === day &&
                        this.bookingState.selectedDate.getMonth() === month;

      let bgColor = isSelected ? '#004e92' : (isPast ? '#f3f4f6' : 'white');
      let textColor = isSelected ? 'white' : (isPast ? '#9ca3af' : '#374151');
      let border = isSelected ? '2px solid #004e92' : (isToday ? '2px solid #f59e0b' : '1px solid #e5e7eb');
      let cursor = isPast ? 'not-allowed' : 'pointer';

      html += `
        <button onclick="${isPast ? '' : `App.selectDateForBooking(${year}, ${month}, ${day})`}"
                ${isPast ? 'disabled' : ''}
                style="padding: 12px; text-align: center; background: ${bgColor}; color: ${textColor}; border: ${border}; border-radius: 8px; cursor: ${cursor}; font-weight: 500; transition: all 0.2s; opacity: ${isPast ? 0.5 : 1};"
                ${!isPast ? `onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'"` : ''}>
          ${day}
          ${isToday ? '<div style="width: 6px; height: 6px; background: #f59e0b; border-radius: 50%; margin: 4px auto 0;"></div>' : ''}
        </button>
      `;
    }

    container.innerHTML = html;
  },

  changeBookingMonth(direction) {
    this.bookingState.currentMonth += direction;
    if (this.bookingState.currentMonth > 11) {
      this.bookingState.currentMonth = 0;
      this.bookingState.currentYear++;
    } else if (this.bookingState.currentMonth < 0) {
      this.bookingState.currentMonth = 11;
      this.bookingState.currentYear--;
    }
    this.renderBookingCalendar();
  },

  async selectDateForBooking(year, month, day) {
    this.bookingState.selectedDate = new Date(year, month, day);
    this.bookingState.selectedTime = null;
    this.bookingState.selectedSlotId = null;
    this.renderBookingCalendar();

    // Hide confirmation when date changes
    document.getElementById('confirmation-section').style.display = 'none';
    document.getElementById('time-slots-section').style.display = 'block';

    const locale = this.currentLanguage === 'el' ? 'el-GR' : 'en-GB';
    document.getElementById('selected-date-display').textContent =
      this.bookingState.selectedDate.toLocaleDateString(locale, { weekday: 'long', day: 'numeric', month: 'long' });

    await this.loadTimeSlots();
    document.getElementById('time-slots-section').scrollIntoView({ behavior: 'smooth' });
  },

  async loadTimeSlots() {
    const container = document.getElementById('time-slots-list');
    container.innerHTML = '<div class="loading"><div class="spinner"></div></div>';

    try {
      const dateStr = this.bookingState.selectedDate.toISOString().split('T')[0];
      const response = await fetch(
        `${API_BASE}/booking/slots?date=${dateStr}&courseType=${encodeURIComponent(this.bookingState.selectedCourse)}`,
        { credentials: 'include' }
      );
      const result = await response.json();

      if (result.success && result.slots && result.slots.length > 0) {
        container.innerHTML = result.slots.map(slot => {
          const isAvailable = slot.canBook;
          const isSelected = this.bookingState.selectedSlotId === slot.id;
          const isCancelled = slot.status === 'cancelled' || slot.persons < 0;

          let statusColor = '#059669';
          let statusIcon = 'fa-check-circle';
          let statusText = this.t('available');

          if (isCancelled) {
            statusColor = '#f59e0b';
            statusIcon = 'fa-ban';
            statusText = this.t('bookingStatusCancelled');
          } else if (!isAvailable) {
            statusColor = '#ef4444';
            statusIcon = 'fa-times-circle';
            statusText = this.t('full');
          }

          const borderColor = isSelected ? '#004e92' : (isAvailable ? '#e5e7eb' : (isCancelled ? '#fef3c7' : '#fee2e2'));

          return `
            <button onclick="${isAvailable ? `App.selectTimeSlot('${slot.id}', '${slot.time}')` : ''}"
                    ${!isAvailable ? 'disabled' : ''}
                    style="padding: 16px; border: 2px solid ${borderColor}; border-radius: 12px; background: ${isSelected ? '#f0f9ff' : 'white'}; cursor: ${isAvailable ? 'pointer' : 'not-allowed'}; opacity: ${isAvailable ? 1 : 0.5}; transition: all 0.2s; text-align: left;">
              <div style="font-weight: 600; font-size: 18px; margin-bottom: 4px; color: ${isSelected ? '#004e92' : '#374151'};">
                ${slot.time}
              </div>
              <div style="font-size: 13px; color: #6b7280; margin-bottom: 4px;">
                ${slot.teacher ? `<i class="fas fa-user"></i> ${slot.teacher}` : ''}
              </div>
              <div style="font-size: 13px; display: flex; justify-content: space-between; align-items: center;">
                <span style="color: ${statusColor};"><i class="fas ${statusIcon}"></i> ${statusText}</span>
                ${slot.persons >= 0 ? `<span style="color: #6b7280;"><i class="fas fa-users"></i> ${slot.persons}</span>` : ''}
              </div>
            </button>
          `;
        }).join('');
      } else {
        container.innerHTML = `
          <div style="text-align: center; padding: 24px; color: #6b7280;">
            <i class="fas fa-calendar-times" style="font-size: 32px; margin-bottom: 12px; display: block;"></i>
            <p>${this.t('noCourses')}</p>
          </div>
        `;
      }
    } catch (error) {
      console.error('Failed to load time slots:', error);
      container.innerHTML = `
        <div style="text-align: center; padding: 24px; color: #6b7280;">
          <i class="fas fa-exclamation-triangle" style="font-size: 32px; margin-bottom: 12px; display: block; color: #f59e0b;"></i>
          <p>${this.t('connectionError')}</p>
        </div>
      `;
    }
  },

  selectTimeSlot(slotId, time) {
    this.bookingState.selectedSlotId = slotId;
    this.bookingState.selectedTime = time;
    this.loadTimeSlots();

    document.getElementById('confirmation-section').style.display = 'block';

    const locale = this.currentLanguage === 'el' ? 'el-GR' : 'en-GB';
    document.getElementById('booking-summary').innerHTML = `
      <div style="margin-bottom: 12px;"><strong>${this.t('classType')}:</strong> <span style="color: #004e92; font-weight: 600;">${this.bookingState.selectedCourse}</span></div>
      <div style="margin-bottom: 12px;"><strong>${this.t('dateLabel')}:</strong> ${this.bookingState.selectedDate.toLocaleDateString(locale, { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}</div>
      <div style="margin-bottom: 12px;"><strong>${this.t('timeLabel')}:</strong> ${this.bookingState.selectedTime}</div>
      <div style="font-size: 14px; color: #059669;"><i class="fas fa-info-circle"></i> ${this.t('bookingInfo')}</div>
    `;

    document.getElementById('confirmation-section').scrollIntoView({ behavior: 'smooth' });
  },

  async confirmBooking(e) {
    const btn = e ? e.currentTarget : null;
    if (btn) {
      btn.disabled = true;
      btn.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${this.t('processing')}`;
    }

    try {
      const response = await fetch(`${API_BASE}/booking/book`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({
          date: this.bookingState.selectedDate.toISOString().split('T')[0],
          courseType: this.bookingState.selectedCourse,
          slotId: this.bookingState.selectedSlotId
        })
      });

      const result = await response.json();

      if (result.success) {
        Toast.success(
          this.t('bookingSuccess'),
          `${this.t('classType')}: ${this.bookingState.selectedCourse} | ${this.bookingState.selectedDate.toLocaleDateString()} ${this.bookingState.selectedTime}`
        );
        this.resetBooking();
        this.switchScreen('bookings');
        this.loadBookings();
      } else {
        Toast.error(this.t('error'), this.t('bookingFailed') + (result.error || ''));
      }
    } catch (error) {
      Toast.error(this.t('error'), error.message);
    } finally {
      if (btn) {
        btn.disabled = false;
        btn.innerHTML = `<i class="fas fa-check"></i> ${this.t('confirmBooking')}`;
      }
    }
  },

  resetBooking() {
    this.bookingState = {
      selectedCourse: null,
      selectedDate: null,
      selectedTime: null,
      selectedSlotId: null,
      currentMonth: new Date().getMonth(),
      currentYear: new Date().getFullYear()
    };

    document.getElementById('calendar-section').style.display = 'none';
    document.getElementById('time-slots-section').style.display = 'none';
    document.getElementById('confirmation-section').style.display = 'none';

    document.querySelectorAll('.course-select-btn').forEach(btn => {
      btn.style.borderColor = '#e5e7eb';
      btn.style.background = 'white';
    });

    this.loadCourses();
  },

  async loadSubscriptions() {
    const container = document.getElementById('subscriptions-list');
    container.innerHTML = '<div class="loading"><div class="spinner"></div></div>';

    const response = await fetch(`${API_BASE}/subscriptions`, { credentials: 'include' });
    const result = await response.json();

    if (result.success && result.data?.length > 0) {
      container.innerHTML = result.data.map(sub => `
        <div class="booking-item" style="flex-wrap: wrap;">
          <div class="booking-icon"><i class="fas fa-id-card"></i></div>
          <div class="booking-details" style="flex: 1; min-width: 200px;">
            <div class="booking-title">${sub.name}</div>
            <div class="booking-meta">
              <span><i class="fas fa-calendar-plus"></i> ${this.t('subscriptionStart')}: ${sub.start}</span> |
              <span><i class="fas fa-calendar-minus"></i> ${this.t('subscriptionEnd')}: ${sub.end}</span>
            </div>
            <div class="booking-meta" style="margin-top: 4px;">
              <span><i class="fas fa-check-circle"></i> ${this.t('subscriptionAttendances')}: ${sub.attendances}</span>
              ${sub.remaining && sub.remaining !== 'Δεν βρέθηκε τμήμα' ? ` | <span><i class="fas fa-hourglass-half"></i> ${sub.remaining}</span>` : ''}
            </div>
          </div>
          <span class="booking-status confirmed">${this.t('bookingStatusActive')}</span>
        </div>
      `).join('');
      this.animateChildren(container, '.booking-item', 80);
    } else {
      container.innerHTML = `
        <div class="empty-state">
          <div class="empty-state-icon"><i class="fas fa-id-card"></i></div>
          <div class="empty-state-title">${this.t('noActiveSubscriptions')}</div>
          <div class="empty-state-text">${this.t('contactReception')}</div>
        </div>
      `;
    }
  },

  async loadAttendances() {
    const tbody = document.getElementById('attendances-table-body');
    tbody.innerHTML = '<tr><td colspan="2" class="loading"><div class="spinner"></div></td></tr>';

    const response = await fetch(`${API_BASE}/attendances`, { credentials: 'include' });
    const result = await response.json();

    if (result.success && result.data?.length > 0) {
      tbody.innerHTML = result.data.map(att => `
        <tr>
          <td><i class="fas fa-calendar" style="color: #0066cc; margin-right: 8px;"></i>${att.date}</td>
          <td><i class="fas fa-clock" style="color: #6b7280; margin-right: 8px;"></i>${att.time}</td>
        </tr>
      `).join('');
    } else {
      tbody.innerHTML = `
        <tr><td colspan="2">
          <div class="empty-state">
            <div class="empty-state-icon"><i class="fas fa-clipboard-list"></i></div>
            <div class="empty-state-title">${this.t('noAttendance')}</div>
          </div>
        </td></tr>
      `;
    }
  },

  async loadWaitlist() {
    const container = document.getElementById('waitlist-content');
    container.innerHTML = '<div class="loading"><div class="spinner"></div></div>';

    const response = await fetch(`${API_BASE}/waitlist`, { credentials: 'include' });
    const result = await response.json();

    if (result.success && result.data?.length > 0) {
      container.innerHTML = result.data.map(item => `
        <div style="padding: 16px; background: #fef3c7; border-radius: 8px; margin-bottom: 12px; border-left: 4px solid #f59e0b;">
          ${item.details || '-'}
        </div>
      `).join('');
    } else {
      container.innerHTML = `
        <div class="empty-state">
          <div class="empty-state-icon"><i class="fas fa-check-circle" style="color: #059669;"></i></div>
          <div class="empty-state-title">${this.t('noWaitlist')}</div>
          <div class="empty-state-text">${this.t('noWaitlistText')}</div>
        </div>
      `;
    }
  },

  async loadCancellations() {
    const container = document.getElementById('cancellations-content');
    container.innerHTML = '<div class="loading"><div class="spinner"></div></div>';

    const response = await fetch(`${API_BASE}/cancellations`, { credentials: 'include' });
    const result = await response.json();

    if (result.success && result.data?.length > 0) {
      container.innerHTML = result.data.map(item => `
        <div style="padding: 16px; background: #fee2e2; border-radius: 8px; margin-bottom: 12px; border-left: 4px solid #ef4444;">
          ${item.details || '-'}
        </div>
      `).join('');
    } else {
      container.innerHTML = `
        <div class="empty-state">
          <div class="empty-state-icon"><i class="fas fa-check-circle" style="color: #059669;"></i></div>
          <div class="empty-state-title">${this.t('noCancellations')}</div>
          <div class="empty-state-text">${this.t('noCancellationsText')}</div>
        </div>
      `;
    }
  },

  async loadBarcode() {
    const display = document.getElementById('barcode-display');
    const number = document.getElementById('barcode-number');
    display.innerHTML = '<div class="loading"><div class="spinner"></div></div>';

    const response = await fetch(`${API_BASE}/barcode`, { credentials: 'include' });
    const result = await response.json();

    if (result.success && result.data) {
      number.textContent = result.data.code || 'Not available';
      if (result.data.svg) {
        display.innerHTML = `<div style="max-width: 300px; margin: 0 auto; padding: 20px; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">${result.data.svg}</div>`;
      } else {
        display.innerHTML = `<p style="color: #6b7280;">${this.t('barcodeNotAvailable')}</p>`;
      }
    }
  }
};

document.addEventListener('DOMContentLoaded', () => App.init());
