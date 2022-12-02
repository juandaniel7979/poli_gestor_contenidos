import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:poli_gestor_contenidos/helpers/debouncer.dart';
import 'package:poli_gestor_contenidos/models/category.dart';
import 'package:poli_gestor_contenidos/models/users_stats.dart';

class SearchService extends ChangeNotifier {
  

final String _baseUrl = '192.168.56.1:3001';

bool _isLoading = true;

List<Categoria> usuarios = [];

final storage = const FlutterSecureStorage();

final debouncer = Debouncer(
  duration: const Duration( milliseconds: 500)
);

final StreamController<List<Categoria>> _suggestionStreamController = StreamController.broadcast();
Stream<List<Categoria>> get suggestionStream => _suggestionStreamController.stream;



Future<List<Categoria>> searchUsuarios 

( String query ) async{ 
    var url = Uri.http(_baseUrl, '/api/buscar/categorias/$query', {
        'x-token': await readToken(),
    });

    final response = await http.get(url);
    final searchResponse = Category.fromJson( response.body);
    
    return searchResponse.categorias;
  }
  
  void getSuggestionByQuery( String searchTerm) {
    
    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final results = await searchUsuarios(searchTerm);
      _suggestionStreamController.add( results );
    };
    final timer = Timer.periodic(const Duration( milliseconds: 300 ), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 300)).then((_) => timer.cancel());
  }


  Future<String> readToken() async {

    return await storage.read(key: 'token') ?? '';
  
  }

}