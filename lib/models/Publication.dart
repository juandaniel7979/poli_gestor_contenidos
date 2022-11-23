// To parse this JSON data, do
//
//     final post = postFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';


class Publication {
    Publication(
      {
        this.id,
        required this.idUser,
        required this.estado,
        required this.description,
        this.picture,
        this.comments,
    });

    String? id;
    final String idUser;
    bool estado;
    String description;
    String? picture;
    List<Comment>? comments;

    factory Publication.fromJson(String str) => Publication.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Publication.fromMap(Map<String, dynamic> json) => Publication(
        // id: json["id"],
        idUser: json["idUser"],
        estado: json["estado"],
        description: json["description"],
        picture: json["picture"],
        // comments: List<Comment>.from(json["comments"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "idUser": idUser,
        "estado": estado,
        "description": description,
        "picture": picture,
        // "comments": List<Comment>.from(comments.map((x) => x)),
    };
    
    Publication copy () => Publication(
      id: id, 
      idUser: idUser, 
      description: description,
      picture: picture,
      estado: estado,
      comments: comments, 
    );
}


class Comment {
    Comment({
        required this.idUser,
        required this.detalle,
        required this.respuestas,
    });

    final String idUser;
    final String detalle;
    final List<Respuesta> respuestas;

    factory Comment.fromJson(String str) => Comment.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        idUser: json["idUser"],
        detalle: json["detalle"],
        respuestas: List<Respuesta>.from(json["respuestas"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "idUser": idUser,
        "detalle": detalle,
        "respuestas": List<dynamic>.from(respuestas.map((x) => x)),
    };
}

class Respuesta {
    Respuesta({
        required this.idUser,
        required this.detalle,
    });

    final String idUser;
    final String detalle;

    factory Respuesta.fromJson(String str) => Respuesta.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Respuesta.fromMap(Map<String, dynamic> json) => Respuesta(
        idUser: json["idUser"],
        detalle: json["detalle"],
    );

    Map<String, dynamic> toMap() => {
        "idUser": idUser,
        "detalle": detalle,
    };
}


