// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get colorSwitch => 'Choose your app color';

  @override
  String get languageSwitch => 'Choose your language';

  @override
  String get addContact => 'Add';

  @override
  String get deleteContact => 'remove';

  @override
  String get deleteAll => 'remove All';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'Enter your contact name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberHint => 'Enter phone number';

  @override
  String get bio => 'Biography';

  @override
  String get bioHint => 'Add a biography';

  @override
  String get submit => 'Submit';

  @override
  String get writeMessage => 'Write a message';

  @override
  String get phone => 'Phone';
}
