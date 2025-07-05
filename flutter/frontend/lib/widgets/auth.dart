import 'package:flutter/material.dart';
import 'package:frontend/providers.dart';
import 'package:frontend/widgets/login.dart';
import 'package:frontend/widgets/register.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Provider.of<AuthenticationProvider>(context).isLogin) Login(),
        if (!Provider.of<AuthenticationProvider>(context).isLogin) Register(),
      ],
    );
  }
}
