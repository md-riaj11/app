import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../config/app_images_config.dart';
import '../../../core/components/headline_with_row.dart';
import '../../../core/models/category.dart';
import '../../../core/routes/app_routes.dart';
import '../category_page.dart';
import 'category_tile.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    Key? key,
    required this.categories,
  }) : super(key: key);

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: HeadlineRow(headline: 'categories', isHeader: false),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final _data = categories[index];
                final _background =
                    index < AppImagesConfig.categoriesImages.length
                        ? AppImagesConfig.categoriesImages[index]
                        : AppImagesConfig.defaultCategoryImage;
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: CategoryTile(
                      categoryModel: _data,
                      backgroundImage: _background,
                      onTap: () {
                        final _arguments = CategoryPageArguments(
                          category: _data,
                          backgroundImage: _background,
                        );
                        Navigator.pushNamed(
                          context,
                          AppRoutes.category,
                          arguments: _arguments,
                        );
                      },
                      // backgroundImage: '',
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
