import 'package:flutter/material.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/providers.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/inputfield.dart';
import 'package:provider/provider.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Provider.of<AuthenticationProvider>(
                    context,
                    listen: false,
                  ).updateEmail(value);
                },
              ),
              SizedBox(height: 15),
              InputField(
                title: password,
                obscureText: true,
                onChanged: (value) {
                  Provider.of<AuthenticationProvider>(
                    context,
                    listen: false,
                  ).updatePassword(value);
                },
              ),
              SizedBox(height: 15),
              InputField(
                title: username,
                onChanged: (value) {
                  Provider.of<AuthenticationProvider>(
                    context,
                    listen: false,
                  ).updateUsername(value);
                },
              ),
              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () async {
                 await Provider.of<SupabaseConfig>(
                    context,
                    listen: false,
                  ).signUpWithEmail(
                    Provider.of<AuthenticationProvider>(
                      context,
                      listen: false,
                    ).email,
                    Provider.of<AuthenticationProvider>(
                      context,
                      listen: false,
                    ).password,context
                  )
                  ;
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(signUpButton),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<AuthenticationProvider>(
                    context,
                    listen: false,
                  ).toggleLogin();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(back),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
