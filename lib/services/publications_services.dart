import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:poli_gestor_contenidos/models/models.dart';

class PublicationsServices extends ChangeNotifier {

  final String _baseUrl = 'flutter-productsapp-a9c30-default-rtdb.firebaseio.com';
  final List<Publication> publications = [];
  late Publication selectedPublication;

  final storage = const FlutterSecureStorage();
  
  bool isLoading = true;
  bool isSaving= false;

  File? newPictureFile;


  PublicationsServices(){
    loadPublications();
  }

  Future<List<Publication>> loadPublications() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseUrl , 'publication.json', 
    // {
    //   'auth': await storage.read(key: 'token') ?? ''
    // }
    );
    final resp = await http.get(url,);
    print(resp.body);

    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProduct = Publication.fromMap( value );

      tempProduct.id = key;
      publications.add( tempProduct );
      
    });
  

      isLoading = false;
      notifyListeners();
      return publications; 
  }

  Future saveOrCreatePublication( Publication publication ) async {
    isSaving = true;
    notifyListeners();

    if( publication.id == null) {
      await createProduct(publication);

    }else{

      await updateProduct(publication);

    }

    isSaving = false;
    notifyListeners();
  }

  Future updateProduct( Publication publication ) async {
    final url = Uri.https( _baseUrl , 'Products/${publication.id}.json');
    final resp = await http.put(url, body: publication.toJson());
    final decodedData = resp.body;
    
    // publications.forEach((element) {
    //   if(element.id == publication.id){
    //     element.name = publication.name;
    //   }
    // });

    final index = publications.indexWhere((element) => element.id == publication.id);
    publications[index] = publication;
    
    return publication.id;
  }


  Future createProduct( Publication publication ) async {
    final url = Uri.https( _baseUrl , 'publication.json');
    final resp = await http.post(url, body: publication.toJson());
    final decodedData = json.decode(resp.body);
    print(decodedData);

    publication.id = decodedData['name'];

    publications.add(publication);
    

    return publication.id;
  }


  void updateSelectedPublicationimage (String path) async {

    selectedPublication.picture = path; 
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