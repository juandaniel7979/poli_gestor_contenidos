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
        required this.estado
    });

    String? id;
    String? imagen;
    String idProfesor;
    String nombre;
    String descripcion;
    List<String> tags;
    String? url;
    String estado;


    String get printTags {
      String temp = '';
      for (var tag in tags) {
        temp += tag;
      }
      return temp;
    }


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
          url: url,
        );
}


class Suscriptores {
    Suscriptores({
        required this.suscriptor,
        required this.estado,
        required this.id,
    });

    Suscriptor suscriptor;
    final String estado;
    final String id;

    factory Suscriptores.fromJson(String str) => Suscriptores.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Suscriptores.fromMap(Map<String, dynamic> json) => Suscriptores(
        suscriptor: json["suscriptor"],
        estado: json["estado"],
        id: json["_id"],
    );

    Map<String, dynamic> toMap() => {
        "suscriptor": suscriptor.toMap(),
        "estado": estado,
        "_id": id,
    };
}
class Suscriptor {
    Suscriptor({
        required this.nit,
        required this.nombre,
        this.nombre2,
        required this.apellido,
        this.apellido2,
        this.imagen,
        required this.correo,
        required this.contrasena,
        required this.rol,
        required this.estado,
        // required this.uid,
    });

    // final List<Map<String, dynamic>>? siguiendo;
    final String nit;
    final String nombre;
    String? nombre2;
    final String apellido;
    String? apellido2;
    String? imagen;
    final String correo;
    final String contrasena;
    final String rol;
    final String estado;
    // final String uid;

    // get nombreCompleto => '$nombre ${nombre2 == null ? '' : nombre2} $apellido ${apellido2==null ? '' : apellido2}';
    get nombreCompleto => '$nombre $apellido ';


    factory Suscriptor.fromJson(String str) => Suscriptor.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Suscriptor.fromMap(Map<String, dynamic> json) => Suscriptor(
        nit: json["nit"],
        nombre: json["nombre"],
        nombre2: json["nombre_2"] == null ? null : json["nombre_2"],
        apellido: json["apellido"],
        apellido2: json["apellido_2"]  == null ? null : json["apellido_2"],
        correo: json["correo"],
        contrasena: json["contrasena"],
        imagen: json["imagen"]  == null ? null : json["imagen"],
        rol: json["rol"],
        estado: json["estado"],
        // uid: json["uid"],
    );

    Map<String, dynamic> toMap() => {
        "nit": nit,
        "nombre": nombre,
        "nombre_2": nombre2 == null ? null : nombre2,
        "apellido": apellido,
        "apellido_2": apellido2 == null ? null : nombre2,
        "correo": correo,
        "contrasena": contrasena,
        "rol": rol,
        "estado": estado,
        // "uid": uid,
    };
}

