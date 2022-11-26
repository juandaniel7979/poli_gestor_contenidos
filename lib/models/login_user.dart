// To parse this JSON data, do
//
//     final loginUser = loginUserFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class LoginUser {
    LoginUser({
        required this.usuario,
        required this.token,
    });

    final Usuario usuario;
    final String token;

    factory LoginUser.fromJson(String str) => LoginUser.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory LoginUser.fromMap(Map<String, dynamic> json) => LoginUser(
        usuario: Usuario.fromMap(json["usuario"]),
        token: json["token"],
    );

    Map<String, dynamic> toMap() => {
        "usuario": usuario.toMap(),
        "token": token,
    };
}


class Usuario {
    Usuario({
        required this.siguiendo,
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
        required this.uid,
    });

    final List<dynamic> siguiendo;
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
    final String uid;

    get nombreCompleto => '$nombre ${nombre2 == null ? '' : nombre2} $apellido ${apellido2==null ? '' : apellido2}';


    factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        siguiendo: List<dynamic>.from(json["siguiendo"].map((x) => x)),
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
        uid: json["uid"],
    );

    Map<String, dynamic> toMap() => {
        "siguiendo": List<dynamic>.from(siguiendo.map((x) => x)),
        "nit": nit,
        "nombre": nombre,
        "nombre_2": nombre2 == null ? null : nombre2,
        "apellido": apellido,
        "apellido_2": apellido2 == null ? null : nombre2,
        "correo": correo,
        "contrasena": contrasena,
        "rol": rol,
        "estado": estado,
        "uid": uid,
    };
}
