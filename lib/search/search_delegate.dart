import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/models/category.dart';
import 'package:poli_gestor_contenidos/services/search_service.dart';
import 'package:provider/provider.dart';

class PoliSearchDelegate extends SearchDelegate{

  @override
  // TODO: implement searchFieldLabel
  // String? get searchFieldLabel => super.searchFieldLabel;
  String? get searchFieldLabel => 'Buscar categoria';


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
        )
    ];

  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: Icon(Icons.arrow_back_ios)
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text('buildActions'); 
  }

  Widget _emptyContainer() {
    return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, color: Colors.black38, size: 100,),
                  Container(
                    width: 300,
                    child: Text("Busca una categoria de tu interes", style: TextStyle( fontSize: 24), textAlign: TextAlign.center,)),
                ],
              ),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if( query.isEmpty) {
      return _emptyContainer();
    }

    final searchService = Provider.of<SearchService>(context);
    searchService.getSuggestionByQuery( query );
    // return FutureBuilder(
    //   future: searchService.searchMovies(query),
    //   builder: ( _, AsyncSnapshot<List<Usuario>> snapshot ) {
    //     if( !snapshot.hasData ) return _emptyContainer();   
    //     final usuarios = snapshot.data!;
    //     return ListView.builder(
    //       itemCount: usuarios.length,
    //       itemBuilder: ( _, int index) => _UserItem(usuarios[index]),
    //     );
    //   },
    // );
    return StreamBuilder(
      stream: searchService.suggestionStream,
      builder: ( _, AsyncSnapshot<List<Categoria>> snapshot ) {
        if( !snapshot.hasData ) return _emptyContainer();
        
        final usuarios = snapshot.data!;
        return ListView.builder(
          itemCount: usuarios.length,
          itemBuilder: ( _, int index) => _UserItem(usuarios[index]),
        );
      },
    );
  }

}

class _UserItem extends StatelessWidget {
  final Categoria categoria;
  const _UserItem(this.categoria);

  @override
  Widget build(BuildContext context) {
    
    // categoria.heroId = 'search-${ categoria.id }';

    return Container(
              margin: EdgeInsets.all(8),
              height: 100,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.cyan,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image(
                          height: 90,
                          image: AssetImage('assets/no-image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 26, left: 10),
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(categoria.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
                        Text(categoria.id!, style: const TextStyle(fontSize: 12), textAlign: TextAlign.start,),
                        Text(categoria.estado, style: const TextStyle(fontSize: 12), textAlign: TextAlign.start,),
                      ],
                    )
                    ),
                  ]),
                ],
              ),
            );
  }
}