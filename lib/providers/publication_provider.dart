import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:poli_gestor_contenidos/models/models.dart';


class PublicationProvider with ChangeNotifier {

// final _APIKEY = 'eae7a8c6d2f840d1a2595dafe0a195df';
  final _baseURL = 'http://192.168.56.1:3001';
  List <Publicacion> publicaciones = [];
  Publicacion selectedPublicacion = Publicacion(
    estado: '',
    id: '',
    idSubcategoria: '',
    idProfesor: '',
    descripcion: '',
    imagenes: []    
    );
  bool _isLoading = true;
  bool isSaving= false;
  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  Map<String,List<Publicacion>> categoriesByTag = {};
  
  PublicationProvider() {


  } 

  
  bool get isLoading => _isLoading;

  getPublicacionesPorId(String id) async {
    _isLoading = true;
    notifyListeners();
    final url = '$_baseURL/api/publicacion/${id}';
    print(url);
    final resp = await http.get(Uri.parse(url));
    print(resp.body);
    final publicationResponse = Publicaciones.fromJson( resp.body );
    publicaciones.addAll( publicationResponse.publicaciones );
    _isLoading = false;
    notifyListeners();
    return null;
  }

  getPublicaciones() async {
    _isLoading = true;
    notifyListeners();
    if(selectedPublicacion.idSubcategoria != null || selectedPublicacion.idSubcategoria != '' ) {
    final url = '$_baseURL/api/publicacion/${selectedPublicacion.idSubcategoria}';
    print(url);
    final resp = await http.get(Uri.parse(url)).timeout(const Duration(milliseconds: 8000));
    print(resp.body);
    final publicationResponse = Publicaciones.fromJson( resp.body );
    publicaciones.addAll( publicationResponse.publicaciones);
    _isLoading = false;
    notifyListeners();
    return null;
    } 
    print('falló');
    return 'error';
  }

  Future saveOrCreatePublicacion( Publicacion publicacion ) async {
    isSaving = true;
    notifyListeners();

    if( publicacion.id == null || publicacion.id == '') {
      await createPublicacion(publicacion);
    }else{
      // print('Actualizar');
      await updatePublicacion(publicacion);

    }

    isSaving = false;
    notifyListeners();
  }

  Future updatePublicacion( Publicacion publicacion ) async {
    final Map<String,dynamic> subcategoryData = {
        'descripcion': publicacion.descripcion,
        'estado':  publicacion.estado,
        'imagenes': publicacion.imagenes
    };
    
    final token = await storage.read(key: 'token') ?? '';
    if(token ==''){ print('No hay token en el request: '); return null;}

    print('id publicacion: ${publicacion.idSubcategoria}');
    final url = Uri.parse('$_baseURL/api/publicacion/${publicacion.idSubcategoria}');
    print('ACTUALIZAR-----------------');
    print(url);
    final resp = await http.put(url, body: json.encode(subcategoryData),
    headers: {
    "Content-Type": "application/json", 
    'x-token': token
    }
    ,).timeout(const Duration(milliseconds: 8000));

    final decodedData = resp.body;
    print(resp.body);
    return publicacion.id;
  }


  Future createPublicacion( Publicacion publicacion ) async {
    final Map<String,dynamic> subcategoryData = {
        'descripcion': publicacion.descripcion,
        'estado':  publicacion.estado,
        'imagenes': publicacion.imagenes
    };
    print(publicacion.idSubcategoria);
    final url = Uri.parse( '$_baseURL/api/publicacion/${publicacion.idSubcategoria}');
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
    publicaciones.add(publicacion);
    
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

  
  void updateSelectedPublicationImage (String path) async {

    selectedPublicacion.imagenes.add(path) ; 
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