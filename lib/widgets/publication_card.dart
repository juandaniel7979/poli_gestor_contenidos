import 'package:flutter/material.dart';
import 'package:poli_gestor_contenidos/models/models.dart';
import 'package:poli_gestor_contenidos/themes/app_theme.dart';

class PublicationCard extends StatelessWidget {

  final Publication publication;
  final Size size;

  const PublicationCard({super.key, required this.publication, required this.size});


  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only( bottom:20, top: size.width/8 <100 ? 80: size.width/5),
      width: double.infinity,
      // height: 400,
      decoration: PublicationcardBorders(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          _BackgroundImage( url: publication.picture,),
        ],
      ),
      );
  }

  BoxDecoration PublicationcardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0,7),
            blurRadius: 10
          )
        ]
      );
}

class _PublicationDescription extends StatelessWidget {
  final String description;
  const _PublicationDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( description, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), maxLines: 4,), //overflow: TextOverflow.ellipsis,),
          ],
        ),
        ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
    color: AppTheme.primary,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25) ),

  );
}




class _BackgroundImage extends StatelessWidget {

  final String? url;
  const _BackgroundImage({ this.url });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
              width: double.infinity,
              height: 400,
              child: url == null 
              ? const Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              ) 
              : FadeInImage(
                // TODO: Fix image not available
                placeholder: const AssetImage('assets/jar-loading.gif'),
                // image: NetworkImage('https://via.placeholder.com/400x300'),
                image: NetworkImage(url!),
                fit: BoxFit.cover,
              ),
              ),
    );
  }
}
