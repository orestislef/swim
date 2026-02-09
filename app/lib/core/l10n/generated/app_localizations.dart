import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('el'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Swim College'**
  String get appTitle;

  /// No description provided for @onlineBooking.
  ///
  /// In en, this message translates to:
  /// **'Online Booking System'**
  String get onlineBooking;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classes;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @waitlist.
  ///
  /// In en, this message translates to:
  /// **'Waitlist'**
  String get waitlist;

  /// No description provided for @cancellations.
  ///
  /// In en, this message translates to:
  /// **'Cancellations'**
  String get cancellations;

  /// No description provided for @myBarcode.
  ///
  /// In en, this message translates to:
  /// **'My Barcode'**
  String get myBarcode;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Here\'s your overview.'**
  String get overview;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @upcomingClasses.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Classes'**
  String get upcomingClasses;

  /// No description provided for @allBookings.
  ///
  /// In en, this message translates to:
  /// **'All Bookings'**
  String get allBookings;

  /// No description provided for @bookClass.
  ///
  /// In en, this message translates to:
  /// **'Book a Class'**
  String get bookClass;

  /// No description provided for @selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select date and time to book your swim'**
  String get selectDateTime;

  /// No description provided for @step1ChooseType.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Choose Class Type'**
  String get step1ChooseType;

  /// No description provided for @step2SelectDate.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Date'**
  String get step2SelectDate;

  /// No description provided for @step3SelectTime.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Select Time Slot'**
  String get step3SelectTime;

  /// No description provided for @step4Confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get step4Confirm;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @yourBooking.
  ///
  /// In en, this message translates to:
  /// **'Your Booking'**
  String get yourBooking;

  /// No description provided for @noClasses.
  ///
  /// In en, this message translates to:
  /// **'No Classes'**
  String get noClasses;

  /// No description provided for @selectedDate.
  ///
  /// In en, this message translates to:
  /// **'Selected Date'**
  String get selectedDate;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @startOver.
  ///
  /// In en, this message translates to:
  /// **'Start Over'**
  String get startOver;

  /// No description provided for @mySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get mySubscriptions;

  /// No description provided for @activeMemberships.
  ///
  /// In en, this message translates to:
  /// **'Active Subscriptions'**
  String get activeMemberships;

  /// No description provided for @attendanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Attendance History'**
  String get attendanceHistory;

  /// No description provided for @trackAttendance.
  ///
  /// In en, this message translates to:
  /// **'Track your class attendance'**
  String get trackAttendance;

  /// No description provided for @attendanceRecords.
  ///
  /// In en, this message translates to:
  /// **'Attendance Records'**
  String get attendanceRecords;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @waitlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Waitlist'**
  String get waitlistTitle;

  /// No description provided for @waitlistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Classes you\'re waiting for'**
  String get waitlistSubtitle;

  /// No description provided for @yourWaitlist.
  ///
  /// In en, this message translates to:
  /// **'Your Waitlist'**
  String get yourWaitlist;

  /// No description provided for @cancellationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellations'**
  String get cancellationsTitle;

  /// No description provided for @cancellationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cancelled class history'**
  String get cancellationsSubtitle;

  /// No description provided for @cancellationHistory.
  ///
  /// In en, this message translates to:
  /// **'Cancellation History'**
  String get cancellationHistory;

  /// No description provided for @showAtEntrance.
  ///
  /// In en, this message translates to:
  /// **'Show this at the entrance'**
  String get showAtEntrance;

  /// No description provided for @presentBarcode.
  ///
  /// In en, this message translates to:
  /// **'Present this barcode when entering the facility'**
  String get presentBarcode;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @programExpires.
  ///
  /// In en, this message translates to:
  /// **'Program Expires'**
  String get programExpires;

  /// No description provided for @accountBalance.
  ///
  /// In en, this message translates to:
  /// **'Account Balance'**
  String get accountBalance;

  /// No description provided for @noUpcomingClasses.
  ///
  /// In en, this message translates to:
  /// **'No upcoming classes'**
  String get noUpcomingClasses;

  /// No description provided for @bookFirstClass.
  ///
  /// In en, this message translates to:
  /// **'Book your first class to get started'**
  String get bookFirstClass;

  /// No description provided for @noBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get noBookings;

  /// No description provided for @startBooking.
  ///
  /// In en, this message translates to:
  /// **'Start by booking your first class'**
  String get startBooking;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelBookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get cancelBookingConfirm;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled successfully!'**
  String get bookingCancelled;

  /// No description provided for @bookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Booking failed: '**
  String get bookingFailed;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @signInProgress.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signInProgress;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @classType.
  ///
  /// In en, this message translates to:
  /// **'Class Type'**
  String get classType;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @bookingInfo.
  ///
  /// In en, this message translates to:
  /// **'This booking will be confirmed after payment at reception.'**
  String get bookingInfo;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking successful!'**
  String get bookingSuccess;

  /// No description provided for @bookingSuccessDetails.
  ///
  /// In en, this message translates to:
  /// **'Please pay at reception and show your barcode.'**
  String get bookingSuccessDetails;

  /// No description provided for @noCourses.
  ///
  /// In en, this message translates to:
  /// **'No courses available'**
  String get noCourses;

  /// No description provided for @spots.
  ///
  /// In en, this message translates to:
  /// **'spots'**
  String get spots;

  /// No description provided for @full.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get full;

  /// No description provided for @noActiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No active subscriptions'**
  String get noActiveSubscriptions;

  /// No description provided for @contactReception.
  ///
  /// In en, this message translates to:
  /// **'Contact reception to purchase a subscription'**
  String get contactReception;

  /// No description provided for @noAttendance.
  ///
  /// In en, this message translates to:
  /// **'No attendance records'**
  String get noAttendance;

  /// No description provided for @noWaitlist.
  ///
  /// In en, this message translates to:
  /// **'No items in waitlist'**
  String get noWaitlist;

  /// No description provided for @noWaitlistText.
  ///
  /// In en, this message translates to:
  /// **'You\'re not waiting for any classes'**
  String get noWaitlistText;

  /// No description provided for @noCancellations.
  ///
  /// In en, this message translates to:
  /// **'No cancellations'**
  String get noCancellations;

  /// No description provided for @noCancellationsText.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t cancelled any classes'**
  String get noCancellationsText;

  /// No description provided for @barcodeNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Barcode not available'**
  String get barcodeNotAvailable;

  /// No description provided for @pleaseEnterBoth.
  ///
  /// In en, this message translates to:
  /// **'Please enter both username and password'**
  String get pleaseEnterBoth;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please try again.'**
  String get connectionError;

  /// No description provided for @activeMember.
  ///
  /// In en, this message translates to:
  /// **'Active Member'**
  String get activeMember;

  /// No description provided for @bookingStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingStatusPending;

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingStatusCancelled;

  /// No description provided for @bookingStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get bookingStatusActive;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @greek.
  ///
  /// In en, this message translates to:
  /// **'Ελληνικά'**
  String get greek;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @inHours.
  ///
  /// In en, this message translates to:
  /// **'in {n} hours'**
  String inHours(int n);

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'in {n} days'**
  String inDays(int n);

  /// No description provided for @subscriptionName.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionName;

  /// No description provided for @subscriptionStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get subscriptionStart;

  /// No description provided for @subscriptionEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get subscriptionEnd;

  /// No description provided for @subscriptionAttendances.
  ///
  /// In en, this message translates to:
  /// **'Attendances'**
  String get subscriptionAttendances;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get reminders before your classes'**
  String get notificationsDescription;

  /// No description provided for @notification24h.
  ///
  /// In en, this message translates to:
  /// **'24h before class'**
  String get notification24h;

  /// No description provided for @notification1h.
  ///
  /// In en, this message translates to:
  /// **'1h before class'**
  String get notification1h;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navDashboard;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navBookClass.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get navBookClass;

  /// No description provided for @navBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get navBarcode;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @notificationTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow: {course} at {time}'**
  String notificationTomorrow(String course, String time);

  /// No description provided for @notificationSoon.
  ///
  /// In en, this message translates to:
  /// **'Starting soon! {course} in 1 hour'**
  String notificationSoon(String course);

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['el', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
