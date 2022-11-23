import 'package:flutter/material.dart';
 
dynamic showMyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        title: const Text('Seleccione una imagen o tome una fotografía'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Icon(Icons.camera_alt, size: 50, color: Colors.indigo),
                      Text('Cámara')
                    ],
                  ),
                  Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(Icons.storage, size: 50, color: Colors.indigo),
                      const Text('Galería')
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cámara',
                style: TextStyle(fontSize: 17, color: Colors.indigo)),
            onPressed: () {
              Navigator.of(context).pop(1);
            },
          ),
          TextButton(
            child: const Text('Galería',
                style: TextStyle(fontSize: 17, color: Colors.indigo)),
            onPressed: () {
              Navigator.of(context).pop(2);
            },
          ),
          TextButton(
            child: const Icon(Icons.close_rounded, color: Colors.red, size: 40),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// onPressed: () async {
//                       final selection = await showMyDialog(context);
//                       if (selection == null) return;
//                       final picker = ImagePicker();
//                       final XFile? pickedFile = await picker.pickImage(
//                         source: (selection == 1)
//                             ? ImageSource.camera
//                             : ImageSource.gallery,
//                         imageQuality: 100,
//                       );
//                       if (pickedFile == null) return;
//                       productService
//                           .updateSelectedProductImage(pickedFile.path);
//                     },