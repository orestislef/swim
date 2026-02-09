# Swim College App

Native Flutter booking app for Swim College. Manage lesson bookings, view subscriptions, track attendance, and more.

## Features

- **Dashboard** - Overview of upcoming lessons and user info
- **Bookings** - View and cancel booked lessons
- **Book a Class** - Browse available slots and book new lessons
- **Barcode** - Personal barcode for facility entrance
- **Subscriptions** - View active subscriptions
- **Attendance** - Track attendance history
- **Waitlist** - Monitor waitlisted classes
- **Cancellations** - View cancelled bookings
- **Profile** - User profile management
- **Settings** - Theme (dark/light), language, and notifications toggle
- **Notifications** - Scheduled reminders 24h and 1h before lessons
- **Offline detection** - Banner when internet is unavailable
- **Localization** - English and Greek

## Tech Stack

| Category | Library |
|---|---|
| State management | flutter_riverpod |
| Routing | go_router |
| HTTP client | dio + dio_cookie_manager |
| Notifications | flutter_local_notifications |
| Barcode | barcode_widget + flutter_svg |
| Storage | shared_preferences |
| Connectivity | connectivity_plus |
| Localization | flutter_localizations + intl |

## Project Structure

```
lib/
├── core/           # Constants, router, localization, shared widgets
├── data/           # API client, models, repositories
├── features/       # Feature modules (screens + providers)
│   ├── auth/
│   ├── barcode/
│   ├── book_class/
│   ├── bookings/
│   ├── dashboard/
│   ├── profile/
│   └── settings/
└── services/       # Notification service
```

## Getting Started

### Prerequisites

- Flutter SDK >= 3.10.4
- Android Studio / Xcode for device emulators

### Setup

```bash
flutter pub get
flutter run
```

### API

The app connects to the backend at `https://orestislef.gr/swim/api`. See the server project in the parent `swim/` directory.

## Localization

Supported languages: **English** (`en`), **Greek** (`el`).

To regenerate localization files after editing `.arb` files:

```bash
flutter gen-l10n
```
