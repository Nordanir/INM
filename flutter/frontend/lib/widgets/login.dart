import 'package:flutter/material.dart';
import 'package:frontend/widgets/inputfield.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 400,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputField(title: "E-Male"),
              SizedBox(height: 40),
              InputField(title: "Password", obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  
                },
                child: Text('Log me in :3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
