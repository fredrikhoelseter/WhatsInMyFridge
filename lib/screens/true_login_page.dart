import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:whats_in_my_fridge/screens/register_page.dart';

import '../responsive/mobile_screen_layout.dart';
import '../utilities/fire_auth.dart';
import '../utilities/validator.dart';

class TrueLoginPage extends StatefulWidget {
  const TrueLoginPage({Key? key}) : super(key: key);

  @override
  State<TrueLoginPage> createState() => _TrueLoginPageState();
}

class _TrueLoginPageState extends State<TrueLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    appBar:
    AppBar(
      title: Text(
        'Whats in my fridge',
        style: GoogleFonts.pacifico(fontSize: 28),
      ),
      centerTitle: true,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Whats in my fridge", style: GoogleFonts.pacifico(fontSize: 28)),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Login',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailTextController,
                  focusNode: _focusEmail,
                  validator: (value) => Validator.validateEmail(
                    email: value,
                  ),
                  decoration: InputDecoration(
                    hintText: "Email",
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordTextController,
                  focusNode: _focusPassword,
                  obscureText: true,
                  validator: (value) => Validator.validatePassword(
                    password: value,
                  ),
                  decoration: InputDecoration(
                    hintText: "Password",
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                _isProcessing
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                _focusEmail.unfocus();
                                _focusPassword.unfocus();

                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  User? user =
                                      await FireAuth.signInUsingEmailPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                  );

                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  if (user != null) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MobileScreenLayout(user: user),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(width: 24.0),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: () {
                    final provider =
                        Provider.of<FireAuth>(context, listen: false);
                    provider.googleLogin();
                  },
                  child: Image(
                    image: AssetImage("assets/images/google_logo.png"),
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
