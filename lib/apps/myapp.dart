import 'package:flutter/material.dart';
import 'package:nguyenminhvuong_btth3/features/profile/screens/profile.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: const Profile(),
      debugShowCheckedModeBanner: false,
    );
  }
}
