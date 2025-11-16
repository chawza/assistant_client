import 'package:assistant_client/core/errors.dart';
import 'package:assistant_client/core/session_storage.dart';
import 'package:assistant_client/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginAttempt() async {
    if (emailController.value.text.isEmpty ||
        passwordController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    var service = AuthService('http://localhost:8000');
    try {
      var result = await service.login(
        emailController.value.text,
        passwordController.value.text,
      );
      var session = await SessionStorage.get();
      session.saveToken(result.$1);
      session.updateUserData(result.$2);
      Navigator.pushNamed(context, '/home');
    } on AuthError catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Page')),
      body: Center(
        child: Padding(
          padding: .all(10.0),
          child: Column(
            spacing: 10.0,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration.collapsed(hintText: "Email"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: "Password"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle login or registration logic here
                  loginAttempt();
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
