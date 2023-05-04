import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});
  static String verificationId = '';

  @override
  OTPState createState() => OTPState();
}

class OTPState extends State<OTP> {
  var code = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset('assets/images/Blackcoffer-logo-new.png'),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Pinput(
                            onChanged: (String value) {
                              code = value;
                            },
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.none,
                            length: 6,
                            onSubmitted: (String text) => showSnackBar(text),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: OTP.verificationId,
                              smsCode: code);
                      await _auth.signInWithCredential(credential);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (Route route) => route.isFirst);
                    } catch (e) {
                      // _showSnackBar('Invalid OTP');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ));
  }
}

Widget showSnackBar(String text) {
  return SnackBar(
    duration: const Duration(seconds: 4),
    content: SizedBox(
      height: 80.0,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 25.0),
        ),
      ),
    ),
    backgroundColor: Colors.green,
  );
}
