import 'package:meta/meta.dart';
import 'dart:convert';

class Subcategory {
    Subcategory({
        required this.total,
        required this.subcategorias,
    });

    final int total;
    final List<Subcategoria> subcategorias;

    factory Subcategory.fromJson(String str) => Subcategory.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Subcategory.fromMap(Map<String, dynamic> json) => Subcategory(
        total: json["total"],
        subcategorias: List<Subcategoria>.from(json["Subcategorias"].map((x) => Subcategoria.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "total": total,
        "Subcategorias": List<dynamic>.from(subcategorias.map((x) => x.toMap())),
    };
}

class Subcategoria {
    Subcategoria({
        required this.id,
        required this.idCategoria,
        required this.idProfesor,
        required this.nombre,
        this.descripcion,
        this.imagen,
        required this.estado,
    });

    final String id;
    final String idCategoria;
    final String idProfesor;
    final String nombre;
    String? descripcion;
    String? imagen;
    String estado;

    factory Subcategoria.fromJson(String str) => Subcategoria.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Subcategoria.fromMap(Map<String, dynamic> json) => Subcategoria(
        id: json["_id"],
        idCategoria: json["id_categoria"],
        idProfesor: json["id_profesor"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        imagen: json["imagen"],
        estado: json["estado"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "id_categoria": idCategoria,
        "id_profesor": idProfesor,
        "nombre": nombre,
        "descripcion": descripcion,
        "imagen": imagen,
        "estado": estado,
    };
    Subcategoria copy () => Subcategoria(
          id: id,
          idCategoria: idCategoria,
          idProfesor: idProfesor,
          descripcion: descripcion,
          estado: estado, 
          nombre: nombre,
          imagen: imagen,
        );
}
