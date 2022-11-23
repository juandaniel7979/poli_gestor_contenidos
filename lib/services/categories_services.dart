import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:poli_gestor_contenidos/models/models.dart';

class CategoryServices extends ChangeNotifier {

  final String _baseUrl = 'http://190.70.51.150:3001/';
  final List<Categoria> categorias = [];
  late Categoria selectedCategory;

  final storage = const FlutterSecureStorage();
  
  bool isLoading = true;
  bool isSaving= false;

  File? newPictureFile;


  CategoryServices(){
    loadCategories();
  }

  Future<List<Categoria>> loadCategories() async {

    isLoading = true; 
    notifyListeners();

    final url = Uri.http( _baseUrl , 'api/categoria', {
      'x-token': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.get(url,);
    print(resp.body);

    final Map<String, dynamic> categoriasMap = json.decode(resp.body);

    categoriasMap.forEach((key, value) {
      final tempCategoria = Categoria.fromMap( value );
      categorias.add( tempCategoria );
    });
  
      isLoading = false;
      notifyListeners();
      return categorias; 
  }

  Future saveOrCreateCategoria( Categoria categoria ) async {
    isSaving = true;
    notifyListeners();

    if( categoria.id == null) {
      await createCategory(categoria);

    }else{

      await updateCategory(categoria);

    }

    isSaving = false;
    notifyListeners();
  }

  Future updateCategory( Categoria categoria ) async {
    final url = Uri.https( _baseUrl , 'api/categoria');
    final resp = await http.put(url, body: categoria.toJson());
    final decodedData = resp.body;
    
    // categoria.forEach((element) {
    //   if(element.id == categoria.id){
    //     element.name = categoria.name;
    //   }
    // });

    final index = categorias.indexWhere((element) => element.id == categoria.id);
    categorias[index] = categoria;
    
    return categoria.id;
  }


  Future createCategory( Categoria categoria ) async {
    final url = Uri.parse( _baseUrl);
    final resp = await http.post(url, body: categoria.toJson());
    print(resp);
    categorias.add(categoria);
    

    return categoria.id;
  }

  
  void updateSelectedCategoryImage (String path) async {

    selectedCategory.imagen = path; 
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