import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  static void launchWhatsApp(
    BuildContext context, {
    required String phoneNumber,
    String? msg,
  }) async {
    String whatsappUrl = "whatsapp://send?phone=$phoneNumber";
    if (msg != null) {
      whatsappUrl += "&text=$msg";
    }
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      launchUrl(Uri.parse(whatsappUrl));
    } else {
      debugPrint("Could not launch Email with $phoneNumber");
    }
  }

  static void launchPhoneApp(BuildContext context, {required String phoneNumber}) async {
    String phone = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(phone))) {
      await launchUrl(Uri.parse(phone));
    } else {
      debugPrint("Could not launch Phone with $phoneNumber");
    }
  }

  static void launchEmailApp(BuildContext context, {required String email}) async {
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: email);

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      debugPrint("Could not launch Email with $email");
    }
  }
}
