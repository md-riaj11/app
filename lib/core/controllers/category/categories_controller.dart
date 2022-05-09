import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/wp_config.dart';
import '../../models/category.dart';
import '../../repositories/categories/category_repository.dart';

final categoriesController =
    StateNotifierProvider<CategoriesNotifier, List<CategoryModel>>((ref) {
  return CategoriesNotifier();
});

class CategoriesNotifier extends StateNotifier<List<CategoryModel>> {
  CategoriesNotifier() : super([]) {
    {
      getAllCategories();
    }
  }

  final _repo = CategoriesRepository();

  final CategoryModel _featureCategory = CategoryModel(
    id: 0, // ignored
    name: WPConfig.featureCategoryName,
    slug: '', // ignored
    link: '', // ignored
  );

  Future<List<CategoryModel>> getAllCategories() async {
    final _data = await _repo.getAllCategory();
    _data.insert(0, _featureCategory);
    state = _data;
    return state;
  }

  Future<List<CategoryModel>> getAllFeatureCategories() async {
    List<CategoryModel> _categories = [];

    if (WPConfig.homeCategories.isNotEmpty) {
      WPConfig.homeCategories.forEach((id, name) {
        _categories.add(
          CategoryModel(
            id: id,
            name: name,
            slug: '',
            link: '',
          ),
        );
      });
    } else {
      _categories = await _repo.getAllCategory();
    }

    _categories.insert(0, _featureCategory);

    return _categories;
  }

  addCategories(List<CategoryModel> data) {
    state = [...state, ...data];
  }

  /// Provides Category Name From category id
  List<String> categoriesName(List<int> data) {
    List<String> _names = [];
    for (var id in data) {
      try {
        final _singleName = state.singleWhere((element) => element.id == id);
        _names.add(_singleName.name);
      } catch (e) {
        // Fluttertoast.showToast(msg: 'No Category Found');
        debugPrint('$id not found in category');
      }
    }
    return _names;
  }
}
