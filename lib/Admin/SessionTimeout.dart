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
  }

  void _onTimeout() {
    if (!_userInteracted) {
      _logout(); // Perform the logout action if user didn't interact
    } else {
      _userInteracted =
          false; // Reset the userInteracted flag for the next timeout
      _resetTimer(); // Restart the timer if user has interacted
    }
  }

  void _logout() {
    // Perform the logout action here (e.g., clear user session, go to login screen)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login_screen()),
    );
  }

  void onUserInteraction() {
    _userInteracted = true;
  }

  // Call this method to reset the timer on user activity
  void onActivityDetected() {
    _userInteracted =
        true; // Set the userInteracted flag to true on user activity
    _resetTimer();
  }

  void dispose() {
    _timer?.cancel();
  }
}
