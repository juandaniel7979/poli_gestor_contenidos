import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/providers/category_provider.dart';
import 'package:poli_gestor_contenidos/providers/subcategory_provider.dart';
import 'package:poli_gestor_contenidos/widgets/background_image.dart';
import 'package:provider/provider.dart';

class CategoryDetailScreen extends StatelessWidget {
  static const String routerName = 'category-detail';

  const CategoryDetailScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final subcategoryProvider = Provider.of<SubcategoryProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Categoria: ${categoryProvider.selectedCategory.nombre}'),
        ),
        body: Stack(
          children: [
            BackgroundImage(url: categoryProvider.selectedCategory.imagen,),
            Container(
              margin: EdgeInsets.only(top: 310),
              child: TabBar(
                onTap: (value){
                  print(subcategoryProvider.subcategorias.length);
                },
                tabs: [
                Tab(child: Text('SUBCATEGORIAS'),),
                Tab(child: Text('APROBAR ESTUDIANTES'),),
              ]),
            ),
            Container(
              margin: EdgeInsets.only(top: 350),
              height: 300,
              child: TabBarView(children: [
                Container(
                  margin: EdgeInsets.only(top: 500),
                  decoration: BoxDecoration(
                    color: Colors.red
                  ),
                  child: ListView.builder(
                    itemCount: subcategoryProvider.subcategorias.length,
                    itemBuilder: (context, index) => Text('${subcategoryProvider.subcategorias[index].nombre}'),
                    ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  width: double.infinity,
                  height: 300,
                  color: Colors.indigo
                  ),
              ]),
            ),
            
            
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //     child: Container(
          //       width: double.infinity,
          //       height: 399,
          //       color: Colors.red
          //       ),
          //   )
          ],
        ),
      ),
    );
  }
}