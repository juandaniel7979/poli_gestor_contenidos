import 'dart:convert';

class Profesor {
    Profesor({
        required this.administrador,
        required this.id,
        required this.uid,
        required this.nombre,
        this.nombre2,
        required this.apellido,
        this.apellido2,
        required this.correo,
        required this.estado,
    });

    final int administrador;
    final String id;
    final String uid;
    final String nombre;
    final String? nombre2;
    final String apellido;
    final String? apellido2;
    final String correo;
    int estado;

    factory Profesor.fromJson(String str) => Profesor.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Profesor.fromMap(Map<String, dynamic> json) => Profesor(
        administrador: json["administrador"],
        id: json["_id"],
        uid: json["uid"],
        nombre: json["nombre"],
        nombre2: json["nombre_2"],
        apellido: json["apellido"],
        apellido2: json["apellido_2"],
        correo: json["correo"],
        estado: json["estado"],
    );

    Map<String, dynamic> toMap() => {
        "administrador": administrador,
        "_id": id,
        "uid": uid,
        "nombre": nombre,
        "nombre_2": nombre2,
        "apellido": apellido,
        "apellido_2": apellido2,
        "correo": correo,
        "estado": estado,
    };

}