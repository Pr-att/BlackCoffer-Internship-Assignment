import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/signIn', (Route route) => route.isFirst);
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
      body: Center(
      child: Column(
        children: const [
          Text('Home Page'),
        ],
      ),
    )
    );
  }
}
