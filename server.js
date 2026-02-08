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
const HOST = process.env.HOST || '0.0.0.0';
const PORT = process.env.PORT || 3000;

app.listen(PORT, HOST, () => {
  console.log(`🏊 Swim College API running on http://${HOST}:${PORT}`);
  console.log(`📋 Health check: http://${HOST}:${PORT}/api/health`);
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
