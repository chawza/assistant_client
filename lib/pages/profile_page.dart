import 'package:assistant_client/core/session_storage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email = '';
  SessionStorage? session;
  @override
  void initState() {
    super.initState();
    _asyncOnLoad();
  }

  void _asyncOnLoad() async {
    session = await SessionStorage.get();

    setState(() {
      _email = session?.user.email ?? '';
    });
  }

  Future<void> logoutAttempt() async {
    session?.clearSession();
    Navigator.pushNamed(context, '/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Email: $_email')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(onPressed: logoutAttempt, child: Text('Logout')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
