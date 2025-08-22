import 'package:flutter/material.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/dimensions/auth_panel.dart';
import 'package:frontend/providers/superbase_config.dart' show SupabaseConfig;
import 'package:frontend/widgets/info_panel.dart';
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
      backgroundColor: deepBlueHighLight,
      body: Consumer<SupabaseConfig>(
        builder: (context, supabase, child) {
          return Center(
            child: Container(
              padding: AppDimensions.normalPadding,
              width: InfoPanelDimensions.infoPanelWidth(context),
              height: InfoPanelDimensions.infoPanelHeight(context),
              decoration: BoxDecoration(
                boxShadow: [AppDimensions.containershadow],
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
  final VoidCallback toggleLogin;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isKeepLogin = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: false);
    return Column(
      children: [
        InputField(controller: emailController, title: email),
        SizedBox(height: AppDimensions.normalSpacing(context)),
        InputField(
          controller: passwordController,
          title: password,
          obscureText: true,
        ),
        SizedBox(height: AppDimensions.normalSpacing(context)),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Checkbox(
                activeColor: accent,
                value: isKeepLogin,
                onChanged: (_) {
                  setState(() {
                    isKeepLogin = !isKeepLogin;
                  });
                },
              ),
              DisplayText(text: rememberMe),
            ],
          ),
        ),

        Spacer(),

        AuthButton(
          onPressed: () async {
            final response = await supabaseConfig.signInWithEmail(
              emailController.text.trim(),
              passwordController.text.trim(),
            );

            showSnackBar(response.$2, context);
            if (response.$1) {
              supabaseConfig.successfulLogin();
              if (isKeepLogin) {
                await supabaseConfig.storeCredentials(email, password);
              }
            }
          },
          buttonText: loginButton,
        ),

        SizedBox(height: AppDimensions.largeSpacing(context)),
        AuthButton(onPressed: widget.toggleLogin, buttonText: registerButton),
      ],
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key, required this.toggleFunction});
  final VoidCallback toggleFunction;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final userNameController = TextEditingController();
  final passWordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passWordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputField(title: email, controller: emailController),
        SizedBox(height: AppDimensions.normalSpacing(context)),
        InputField(
          title: password,
          obscureText: true,
          controller: passWordController,
        ),
        SizedBox(height: AppDimensions.normalSpacing(context)),
        InputField(title: username, controller: userNameController),

        Spacer(),
        AuthButton(
          onPressed: () async {
            final response = await supabaseConfig.signUpWithEmail(
              emailController.text.trim(),
              passWordController.text.trim(),
              userNameController.text.trim(),
            );
            showSnackBar(response.$2, context);
            if (response.$1) {
              widget.toggleFunction();
            }
          },
          buttonText: registerButton,
        ),
        SizedBox(height: AppDimensions.normalSpacing(context)),
        AuthButton(onPressed: widget.toggleFunction, buttonText: back),
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
    return TextFormField(
      style: textStyle(AppDimensions.normalFontSize),

      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: textStyle(AppDimensions.normalFontSize),
        hintStyle: textStyle(AppDimensions.normalFontSize),
        focusedBorder: OutlineInputBorder(
          borderRadius: AuthPanelDimensions.inputBorderRadius,
          borderSide: BorderSide(color: deepAccent),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: deepBlueHighLight),
          borderRadius: AuthPanelDimensions.inputBorderRadius,
        ),
      ),
    );
  }
}

class AuthButton extends StatefulWidget {
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });
  final VoidCallback onPressed;
  final String buttonText;
  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  void hover() {
    setState(() {
      isHovered = !isHovered;
    });
  }

  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (_) {
        hover();
      },
      onEnter: (_) {
        setState(() {
          hover();
        });
      },

      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isHovered ? accent : deepBlueHighLight,
          minimumSize: const Size(400, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: DisplayText(text: widget.buttonText),
      ),
    );
  }
}

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(duration: Duration(seconds: 4), content: Text(message)),
  );
}
