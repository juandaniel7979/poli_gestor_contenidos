import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/models/models.dart';

class PublicationFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Publication publication;
  
  PublicationFormProvider( this.publication);

  updateAvailability(bool value ) {
    print(value);
    publication.estado = value;
    notifyListeners();
  }

  bool isValidForm() {

    print(publication.description);
    print(publication.id);
    print(publication.estado);
    
    return formKey.currentState?.validate() ?? false;
  }


}