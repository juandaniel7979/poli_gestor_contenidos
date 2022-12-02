import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:poli_gestor_contenidos/models/subcategory.dart';
import 'package:poli_gestor_contenidos/models/suscripcion_response.dart';
import 'package:poli_gestor_contenidos/models/tags_model.dart';

// TODO: Corregir url con ip local

class SuscripcionProvider with ChangeNotifier {

// final _APIKEY = 'eae7a8c6d2f840d1a2595dafe0a195df';
  final _baseURL = 'http://192.168.56.1:3001';
  List <Suscripcion> suscripcions = [];
  // Suscripcion selectedSubcategory = Suscripcion(
  //   estado: '',
  //   id: '',
  //   categoria: l,
  //   usuario: '',
  //   );
  bool _isLoading = true;
  bool isSaving= false;
  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  Map<String,List<Suscripcion>> categoriesByTag = {};
  
  SuscripcionProvider() {} 

  
  bool get isLoading => _isLoading;

  getSuscripcionesPorCategoria(String id) async {
    _isLoading = true;
    notifyListeners();
    final url = '$_baseURL/api/suscripcion/categoria/${id}';
    print(url);

    final token = await storage.read(key: 'token') ?? '';
    if(token ==''){ print('No hay token en el request: '); return null;}

    final resp = await http.get(Uri.parse(url),
    headers: {
      "Content-Type": "application/json", 
      'x-token': token
    });
    print(resp.body);
    final subcategoryResponse = Suscripciones.fromJson( resp.body );
    suscripcions.addAll( subcategoryResponse.suscripciones);
    _isLoading = false;
    notifyListeners();
    return null;
  }



  Future aprobarSuscripcion( String id, String id_categoria) async {
    final Map<String,dynamic> subcategoryData = {
        'estado': "APROBADO",
        'id_usuario': id
    };
    
    final token = await storage.read(key: 'token') ?? '';
    if(token ==''){ print('No hay token en el request: '); return null;}

    print('id categoria: ${id}');
    final url = Uri.parse('$_baseURL/api/suscripcion/${id_categoria}');
    print('APROBAR');
    final resp = await http.put(url, body: json.encode(subcategoryData),
    headers: {
    "Content-Type": "application/json", 
    'x-token': token
    }
    ,).timeout(const Duration(milliseconds: 8000));
    print(resp.body);

    return null;
  }


  Future rechazarSuscripcion( String id, String id_categoria) async {
    final Map<String,dynamic> subcategoryData = {
        'estado': "RECHAZADO",
        'id_usuario': id
    };
    
    final token = await storage.read(key: 'token') ?? '';
    if(token ==''){ print('No hay token en el request: '); return null;}

    print('id categoria: ${id}');
    final url = Uri.parse('$_baseURL/api/suscripcion/${id_categoria}');
    print('APROBAR');
    final resp = await http.put(url, body: json.encode(subcategoryData),
    headers: {
    "Content-Type": "application/json", 
    'x-token': token
    }
    ,).timeout(const Duration(milliseconds: 8000));
    print(resp.body);

    return null;
  }


  Future createSuscripcion( String idCategoria ) async {

    final token = await storage.read(key: 'token') ?? '';
    if(token ==''){ print('No hay token en el request: '); return null;}
    final url = Uri.parse( '$_baseURL/api/suscripcion/$idCategoria');
    print('CREAR-----------------');
    print(url);
    try {
    final resp = await http.post(url,
    headers: {
      "Content-Type": "application/json", 
      'x-token': token
    }
    );
    print(resp.body);  
    
    final Map<String, dynamic> decodedResp = json.decode( resp.body);

    if( decodedResp.containsKey('estado')) {
      return null;
    }else{
      print(decodedResp['errors']);
      return decodedResp['errors'][0];
    }
      
    } catch (e) {
      print(e);
      isSaving = false;
    }
  }

  


}