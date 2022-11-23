import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/models/models.dart';
import 'package:poli_gestor_contenidos/screens/archives_screen.dart';
import 'package:poli_gestor_contenidos/screens/feedback_screen.dart';
import 'package:poli_gestor_contenidos/screens/publication_edit_screen.dart';
import 'package:poli_gestor_contenidos/screens/screens.dart';
// import 'package:poli_gestor_contenidos/services/auth_services.dart';
import 'package:poli_gestor_contenidos/services/publications_services.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  static const String routerName = 'category';
  const CategoryScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final publicationService = Provider.of<PublicationsServices>(context);
    if( publicationService.isLoading ) return const LoadingScreen();
    return ChangeNotifierProvider(
      create: (context) => _NavegationModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Category - {CategoryName}'),
          backgroundColor: AppTheme.primary,
        ),
        drawer: SideMenu(),
        body: _Paginas(),
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
      bottomNavigationBar: const _Navegacion(),
      ),
    );
  }
}

class _Navegacion extends StatelessWidget {
  const _Navegacion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navegationModel = Provider.of<_NavegationModel>(context);

    return BottomNavigationBar(
        currentIndex: navegationModel.paginaActual,
        onTap: (i) => navegationModel.paginaActual = i,
        backgroundColor: AppTheme.primary,
        items: const [
            BottomNavigationBarItem(
              icon: Icon( Icons.home_outlined),
              label: 'Publicaciones'
              ),
            BottomNavigationBarItem(
              icon: Icon( Icons.archive),
              label: 'Archivos'
              ),
        ],
      );
  }
}



class _Paginas extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final navegationModel = Provider.of<_NavegationModel>(context);

    return PageView(
      controller: navegationModel.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const <Widget>[
          FeedbackScreen(),
          ArchivesScreen()
      ],
    );
  }
}


class _NavegationModel with ChangeNotifier {
  int _paginaActual = 0;

  final PageController _pageController = PageController(initialPage: 0);

  int get paginaActual => _paginaActual;

  set paginaActual( int valor ) {
    _paginaActual = valor;
    _pageController.animateToPage(valor, duration: const Duration( milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  PageController get pageController => _pageController;
}