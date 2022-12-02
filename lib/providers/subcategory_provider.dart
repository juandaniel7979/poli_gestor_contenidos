import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:poli_gestor_contenidos/models/subcategory.dart';
import 'package:poli_gestor_contenidos/models/tags_model.dart';

// TODO: Corregir url con ip local

class SubcategoryProvider with ChangeNotifier {

// final _APIKEY = 'eae7a8c6d2f840d1a2595dafe0a195df';
  final _baseURL = 'http://192.168.56.1:3001';
  List <Subcategoria> subcategorias = [];
  Subcategoria selectedSubcategory = Subcategoria(
    nombre: '',
    estado: '',
    id: '',
    idCategoria: '',
    idProfesor: '',
    descripcion: '',
    imagen: null    
    );
  bool _isLoading = true;
  bool isSaving= false;
  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  Subcategoria sub = Subcategoria(
    nombre: '',
    estado: '',
    id: '',
    idCategoria: '',
    idProfesor: '',
    descripcion: '',
    imagen: ''    
    );

  Map<String,List<Subcategoria>> categoriesByTag = {};
  
  SubcategoryProvider() {} 

  
  bool get isLoading => _isLoading;

  getSubcategoriasPorId(String id) async {
    _isLoading = true;
    notifyListeners();
    final url = '$_baseURL/api/subcategoria/${id}';
    print(url);
    final resp = await http.get(Uri.parse(url));
    print(resp.body);
    final subcategoryResponse = Subcategory.fromJson( resp.body );
    subcategorias.addAll( subcategoryResponse.subcategorias);
    _isLoading = false;
    notifyListeners();
    return null;
  }

  getSubcategorias() async {
    _isLoading = true;
    notifyListeners();
    if(selectedSubcategory.idCategoria != null || selectedSubcategory.idCategoria != '' ) {
    final url = '$_baseURL/api/subcategoria/${selectedSubcategory.idCategoria}';
    print(url);
    final resp = await http.get(Uri.parse(url)).timeout(const Duration(milliseconds: 8000));
    print(resp.body);
    final subcategoryResponse = Subcategory.fromJson( resp.body );
    subcategorias.addAll( subcategoryResponse.subcategorias);
    _isLoading = false;
    notifyListeners();
    return null;
    } 
    print('falló');
    return 'error';
  }

  Future saveOrCreateCategoria( Subcategoria subcategoria ) async {
    isSaving = true;
    notifyListeners();

    if( subcategoria.id == null || subcategoria.id == '') {
      await createSubcategory(subcategoria);
    }else{
      // print('Actualizar');
      await updateSubcategory(subcategoria);

    }

    isSaving = false;
    notifyListeners();
  }

  Future updateSubcategory( Subcategoria subcategoria ) async {
    final Map<String,dynamic> subcategoryData = {
        'nombre': subcategoria.nombre,
        'descripcion': subcategoria.descripcion,
        'estado':  subcategoria.estado,
        'imagen': subcategoria.imagen
    };
    
    final token = await storage.read(key: 'token') ?? '';
    if(token ==''){ print('No hay token en el request: '); return null;}

    final url = Uri.parse('$_baseURL/api/subcategoria/${subcategoria.id}');
    print('ACTUALIZAR-----------------');
    print(url);
    final resp = await http.put(url, body: json.encode(subcategoryData),
    headers: {
    "Content-Type": "application/json", 
    'x-token': token
    }
    ,);
    
    final index = subcategorias.indexWhere((element) => element.id == subcategoria.id);
    subcategorias[index] = subcategoria;
    notifyListeners();

    final decodedData = resp.body;
    print(resp.body);
    return subcategoria.id;
  }


  Future createSubcategory( Subcategoria subcategoria ) async {
    final Map<String,dynamic> subcategoryData = {
        'nombre': subcategoria.nombre,
        'descripcion': subcategoria.descripcion,
    };
    print(subcategoria.idCategoria);
    final url = Uri.parse( '$_baseURL/api/subcategoria/${subcategoria.idCategoria}');
    print('CREAR-----------------');
    print(url);
    try {
    final resp = await http.post(url,
    body: json.encode(subcategoryData),
    headers: {
      "Content-Type": "application/json", 
      'x-token': await storage.read(key: 'token') ?? ''
    }
    ).timeout(const Duration(seconds: 30));
    print(resp.body);  
    subcategorias.add(subcategoria);
    
    final Map<String, dynamic> decodedResp = json.decode( resp.body);

    if( decodedResp.containsKey('id_profesor')) {
      print('resp.body');
      print(resp.body);
      return null;
    }else{
      print(decodedResp['errors'][0]);
      return 'error';
    }
      
    } catch (e) {
      print(e);
      isSaving = false;
    }
  }

  
  void updateSelectedSubategoryImage (String path) async {

    selectedSubcategory.imagen = path; 
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if ( newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dlcmims3m/image/upload?upload_preset=xysn0jp7');

    final imageUploadRequest = http.MultipartRequest( 'POST', url );

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('Algo salio mal');
      print( resp.body);
      return null;
    }
    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
}



}