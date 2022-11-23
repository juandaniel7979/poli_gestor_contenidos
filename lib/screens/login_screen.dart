import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/providers/login_form_provider.dart';
import 'package:poli_gestor_contenidos/providers/providers.dart';
import 'package:poli_gestor_contenidos/screens/list_categories_screen.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/ui/input_decorations.dart';
import 'package:poli_gestor_contenidos/widgets/widgets.dart';
import 'package:poli_gestor_contenidos/services/services.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatelessWidget {

  static const String routerName = 'login';
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 250,),

              CardContainer(
                child: Column(
                  children: [
                    const SizedBox( height: 10,),
                    Text('Login', style: Theme.of(context).textTheme.headline4,),
                    const SizedBox( height:30,),   
                    ChangeNotifierProvider(
                      create:  ( _ ) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox( height: 50,),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'Registro'),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(AppTheme.primary.withOpacity(0.1)),
                  shape: MaterialStateProperty.all( const StadiumBorder())
                ),
                child: const Text('Crear una nueva cuenta', style: TextStyle( fontSize: 18, color: Colors.black87),)
              ),
              const SizedBox( height: 50,)
              

            ]
            ),
        )
      )
    );
  }
}

class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  final loginForm = Provider.of<LoginFormProvider>(context);
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  
    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: true,
              autofocus: true,
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.red,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                label: 'Correo electronico',
                prefixIcon: Icons.alternate_email_sharp,
                color: themeProvider.currentTheme.backgroundColor 
              ),
              onChanged: (value) => loginForm.correo = value,
              validator: ( value ) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                ? null
                : 'El valor ingresado no luce como un correo';
              },
            ),

            const SizedBox( height: 30,),
            
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                label: 'Contraseña',
                prefixIcon: Icons.lock_outline,
                color: themeProvider.currentTheme.backgroundColor 
              ),
              onChanged: (value) => loginForm.contrasena = value,
              validator: ( value ) {

                return ( value != null && value.length >= 6) ? null: 'La contraseña ingresada es incorrecta';
              },
            ),
            
            const SizedBox( height: 30,),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: AppTheme.primary,
              onPressed: loginForm.isLoading ? null : () async {
                if( !loginForm.isValidForm() ) return;

                FocusScope.of(context).unfocus();
                final authService = Provider.of<AuthService>(context, listen: false);
                loginForm.isLoading = true;
                final String? errorMessage = await authService.login(loginForm.correo, loginForm.contrasena);

                if( errorMessage == null ) {

                  Navigator.pushReplacementNamed(context, ListCategoriesScreen.routerName);

                }else{
                  // TODO:mostrar error en pantalla
                  // print(errorMessage);
                  NotificationsService.showSnackbar(errorMessage);
                  loginForm.isLoading = false;
                }
            },
              child: Container(
                padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                  ? 'Espere..'
                  :'Ingresar',
                style: const TextStyle(color: Colors.white),),
              ),)
          ],
        ),
      ),
    );
  }
}