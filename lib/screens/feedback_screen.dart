import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/forms/publication_form_provider.dart';
import 'package:poli_gestor_contenidos/models/models.dart';
import 'package:poli_gestor_contenidos/providers/publication_provider.dart';
import 'package:poli_gestor_contenidos/providers/subcategory_provider.dart';
import 'package:poli_gestor_contenidos/screens/publication_edit_screen.dart';
import 'package:poli_gestor_contenidos/screens/screens.dart';
import 'package:poli_gestor_contenidos/services/auth_services.dart';
import 'package:poli_gestor_contenidos/share_preferences/preferences.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/widgets/widgets.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatelessWidget {
  static const String routerName = 'feedback';
  const FeedbackScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final publicationProvider = Provider.of<PublicationProvider>(context);
    final subcategoryProvider = Provider.of<SubcategoryProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);


    if( publicationProvider.isLoading ) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(subcategoryProvider.selectedSubcategory.nombre),
      ),
      drawer: const SideMenu(),
      body: 
      publicationProvider.publicaciones.length < 1
      ? Container(
        width: double.infinity,
        // color: Colors.red,
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/404.png'), fit: BoxFit.cover,
              height: 450,
              ),
            Text("No hay publicaciones aun", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Preferences.isDarkMode ? Colors.white :  Colors.black87), textAlign: TextAlign.center,)
          ]
          ),
      )
      : _ListPublications(publicationProvider: publicationProvider),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.secondary,
        child: const Icon(Icons.add),
        onPressed: (){
            // TODO: Añadir id de la subcategoria
          publicationProvider.selectedPublicacion = Publicacion(
            id: '',
            idSubcategoria: subcategoryProvider.selectedSubcategory.id,
            idProfesor: '',
            descripcion: '',
            estado: 'PUBLICO',
            imagenes: [],
            );
          Navigator.pushNamed(context, PublicationEditScreen.routerName);
        },
    ),
    // bottomNavigationBar: _Navegacion(),
    );
  }
}

class _ListPublications extends StatelessWidget {
  const _ListPublications({
    Key? key,
    required this.publicationProvider,
  }) : super(key: key);

  final PublicationProvider publicationProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: publicationProvider.publicaciones.length,
      itemBuilder: ((context, index){
      var textStyle = const TextStyle( fontSize: 15, color: Colors.black);
      // print(txtSize.height);
      return Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                      onBackgroundImageError: (exception, stackTrace) => Colors.white,
                      // backgroundImage: NetworkImage(publicationProvider.publications[index].picture ?? 'https://placeholder.com/300x300')),
                      backgroundImage: NetworkImage('https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/one-piece-luffy-1589967502.jpg')),
                    const SizedBox( width: 10,),
                    Text('Juan Daniel Vargas Ramírez',textAlign: TextAlign.start, style: TextStyle( fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, 
                      color: Colors.red
                      ),
                      onPressed: () {},
                      ),
                  ],
                ),
                Container(
                  height: 150,
                  child: SingleChildScrollView(
                    child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(publicationProvider.publicaciones[index].descripcion , style: textStyle),
                  )),
                ),
              ],
            ),
          ),
          GestureDetector(
          onTap: () {
            publicationProvider.selectedPublicacion = publicationProvider.publicaciones[index].copy();
            Navigator.pushNamed(context, PublicationEditScreen.routerName);
          },
          child: PublicationCard(publication: publicationProvider.publicaciones[index])
          ),
        ],
        
      );

      }
      ),
    );
    
  }
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 5, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}


