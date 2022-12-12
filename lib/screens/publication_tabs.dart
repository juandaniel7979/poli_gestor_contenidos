import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/screens/archives_screen.dart';
import 'package:poli_gestor_contenidos/screens/feedback_screen.dart';
import 'package:provider/provider.dart';


class PublicationTabsPage extends StatelessWidget {
  static const routerName = 'publication-tabs-page';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ( _ ) => _NavegationModel(),
      child: Scaffold(
        body: _Paginas(),
        bottomNavigationBar: _Navegacion(),
      ),
    );
  }
}

class _Navegacion extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final navegationModel = Provider.of<_NavegationModel>(context);

    return BottomNavigationBar(
      currentIndex: navegationModel.paginaActual,
      onTap: (i) => navegationModel.paginaActual = i,
      items: const [
        BottomNavigationBarItem( icon: Icon( Icons.person_outline), label: 'Explorar' ),
        BottomNavigationBarItem( icon: Icon( Icons.public), label: 'Archivos' ),
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
      children: const [
        FeedbackScreen(),
        ArchivesScreen(),

      ],
    );
  }
}


class _NavegationModel with ChangeNotifier {
  int _paginaActual = 0;

  final PageController _pageController = PageController(initialPage: 0);
// eae7a8c6d2f840d1a2595dafe0a195df

  int get paginaActual => _paginaActual;

  set paginaActual( int valor ) {
    _paginaActual = valor;
    _pageController.animateToPage(valor, duration: const Duration( milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  PageController get pageController => _pageController;
}