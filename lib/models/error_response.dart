// To parse this JSON data, do
//
//     final error = errorFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Errors {
    Errors({
        required this.errors,
    });

    final List<Error> errors;

    factory Errors.fromJson(String str) => Errors.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Errors.fromMap(Map<String, dynamic> json) => Errors(
        errors: List<Error>.from(json["errors"].map((x) => Error.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "errors": List<dynamic>.from(errors.map((x) => x.toMap())),
    };
}

class Error {
    Error({
        required this.value,
        required this.msg,
        required this.param,
        required this.location,
    });

    final String value;
    final String msg;
    final String param;
    final String location;

    factory Error.fromJson(String str) => Error.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Error.fromMap(Map<String, dynamic> json) => Error(
        value: json["value"],
        msg: json["msg"],
        param: json["param"],
        location: json["location"],
    );

    Map<String, dynamic> toMap() => {
        "value": value,
        "msg": msg,
        "param": param,
        "location": location,
    };
}
