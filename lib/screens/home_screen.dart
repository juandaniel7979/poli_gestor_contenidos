import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  static const String routerName = 'Home';
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppTheme.primary,
      ),
      drawer: SideMenu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('isDarkmode: ${ Preferences.isDarkMode }'),
          Divider(),
          Text('Genero: ${ Preferences.gender}'),
          Divider(),
          Text('Nombre de usuario: ${ Preferences.name}'),
          Divider(),

        ],

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
            BottomNavigationBarItem(
              icon: Icon( Icons.home_outlined),
              label: 'Publicaciones'
              ),
            BottomNavigationBarItem(
              icon: Icon( Icons.archive),
              label: 'Archivos'
              ),
        ],
      ),
    );
  }
}