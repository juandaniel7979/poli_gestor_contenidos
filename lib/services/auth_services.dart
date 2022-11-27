import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:poli_gestor_contenidos/models/users_stats.dart';

class AuthService extends ChangeNotifier{


  final String _baseUrl = '192.168.56.1:3001';

  final storage = const FlutterSecureStorage();

  late Usuario usuario; 
  // Si retornamos algo es un error, sino todo bien
  Future<String?> createUser(String uid, String correo, String contrasena, String nombre, String nombre2, String apellido, String apellido2, String rol) async {

    final Map<String,dynamic> authData = {
        'nit': uid.trim(),
        'nombre': nombre.trim(),
        'nombre_2': nombre2.trim(),
        'apellido': apellido.trim(),
        'apellido_2': apellido2.trim(),
        'correo': correo.toLowerCase().trim(),
        'contrasena': contrasena,
        'rol':  rol
    };

    print(jsonEncode(authData));

    final url = Uri.http( _baseUrl,'/api/usuarios');

    final resp = await http.post(url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(authData));
    print(resp.body);
    final Map<String, dynamic> decodedResp = json.decode( resp.body);

    if( decodedResp.containsKey('usuario')) {
      // Hay que guardarlo en un lugar seguro
      print(decodedResp['usuario']);
      return null;
    }else{
      print(decodedResp['errors'][0]);
      return 'error';
    }
  }


  Future<String?> login(String correo, String contrasena) async {
    final Map<String,dynamic> authData = {
      'correo': correo,
      'contrasena': contrasena
    };
    final url = Uri.http( _baseUrl, '/api/auth/login', );

    final resp = await http.post(url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(authData)
    ).timeout(const Duration(milliseconds: 8000));
    print(resp.body);
    final Map<String, dynamic> decodedResp = json.decode( resp.body);

    if( decodedResp.containsKey('token')) {
      storage.write(key: 'token', value: decodedResp['token']);
      usuario = Usuario.fromMap(decodedResp['usuario']);

      print(usuario.nombreCompleto);
      return null;
    }else{ 
      print(decodedResp['errors'][0]);
      return decodedResp['errors'][0]; }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {

    return await storage.read(key: 'token') ?? '';
  
  }


}

