import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/models/models.dart';

class CategoryFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Categoria categoria;
  
  CategoryFormProvider( this.categoria);

  updateAvailability(String value ) {
    print(value);
    categoria.estado = value;
    notifyListeners();
  }

  bool isValidForm() {

    print(categoria.id);
    print(categoria.nombre);
    print(categoria.descripcion);
    print(categoria.tags);
    print(categoria.url);
    
    return formKey.currentState?.validate() ?? false;
  }


}