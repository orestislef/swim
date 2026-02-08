const API_BASE = '/api';

const App = {
  currentUser: null,
  isAuthenticated: false,
  
  // Booking state
  bookingState: {
    selectedCourse: null,
    selectedDate: null,
    selectedTime: null,
    currentMonth: new Date().getMonth(),
    currentYear: new Date().getFullYear()
  },
  
  async init() {
    this.bindEvents();
    await this.checkAuth();
  },

  async checkAuth() {
    try {
      const response = await fetch(`${API_BASE}/auth/status`, {
        credentials: 'include'
      });
      const result = await response.json();
      
      if (result.authenticated) {
        this.isAuthenticated = true;
        document.getElementById('login-page').style.display = 'none';
        document.getElementById('app').classList.add('active');
        await this.loadDashboardData();
      }
    } catch (error) {
      console.error('Auth check error:', error);
    }
  },

  bindEvents() {
    // Login
    document.getElementById('login-btn').addEventListener('click', () => this.login());
    document.getElementById('register-btn').addEventListener('click', () => alert('Registration coming soon!'));
    
    // Logout
    document.getElementById('logout-btn').addEventListener('click', () => this.logout());
    
    // Navigation
    document.querySelectorAll('.nav-item').forEach(item => {
      item.addEventListener('click', (e) => {
        e.preventDefault();
        const screen = item.dataset.screen;
        this.switchScreen(screen);
        
        // Update active nav
        document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
        item.classList.add('active');
      });
    });
    
    // Enter key on login
    document.getElementById('password').addEventListener('keypress', (e) => {
      if (e.key === 'Enter') this.login();
    });
  },

  async login() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const errorMsg = document.getElementById('login-error');
    const errorText = document.getElementById('error-text');
    const loginBtn = document.getElementById('login-btn');
    
    if (!username || !password) {
      errorText.textContent = 'Please enter both username and password';
      errorMsg.classList.add('show');
      return;
    }

    errorMsg.classList.remove('show');
    loginBtn.disabled = true;
    loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Signing in...';

    try {
      const response = await fetch(`${API_BASE}/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({ username, password })
      });
      
      const result = await response.json();
      
      if (result.success) {
        this.currentUser = result.userData;
        this.isAuthenticated = true;
        document.getElementById('login-page').style.display = 'none';
        document.getElementById('app').classList.add('active');
        await this.loadDashboardData();
      } else {
        errorText.textContent = result.error || 'Invalid credentials';
        errorMsg.classList.add('show');
      }
    } catch (error) {
      errorText.textContent = 'Connection error. Please try again.';
      errorMsg.classList.add('show');
    } finally {
      loginBtn.disabled = false;
      loginBtn.innerHTML = '<i class="fas fa-sign-in-alt"></i> Sign In';
    }
  },

  logout() {
    fetch(`${API_BASE}/auth/logout`, {
      method: 'POST',
      credentials: 'include'
    }).finally(() => {
      this.currentUser = null;
      this.isAuthenticated = false;
      document.getElementById('app').classList.remove('active');
      document.getElementById('login-page').style.display = 'flex';
      document.getElementById('username').value = '';
      document.getElementById('password').value = '';
      
      // Reset nav
      document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
      document.querySelector('[data-screen="home"]').classList.add('active');
    });
  },

  switchScreen(screenName) {
    // Hide all screens
    document.querySelectorAll('.screen').forEach(screen => {
      screen.classList.remove('active');
    });
    
    // Show selected screen
    const targetScreen = document.getElementById(`screen-${screenName}`);
    if (targetScreen) {
      targetScreen.classList.add('active');
      this.loadScreenData(screenName);
    }
  },

  async loadDashboardData() {
    try {
      // Load dashboard
      const dashboardRes = await fetch(`${API_BASE}/dashboard`, {
        credentials: 'include'
      });
      const dashboard = await dashboardRes.json();
      
      if (dashboard.success && dashboard.data) {
        const name = dashboard.data.name || 'Member';
        const expiry = dashboard.data.expiry || '-';
        const balance = dashboard.data.balance || '€0';
        
        document.getElementById('user-name').textContent = name;
        document.getElementById('stat-name').textContent = name.split(' ')[0] || name;
        document.getElementById('stat-expiry').textContent = expiry;
        document.getElementById('stat-balance').textContent = balance;
        document.getElementById('profile-name').textContent = name;
        document.getElementById('profile-expiry').textContent = expiry;
        document.getElementById('profile-balance').textContent = balance;
      }

      // Load bookings
      const bookingsRes = await fetch(`${API_BASE}/bookings`, {
        credentials: 'include'
      });
      const bookingsResult = await bookingsRes.json();
      
      if (bookingsResult.success && bookingsResult.data) {
        const bookings = bookingsResult.data.bookings || [];
        const total = bookingsResult.data.total || bookings.length;
        
        document.getElementById('stat-bookings').textContent = total;
        
        // Render upcoming
        const upcoming = bookings.slice(0, 3);
        const container = document.getElementById('upcoming-list');
        
        if (upcoming.length > 0) {
          container.innerHTML = upcoming.map(b => `
            <div class="booking-item ${b.status}">
              <div class="booking-icon">
                <i class="fas fa-swimmer"></i>
              </div>
              <div class="booking-details">
                <div class="booking-title">${b.course}</div>
                <div class="booking-meta">
                  <i class="fas fa-calendar"></i> ${b.date} &nbsp;
                  <i class="fas fa-clock"></i> ${b.time}
                </div>
              </div>
              <span class="booking-status ${b.status}">${b.statusText}</span>
            </div>
          `).join('');
        } else {
          container.innerHTML = `
            <div class="empty-state">
              <div class="empty-state-icon"><i class="fas fa-calendar-times"></i></div>
              <div class="empty-state-title">No upcoming classes</div>
              <div class="empty-state-text">Book your first class to get started</div>
            </div>
          `;
        }
      }
    } catch (error) {
      console.error('Dashboard load error:', error);
    }
  },

  async loadScreenData(screenName) {
    try {
      switch (screenName) {
        case 'bookings':
          await this.loadBookings();
          break;
        case 'courses':
          await this.loadCourses();
          break;
        case 'subscriptions':
          await this.loadSubscriptions();
          break;
        case 'attendances':
          await this.loadAttendances();
          break;
        case 'waitlist':
          await this.loadWaitlist();
          break;
        case 'cancellations':
          await this.loadCancellations();
          break;
        case 'barcode':
          await this.loadBarcode();
          break;
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
      container.innerHTML = `
        <div>
          ${result.data.bookings.map(b => `
            <div class="booking-item ${b.status}" id="booking-${b.id}">
              <div class="booking-icon"><i class="fas fa-swimmer"></i></div>
              <div class="booking-details">
                <div class="booking-title">${b.course}</div>
                <div class="booking-meta">
                  <span>ID: ${b.id}</span> | 
                  <span><i class="fas fa-calendar"></i> ${b.date}</span> | 
                  <span><i class="fas fa-clock"></i> ${b.time}</span>
                </div>
              </div>
              <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
                <span class="booking-status ${b.status}">${b.statusText}</span>
                ${b.status === 'pending' ? `
                  <button onclick="App.cancelBooking('${b.id}')" 
                          style="padding: 6px 12px; background: #fee2e2; color: #991b1b; border: none; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600;">
                    <i class="fas fa-times"></i> Cancel
                  </button>
                ` : ''}
              </div>
            </div>
          `).join('')}
        </div>
      `;
    } else {
      container.innerHTML = `
        <div class="empty-state">
          <div class="empty-state-icon"><i class="fas fa-calendar-times"></i></div>
          <div class="empty-state-title">No bookings found</div>
          <div class="empty-state-text">Start by booking your first class</div>
        </div>
      `;
    }
  },

  async cancelBooking(bookingId) {
    if (!confirm('Are you sure you want to cancel this booking?')) {
      return;
    }
    
    try {
      const response = await fetch(`${API_BASE}/booking/cancel`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({ bookingId })
      });
      
      const result = await response.json();
      
      if (result.success) {
        alert('✅ Booking cancelled successfully!');
        // Remove the booking from UI
        const bookingEl = document.getElementById(`booking-${bookingId}`);
        if (bookingEl) {
          bookingEl.style.opacity = '0.5';
          bookingEl.innerHTML += '<div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: rgba(239, 68, 68, 0.9); color: white; padding: 8px 16px; border-radius: 8px; font-weight: 600;">CANCELLED</div>';
        }
        // Reload bookings after a delay
        setTimeout(() => this.loadBookings(), 1000);
      } else {
        alert('❌ ' + (result.error || 'Failed to cancel booking'));
      }
    } catch (error) {
      alert('❌ Error: ' + error.message);
    }
  },

  async loadCourses() {
    // Load course types for booking interface
    const container = document.getElementById('booking-course-types');
    if (!container) return;
    
    container.innerHTML = '<div class="loading"><div class="spinner"></div></div>';
    
    const response = await fetch(`${API_BASE}/courses`, { credentials: 'include' });
    const result = await response.json();
    
    if (result.success && result.data?.courseTypes?.length > 0) {
      const courseIcons = {
        'BABY': 'fa-baby',
        'A1': 'fa-swimmer',
        'A2': 'fa-swimmer',
        'E1': 'fa-running',
        'E2': 'fa-running',
        'PERSONAL': 'fa-user',
        'REHAB': 'fa-heartbeat',
        'AEROBICS': 'fa-dumbbell',
        'SCHOOL': 'fa-graduation-cap',
        'YOGA/PILATES': 'fa-spa'
      };
      
      container.innerHTML = result.data.courseTypes.map(course => `
        <button onclick="App.selectCourseForBooking('${course}')" 
                class="course-select-btn ${this.bookingState.selectedCourse === course ? 'selected' : ''}"
                style="padding: 16px 24px; border: 2px solid #e5e7eb; border-radius: 12px; background: white; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; gap: 12px; font-size: 16px; font-weight: 500;">
          <i class="fas ${courseIcons[course] || 'fa-swimmer'}" style="color: #004e92; font-size: 24px;"></i>
          <span>${course}</span>
        </button>
      `).join('');
    } else {
      container.innerHTML = '<p style="color: #6b7280;">No courses available</p>';
    }
  },

  // Booking Methods
  selectCourseForBooking(course) {
    this.bookingState.selectedCourse = course;
    
    // Update UI
    document.querySelectorAll('.course-select-btn').forEach(btn => {
      btn.style.borderColor = '#e5e7eb';
      btn.style.background = 'white';
    });
    event.currentTarget.style.borderColor = '#004e92';
    event.currentTarget.style.background = '#f0f9ff';
    
    // Show calendar
    document.getElementById('calendar-section').style.display = 'block';
    this.renderBookingCalendar();
    
    // Scroll to calendar
    document.getElementById('calendar-section').scrollIntoView({ behavior: 'smooth' });
  },

  renderBookingCalendar() {
    const container = document.getElementById('booking-calendar');
    const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    document.getElementById('booking-calendar-month').textContent = 
      `${monthNames[this.bookingState.currentMonth]} ${this.bookingState.currentYear}`;
    
    const year = this.bookingState.currentYear;
    const month = this.bookingState.currentMonth;
    
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const daysInPrevMonth = new Date(year, month, 0).getDate();
    
    let html = '';
    
    // Day headers
    const dayHeaders = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    dayHeaders.forEach(day => {
      html += `<div style="text-align: center; font-weight: 600; color: #6b7280; padding: 8px; font-size: 12px;">${day}</div>`;
    });
    
    // Previous month days
    for (let i = firstDay - 1; i >= 0; i--) {
      const day = daysInPrevMonth - i;
      html += `<div style="padding: 12px; text-align: center; color: #d1d5db; background: #f9fafb; border-radius: 8px;">${day}</div>`;
    }
    
    // Current month days
    const today = new Date();
    for (let day = 1; day <= daysInMonth; day++) {
      const isToday = today.getDate() === day && today.getMonth() === month && today.getFullYear() === year;
      const isSelected = this.bookingState.selectedDate && 
                        this.bookingState.selectedDate.getDate() === day &&
                        this.bookingState.selectedDate.getMonth() === month;
      
      // Check if day has classes (simplified - in real app would check from API)
      const hasClasses = [8, 15, 22].includes(day); // Example: Sundays
      
      let bgColor = isSelected ? '#004e92' : (hasClasses ? '#d1fae5' : 'white');
      let textColor = isSelected ? 'white' : (hasClasses ? '#065f46' : '#374151');
      let border = isSelected ? '2px solid #004e92' : (isToday ? '2px solid #f59e0b' : '1px solid #e5e7eb');
      
      html += `
        <button onclick="App.selectDateForBooking(${year}, ${month}, ${day})" 
                style="padding: 12px; text-align: center; background: ${bgColor}; color: ${textColor}; border: ${border}; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.2s;"
                onmouseover="this.style.transform='scale(1.05)'" 
                onmouseout="this.style.transform='scale(1)'">
          ${day}
          ${hasClasses ? '<div style="width: 6px; height: 6px; background: #10b981; border-radius: 50%; margin: 4px auto 0;"></div>' : ''}
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
    
    // Update calendar UI
    this.renderBookingCalendar();
    
    // Show time slots section
    document.getElementById('time-slots-section').style.display = 'block';
    document.getElementById('selected-date-display').textContent = 
      this.bookingState.selectedDate.toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long' });
    
    // Load time slots (simulated for now)
    await this.loadTimeSlots();
    
    // Scroll to time slots
    document.getElementById('time-slots-section').scrollIntoView({ behavior: 'smooth' });
  },

  async loadTimeSlots() {
    const container = document.getElementById('time-slots-list');
    container.innerHTML = '<div class="loading"><div class="spinner"></div></div>';
    
    // Simulate API call - in production this would fetch from backend
    setTimeout(() => {
      const timeSlots = [
        { time: '10:00', available: 3, instructor: 'Maria' },
        { time: '11:00', available: 0, instructor: 'John' },
        { time: '17:00', available: 5, instructor: 'George' },
        { time: '18:00', available: 2, instructor: 'Anna' },
        { time: '19:00', available: 4, instructor: 'Maria' }
      ];
      
      container.innerHTML = timeSlots.map(slot => {
        const isAvailable = slot.available > 0;
        const isSelected = this.bookingState.selectedTime === slot.time;
        
        return `
          <button onclick="App.selectTimeSlot('${slot.time}')" 
                  ${!isAvailable ? 'disabled' : ''}
                  style="padding: 16px; border: 2px solid ${isSelected ? '#004e92' : (isAvailable ? '#e5e7eb' : '#fee2e2')}; border-radius: 12px; background: ${isSelected ? '#f0f9ff' : 'white'}; cursor: ${isAvailable ? 'pointer' : 'not-allowed'}; opacity: ${isAvailable ? 1 : 0.5}; transition: all 0.2s; text-align: left;">
            <div style="font-weight: 600; font-size: 18px; margin-bottom: 4px; color: ${isSelected ? '#004e92' : '#374151'};">
              ${slot.time} - ${parseInt(slot.time.split(':')[0]) + 1}:00
            </div>
            <div style="font-size: 14px; color: #6b7280;">
              <i class="fas fa-user"></i> ${slot.instructor}
              ${isAvailable 
                ? `<span style="color: #059669; float: right;"><i class="fas fa-check-circle"></i> ${slot.available} spots</span>`
                : '<span style="color: #ef4444; float: right;"><i class="fas fa-times-circle"></i> Full</span>'
              }
            </div>
          </button>
        `;
      }).join('');
    }, 500);
  },

  selectTimeSlot(time) {
    this.bookingState.selectedTime = time;
    
    // Update UI
    this.loadTimeSlots();
    
    // Show confirmation
    document.getElementById('confirmation-section').style.display = 'block';
    
    const summaryHtml = `
      <div style="margin-bottom: 12px;"><strong>Class Type:</strong> <span style="color: #004e92; font-weight: 600;">${this.bookingState.selectedCourse}</span></div>
      <div style="margin-bottom: 12px;"><strong>Date:</strong> ${this.bookingState.selectedDate.toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}</div>
      <div style="margin-bottom: 12px;"><strong>Time:</strong> ${this.bookingState.selectedTime} - ${parseInt(this.bookingState.selectedTime.split(':')[0]) + 1}:00</div>
      <div style="font-size: 14px; color: #059669;"><i class="fas fa-info-circle"></i> This booking will be confirmed after payment at reception.</div>
    `;
    
    document.getElementById('booking-summary').innerHTML = summaryHtml;
    
    // Scroll to confirmation
    document.getElementById('confirmation-section').scrollIntoView({ behavior: 'smooth' });
  },

  async confirmBooking() {
    const btn = event.target;
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
    
    try {
      const response = await fetch(`${API_BASE}/booking/book`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({
          date: this.bookingState.selectedDate.toISOString().split('T')[0],
          time: this.bookingState.selectedTime,
          courseType: this.bookingState.selectedCourse
        })
      });
      
      const result = await response.json();
      
      if (result.success) {
        alert('✅ Booking successful!\n\n' +
              `Class: ${this.bookingState.selectedCourse}\n` +
              `Date: ${this.bookingState.selectedDate.toLocaleDateString()}\n` +
              `Time: ${this.bookingState.selectedTime}\n\n` +
              'Please pay at reception and show your barcode.');
        
        // Reset and go to bookings
        this.resetBooking();
        this.switchScreen('bookings');
        this.loadBookings();
      } else {
        alert('❌ Booking failed: ' + (result.error || 'Unknown error'));
      }
    } catch (error) {
      alert('❌ Error: ' + error.message);
    } finally {
      btn.disabled = false;
      btn.innerHTML = '<i class="fas fa-check"></i> Confirm Booking';
    }
  },

  resetBooking() {
    this.bookingState = {
      selectedCourse: null,
      selectedDate: null,
      selectedTime: null,
      currentMonth: new Date().getMonth(),
      currentYear: new Date().getFullYear()
    };
    
    // Hide sections
    document.getElementById('calendar-section').style.display = 'none';
    document.getElementById('time-slots-section').style.display = 'none';
    document.getElementById('confirmation-section').style.display = 'none';
    
    // Reset course selection
    document.querySelectorAll('.course-select-btn').forEach(btn => {
      btn.style.borderColor = '#e5e7eb';
      btn.style.background = 'white';
    });
    
    // Reload courses
    this.loadCourses();
  },

  async loadSubscriptions() {
    const container = document.getElementById('subscriptions-list');
    container.innerHTML = '<div class="loading"><div class="spinner"></div></div>';
    
    const response = await fetch(`${API_BASE}/subscriptions`, { credentials: 'include' });
    const result = await response.json();
    
    if (result.success && result.data?.length > 0) {
      container.innerHTML = result.data.map(sub => `
        <div class="booking-item">
          <div class="booking-icon"><i class="fas fa-id-card"></i></div>
          <div class="booking-details">
            <div class="booking-title">${sub.name}</div>
            <div class="booking-meta">
              <span><i class="fas fa-calendar-plus"></i> ${sub.start}</span> | 
              <span><i class="fas fa-calendar-minus"></i> ${sub.end}</span> | 
              <span><i class="fas fa-check-circle"></i> ${sub.attendances} attended</span>
            </div>
          </div>
          <span class="booking-status confirmed">Active</span>
        </div>
      `).join('');
    } else {
      container.innerHTML = `
        <div class="empty-state">
          <div class="empty-state-icon"><i class="fas fa-id-card"></i></div>
          <div class="empty-state-title">No active subscriptions</div>
          <div class="empty-state-text">Contact reception to purchase a subscription</div>
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
        <tr>
          <td colspan="2">
            <div class="empty-state">
              <div class="empty-state-icon"><i class="fas fa-clipboard-list"></i></div>
              <div class="empty-state-title">No attendance records</div>
            </div>
          </td>
        </tr>
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
          <div class="empty-state-title">No items in waitlist</div>
          <div class="empty-state-text">You're not waiting for any classes</div>
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
          <div class="empty-state-title">No cancellations</div>
          <div class="empty-state-text">You haven't cancelled any classes</div>
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
        display.innerHTML = result.data.svg;
      } else {
        display.innerHTML = '<p style="color: #6b7280;">Barcode not available</p>';
      }
    }
  }
};

document.addEventListener('DOMContentLoaded', () => App.init());
