# Swim College - Online Booking System

A modern web application for managing swim class bookings at Swim College. This project provides a Node.js API wrapper for the ASP.NET Swim College booking system, featuring a responsive web interface for members.

**Live:** [https://orestislef.gr/swim](https://orestislef.gr/swim)
**API Docs (Swagger):** [https://orestislef.gr/swim/docs](https://orestislef.gr/swim/docs)

## Features

- **Secure Authentication** - Login with existing Swim College credentials
- **Dashboard** - Overview of membership status, upcoming classes, and balance
- **Online Booking** - Book swim classes with interactive calendar and time slot selection
- **Course Management** - View available swim courses (Baby, A1, A2, E1, E2, Personal, Rehab, Aerobics, School, Yoga/Pilates)
- **Subscriptions** - View active membership subscriptions
- **Attendance History** - Track class attendance records
- **Waitlist** - Monitor waitlisted classes
- **Cancellations** - View and manage cancellation history
- **Digital Barcode** - Access member barcode for facility entry
- **Calendar Export** - Download .ics files for upcoming classes
- **Multi-language** - Greek and English support
- **Swagger API Docs** - Interactive API documentation at `/docs`

## Tech Stack

- **Backend**: Node.js, Express 5
- **Frontend**: Vanilla JavaScript, HTML5, CSS3
- **API Docs**: Swagger UI (swagger-ui-express)
- **External API**: ASP.NET Swim College booking system (scraped via cheerio + axios)

## Getting Started

### Prerequisites

- Node.js 18+
- npm
- Active Swim College account

### Installation

```bash
# Clone the repository
git clone https://github.com/orestislef/swim.git
cd swim

# Install dependencies
npm install
```

### Configuration

Create a `.env` file in the root directory:

```env
HOST=127.0.0.1
PORT=3001
```

### Running

```bash
# Start development server with auto-reload
npm run dev

# Or start production server
npm start
```

The application will be available at `http://localhost:3001`

## API Documentation

### Interactive Docs

Full interactive API documentation is available at **`/docs`** (Swagger UI):
- **Production:** [https://orestislef.gr/swim/docs](https://orestislef.gr/swim/docs)
- **Local:** [http://localhost:3001/docs](http://localhost:3001/docs)
- **JSON spec:** `/api/docs.json`

### Authentication Flow (for Mobile App Developers)

This API uses **cookie-based authentication**. Here's the complete flow:

#### 1. Login

```http
POST /swim/api/auth/login
Content-Type: application/json

{
  "username": "your_phone_number",
  "password": "your_password"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "message": "Login successful",
    "userData": {
      "name": "John Doe",
      "expiry": "31/03/2026",
      "balance": "0.00"
    }
  }
}
```

**Important:** The response includes `Set-Cookie` headers:
```
Set-Cookie: authenticated=true; HttpOnly; Max-Age=86400
Set-Cookie: cookies=["ASP.NET_SessionId=...", ...]; HttpOnly; Max-Age=86400
```

#### 2. Using Authenticated Endpoints

For **web browsers**, cookies are sent automatically with `credentials: 'include'`.

For **mobile apps** (Flutter, React Native, Swift, Kotlin), you must:
1. Capture the `Set-Cookie` headers from the login response
2. Store the cookie values
3. Include them in all subsequent requests via the `Cookie` header

```http
GET /swim/api/dashboard
Cookie: authenticated=true; cookies=["ASP.NET_SessionId=...", ...]
```

#### 3. Check Auth Status

```http
GET /swim/api/auth/status
Cookie: authenticated=true; cookies=[...]
```

**Response:**
```json
{
  "success": true,
  "authenticated": true
}
```

#### 4. Logout

```http
POST /swim/api/auth/logout
Cookie: authenticated=true; cookies=[...]
```

#### Session Expiry
- Cookies expire after **24 hours**
- If any protected endpoint returns `401`, redirect to login
- The upstream ASP.NET session may expire sooner

### API Endpoints Reference

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/api/health` | GET | No | Health check |
| `/api/auth/login` | POST | No | Login (sets cookies) |
| `/api/auth/logout` | POST | No | Logout (clears cookies) |
| `/api/auth/status` | GET | No | Check if authenticated |
| `/api/dashboard` | GET | Yes | Dashboard data (name, expiry, balance) |
| `/api/bookings` | GET | Yes | All bookings (past + upcoming) |
| `/api/booking/calendar` | GET | Yes | Calendar availability |
| `/api/booking/slots` | GET | Yes | Time slots for a date |
| `/api/booking/book` | POST | Yes | Book a class |
| `/api/booking/cancel` | POST | Yes | Cancel a booking |
| `/api/courses` | GET | Yes | Available course types |
| `/api/subscriptions` | GET | Yes | User subscriptions |
| `/api/attendances` | GET | Yes | Attendance history |
| `/api/waitlist` | GET | Yes | Waitlist entries |
| `/api/cancellations` | GET | Yes | Cancellation history |
| `/api/barcode` | GET | Yes | Member barcode (code + SVG) |
| `/api/users` | GET | Yes | User profile |

### Booking Flow

The booking process follows these steps:

```
1. GET /api/courses          → Get available course types (e.g., BABY, A1, A2)
2. GET /api/booking/slots    → Get time slots for a date + course type
   ?date=2026-02-11&courseType=BABY
3. POST /api/booking/book    → Book a specific slot
   { "date": "2026-02-11", "courseType": "BABY", "slotId": "12345" }
```

**Slot response example:**
```json
{
  "success": true,
  "slots": [
    {
      "id": "12345",
      "course": "BABY SWIMMING",
      "date": "11/02/2026",
      "time": "10:00 - 11:00",
      "teacher": "Maria K.",
      "persons": 3,
      "canBook": true,
      "status": "available"
    },
    {
      "id": "12346",
      "course": "BABY SWIMMING",
      "date": "11/02/2026",
      "time": "11:00 - 12:00",
      "teacher": "Nikos P.",
      "persons": 8,
      "canBook": false,
      "status": "available"
    }
  ]
}
```

### Cancel Booking Flow

```
1. GET /api/bookings                    → Find booking ID
2. POST /api/booking/cancel             → Cancel by ID
   { "bookingId": "67890" }
```

## Project Structure

```
swim/
├── server.js                # Express server entry point
├── swagger.js               # Swagger/OpenAPI spec definition
├── routes/
│   ├── api.js              # Health check & info routes
│   ├── auth.js             # Authentication routes (login/logout/status)
│   ├── dashboard.js        # Dashboard data
│   ├── bookings.js         # List bookings
│   ├── booking.js          # Book/cancel/slots actions
│   ├── courses.js          # Course types
│   ├── subscriptions.js    # Subscriptions
│   ├── attendances.js      # Attendance records
│   ├── waitlist.js         # Waitlist
│   ├── cancellations.js    # Cancellation history
│   ├── barcode.js          # Member barcode
│   └── users.js            # User profile
├── services/
│   ├── swimCollegeService.js  # Core ASP.NET scraper (login, dashboard, etc.)
│   └── bookingService.js      # Booking scraper (slots, book, cancel)
├── www/                    # Static web files
│   ├── index.html          # Main SPA
│   ├── css/styles.css      # Styles
│   ├── js/app.js           # Frontend JavaScript
│   └── images/logo.png     # Logo
├── .env                    # Environment variables
├── .gitignore              # Git ignore rules
└── package.json            # npm dependencies
```

## Deployment

The app is deployed on an Ubuntu server with:
- **systemd** service (`swim.service`)
- **Apache** reverse proxy: `/swim/` → `localhost:3001`
- Node.js via nvm

## Language Support

Supports **Greek** and **English**. Default language is Greek. Switch via the language selector in the top-right corner.

## License

ISC License

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Support

For issues related to the Swim College booking system, please contact Swim College directly.
For issues with this wrapper, please open an issue on GitHub.
