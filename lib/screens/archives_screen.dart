import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';
import 'package:poli_gestor_contenidos/widgets/side_menu.dart';

class ArchivesScreen extends StatelessWidget {

  const ArchivesScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text('Archivos'),
      ),
      body: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[400],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 15,
                    runSpacing: 10,
                    children: [
                      ...List.generate(18,
                        (index) => Container(
                        padding: const EdgeInsets.all(8),
                        width: 150,
                        color: Colors.grey,
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        index%3 ==0 
                        ?Icon(Icons.folder_zip_outlined, color: AppTheme.secondary, size: 38,)
                        :Icon(Icons.photo, color: AppTheme.primary, size: 38,),
                        index%3 ==0 
                        ? Container(
                          width: double.infinity,
                          height: 50,
                          child: Text('archivo_${index*4821874}_19_11_2021.zip', textAlign: TextAlign.center,),
                          )
                        :Container(
                          width: double.infinity,
                          height: 50,
                          child: Text('imagen_${index*4821874}_19_11_2021.jpg', textAlign: TextAlign.center),
                          ),
                        ],)
                        
                        )
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      drawer: SideMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: AppTheme.secondary,
        child: Icon(Icons.add),
      ),
    );
  }
}