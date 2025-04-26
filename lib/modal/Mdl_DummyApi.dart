import 'dart:convert';

import 'package:agni_chit_saving/routes/app_export.dart';
import 'package:http/http.dart' as http;

class MdlDummyapi {
  int userid;
  int id;
  String tittle;
  String body;

  MdlDummyapi({
    required this.userid,
    required this.id,
    required this.tittle,
    required this.body,
  });

  factory MdlDummyapi.fromjson(Map<String, dynamic> json) {
    return MdlDummyapi(
        userid: json['userId'] ?? '',
        id: json['id'] ?? '',
        tittle: json['title'] ?? '',
        body: json['body'] ?? '');
  }
}
