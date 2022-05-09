import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../config/wp_config.dart';
import '../../models/author.dart';

class UserRepository {
  static Future<AuthorData?> getUserNamebyID(int id) async {
    final _url = 'https://${WPConfig.url}/wp-json/wp/v2/users/$id';
    try {
      final _response = await http.get(Uri.parse(_url));
      if (_response.statusCode == 200) {
        final _decodedData = jsonDecode(_response.body);
        final _author = AuthorData.fromMap(_decodedData);
        return _author;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error happened while fetching author data');
      return null;
    }
    return null;
  }
}
