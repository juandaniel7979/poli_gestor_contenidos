
import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/providers/theme_provider.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/widgets/side_menu.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const String routerName = 'Settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  // bool isDarkmode = false;
  // int gender = 1;
  // String name = 'Pedro';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Settings'),
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Ajustes', style: TextStyle( fontSize: 45, fontWeight: FontWeight.w300),),
              Divider(),
              SwitchListTile.adaptive(
                value: Preferences.isDarkMode,
                title: const Text('Modo oscuro'),
                onChanged: ( value ){
                    Preferences.isDarkMode = value;
                    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

                    value 
                      ? themeProvider.setDarkMode()
                      : themeProvider.setLightMode();

                    setState(() {});
                }
              ),
              Divider(),
              
            ]
          ),
        ),
      ),
    );
  }
}