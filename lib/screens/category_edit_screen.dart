import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poli_gestor_contenidos/providers/category_form_provider.dart';
import 'package:poli_gestor_contenidos/providers/category_provider.dart';
import 'package:poli_gestor_contenidos/providers/providers.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:provider/provider.dart';

import 'package:poli_gestor_contenidos/ui/input_decorations.dart';
import 'package:poli_gestor_contenidos/widgets/widgets.dart';

class CategoryEditScreen extends StatelessWidget {

  static const String routerName = 'edit-category';
  const CategoryEditScreen({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

    final categoryProvider = Provider.of<CategoryProvider>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => CategoryFormProvider( categoryProvider.selectedCategory ),
      child: _ProductScreenBody(categoryProvider: categoryProvider),
      );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.categoryProvider,
  }) : super(key: key);

  final CategoryProvider categoryProvider;

  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<CategoryFormProvider>(context); 
    return DefaultTabController(
      length: 2,
      initialIndex: categoryProvider.selectedCategory.estado == 'PUBLICO' ? 0 : 1,
      child: Scaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Stack(
                children: [
                  BackgroundImage( url: categoryProvider.selectedCategory.imagen,),
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
                          categoryProvider.updateSelectedCategoryImage(pickedFile.path);
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
          onPressed: categoryProvider.isSaving
          ? null
          : () async {
            if( !categoryForm.isValidForm() ) return;
    
              final String? imageUrl = await categoryProvider.uploadImage();
    
              if( imageUrl != null ) categoryForm.categoria.imagen = imageUrl;
              print(categoryForm.categoria.imagen);
              print('ESTADO');
              print(categoryForm.categoria.estado);
              print('ESTADO');
              await categoryProvider.saveOrCreateCategoria(categoryForm.categoria);
    
          },
          child: categoryProvider.isSaving
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
  
  final categoryForm = Provider.of<CategoryFormProvider>(context);
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final categoria = categoryForm.categoria;
  
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
              key: categoryForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      style: TextStyle(color: Preferences.isDarkMode ? Colors.black : Colors.white),
                      initialValue: categoria.nombre,
                      onChanged: (value) => categoria.nombre = value,
                      validator: (value) {
                        if( value == null || value.isEmpty){
                          return 'El nombre es obligatorio';
                        }
                      },
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre de la categoria',
                        label: 'Nombre:',
                        color: Preferences.isDarkMode ? Colors.black45 : Colors.white
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(color: Preferences.isDarkMode ? Colors.black : Colors.white),
                      initialValue: categoria.descripcion,
                      onChanged: (value) => categoria.descripcion = value,
                      validator: (value) {
                        if( value == null || value.isEmpty){
                          return 'La descripcion es obligatorio';
                        }
                      },
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Descripcion de la categoria',
                        label: 'Descripcion:',
                        color: Preferences.isDarkMode ? Colors.black45 : Colors.white
                      ),
                    ),
                    
                    const SizedBox( height: 30,),

                    TabBar(
                      onTap: (selectedRol) {
                      switch(selectedRol) {
                        case 0: {
                          categoryForm.categoria.estado = "PUBLICO";
                          print(categoryForm.categoria.estado);
                        }
                        break;
                        case 1: {
                          categoryForm.categoria.estado = "PRIVADO";
                          print(categoryForm.categoria.estado);
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