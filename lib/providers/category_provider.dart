import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:poli_gestor_contenidos/models/category.dart';
import 'package:poli_gestor_contenidos/models/tags_model.dart';

// TODO: Corregir url con ip local

class CategoryProvider with ChangeNotifier {

  List <Tag> tags = [
    Tag( FontAwesomeIcons.addressCard       , 'GENERAL'             , Colors.green          , false),
    Tag( FontAwesomeIcons.calculator        , 'MATEMATICAS'         , Colors.blue.shade600  , false),
    Tag( FontAwesomeIcons.gears             , 'INGENIERIA'          , Colors.indigo         , false),
    Tag( FontAwesomeIcons.tv                , 'REDES'               , Colors.cyan           , false),
    Tag( FontAwesomeIcons.headSideVirus     , 'SOCIALES'            , Colors.orange         , false),
    Tag( FontAwesomeIcons.vials             , 'CIENCIAS NATURALES'  , Colors.redAccent      , false),
    Tag( FontAwesomeIcons.volleyball        , 'DEPORTES'            , Colors.amber          , false),
    Tag( FontAwesomeIcons.suitcaseMedical   , 'MEDICINA'            , Colors.deepPurple     , false),    
    Tag( FontAwesomeIcons.memory            , 'OTROS'               , Colors.lightGreen     , false),    
  ];


  Color colorByTagName (String name) {
      for (var i = 0; i < tags.length-1; i++) {
          if( tags[i].name == name){
            return tags[i].color;
          }
      }
        return Colors.amber;
  }

  List<Tag>  get copyTags {
      List<Tag> tagsTemp = [];
      for (var element in tags) {
        tagsTemp.add(element);
      }
      return tagsTemp;
  }
// final _APIKEY = 'eae7a8c6d2f840d1a2595dafe0a195df';
  final _baseURL = 'http://192.168.56.1:3001';
  String _selectedTag = 'GENERAL';

  // List<String> selectedTags = [];
  List <Categoria> categorias = [];
  late Categoria selectedCategory;
  bool _isLoading = true;
  bool isSaving= false;
  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  Map<String,List<Categoria>> categoriesByTag = {};
  
  CategoryProvider() {
    getTopCategorias();
    tags.forEach((item) {
      categoriesByTag[item.name] = List<Categoria>.empty(growable: true);
    });
    getCategoriesPorTag( _selectedTag );
  } 

  
  bool get isLoading => _isLoading;

  String get selectedTag => _selectedTag;

  set selectedTag( String valor ) {
    _selectedTag = valor;
    
    _isLoading = true;
    getCategoriesPorTag( valor );
    notifyListeners();
  }

  List<Categoria> get getCategoriasPorTag => categoriesByTag[selectedTag]!;

  getTopCategorias() async {
    _isLoading = true;
    notifyListeners();
    final url = '${_baseURL}/api/categoria';
    final resp = await http.get(Uri.parse(url)).timeout(const Duration(milliseconds: 8000));
    // print(resp.body);
    final categoryResponse = Category.fromJson( resp.body );
    
    categorias.addAll( categoryResponse.categorias);
    _isLoading = false;
    notifyListeners();
  }

  getCategoriesPorTag( String tag ) async {
    // if( categoriesByTag[tag]!.isNotEmpty ) {
    // _isLoading = false;
    //   notifyListeners();
    //   return categoriesByTag[tag];
    // }

    final url = '$_baseURL/api/categoria/tag/$tag';
    print(url);
    final resp = await http.get(Uri.parse(url),
    headers: {
      'x-token': await storage.read(key: 'token') ?? ''
    }
    ).timeout(const Duration(milliseconds: 16000));
    print(resp.body);
    final categoryResponse = Category.fromJson( resp.body );
    categorias = [];
    categorias.addAll( categoryResponse.categorias );
    _isLoading = false;
    notifyListeners();
  }

  Future saveOrCreateCategoria( Categoria categoria ) async {
    isSaving = true;
    notifyListeners();

    if( categoria.id == null) {
      await createCategory(categoria);
    }else{
      print('Actualizar');
      await updateCategory(categoria);
    }
    isSaving = false;
    notifyListeners();
  }

  Future updateCategory( Categoria categoria ) async {
    final Map<String,dynamic> categoryData = {
        'nombre': categoria.nombre,
        'descripcion': categoria.descripcion,
        'estado':  categoria.estado,
        'imagen': categoria.imagen,
        'tags': categoria.tags
    };
      
      
    final token = await storage.read(key: 'token') ?? '';
    if(token =='' || token == null){ print('No hay token en el request: '); return null;}
    final url = Uri.parse( '$_baseURL/api/categoria/${categoria.id}');
    final resp = await http.put(url, body: json.encode(categoryData),
    headers: {
    "Content-Type": "application/json", 
    'x-token': token
    });
    if(resp.statusCode == 200) {
      final index = categorias.indexWhere((element) => element.id == categoria.id);
      categorias[index] = categoria;
      print(categoria.nombre);
      return categoria.id;
    }
  
  }


  Future createCategory( Categoria categoria ) async {
    final Map<String,dynamic> categoryData = {
        'nombre': categoria.nombre,
        'descripcion': categoria.descripcion,
        'estado':  categoria.estado,
        'imagen': categoria.imagen,
        'tags': categoria.tags
    };
    print(categoria.estado);
    final url = Uri.parse( '$_baseURL/api/categoria');
    try {
    final token = await storage.read(key: 'token') ?? '';
    if(token ==''){ print('No hay token en el request: '); return null;}
    print(token);
    final resp = await http.post(url,
    body: json.encode(categoryData),
    headers: {
      "Content-Type": "application/json", 
      'x-token': token
    }
    ).timeout(const Duration(seconds: 30));
    print(resp.body);  
    
    final Map<String, dynamic> decodedResp = json.decode( resp.body);

    if( decodedResp.containsKey('id_profesor')) {
      categoria.id = decodedResp['_id'];
      categorias.add(categoria);
      final index = categorias.indexWhere((element) => element.id == categoria.id);
      categorias[index] = categoria;

      notifyListeners();
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

    Future deleteCategory( Categoria categoria ) async {
      
      final token = await storage.read(key: 'token') ?? '';
      if(token =='' || token == null){ print('No hay token en el request: '); return null;}
      final url = Uri.parse( '$_baseURL/api/categoria/${categoria.id}');
      final resp = await http.delete(url,
      headers: {
      "Content-Type": "application/json", 
      'x-token': token
      });
      if(resp.statusCode == 200) {
        final index = categorias.indexWhere((element) => element.id == categoria.id);
        categorias.removeAt(index);
        notifyListeners();
        print(categoria.nombre);
        return categoria.id;
      }
  
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