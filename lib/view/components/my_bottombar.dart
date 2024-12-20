import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const MyBottomNavigationBar(this.selectedIndex, this.onItemTapped,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      selectedItemColor: Color.fromARGB(255, 130, 30, 60),
      unselectedItemColor: const Color.fromARGB(255, 150, 150, 150),
      iconSize: 28,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_outlined),
          label: 'Cardápio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Sacola',
        ),
      ],
    );
  }
}
