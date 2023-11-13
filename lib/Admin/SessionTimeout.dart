import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_02_final/authentication/screens/login.dart';

class SessionTimeout {
  final BuildContext context;
  final int timeoutInSeconds;
  Timer? _timer;
  bool _userInteracted = false;

  SessionTimeout(this.context, this.timeoutInSeconds) {
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: timeoutInSeconds), _onTimeout);
    print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
  }

  void _onTimeout() {
    if (!_userInteracted) {
      _logout(); // Perform the logout action if the user didn't interact
    } else {
      _userInteracted =
          false; // Reset the userInteracted flag for the next timeout
      _resetTimer(); // Restart the timer if the user has interacted
    }
  }

  void _logout() {
    // Perform the logout action here (e.g., clear user session, go to the login screen)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login_screen()),
    );
  }

  void onUserInteraction() {
    _userInteracted = true;
    _resetTimer(); // Reset the timer on user interaction
  }

  // This method is named onActivityDetected, consistent with AdminHome usage
  void onActivityDetected() {
    onUserInteraction();
  }

  void dispose() {
    _timer?.cancel();
  }
}
