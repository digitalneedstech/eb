import 'package:flutter/material.dart';

class MailSentPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Mail Sent",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
