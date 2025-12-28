// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get colorSwitch => 'Choisissez la couleur de votre appli';

  @override
  String get languageSwitch => 'Choisissez votre language';

  @override
  String get addContact => 'Ajoutez';

  @override
  String get deleteContact => 'Supprimez';

  @override
  String get deleteAll => 'Supprimez tout';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get name => 'Nom';

  @override
  String get nameHint => 'Entrez le nom du contact';

  @override
  String get phoneNumber => 'Numero de tel';

  @override
  String get phoneNumberHint => 'Entrez le num de tel';

  @override
  String get bio => 'Biographie';

  @override
  String get bioHint => 'Ajoutez une biographie';

  @override
  String get submit => 'Ajoutez';

  @override
  String get writeMessage => 'Ecrivez votre message';

  @override
  String get phone => 'Num';

  @override
  String get lastTimeBackgroundMsg => 'Dernière mise en arrière-plan';

  @override
  String get seconds => 'secondes';

  @override
  String get hours => 'heures';

  @override
  String get noContactText => 'Ajoutez un contact et commencez une conversation !';

  @override
  String get telephonyInitErrorMsg => 'Veuillez Autoriser l\'appli !\nrafrechissez votre app et reesseyez';
}
