import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/superbase_config.dart' show SupabaseConfig;
import 'package:frontend/widgets/inputfield.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool loginOrRegister = true;
  void toggleLoginOrRegister() {
    setState(() {
      loginOrRegister = !loginOrRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6D93c2),
      body: Consumer<SupabaseConfig>(
        builder: (context, supabase, child) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(20),
              width: InfoPanelDimensions.infoPanelWidth(context),
              height: InfoPanelDimensions.infoPanelHeight(context),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff7092BE).withValues(alpha: 0.7),
                    spreadRadius: 5,
                    blurRadius: 1,
                    offset: Offset(-3, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(
                  AppDimensions.infoPanelBorderRadius,
                ),
                border: Border.all(color: Colors.black),
                color: Color(0xffA7BFDC),
              ),
              child: loginOrRegister
                  ? Login(toggleLogin: toggleLoginOrRegister)
                  : Register(toggleFunction: toggleLoginOrRegister),
            ),
          );
        },
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key, required this.toggleLogin});
  final Function toggleLogin;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String emailValue = "";
  String passwordValue = "";
  @override
  Widget build(BuildContext context) {
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: true);
    return Column(
      children: [
        InputField(
          title: email,
          onChanged: (value) {
            setState(() {
              emailValue = value;
            });
          },
        ),
        SizedBox(height: 15),
        InputField(
          title: password,
          obscureText: true,
          onChanged: (value) {
            setState(() {
              passwordValue = value;
            });
          },
        ),
        Spacer(),

        ElevatedButton(
          onPressed: () async {
            final response = await supabaseConfig.signInWithEmail(
              emailValue,
              passwordValue,
            );
            if (response) {
              supabaseConfig.successfulLogin();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: blue1,
            minimumSize: const Size(400, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(style: TextStyle(color: Colors.black), loginButton),
        ),

        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.toggleLogin();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: blue1,
            minimumSize: const Size(400, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(style: TextStyle(color: Colors.black), registerButton),
        ),
      ],
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key, required this.toggleFunction});
  final Function toggleFunction;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String userNameValue = "";
  String passwordValue = "";
  String emailValue = "";
  @override
  Widget build(BuildContext context) {
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: true);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputField(
          title: email,
          onChanged: (value) {
            setState(() {
              emailValue = value;
            });
          },
        ),
        SizedBox(height: 15),
        InputField(
          title: password,
          obscureText: true,
          onChanged: (value) {
            setState(() {
              passwordValue = value;
            });
          },
        ),
        SizedBox(height: 15),
        InputField(
          title: username,
          onChanged: (value) {
            setState(() {
              userNameValue = value;
            });
          },
        ),

        Spacer(),
        ElevatedButton(
          onPressed: () async {
            final successfulRegistration = await supabaseConfig.signUpWithEmail(
              emailValue,
              passwordValue,
              userNameValue,
            );
            if (successfulRegistration) {
              widget.toggleFunction();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: blue1,
            minimumSize: const Size(400, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(style: TextStyle(color: Colors.black), signUpButton),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            widget.toggleFunction();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: blue1,
            minimumSize: const Size(400, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(style: TextStyle(color: Colors.black), back),
        ),
      ],
    );
  }
}
