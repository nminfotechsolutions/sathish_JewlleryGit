import 'dart:convert';

import 'package:agni_chit_saving/modal/Mdl_DummyApi.dart';
import 'package:http/http.dart' as http;

import '../utils/commonUtils.dart';

class MdlDummyapiservices {
  Future<MdlDummyapi?> fetchData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        commonUtils.log.i(data);
        return MdlDummyapi.fromjson(data);
      } else {
        commonUtils.log.e('Failes to fecth');
        return null;
      }
    } catch (e) {
      commonUtils.log.e('Failes cathc${e}');
      return null;
    }
  }
}
