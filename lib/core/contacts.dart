import 'package:url_launcher/url_launcher.dart';

/// MDRRMO line residents reach from the app. TODO: confirm this number with the LGU.
const kRescueHotline = '(075) 562-2019';

/// Opens the phone dialer; returns false when the device can't place calls.
Future<bool> callNumber(String number) {
  return launchUrl(Uri(scheme: 'tel', path: number.replaceAll(RegExp(r'[^0-9+]'), '')));
}
