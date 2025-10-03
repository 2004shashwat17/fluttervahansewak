import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome': 'Welcome To Vahan Sewak',
      'tagline': 'Delhi NCR\'s Trusted Vehicle Assistant',
      'vehicleBreakdown': 'Vehicle Breakdown?',
      'getHelp': 'Get help from verified mechanics near you in minutes',
      'getHelpNow': 'Get help now',
      'verifiedMechanics': 'Verified Mechanics',
      'minResponse': '15 Min Response',
      'rating': '4.8 Rating',
      'emergency': 'Emergency',
      'history': 'History',
      'profile': 'Profile',
      'chooseRole': 'Choose Your Role',
      'customer': 'I\'m a Customer',
      'customerDesc': 'Need help with vehicle breakdown',
      'mechanic': 'I\'m a Mechanic',
      'mechanicDesc': 'Help customers with their vehicles',
      'problem': 'What\'s the problem?',
      'selectIssue': 'Select the issue you\'re experiencing:',
      'engineIssues': 'Engine Issues',
      'brakeIssues': 'Brake Issues',
      'fuelIssues': 'Fuel Issues',
      'tirePuncture': 'Tire Puncture',
      'lockIssues': 'Lock/Unlock Issues',
      'electricalIssues': 'Electrical Issues',
      'engineLight': 'Engine Light',
      'towMe': 'Tow Me',
      'other': 'Other / Not Sure',
    },
    'hi': {
      'welcome': 'वहन सेवक में आपका स्वागत है',
      'tagline': 'दिल्ली एनसीआर का भरोसेमंद वाहन सहायक',
      'vehicleBreakdown': 'वाहन खराब?',
      'getHelp': 'अपने आस-पास के सत्यापित मैकेनिक से मिनटों में मदद पाएं',
      'getHelpNow': 'अभी मदद लें',
      'verifiedMechanics': 'सत्यापित मैकेनिक',
      'minResponse': '15 मिनट जवाब',
      'rating': '4.8 रेटिंग',
      'emergency': 'आपातकाल',
      'history': 'इतिहास',
      'profile': 'प्रोफ़ाइल',
      'chooseRole': 'अपनी भूमिका चुनें',
      'customer': 'मैं एक ग्राहक हूं',
      'customerDesc': 'वाहन खराबी में मदद चाहिए',
      'mechanic': 'मैं एक मैकेनिक हूं',
      'mechanicDesc': 'ग्राहकों के वाहनों की मदद करें',
      'problem': 'समस्या क्या है?',
      'selectIssue': 'आप जिस समस्या का सामना कर रहे हैं उसे चुनें:',
      'engineIssues': 'इंजन की समस्या',
      'brakeIssues': 'ब्रेक की समस्या',
      'fuelIssues': 'ईंधन की समस्या',
      'tirePuncture': 'टायर पंचर',
      'lockIssues': 'लॉक/अनलॉक समस्या',
      'electricalIssues': 'बिजली की समस्या',
      'engineLight': 'इंजन लाइट',
      'towMe': 'मुझे खींचें',
      'other': 'अन्य / निश्चित नहीं',
    },
  };

  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get tagline => _localizedValues[locale.languageCode]!['tagline']!;
  String get vehicleBreakdown => _localizedValues[locale.languageCode]!['vehicleBreakdown']!;
  String get getHelp => _localizedValues[locale.languageCode]!['getHelp']!;
  String get getHelpNow => _localizedValues[locale.languageCode]!['getHelpNow']!;
  String get verifiedMechanics => _localizedValues[locale.languageCode]!['verifiedMechanics']!;
  String get minResponse => _localizedValues[locale.languageCode]!['minResponse']!;
  String get rating => _localizedValues[locale.languageCode]!['rating']!;
  String get emergency => _localizedValues[locale.languageCode]!['emergency']!;
  String get history => _localizedValues[locale.languageCode]!['history']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get chooseRole => _localizedValues[locale.languageCode]!['chooseRole']!;
  String get customer => _localizedValues[locale.languageCode]!['customer']!;
  String get customerDesc => _localizedValues[locale.languageCode]!['customerDesc']!;
  String get mechanic => _localizedValues[locale.languageCode]!['mechanic']!;
  String get mechanicDesc => _localizedValues[locale.languageCode]!['mechanicDesc']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}