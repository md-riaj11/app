import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../config/wp_config.dart';
import '../../models/category.dart';

abstract class CategoriesRepoAbstract {
  /// Gets all the category from the website
  Future<List<CategoryModel>> getAllCategory();

  /// Get Single Category
  Future<CategoryModel?> getCategory(int id);
}

class CategoriesRepository extends CategoriesRepoAbstract {
  @override
  Future<List<CategoryModel>> getAllCategory() async {
    final _client = http.Client();
    String _url =
        'https://${WPConfig.url}/wp-json/wp/v2/categories/?per_page=100';
    List<CategoryModel> _allCategories = [];
    try {
      final _response = await _client.get(Uri.parse(_url));

      if (_response.statusCode == 200) {}
      final _allData = jsonDecode(_response.body) as List;
      _allCategories = _allData.map((e) => CategoryModel.fromMap(e)).toList();
      _allCategories = _removeBlockedCategories(_allCategories);
      return _allCategories;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    } finally {
      _client.close();
    }
  }

  @override
  Future<CategoryModel?> getCategory(int id) async {
    final _client = http.Client();
    String _url = 'https://${WPConfig.url}/wp-json/wp/v2/categories/$id';
    try {
      final _response = await _client.get(Uri.parse(_url));
      if (_response.statusCode == 200) {
        return CategoryModel.fromJson(_response.body);
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    } finally {
      _client.close();
    }
  }

  /// Removes Blocked Categories defined in [WPConfig]
  List<CategoryModel> _removeBlockedCategories(List<CategoryModel> data) {
    final _blockedData = WPConfig.blockedCategoriesIds;
    for (var blockedID in _blockedData) {
      data.removeWhere((element) => element.id == blockedID);
    }
    return data;
  }
}
