import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/models/models.dart';
import 'package:poli_gestor_contenidos/screens/archives_screen.dart';
import 'package:poli_gestor_contenidos/screens/publication_edit_screen.dart';
import 'package:poli_gestor_contenidos/screens/screens.dart';
import 'package:poli_gestor_contenidos/services/auth_services.dart';
import 'package:poli_gestor_contenidos/services/publications_services.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/widgets/widgets.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatelessWidget {
  static const String routerName = 'feedback';
  const FeedbackScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final publicationService = Provider.of<PublicationsServices>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    if( publicationService.isLoading ) return const LoadingScreen();
    return Scaffold(
      drawer: SideMenu(),
      body: _ListPublications(publicationService: publicationService),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          publicationService.selectedPublication = Publication(
            description: '',
            estado: true,
            idUser: ''
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
    required this.publicationService,
  }) : super(key: key);

  final PublicationsServices publicationService;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: publicationService.publications.length,
      itemBuilder: ((context, index){
      var textStyle = const TextStyle( fontSize: 15, color: Colors.black);
      final Size txtSize = _textSize(publicationService.publications[index].description, textStyle);
      // print(txtSize.height);
      return Stack(
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
                      backgroundImage: NetworkImage(publicationService.publications[index].picture ?? 'https://placeholder.com/300x300')),
                    const SizedBox( width: 10,),
                    Text('Juan Daniel Vargas Ramírez',textAlign: TextAlign.start, style: TextStyle( fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, 
                      color: Colors.white38
                      ),
                      onPressed: () {},
                      ),
                  ],
                ),
                SingleChildScrollView(child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(publicationService.publications[index].description, style: textStyle),
                )),
              ],
            ),
          ),
          GestureDetector(
          onTap: () {
            publicationService.selectedPublication = publicationService.publications[index].copy();
            Navigator.pushNamed(context, PublicationEditScreen.routerName);
          },
          child: PublicationCard(publication: publicationService.publications[index], size: txtSize)
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


