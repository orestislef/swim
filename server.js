require('dotenv').config();

const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const path = require('path');
const swimCollegeService = require('./services/swimCollegeService');
const apiRoutes = require('./routes/api');
const authRoutes = require('./routes/auth');
const dashboardRoutes = require('./routes/dashboard');
const bookingsRoutes = require('./routes/bookings');
const coursesRoutes = require('./routes/courses');
const subscriptionsRoutes = require('./routes/subscriptions');
const attendancesRoutes = require('./routes/attendances');
const waitlistRoutes = require('./routes/waitlist');
const cancellationsRoutes = require('./routes/cancellations');
const barcodeRoutes = require('./routes/barcode');
const usersRoutes = require('./routes/users');
const bookingRoutes = require('./routes/booking');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({
  origin: true,
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

app.use((req, res, next) => {
  req.swimCollegeService = swimCollegeService;
  next();
});

app.use('/api', apiRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use('/api/bookings', bookingsRoutes);
app.use('/api/courses', coursesRoutes);
app.use('/api/subscriptions', subscriptionsRoutes);
app.use('/api/attendances', attendancesRoutes);
app.use('/api/waitlist', waitlistRoutes);
app.use('/api/cancellations', cancellationsRoutes);
app.use('/api/barcode', barcodeRoutes);
app.use('/api/users', usersRoutes);
app.use('/api/booking', bookingRoutes);

app.use(express.static(path.join(__dirname, 'www')));

app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  res.status(500).json({
    success: false,
    error: 'Internal server error',
    message: err.message
  });
});

app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found'
  });
});

app.listen(PORT, () => {
  console.log(`🏊 Swim College API running on http://localhost:${PORT}`);
  console.log(`📋 Health check: http://localhost:${PORT}/api/health`);
  console.log(`🔐 Login: POST /api/auth/login with {username, password}`);
  console.log(`📅 Courses: GET /api/courses`);
  console.log(`📋 Bookings: GET /api/bookings`);
  console.log(`📋 Subscriptions: GET /api/subscriptions`);
  console.log(`✅ Attendances: GET /api/attendances`);
  console.log(`⏳ Waitlist: GET /api/waitlist`);
  console.log(`❌ Cancellations: GET /api/cancellations`);
  console.log(`📊 Barcode: GET /api/barcode`);
});

module.exports = app;
