import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:poli_gestor_contenidos/providers/providers.dart';
import 'package:poli_gestor_contenidos/services/publications_services.dart';
import 'package:provider/provider.dart';

import 'package:poli_gestor_contenidos/providers/product_form_provider.dart';
import 'package:poli_gestor_contenidos/ui/input_decorations.dart';
import 'package:poli_gestor_contenidos/widgets/widgets.dart';

class PublicationEditScreen extends StatelessWidget {

  static const String routerName = 'edit-publication';
  const PublicationEditScreen({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

    final publicationService = Provider.of<PublicationsServices>(context);


    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider( publicationService.selectedPublication ),
      child: _ProductScreenBody(publicationService: publicationService),
      );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.publicationService,
  }) : super(key: key);

  final PublicationsServices publicationService;

  @override
  Widget build(BuildContext context) {
    final publicationForm = Provider.of<ProductFormProvider>(context); 
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                BackgroundImage( url: publicationService.selectedPublication.picture,),
                Positioned(
                  top: 60,
                  left: 15,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon( Icons.arrow_back_ios_new, size: 40, color: Colors.white,),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      
                      final picker = ImagePicker();
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
                        publicationService.updateSelectedPublicationimage(pickedFile.path);
                    },
                    icon: const Icon( Icons.camera_alt_outlined, size: 40, color: Colors.white,),
                  ),
                ),
              ],
            ),
            
            const SizedBox( height: 100,),

            const _PublicationForm(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: publicationService.isSaving
        ? null
        : () async {
          if( !publicationForm.isValidForm() ) return;

            final String? imageUrl = await publicationService.uploadImage();

            if( imageUrl != null ) publicationForm.publication.picture = imageUrl;

            await publicationService.saveOrCreatePublication(publicationForm.publication);

        },
        child: publicationService.isSaving
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
  
  final publicationForm = Provider.of<ProductFormProvider>(context);
  final publication = publicationForm.publication;
  final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal:  10),
      child: Container(
        padding: const EdgeInsets.symmetric( horizontal: 20),
        width: double.infinity,
        height: 300,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: publicationForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10,),
              TextFormField(
                initialValue: publication.description,
                onChanged: (value) => publication.description = value,
                validator: (value) {
                  if( value == null || value.isEmpty){
                    return 'El nombre es obligatorio';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  label: 'Nombre:',
                  color: themeProvider.currentTheme.backgroundColor
                ),
              ),

              const SizedBox( height: 30,),
              
              
              SwitchListTile.adaptive(
                value: publication.estado,
                title: const Text('Visible'),
                activeColor: Colors.indigo,
                onChanged: publicationForm.updateAvailability,
              ),

              const SizedBox( height: 30,),


            ],
          ),
        ),
      ),
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