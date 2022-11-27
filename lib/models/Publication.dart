// To parse this JSON data, do
//
//     final publicaciones = publicacionesFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Publicaciones {
    Publicaciones({
        required this.publicaciones,
    });

    final List<Publicacion> publicaciones;

    factory Publicaciones.fromJson(String str) => Publicaciones.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Publicaciones.fromMap(Map<String, dynamic> json) => Publicaciones(
        publicaciones: List<Publicacion>.from(json["publicaciones"].map((x) => Publicacion.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "publicaciones": List<dynamic>.from(publicaciones.map((x) => x.toMap())),
    };
}

class Publicacion {
    Publicacion({
        required this.id,
        required this.idSubcategoria,
        required this.idProfesor,
        required this.nombre,
        this.descripcion,
        required this.imagenes,
        required this.estado,
    });

    String id;
    String idSubcategoria;
    String idProfesor;
    String nombre;
    String? descripcion;
    final List<String> imagenes;
    String estado;

    factory Publicacion.fromJson(String str) => Publicacion.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Publicacion.fromMap(Map<String, dynamic> json) => Publicacion(
        id: json["_id"],
        idSubcategoria: json["id_subcategoria"],
        idProfesor: json["id_profesor"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        imagenes: List<String>.from(json["imagenes"].map((x) => x)),
        estado: json["estado"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "id_subcategoria": idSubcategoria,
        "id_profesor": idProfesor,
        "nombre": nombre,
        "descripcion": descripcion,
        "imagenes": List<dynamic>.from(imagenes.map((x) => x)),
        "estado": estado,
    };


    Publicacion copy () => Publicacion(
          id: id,
          idSubcategoria: idSubcategoria,
          idProfesor: idProfesor,
          descripcion: descripcion,
          estado: estado, 
          nombre: nombre,
          imagenes: imagenes,
        );
}
