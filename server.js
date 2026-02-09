require("dotenv").config();

const express = require("express");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const path = require("path");
const swaggerUi = require("swagger-ui-express");
const swaggerSpec = require("./swagger");
const swimCollegeService = require("./services/swimCollegeService");
const apiRoutes = require("./routes/api");
const authRoutes = require("./routes/auth");
const dashboardRoutes = require("./routes/dashboard");
const bookingsRoutes = require("./routes/bookings");
const coursesRoutes = require("./routes/courses");
const subscriptionsRoutes = require("./routes/subscriptions");
const attendancesRoutes = require("./routes/attendances");
const waitlistRoutes = require("./routes/waitlist");
const cancellationsRoutes = require("./routes/cancellations");
const barcodeRoutes = require("./routes/barcode");
const usersRoutes = require("./routes/users");
const bookingRoutes = require("./routes/booking");

const app = express();
const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Attach swimCollegeService to request
app.use((req, res, next) => {
  req.swimCollegeService = swimCollegeService;
  next();
});

// Swagger API docs at /docs
app.use("/docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
  customCss: '.swagger-ui .topbar { display: none }',
  customSiteTitle: 'Swim College API Docs'
}));

// Serve swagger spec as JSON
app.get("/api/docs.json", (req, res) => {
  res.json(swaggerSpec);
});

// Static files
app.use(express.static(path.join(__dirname, "www")));

// Auth middleware for protected routes
const requireAuth = (req, res, next) => {
  if (req.cookies?.authenticated !== 'true') {
    return res.status(401).json({ success: false, error: 'Not authenticated' });
  }
  next();
};

// API routes
app.use("/api", apiRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/dashboard", requireAuth, dashboardRoutes);
app.use("/api/bookings", requireAuth, bookingsRoutes);
app.use("/api/courses", requireAuth, coursesRoutes);
app.use("/api/subscriptions", requireAuth, subscriptionsRoutes);
app.use("/api/attendances", requireAuth, attendancesRoutes);
app.use("/api/waitlist", requireAuth, waitlistRoutes);
app.use("/api/cancellations", requireAuth, cancellationsRoutes);
app.use("/api/barcode", requireAuth, barcodeRoutes);
app.use("/api/users", requireAuth, usersRoutes);
app.use("/api/booking", requireAuth, bookingRoutes);

// Fallback to index.html for SPA
app.get("/{*path}", (req, res) => {
  res.sendFile(path.join(__dirname, "www", "index.html"));
});

app.listen(PORT, HOST, () => {
  console.log(`Swim College API running on http://${HOST}:${PORT}`);
});

module.exports = app;
