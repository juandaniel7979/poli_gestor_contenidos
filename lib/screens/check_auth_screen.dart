import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/screens/home_screen.dart';
import 'package:poli_gestor_contenidos/screens/list_categories_screen.dart';
import 'package:poli_gestor_contenidos/screens/login_screen.dart';
import 'package:poli_gestor_contenidos/services/auth_services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  static const routerName = "check-auth-screen";

  const CheckAuthScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: authService.readToken(),
        builder: ( context, AsyncSnapshot<String> snapshot) {
          if( !snapshot.hasData ) return const Text('Espere');

          if( snapshot.data == ''){
            Future.microtask(() {
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: ( _, __, ___) => LoginScreen(),
                transitionDuration: Duration(seconds: 0)
              )
            );
            });
          }else{
            Future.microtask(() {
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: ( _, __, ___) => const ListCategoriesScreen(),
                transitionDuration: const Duration(seconds: 0)
              )
            );
            });

          }

          return Container();

        },
        ),
    );
  }
}