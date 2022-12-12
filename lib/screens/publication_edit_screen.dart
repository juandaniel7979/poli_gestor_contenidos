
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poli_gestor_contenidos/forms/publication_form_provider.dart';
import 'package:poli_gestor_contenidos/models/models.dart';
import 'package:poli_gestor_contenidos/providers/providers.dart';
import 'package:poli_gestor_contenidos/services/auth_services.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/ui/input_decorations.dart';
import 'package:poli_gestor_contenidos/widgets/background_image.dart';
import 'package:provider/provider.dart';

class PublicationEditScreen extends StatelessWidget {
  static const routerName = "publication-edit";
  const PublicationEditScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final publicationProvider = Provider.of<PublicationProvider>(context);


    return ChangeNotifierProvider(
      create: ( _ ) => PublicationFormProvider( publicationProvider.selectedPublicacion ),
      child: const _PublicationScreenBody(),
      );
  }

}

class _PublicationScreenBody extends StatelessWidget {
  const _PublicationScreenBody({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final publicationProvider = Provider.of<PublicationProvider>(context);
  
  
  XFile? _showcontent() {
      final picker = ImagePicker();
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!
    
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro que desea borrar esta categoria?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('¿Quieres seleccionar una imagen de galeria o tomar una foto?'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final XFile? pickedFile = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 100
                ); 
        
                if( pickedFile == null) {
                  print('No seleccionó nada');
                  return;
                }
                print('Tenemos imagen ${ pickedFile.path}');
                publicationProvider.updateSelectedPublicationImage(pickedFile.path);
                Navigator.of(context).pop();
              },
              child: const Text('Galeria'),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () async{
              
              final XFile? pickedFile = await picker.pickImage(
                source: ImageSource.camera,
                // source: ImageSource.gallery,
                imageQuality: 100
                ); 
        
                if( pickedFile == null) {
                  print('No seleccionó nada');
                  return;
                }
                print('Tenemos imagen ${ pickedFile.path}');
                publicationProvider.updateSelectedPublicationImage(pickedFile.path);
                Navigator.of(context).pop();
              },
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );
    }


    final publicationForm = Provider.of<PublicationFormProvider>(context); 
    final usuario = Provider.of<AuthService>(context); 
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: const Text('algo'),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Stack(
                children: [
                // TODO: listViewBuilder imagenes
                // BackgroundImage( url: publicationProvider.selectedPublicacion.imagenes[0],),
                    publicationProvider.selectedPublicacion.imagenes.isNotEmpty
                    ?BackgroundImage( url: publicationProvider.selectedPublicacion.imagenes[0],)
                    :BackgroundImage( url: '',),
    
                  Positioned(
                    top: 60,
                    left: 15,
                    child: IconButton(
                      onPressed: () {
                      publicationProvider.selectedPublicacion = Publicacion(
                                  id: '',
                                  idSubcategoria: '',
                                  idProfesor: '',
                                  descripcion: '',
                                  estado: 'PUBLICO',
                                  imagenes: [],
                                  profesor: usuario.usuario
                                  );
                        Navigator.of(context).pop();
                      },
                      icon: const Icon( Icons.arrow_back_ios_new, size: 40, color: Colors.white,),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      onPressed: () async {
                        // final filePicker = await FilePicker.platform.pickFiles(allowMultiple: false);
                        //   if (filePicker != null) {
                        //       publicationProvider.updateSelectedPublicationImage(filePicker.files.single.path!);
                        //   }else{
                        //     print('No seleccionó nada');
                        //       return;
                        //   }
          
                        final XFile? pickedFile = _showcontent();
                  
                          if( pickedFile == null) {
                            print('No seleccionó nada');
                            return;
                          }
                          print('Tenemos imagen ${ pickedFile.path}');
                          publicationProvider.updateSelectedPublicationImage(pickedFile.path);

                      },
                      icon: const Icon( Icons.camera_alt_outlined, size: 40, color: Colors.white,),
                    ),
                  ),
                ],
              ),
              const SizedBox( height: 30,),
              const _PublicationForm(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.secondary,
          onPressed: publicationProvider.isSaving
          ? null
          : () async {
            if( !publicationForm.isValidForm() ) return;
      
              final String? imageUrl = await publicationProvider.uploadImage();
              publicationForm.publication.profesor = usuario.usuario;
              if( imageUrl != null ) publicationForm.publication.imagenes.add(imageUrl);
              // print(publicationForm.publicacion.imagen);
              // print(publicationForm.publicacion.estado);
              await publicationProvider.saveOrCreatePublicacion(publicationForm.publication);
      
          },
          child: publicationProvider.isSaving   
          ? const CircularProgressIndicator( color: Colors.white,)
          : const Icon( Icons.save_outlined),
        ),
      ),
    );
  }

  
  }

class _PublicationForm extends StatelessWidget {


  const _PublicationForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
  final publicationForm = Provider.of<PublicationFormProvider>(context);
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final publicacion = publicationForm.publication;
  
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric( horizontal:  10),
          child: Container(
            padding: const EdgeInsets.symmetric( horizontal: 20),
            width: double.infinity,
            height: 450,
            decoration: _buildBoxDecoration(),
            child: Form(
              key: publicationForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(color: Preferences.isDarkMode ? Colors.white : Colors.black),
                      initialValue: publicacion.descripcion,
                      onChanged: (value) => publicacion.descripcion = value,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if( value == null || value.isEmpty){
                          return 'La descripcion es obligatorio';
                        }
                      },
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Descripcion de la publicacion',
                        label: 'Descripcion:',
                        color: Preferences.isDarkMode ? Colors.black45 : Colors.white
                      ),
                    ),
                    
                    const SizedBox( height: 30,),

                    // TabBar(
                    //   onTap: (selectedRol) {
                    //   switch(selectedRol) {
                    //     case 0: {
                    //       publicationForm.publication.estado = "PUBLICO";
                    //       print(publicationForm.publication.estado);
                    //     }
                    //     break;
                    //     case 1: {
                    //       publicationForm.publication.estado = "PRIVADO";
                    //       print(publicationForm.publication.estado);
                    //     }
                    //     break;

                    //   }
                    // },
                    // labelColor: Colors.white,
                    // unselectedLabelColor: Colors.grey,
                    // indicator: BoxDecoration(
                    //   color: AppTheme.primary,
                    //   borderRadius: BorderRadius.circular(10)
                    // ),
                    //   tabs: const [
                    //     Tab(text: 'PUBLICO', icon: Icon(Icons.public)),
                    //     Tab(text: 'PRIVADO', icon: Icon(Icons.lock),),
                    //   ]
                    // ),
                  
                    const SizedBox( height: 30,),
                  
                  
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only( bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(0,5),
        blurRadius: 5
      )
    ]
  );
}