import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/models/models.dart';
import 'package:poli_gestor_contenidos/providers/category_provider.dart';
import 'package:poli_gestor_contenidos/providers/providers.dart';
import 'package:poli_gestor_contenidos/providers/subcategory_provider.dart';
import 'package:poli_gestor_contenidos/screens/screens.dart';
import 'package:poli_gestor_contenidos/services/auth_services.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/widgets/side_menu.dart';
import 'package:provider/provider.dart';

class ListCategoriesScreen extends StatelessWidget {

  static const String routerName = 'list-categories';

  const ListCategoriesScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
      final args = ModalRoute.of(context)?.settings.arguments ?? 'no data';
    final categoria = Provider.of<CategoryProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    
    if( categoria.isLoading ) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de categorias'),
        backgroundColor: AppTheme.primary
      ),
      drawer: const SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            _ListTags(tags: categoria.tags),
            _ListCategories(categoryProvider: categoria)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: (){
        categoria.selectedCategory = Categoria(
          descripcion: '',
          idProfesor: '',
          id: null,
          nombre: '',
          url: '',
          tags: ['GENERAL'],
          suscriptores: [],
          estado: 'PUBLICO',
          );
        Navigator.pushNamed(context, CategoryEditScreen.routerName);
      },
        backgroundColor: AppTheme.secondary,
        child: const Icon(Icons.add,size: 32, color: AppTheme.primary,),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 2,
      //   backgroundColor: Colors.grey,
      //   items: [
      //     BottomNavigationBarItem(label: 'Explorar', icon: Icon(Icons.topic_outlined, color: AppTheme.secondary,),),
      //     BottomNavigationBarItem(label: 'Explorar', icon: Icon(Icons.topic_outlined)),
      //     BottomNavigationBarItem(label: 'Categorias', icon: Icon(Icons.topic_outlined)),
      //   ]
      //   ),
    );
  }
}


class _ListTags extends StatelessWidget {
  final List<Tag> tags;
  const _ListTags({required this.tags});


  @override
  Widget build(BuildContext context) {
  final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    var boxDecoration = BoxDecoration(
        color: Preferences.isDarkMode ?  Colors.black45 :Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      );
    return Container(
      decoration: boxDecoration,
      height: 80,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index) {
          final cName = tags[index].name;
          return  Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _TagButton(tag: tags[index]),
                const SizedBox( height: 5,),
                Text('${cName[0].toUpperCase()}${cName.substring(1)}')
              ],
            ),
            );
        },
      ),
    );
  }
}

class _TagButton extends StatelessWidget {
  final Tag tag;
  const _TagButton({required this.tag});

  @override
  Widget build(BuildContext context) {
      final categoryProvider = Provider.of<CategoryProvider>(context);
    return GestureDetector(
      onTap: () {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
        categoryProvider.selectedTag = tag.name;
        print(categoryProvider.selectedTag);
      },
      child: Container(
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric( horizontal: 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2)
              ),
              child: Icon(
                tag.icon,
                color:  ( tag.name == categoryProvider.selectedTag)
                ? AppTheme.secondary
                : AppTheme.primary 
                ),
            ),
            
            

          ],
        ),
      ),
    );
  }
}

class _ListCategories extends StatelessWidget {
  const _ListCategories({
    Key? key,
    required this.categoryProvider,
  }) : super(key: key);

  final CategoryProvider categoryProvider;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final subcategoryProvider = Provider.of<SubcategoryProvider>(context, listen: false);
    return 
    categoryProvider.categorias.length >0 
    ? _List(categoryProvider: categoryProvider, subcategoryProvider: subcategoryProvider)
    : Container(
      width: double.infinity,
      // height: 500, 
      // color: Colors.red,
      child: Column(
        children: [
          Image(
            image: AssetImage('assets/404.png'),
            fit: BoxFit.cover,
          ),
          Text('No hay categorias sobre ${categoryProvider.selectedTag.toUpperCase()}', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center, )
        ],
      ),
      );
  }
}

class _List extends StatelessWidget {
  const _List({
    Key? key,
    required this.categoryProvider,
    required this.subcategoryProvider,
  }) : super(key: key);

  final CategoryProvider categoryProvider;
  final SubcategoryProvider subcategoryProvider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: categoryProvider.categorias.length,
        itemBuilder: (context, index) => 
        GestureDetector(
            onTap: () async{
              categoryProvider.selectedCategory = categoryProvider.categorias[index].copy();
              subcategoryProvider.selectedSubcategory.idCategoria = categoryProvider.categorias[index].id!;
              await subcategoryProvider.getSubcategorias();
              print(categoryProvider.selectedCategory.nombre);
              Navigator.pushNamed(context, CategoryDetailScreen.routerName);
            },
            child: Container(
              margin: EdgeInsets.only( top: 10, bottom: 5),
              decoration: BoxDecoration(
                  color: Preferences.isDarkMode ?  Colors.black45 :Colors.white,
                  borderRadius:  BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              padding: const EdgeInsets.only(left: 8,top: 8, bottom: 16),
              width: double.infinity,
              child: Row(
                children: [
                  CircleAvatar(radius: 35.0, backgroundImage: NetworkImage(categoryProvider.categorias[index].imagen != null && categoryProvider.categorias[index].imagen != '' ?  categoryProvider.categorias[index].imagen!  : 'https://www.ocu.org/-/media/ocu/images/home/alimentacion/alimentos/panes/panes-guia-compra.jpg' ),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only( left: 10, bottom: 10),
                          child: Text(categoryProvider.categorias[index].nombre, style: const TextStyle( fontSize: 14, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.68,
                          child: Padding(
                            padding: const EdgeInsets.only( left: 10),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(categoryProvider.categorias[index].descripcion,
                                    style: const TextStyle( fontSize: 12), maxLines: 4, overflow: TextOverflow.ellipsis,),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if(categoryProvider.categorias[index].tags.length != 0) 
                        TagsCategory(tag: categoryProvider.categorias[index].tags )
                      ],

                    ),
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,),
                      child: PopupMenuButton<int>(
                        onSelected: (item) {
                          switch (item) {
                            case 0:
                              categoryProvider.selectedCategory = categoryProvider.categorias[index].copy();
                              Navigator.pushNamed(context, CategoryEditScreen.routerName);
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
                    ),
                ],
                )
            ),
          ),
        ),
    );
  }
}

class TagsCategory extends StatelessWidget {
  const TagsCategory({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final List<String> tag;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width*0.68 ,
      child: Wrap(
        spacing: 6,
            children: [
              ...List.generate( tag.length, (i) => Chip(
                backgroundColor: categoryProvider.colorByTagName(tag[i]),
                padding: const EdgeInsets.all(1),
                elevation: 2,
                label: Text(tag[i], style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                

              ),)
            ],
          ),
    );
  }
}

