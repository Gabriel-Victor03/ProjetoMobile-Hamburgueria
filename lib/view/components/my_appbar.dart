import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 130, 30, 60),
      foregroundColor: Colors.white,
      title: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/homepage'); // Navega para a HomePage
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo.png',
              height: 35,
            ),
          ),
        ),
      ),
      toolbarHeight: 60,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(35.0);
}
