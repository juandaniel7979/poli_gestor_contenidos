import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String correo = '';
  String contrasena = '';
  String uid = '';
  String nombre = '';
  String nombre2 = '';
  String apellido = '';
  String apellido2 = '';
  String rol = '';

  bool _isLoading = false;


  bool get isLoading => _isLoading;
  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm (){

    print(formKey.currentState?.validate());
    return formKey.currentState?.validate() ?? false;
  }
}