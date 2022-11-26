import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poli_gestor_contenidos/forms/subcategory_form_provider.dart';
import 'package:poli_gestor_contenidos/models/subcategory.dart';
import 'package:poli_gestor_contenidos/providers/category_provider.dart';
import 'package:poli_gestor_contenidos/providers/providers.dart';
import 'package:poli_gestor_contenidos/providers/subcategory_provider.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/ui/input_decorations.dart';
import 'package:poli_gestor_contenidos/widgets/background_image.dart';
import 'package:provider/provider.dart';

class SubcategoryEditScreen extends StatelessWidget {
  static const routerName = "subcategory-edit";
  const SubcategoryEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final subcategoryProvider = Provider.of<SubcategoryProvider>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => SubcategoryFormProvider( subcategoryProvider.selectedSubcategory ),
      child: _CategoryScreenBody(subcategoryProvider: subcategoryProvider),
      );
  }
}

class _CategoryScreenBody extends StatelessWidget {
  const _CategoryScreenBody({
    Key? key,
    required this.subcategoryProvider,
  }) : super(key: key);

  final SubcategoryProvider subcategoryProvider;

  @override
  Widget build(BuildContext context) {
    final subcategoryForm = Provider.of<SubcategoryFormProvider>(context); 
    return DefaultTabController(
      length: 2,
      initialIndex: subcategoryProvider.selectedSubcategory.estado == 'PUBLICO' ? 0 : 1,
      child: Scaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Stack(
                children: [
                  BackgroundImage( url: subcategoryProvider.selectedSubcategory.imagen,),
                  Positioned(
                    top: 60,
                    left: 15,
                    child: IconButton(
                      onPressed: () {
                        subcategoryProvider.selectedSubcategory = Subcategoria(
                          nombre: '',
                          estado: '',
                          id: '',
                          idCategoria: '',
                          idProfesor: '',
                          descripcion: '',
                          imagen: ''    
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
                          subcategoryProvider.updateSelectedSubategoryImage(pickedFile.path);
                      },
                      icon: const Icon( Icons.camera_alt_outlined, size: 40, color: Colors.white,),
                    ),
                  ),
                ],
              ),
              
              const SizedBox( height: 30,),
    
              const _CategoryForm(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.secondary,
          onPressed: subcategoryProvider.isSaving
          ? null
          : () async {
            if( !subcategoryForm.isValidForm() ) return;
    
              final String? imageUrl = await subcategoryProvider.uploadImage();
    
              if( imageUrl != null ) subcategoryForm.subcategoria.imagen = imageUrl;
              // print(subcategoryForm.subcategoria.imagen);
              // print(subcategoryForm.subcategoria.estado);
              await subcategoryProvider.saveOrCreateCategoria(subcategoryForm.subcategoria);
    
          },
          child: subcategoryProvider.isSaving
          ? const CircularProgressIndicator( color: Colors.white,)
          : const Icon( Icons.save_outlined),
        ),
      ),
    );
  }
}

class _CategoryForm extends StatelessWidget {


  const _CategoryForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
  final subcategoryForm = Provider.of<SubcategoryFormProvider>(context);
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final subcategoria = subcategoryForm.subcategoria;
  
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
              key: subcategoryForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      style: TextStyle(color: Preferences.isDarkMode ? Colors.white : Colors.black),
                      initialValue: subcategoria.nombre,
                      onChanged: (value) => subcategoria.nombre = value,
                      validator: (value) {
                        if( value == null || value.isEmpty){
                          return 'El nombre es obligatorio';
                        }
                      },
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre de la subcategoria',
                        label: 'Nombre:',
                        color: Preferences.isDarkMode ? Colors.black45 : Colors.white
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(color: Preferences.isDarkMode ? Colors.white : Colors.black),
                      initialValue: subcategoria.descripcion,
                      onChanged: (value) => subcategoria.descripcion = value,
                      validator: (value) {
                        if( value == null || value.isEmpty){
                          return 'La descripcion es obligatorio';
                        }
                      },
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Descripcion de la subcategoria',
                        label: 'Descripcion:',
                        color: Preferences.isDarkMode ? Colors.black45 : Colors.white
                      ),
                    ),
                    
                    const SizedBox( height: 30,),

                    TabBar(
                      onTap: (selectedRol) {
                      switch(selectedRol) {
                        case 0: {
                          subcategoryForm.subcategoria.estado = "PUBLICO";
                          print(subcategoryForm.subcategoria.estado);
                        }
                        break;
                        case 1: {
                          subcategoryForm.subcategoria.estado = "PRIVADO";
                          print(subcategoryForm.subcategoria.estado);
                        }
                        break;

                      }
                    },
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(10)
                    ),
                      tabs: const [
                        Tab(text: 'PUBLICO', icon: Icon(Icons.public)),
                        Tab(text: 'PRIVADO', icon: Icon(Icons.lock),),
                      ]
                    ),
                  
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