import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poli_gestor_contenidos/forms/publication_form_provider.dart';
import 'package:poli_gestor_contenidos/forms/subcategory_form_provider.dart';
import 'package:poli_gestor_contenidos/models/login_user.dart';
import 'package:poli_gestor_contenidos/models/models.dart';
import 'package:poli_gestor_contenidos/providers/providers.dart';
import 'package:poli_gestor_contenidos/providers/publication_provider.dart';
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
      child: _PublicationScreenBody(publicationProvider: publicationProvider),
      );
  }

}

class _PublicationScreenBody extends StatelessWidget {
  const _PublicationScreenBody({
    Key? key,
    required this.publicationProvider,
  }) : super(key: key);

  final PublicationProvider publicationProvider;

  @override
  Widget build(BuildContext context) {
    final publicationForm = Provider.of<PublicationFormProvider>(context); 
    final usuario = Provider.of<AuthService>(context,listen: false); 
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
// TODO: listViewBuilder imagenes
              // BackgroundImage( url: publicationService.selectedPublicacion.picture,),
                publicationProvider.selectedPublicacion.imagenes.length>0
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
                      final picker = ImagePicker();
                      // final filePicker
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