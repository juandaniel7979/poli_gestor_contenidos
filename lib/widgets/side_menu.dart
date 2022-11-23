import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poli_gestor_contenidos/screens/list_categories_screen.dart';
import 'package:poli_gestor_contenidos/screens/screens.dart';
import 'package:poli_gestor_contenidos/services/auth_services.dart';


class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeader(),

          ListTile(
            leading: const Icon( Icons.pages_outlined,), 
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, ListCategoriesScreen.routerName);
            },
          ),
          ListTile(
            leading: const Icon( Icons.people_alt_outlined,), 
            title: const Text('People'),
            onTap: () {

            },
          ),
          ListTile(
            leading: const Icon( Icons.settings_outlined,), 
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushReplacementNamed(context, SettingsScreen.routerName);
            },
          ),
          ListTile(
            leading: const Icon( Icons.settings_outlined,), 
            title: const Text('Logout'),
            onTap: () {
              authService.logout();
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) => LoginScreen())
                );
            },
          ),

        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Container(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/menu-img.jpg'),
            fit: BoxFit.cover
            ),

        ),
      );
  }
}