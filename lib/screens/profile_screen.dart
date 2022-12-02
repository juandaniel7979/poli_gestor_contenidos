import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poli_gestor_contenidos/models/users_stats.dart';
import 'package:poli_gestor_contenidos/services/auth_services.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/widgets/side_menu.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  
  static const routerName = 'profile';
  const ProfileScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final usuario = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: Padding(
            padding: EdgeInsets.only(left: size.width*0.118),
              child: Text('${usuario.usuario.nombreCompleto}'),
          ), 
        ),
        drawer: const SideMenu(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(140.0),
                            child: FadeInImage(
                              height: 250,
                              width: 250,
                              fit: BoxFit.cover,
                              placeholder: const AssetImage('assets/jar-loading.gif'),
                              image: NetworkImage(usuario.usuario.imagen ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/681px-Placeholder_view_vector.svg.png'),
                            ),
                        ),
                        Positioned(
                          top: 180,
                          right: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: IconButton(
                              alignment: Alignment.center,
                              onPressed: () async {
                                
                                final picker = ImagePicker();
                                final XFile? pickedFile = await picker.pickImage(
                                  source: ImageSource.camera,
                                  // source: ImageSource.gallery,
                                  imageQuality: 100
                                  ); 
                        
                                  if( pickedFile == null) {
                                    print('No seleccionó nada');
                                    return;
                                  }
                                  print('Tenemos imagen ${ pickedFile.path}');
                                  usuario.updateUserImage(pickedFile.path);
                              },
                              icon: const Icon( Icons.camera_alt_outlined, size: 40, color: Colors.red,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 10,),
            
              Container(
                color: Preferences.isDarkMode ?Colors.black12 : Colors.black54,
                child: const TabBar(
                indicator: BoxDecoration(
                  color: AppTheme.primary,
                ),
                labelColor: AppTheme.secondary,
                labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(child: Text('ACERCA DE'),),
                  Tab(child: Text('SIGUIENDO'),)
                ]
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,
                height: 350,
                // color: Colors.blue, 
                child: TabBarView(
                  children: [
                    _AboutUser(usuario: usuario.usuario),
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.indigo
                      ),
                  ],
                )
              ),
          ],
        ),
      ),
    );
  }
}

class _AboutUser extends StatelessWidget {
  const _AboutUser({
    Key? key, required this.usuario,
  }) : super(key: key);

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      // color: Colors.red,
      child: Center(
        child: Column(children: [

          _FieldLabel(field: 'nombre', label: usuario.correo),
          SizedBox(height: 10,),
          _FieldLabel(field: 'correo', label: usuario.nombreCompleto),
          SizedBox(height: 10,),
          _FieldLabel(field: 'rol', label: usuario.rol),
        ]),
      ),
      );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    Key? key, required this.field, required this.label,
  }) : super(key: key);

  final String field;
  final String label;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
    _Field(texto: field),
    _Label(texto: label),
      
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({ required this.texto});
  final String texto;
  @override
  Widget build(BuildContext context) {
    return Text('${texto.toUpperCase()}: ', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppTheme.primary),);
  }
}

class _Label extends StatelessWidget {
  const _Label({
    Key? key,
    required this.texto,
  }) : super(key: key);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text('"${texto}"', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.secondary),);
  }
}