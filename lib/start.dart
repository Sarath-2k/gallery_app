import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:gallery_app/main.dart';
import 'package:local_auth/local_auth.dart';

import 'home.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyPart(context),
    );
  }

  BodyPart(BuildContext context) {
    if (appLock == true) {
      showLockScreen(
        context: context,
        correctString: '1234',
        canBiometric: true,
        showBiometricFirst: true,
        biometricAuthenticate: (_) async {
          final localAuth = LocalAuthentication();
          final didAuthenticate = await localAuth.authenticateWithBiometrics(
              localizedReason: 'Please authenticate');

          if (didAuthenticate) {
            return true;
          }

          return false;
        },
        onUnlocked: () {},
      );
    } else {
      return Home();
    }
  }
}
