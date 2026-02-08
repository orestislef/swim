# Swim College - Online Booking System

A modern web application for managing swim class bookings at Swim College. This project provides a Node.js API wrapper for the ASP.NET Swim College booking system, featuring a responsive web interface for members.

## Features

- **Secure Authentication** - Login with existing Swim College credentials
- **Dashboard** - Overview of membership status, upcoming classes, and balance
- **Online Booking** - Book swim classes with interactive calendar
- **Course Management** - View available swim courses (Baby, A1, A2, E1, E2, Personal, Rehab, Aerobics, School, Yoga/Pilates)
- **Subscriptions** - View active membership subscriptions
- **Attendance History** - Track class attendance records
- **Waitlist** - Monitor waitlisted classes
- **Cancellations** - View cancellation history
- **Digital Barcode** - Access member barcode for facility entry

## Tech Stack

- **Backend**: Node.js, Express.js
- **Frontend**: Vanilla JavaScript, HTML5, CSS3
- **External API**: ASP.NET Swim College booking system

## Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn
- Active Swim College account

### Installation

```bash
# Clone the repository
git clone https://github.com/orestislef/swim.git
cd swim

# Install dependencies
npm install

# Configure environment variables
# Edit .env file with your Swim College credentials
```

### Configuration

Create a `.env` file in the root directory:

```env
SWIM_API_BASE_URL=https://www.my-cloud.gr/www.swimcollege.gr
SWIM_LOGIN_URL=https://www.my-cloud.gr/www.swimcollege.gr/login.aspx
PORT=3000
```

### Running

```bash
# Start development server with auto-reload
npm run dev

# Or start production server
npm start
```

The application will be available at `http://localhost:3000`

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/auth/login` | POST | User login |
| `/api/auth/logout` | POST | User logout |
| `/api/auth/status` | GET | Check authentication status |
| `/api/dashboard` | GET | Get dashboard data |
| `/api/bookings` | GET | Get all bookings |
| `/api/booking/book` | POST | Create new booking |
| `/api/booking/cancel` | POST | Cancel a booking |
| `/api/courses` | GET | Get available courses |
| `/api/subscriptions` | GET | Get user subscriptions |
| `/api/attendances` | GET | Get attendance history |
| `/api/waitlist` | GET | Get waitlist items |
| `/api/cancellations` | GET | Get cancellation history |
| `/api/barcode` | GET | Get member barcode |
| `/api/users` | GET | Get user profile |

## Project Structure

```
swim/
├── server.js              # Express server entry point
├── routes/
│   ├── api.js            # API routes configuration
│   ├── auth.js           # Authentication routes
│   ├── dashboard.js      # Dashboard data routes
│   ├── bookings.js       # Bookings routes
│   ├── booking.js        # Booking actions routes
│   ├── courses.js        # Courses routes
│   ├── subscriptions.js  # Subscriptions routes
│   ├── attendances.js    # Attendances routes
│   ├── waitlist.js       # Waitlist routes
│   ├── cancellations.js  # Cancellations routes
│   ├── barcode.js        # Barcode routes
│   └── users.js          # User routes
├── services/
│   └── swimCollegeService.js  # Swim College API wrapper
├── www/                  # Static web files
│   ├── index.html        # Main application HTML
│   ├── css/
│   │   └── styles.css   # Application styles
│   ├── js/
│   │   └── app.js       # Frontend JavaScript
│   └── images/
│       └── logo.png      # Swim College logo
├── .env                  # Environment variables
├── .gitignore           # Git ignore rules
└── package.json         # npm dependencies
```

## Language Support

This application supports both **Greek (Ελληνικά)** and **English** languages.

- Default language: **Greek**
- Switch between languages using the language selector in the top navigation

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
