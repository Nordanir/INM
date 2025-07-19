import 'package:flutter/material.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/auth_provider.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/inputfield.dart';
import 'package:frontend/widgets/login_checkbox.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: true,
    );
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: true);
    return SizedBox(
      width: 300,
      height: 400,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputField(
                title: email,
                onChanged: (value) {
                  authProvider.updateEmail(value);
                },
              ),
              SizedBox(height: 15),
              InputField(
                title: password,
                obscureText: true,
                onChanged: (value) {
                  authProvider.updatePassword(value);
                },
              ),
              SizedBox(height: 20),
              LoginCheckBox(
                label: rememberMe,
                onChanged: (value) {
                  authProvider.toggleRememberMe();
                },
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  authProvider.successfulLogin = await supabaseConfig
                      .signInWithEmail(
                        authProvider.email,
                        authProvider.password,
                      );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(loginButton),
              ),

              ElevatedButton(
                onPressed: () {
                  authProvider.toggleLogin();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(registerButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
