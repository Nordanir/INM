import 'package:flutter/material.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/providers/superbase_config.dart' show SupabaseConfig;
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
                    color: deepBlueHighLight.withValues(alpha: 0.7),
                    spreadRadius: 5,
                    blurRadius: 1,
                    offset: Offset(-3, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(
                  AppDimensions.infoPanelBorderRadius,
                ),
                border: Border.all(color: black),
                color: lightBlueHighlight,
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: false);
    return Column(
      children: [
        InputField(controller: emailController, title: email),
        SizedBox(height: 15),
        InputField(
          controller: passwordController,
          title: password,
          obscureText: true,
        ),
        Spacer(),

        ElevatedButton(
          onPressed: () async {
            final response = await supabaseConfig.signInWithEmail(
              emailController.text.trim(),
              passwordController.text.trim(),
            );

            _showSnackBar(response.$2, context);
            if (response.$1) {
              supabaseConfig.successfulLogin();

              emailController.dispose();
              passwordController.dispose();
            }
          },
          style: _authButtonStyle,
          child: Text(style: TextStyle(color: Colors.black), loginButton),
        ),

        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.toggleLogin();
            });
          },
          style: _authButtonStyle,
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
  final userNameController = TextEditingController();
  final passWordController = TextEditingController();
  final emailController = TextEditingController();

  void disableControllers() {
    userNameController.dispose();
    passWordController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputField(title: email, controller: emailController),
        SizedBox(height: 15),
        InputField(
          title: password,
          obscureText: true,
          controller: passWordController,
        ),
        SizedBox(height: 15),
        InputField(title: username, controller: userNameController),

        Spacer(),
        ElevatedButton(
          onPressed: () async {
            final response = await supabaseConfig.signUpWithEmail(
              emailController.text.trim(),
              passWordController.text.trim(),
              userNameController.text.trim(),
            );
            _showSnackBar(response.$2, context);
            if (response.$1) {
              widget.toggleFunction();
              disableControllers();
            }
          },
          style: _authButtonStyle,
          child: Text(style: TextStyle(color: Colors.black), signUpButton),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            widget.toggleFunction();
            disableControllers();
          },
          style: _authButtonStyle,
          child: Text(style: TextStyle(color: Colors.black), back),
        ),
      ],
    );
  }
}

class InputField extends StatefulWidget {
  final String title;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;

  const InputField({
    super.key,
    this.title = "Default",
    this.obscureText = false,
    this.onChanged,
    required this.controller,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: TextStyle(color: Colors.black, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(8.0),
            right: Radius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

ButtonStyle _authButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: blue1,
  minimumSize: const Size(400, 50),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
);

void _showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(duration: Duration(seconds: 4), content: Text(message)),
  );
}
