// To parse this JSON data, do
//
//     final suscripciones = suscripcionesFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Suscripciones {
    Suscripciones({
      required this.suscripciones,
    });

    final List<Suscripcion> suscripciones;

    factory Suscripciones.fromJson(String str) => Suscripciones.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Suscripciones.fromMap(Map<String, dynamic> json) => Suscripciones(
        suscripciones: List<Suscripcion>.from(json["suscripciones"].map((x) => Suscripcion.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "suscripciones": List<dynamic>.from(suscripciones.map((x) => x.toMap())),
    };
}

class Suscripcion {
    Suscripcion({
      required this.id,
      required this.categoria,
      required this.usuario,
      required this.estado,
    });

    final String id;
    final CategoriaSuscripcion categoria;
    final User usuario;
    final String estado;

    factory Suscripcion.fromJson(String str) => Suscripcion.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Suscripcion.fromMap(Map<String, dynamic> json) => Suscripcion(
        id: json["_id"],
        categoria: CategoriaSuscripcion.fromMap(json["categoria"]),
        usuario: User.fromMap(json["usuario"]),
        estado: json["estado"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "categoria": categoria.toMap(),
        "usuario": usuario.toMap(),
        "estado": estado,
    };
}

class CategoriaSuscripcion{
    CategoriaSuscripcion({
      required this.id,
      required this.idProfesor,
      required this.nombre,
      required this.descripcion,
      required this.tags,
      required this.url,
      required this.imagen,
      required this.estado,
    });

    final String id;
    final String idProfesor;
    final String nombre;
    final String descripcion;
    final List<String> tags;
    final String url;
    final String imagen;
    final String estado;

    factory CategoriaSuscripcion.fromJson(String str) => CategoriaSuscripcion.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CategoriaSuscripcion.fromMap(Map<String, dynamic> json) => CategoriaSuscripcion(
        id: json["_id"],
        idProfesor: json["id_profesor"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        url: json["url"],
        imagen: json["imagen"],
        estado: json["estado"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "id_profesor": idProfesor,
        "nombre": nombre,
        "descripcion": descripcion,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "url": url,
        "imagen": imagen,
        "estado": estado,
    };
}

class User {
    User({
      required this.nit,
      required this.nombre,
      required this.nombre2,
      required this.apellido,
      required this.apellido2,
      required this.correo,
      required this.contrasena,
      required this.imagen,
      required this.rol,
      required this.estado,
      required this.siguiendo,
      required this.uid,
    });

    final String nit;
    final String nombre;
    final String nombre2;
    final String apellido;
    final String apellido2;
    final String correo;
    final String contrasena;
    final String imagen;
    final String rol;
    final String estado;
    final List<dynamic> siguiendo;
    final String uid;

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        nit: json["nit"],
        nombre: json["nombre"],
        nombre2: json["nombre_2"],
        apellido: json["apellido"],
        apellido2: json["apellido_2"],
        correo: json["correo"],
        contrasena: json["contrasena"],
        imagen: json["imagen"],
        rol: json["rol"],
        estado: json["estado"],
        siguiendo: List<dynamic>.from(json["siguiendo"].map((x) => x)),
        uid: json["uid"],
    );

    Map<String, dynamic> toMap() => {
        "nit": nit,
        "nombre": nombre,
        "nombre_2": nombre2,
        "apellido": apellido,
        "apellido_2": apellido2,
        "correo": correo,
        "contrasena": contrasena,
        "imagen": imagen,
        "rol": rol,
        "estado": estado,
        "siguiendo": List<dynamic>.from(siguiendo.map((x) => x)),
        "uid": uid,
    };
}
