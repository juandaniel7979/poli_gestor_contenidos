import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/models/models.dart';
import 'package:poli_gestor_contenidos/models/subcategory.dart';

class SubcategoryFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Subcategoria subcategoria;
  
  SubcategoryFormProvider( this.subcategoria);

  updateAvailability(String value ) {
    print(value);
    subcategoria.estado = value;
    notifyListeners();
  }

  bool isValidForm() {

    print(subcategoria.id);
    print(subcategoria.nombre);
    print(subcategoria.descripcion);
    print(subcategoria.idProfesor);
    print(subcategoria.idCategoria);
    print(subcategoria.imagen);
    
    return formKey.currentState?.validate() ?? false;
  }


}