import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/models/subcategory.dart';
import 'package:poli_gestor_contenidos/providers/category_provider.dart';
import 'package:poli_gestor_contenidos/providers/subcategory_provider.dart';
import 'package:poli_gestor_contenidos/screens/subcategory_edit_screen.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/widgets/background_image.dart';
import 'package:provider/provider.dart';

class CategoryDetailScreen extends StatelessWidget {
  static const String routerName = 'category-detail';

  const CategoryDetailScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final categoria = Provider.of<CategoryProvider>(context);
    final subcategoria = Provider.of<SubcategoryProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: (){
              subcategoria.subcategorias = [];
              Navigator.pop(context);
            },
          ),
          title: Text('Categoria: ${categoria.selectedCategory.nombre}'),
        ),
        body: Stack(
          children: [
            BackgroundImage(url: categoria.selectedCategory.imagen,),
            Container(
              margin: const EdgeInsets.only(top: 310),
              decoration: const BoxDecoration(
                color:AppTheme.primary
              ),
              child: TabBar(
                onTap: (value){
                  print(subcategoria.subcategorias.length);
                  // print(categoria.selectedCategory.suscriptores.length);
                },
                tabs: [
                Tab(child: Text('SUBCATEGORIAS'),),
                Tab(child: Text('APROBAR ESTUDIANTES'),),
              ]),
            ),
            Container(
              margin: EdgeInsets.only(top: 350),
              height: 500,
              child: TabBarView(children: [
                subcategoria.subcategorias.length > 0
                ?_ListSubcategories(subcategoria: subcategoria)
                : Container(
                  margin: EdgeInsets.all(8),
                  width: double.infinity,
                  height: 300,
                  // color: Colors.red,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/no-subcategorias.png'), fit: BoxFit.cover,
                        height: 250,
                        ),
                      Text("Aún no existen subcategorias dentro de esta categoria", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Preferences.isDarkMode ? Colors.white :  Colors.black87), textAlign: TextAlign.center,)
                    ]
                    ),
                  ),
                categoria.selectedCategory.suscriptores.length >0
                ? _ListSuscriptions(categoria: categoria)
                : Container(
                  width: double.infinity,
                  height: 200,
                  // color: Colors.red,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/404.png'), fit: BoxFit.cover,
                        height: 250,
                        ),
                      Text("No hay suscripciones por aprobar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Preferences.isDarkMode ? Colors.white :  Colors.black87), textAlign: TextAlign.center,)
                    ]
                    ),
                  ),
              ]),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.secondary,
          onPressed: (){
              subcategoria.selectedSubcategory = Subcategoria(
                id: '',
                idCategoria: categoria.selectedCategory.id!,
                imagen: null,
                descripcion: '',
                idProfesor: '',
                nombre: '',
                estado: 'PUBLICO',
                );
              Navigator.pushNamed(context, SubcategoryEditScreen.routerName);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class _ListSubcategories extends StatelessWidget {
  const _ListSubcategories({
    Key? key,
    required this.subcategoria,
  }) : super(key: key);

  final SubcategoryProvider subcategoria;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Preferences.isDarkMode ?Colors.black26 : Colors.white,
      ),
      child: ListView.builder(
        itemCount: subcategoria.subcategorias.length,
        itemBuilder: (context, index) => _SubcategoryCard(subcategoria: subcategoria, index: index,),
        ),
    );
  }
}

class _SubcategoryCard extends StatelessWidget {
  final int index;
  const _SubcategoryCard({
    Key? key,
    required this.subcategoria, required this.index,
  }) : super(key: key);

  final SubcategoryProvider subcategoria;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Preferences.isDarkMode ?Colors.black26 : Colors.white,
          borderRadius: BorderRadius.circular(8)
          
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 330,
                child: Row(
                  children: [
                    _SubcategoryImage(subcategoria: subcategoria, index: index),
                    _SubcategoryLabels(subcategoria: subcategoria, index: index),

                  ],
                ),
              ),
              _SubcategoryIconMenu(subcategoria: subcategoria, index: index),
            
            ],
          ),
        )),
    );
  } 
}

class _SubcategoryIconMenu extends StatelessWidget {
  const _SubcategoryIconMenu({
    Key? key,
    required this.subcategoria,
    required this.index,
  }) : super(key: key);

  final SubcategoryProvider subcategoria;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,),
      child: PopupMenuButton<int>(
        onSelected: (item) {
          switch (item) {
            case 0:
              subcategoria.selectedSubcategory = subcategoria.subcategorias[index].copy();
              Navigator.pushNamed(context, SubcategoryEditScreen.routerName);
              break;
            case 1:
              // TODO: ELIMINAR
              break;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem<int>(value: 0, child: Text('Editar')),
          const PopupMenuItem<int>(value: 1, child: Text('Eliminar')),
        ],
      ),
    );
  }
}

class _SubcategoryLabels extends StatelessWidget {
  const _SubcategoryLabels({
    Key? key,
    required this.subcategoria,
    required this.index,
  }) : super(key: key);

  final SubcategoryProvider subcategoria;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 230,
          child: Text('${subcategoria.subcategorias[index].nombre}',
            style: TextStyle(color: Preferences.isDarkMode ?Colors.white : Colors.black45, fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, maxLines: 2,
          ),
        ),
        const SizedBox(height: 5,),
        Container(
          width: 250,
          child: Text('${subcategoria.subcategorias[index].descripcion ?? 'Esta subcategoria no cuenta con una descripcion'}',
            style: TextStyle(color: Preferences.isDarkMode ?Colors.white : Colors.black45, fontSize: 14), overflow: TextOverflow.ellipsis, softWrap: true, maxLines: 1,),
        )
      ],
    );
  }
}

class _SubcategoryImage extends StatelessWidget {
  const _SubcategoryImage({
    Key? key,
    required this.subcategoria,
    required this.index,
  }) : super(key: key);

  final SubcategoryProvider subcategoria;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
    margin: EdgeInsets.symmetric( horizontal: 5, vertical: 15),
    child: (subcategoria.subcategorias[index].imagen != null && subcategoria.subcategorias[index].imagen != '' ) 
    ? ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FadeInImage(
        fit: BoxFit.cover,
        placeholder: AssetImage('assets/no-image.png'),
        image: NetworkImage( subcategoria.subcategorias[index].imagen! ),
      ),
    )
    : ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: const Image(image: AssetImage('assets/no-image.png'),
      fit: BoxFit.cover,
      ))
    );
  }
}


class _ListSuscriptions extends StatelessWidget {
    final CategoryProvider categoria;
  const _ListSuscriptions({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Preferences.isDarkMode ?Colors.black26 : Colors.white,
      ),
      child: ListView.builder(
        itemCount: categoria.selectedCategory.suscriptores.length,
        itemBuilder: (context, index) => _SuscriptionCard(categoria: categoria, index: index,),
        ),
    );
  }
}

class _SuscriptionCard extends StatelessWidget {
  final int index;
  final CategoryProvider categoria;
  const _SuscriptionCard({
    Key? key, 
    required this.index,
    required this.categoria,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Preferences.isDarkMode ?Colors.black26 : Colors.white,
          borderRadius: BorderRadius.circular(8)
          
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Container(
              width: 250,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                width: 50,
                height: 50,
              margin: const EdgeInsets.symmetric( horizontal: 5, vertical: 15),
              // TODO: Reemplazar imagenes
              child: (categoria.selectedCategory.suscriptores[index].id != null) 
              ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/no-image.png'),
                  image: NetworkImage( 'https://i.pinimg.com/originals/92/33/38/923338a4952114e7a040b12d15be600f.jpg'),
                ),
              )
              : const Image(image: AssetImage('assets/no-image.png'))
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text('${categoria.selectedCategory.suscriptores[index].suscriptor.nombreCompleto} ',
                      style: TextStyle(color: Preferences.isDarkMode ?Colors.white : Colors.black45, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    child: Text('${categoria.selectedCategory.suscriptores[index].estado }',
                      style: TextStyle(color: Preferences.isDarkMode ?Colors.white : Colors.black45, fontSize: 14), overflow: TextOverflow.ellipsis, softWrap: true, maxLines: 1,),
                  )
                ],
              ),
                ],
              ),
            ),
              Container(
                padding: EdgeInsets.all(2),
                child: IconButton(
                  onPressed: (){
                    // TODO: APROBAR USUARIO
                  },
                  icon: const Icon(Icons.check, color: AppTheme.primary, size: 36,)
                  ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                child: IconButton(
                  onPressed: (){
                    // TODO: RECHAZAR USUARIO
                  },
                  icon: Icon(Icons.close, color: Colors.red, size: 36,)
                  ),
              ),
            ],
          ),
        )),
    );
  } 
}
