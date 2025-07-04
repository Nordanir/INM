import 'package:flutter/material.dart';
import 'package:frontend/providers.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/inputfield.dart';
import 'package:frontend/widgets/login_checkbox.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SupabaseConfig>(context, listen: false);
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
                title: "E-Male",
                onChanged: (value) {
                  Provider.of<FormProvider>(
                    context,
                    listen: false,
                  ).updateEmail(value);
                },
              ),
              SizedBox(height: 15),
              InputField(
                title: "Password",
                obscureText: true,
                onChanged: (value) {
                  Provider.of<FormProvider>(
                    context,
                    listen: false,
                  ).updatePassword(value);
                },
              ),
              SizedBox(height: 20),
              LoginCheckBox(
                label: "Remember me",
                onChanged: (value) {
                  Provider.of<FormProvider>(
                    context,
                    listen: false,
                  ).toggleRememberMe();
                },
              ),
              SizedBox(height: 15),
              LoginCheckBox(label: "Keep me logged in"),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Provider.of<SupabaseConfig>(
                    context,
                    listen: false,
                  ).signUpWithEmail(
                    Provider.of<FormProvider>(
                      context,
                      listen: false,
                    ).email,
                    Provider.of<FormProvider>(
                      context,
                      listen: false,
                    ).password,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Log me in :3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
