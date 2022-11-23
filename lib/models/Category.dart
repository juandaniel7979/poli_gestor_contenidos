// To parse this JSON data, do
//
//     final category = categoryFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Category {
    Category({
        this.total,
        required this.categorias,
    });

    final int? total;
    final List<Categoria> categorias;

    factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        total: json["total"],
        categorias: List<Categoria>.from(json["categorias"].map((x) => Categoria.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "total": total,
        "categorias": List<dynamic>.from(categorias.map((x) => x.toMap())),
    };
}

class Categoria {
      Categoria({
        this.imagen,
        this.id,
        required this.idProfesor,
        required this.nombre,
        required this.descripcion,
        required this.tags,
        this.url,
        this.suscriptores,
        required this.estado
    });

    String? id;
    String? imagen;
    String idProfesor;
    String nombre;
    String descripcion;
    List<String> tags;
    String? url;
    List<Suscriptores>? suscriptores;
    String estado;

    factory Categoria.fromJson(String str) => Categoria.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Categoria.fromMap(Map<String, dynamic> json) => Categoria(
        imagen: json["imagen"],
        id: json["_id"],
        idProfesor: json["id_profesor"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        url: json["url"],
        suscriptores: List<Suscriptores>.from(json["suscriptores"].map((x) => Suscriptores.fromMap(x))),
        estado: json["estado"],
    );

    Map<String, dynamic> toMap() => {
        "imagen": imagen,
        "_id": id,
        "id_profesor": idProfesor,
        "nombre": nombre,
        "descripcion": descripcion,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "url": url,
        "suscriptores": [],
        "estado": estado,
    };
        Categoria copy () => Categoria(
          id: id,
          descripcion: descripcion,
          estado: estado, 
          idProfesor: idProfesor,
          nombre: nombre,
          tags: tags,
          imagen: imagen,
          suscriptores: suscriptores,
          url: url,
        );
}

class Suscriptores {
    Suscriptores({
        required this.id,
        required this.estado,
    });

    final String id;
    final String estado;

    factory Suscriptores.fromJson(String str) => Suscriptores.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Suscriptores.fromMap(Map<String, dynamic> json) => Suscriptores(
        id: json["_id"],
        estado: json["estado"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "estado": estado,
    };


}
