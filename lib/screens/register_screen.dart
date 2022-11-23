import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/providers/providers.dart';
import 'package:poli_gestor_contenidos/screens/login_screen.dart';
import 'package:poli_gestor_contenidos/services/services.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:poli_gestor_contenidos/ui/input_decorations.dart';
import 'package:poli_gestor_contenidos/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
    static const String routerName = 'register';

  const RegisterScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                      Text('Crear cuenta', style: Theme.of(context).textTheme.headline4,),
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
                  onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all( const StadiumBorder())
                  ),
                  child: const Text('¿Ya tienes una cuenta?', style: TextStyle( fontSize: 18, color: Colors.black87),)
                ),
                const SizedBox( height: 50,)
                
    
              ]
              ),
          )
        )
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  final loginForm = Provider.of<LoginFormProvider>(context);
    return Column(
      children: [
        TabBar(
              onTap: (selectedRol) {
                switch(selectedRol) {
                  case 0: {
                    loginForm.rol = "PROFESOR";
                    print(loginForm.rol);
                  }
                  break;
                  case 1: {
                    loginForm.rol = "ESTUDIANTE";
                    print(loginForm.rol);
                  }
                  break;

                }
              },
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10)
              ),
              tabs: const [
                  Tab(child: Text('PROFESOR')),
                  Tab(child: Text('ESTUDIANTE')),
              ] 
              ),
              _FormRegister(loginForm: loginForm)
      ],
    );
  }
}

class _FormRegister extends StatelessWidget {
  const _FormRegister({
    Key? key,
    required this.loginForm,
  }) : super(key: key);

  final LoginFormProvider loginForm;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '15600452',
                color: themeProvider.currentTheme.backgroundColor,
                label: 'NIT',
              ),
              onChanged: (value) => loginForm.uid = value,
              validator: ( value ) {
                if(value!.isEmpty){
                return 'El nit es obligatorio';
                  
                }
              },
            ),
          ),
          // Nombres
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: TextFormField(
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecorations.authInputDecoration(
                                hintText: 'pepito',
                                color: themeProvider.currentTheme.backgroundColor,
                                label: 'Nombre',
                              ),
                              onChanged: (value) => loginForm.nombre = value,
                              validator: ( value ) {
                  if( value!.isEmpty){
                    return 'El nombre es obligatorio';
                  }
                              },
                            ),
                ),
              ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Juan',
                  color: themeProvider.currentTheme.backgroundColor,
                  label: '2do Nombre',
                ),
                onChanged: (value) => loginForm.nombre2 = value,
              ),
            ),
          ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Gonzalez',
                  color: themeProvider.currentTheme.backgroundColor,
                  label: 'Apellido',
                              ),
                              onChanged: (value) => loginForm.apellido = value,
                              validator: ( value ) {
                  if( value!.isEmpty){
                    return 'El apellido es obligatorio';
                  }
                              },
                            ),
                ),
              ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: 'Agudelo',
                    color: themeProvider.currentTheme.backgroundColor,
                    label: '2do Apellido',
                  ),
                  onChanged: (value) => loginForm.apellido2 = value,
                ),
              ),
            ),
            ],
          ),
          SizedBox(height: 30,),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'john.doe@gmail.com',
              color: themeProvider.currentTheme.backgroundColor,
              label: 'Correo electronico',
              prefixIcon: Icons.alternate_email_sharp
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
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*****',
              color: themeProvider.currentTheme.backgroundColor,
              label: 'Contraseña',
              prefixIcon: Icons.lock_outline
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
              // await Future.delayed(const Duration(seconds: 2));
              
              final String? errorMessage = await authService.createUser( loginForm.uid, loginForm.correo, loginForm.contrasena, loginForm.nombre, loginForm.nombre2, loginForm.apellido, loginForm.apellido2, loginForm.rol);
      
              if( errorMessage == null ) {
      
                Navigator.pushReplacementNamed(context, LoginScreen.routerName);
      
              }else{
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
    );
  }
}