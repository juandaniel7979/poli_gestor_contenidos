import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/models/models.dart';

class PublicationFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Publicacion publication;
  
  PublicationFormProvider( this.publication);

  updateAvailability(String value ) {
    print(value);
    publication.estado = value;
    notifyListeners();
  }

  bool isValidForm() {

    print(publication.descripcion);
    print(publication.id);
    print(publication.estado);
      print(publication.imagenes);
    
    return formKey.currentState?.validate() ?? false;
  }


}