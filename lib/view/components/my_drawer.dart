import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 16.0), // Adiciona espaço no topo
            child: ListTile(
              title: Text(
                'Administração',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 130, 30, 60),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person,
                color: Colors.black), // Ícone de perfil
            title: const Text('Painel Administrativo'),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            title: Text(
              'Horários',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 130, 30, 60),
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Segunda a Quinta: 18:00 - 23:00',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Arial',
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Sexta e Sábado: 18:00 - 01:00',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Arial',
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Domingo: 17:00 - 23:00',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Arial',
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Endereço',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 130, 30, 60),
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'GO-154, km 218 - Zona Rural, Ceres - GO, 76300-000',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontFamily: 'Arial',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
