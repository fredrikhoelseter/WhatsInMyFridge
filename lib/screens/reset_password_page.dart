import 'package:flutter/material.dart';
import 'package:whats_in_my_fridge/utilities/fire_auth.dart';
import '../utilities/validator.dart';

//The UI of this page is taken from https://github.com/dev-tayy/fuzzy-eureka/tree/master/lib/screens with some changes.
//Using our methods to reset password and validate.
class ResetPasswordPage extends StatefulWidget {
  static const String id = 'reset_password';
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordScreenPage();
}

class _ResetPasswordScreenPage extends State<ResetPasswordPage> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = FireAuth();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
                const SizedBox(height: 70),
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please enter your email address to recover your password.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Email address',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  controller: _emailController,
                  validator: (value) => Validator.validateEmail(
                    email: value,
                  ),
                ),
                const SizedBox(height: 16),
                const Expanded(child: SizedBox()),
                Center(
                    child: ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      final _status =
                          await _authService.resetPasswordNotSignedIn(
                              email: _emailController.text.trim());
                    }
                  },
                  child: Text('Reset password',
                      style: TextStyle(color: Colors.white)),
                )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
