import 'package:flutter/material.dart';
import 'package:kofoos/src/common/back_button_widget.dart';
import 'package:kofoos/src/pages/search/api/search_api.dart';
import 'package:kofoos/src/pages/search/search_product_page.dart';

class SearchCategoryPage extends StatelessWidget {
  const SearchCategoryPage({Key? key}) : super(key: key);

  Widget _category(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: [
        CategoryButton(
          title: 'Snack/Chocolate/Cereal',
          // 중분류
          subcategories: [
            'Snack',
            'Cereal',
            'Chocolate',
            'Chewing Gum',
            'Candy',
            'Pie',
            'Biscuit/Cookie',
            'Processed meat',
            'etc',
          ],
        ),
        CategoryButton(
          title: 'Dessert/Bakery',
          // 중분류
          subcategories: [
            'Dessert',
            'Bakery',
            'Puree',
            'Pudding/Jelly',
          ],
        ),
        CategoryButton(
          title: 'Ramen',
          // 중분류
          subcategories: [
            'Packaged Ramen',
            'Cup Ramen',
          ],
        ),
        CategoryButton(
          title: 'Convenience Food',
          // 중분류
          subcategories: [
            'Chilled/Frozen Food',
            'Retort Food',
            'Side dishes',
          ],
        ),
        CategoryButton(
          title: 'Canned/Jarred Food',
          // 중분류
          subcategories: [
            'Jarred Food',
            'Canned Food',
          ],
        ),
        CategoryButton(
          title: 'Milk/Butter/Cheese',
          // 중분류
          subcategories: [
            'Milk',
            'Butter',
            'Cheese',
            'Ice cream',
            'Yogurt',
          ],
        ),
        CategoryButton(
          title: 'Grains/Noodles',
          // 중분류
          subcategories: [
            'Grains',
            'Dried Noodles',
          ],
        ),
        CategoryButton(
          title: 'Beverage',
          // 중분류
          subcategories: [
            'Water',
            'Sparkling Water',
            'Tea',
            'Functional Beverage',
            'Fruit/Vegetable Juice',
            'Soda',
            'Coffee',
            'Soy Milk',
            'etc',
          ],
        ),
        CategoryButton(
          title: 'Alcoholic Beverage',
          // 중분류
          subcategories: [
            'Soju',
            'Beer',
            'Wine',
            'Traditional Liquor',
            'etc',
          ],
        ),
        CategoryButton(
          title: 'Coffee/Tea',
          // 중분류
          subcategories: [
            'Liquid Tea',
            'Powdered Tea',
            'Coffee Creamer',
          ],
        ),
        CategoryButton(
          title: 'Sauce/Seasoning',
          // 중분류
          subcategories: [
            'Sauce',
            'Oil',
            'Powder',
            'Seasoning',
            'Korean traditional sauce',
          ],
        ),
        CategoryButton(
          title: 'Pet Supplies',
          // 중분류
          subcategories: [
            'Pet Treats',
            'Pet Food',
          ],
        ),
        CategoryButton(
          title: 'Health Supplement',
          // 중분류
          subcategories: [
            'Nutritional Supplement',
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _category(context),
              ],
            ),
          ),
          BackButtonWidget(),
        ],
      ),
    );
  }
}

// 대분류
class CategoryButton extends StatefulWidget {
  final String title;
  final List<String> subcategories;

  CategoryButton({required this.title, required this.subcategories});

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

// 대분류 상태
class _CategoryButtonState extends State<CategoryButton> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Align to the right
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // Adding SizedBox to create spacing
                SizedBox(width: 20.0),
                // 화살표 아이콘 추가
                Icon(isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Column(
              children: widget.subcategories
                  .map((subcategory) => SubcategoryTile(
                  categoryName: widget.title, subcategoryName: subcategory))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

// 중분류
class SubcategoryTile extends StatefulWidget {
  final String categoryName;
  final String subcategoryName;

  SubcategoryTile({required this.categoryName, required this.subcategoryName});

  @override
  _SubcategoryTileState createState() => _SubcategoryTileState();
}

class _SubcategoryTileState extends State<SubcategoryTile> {
  int subcategoryCount = 0; // 소분류 개수 초기값
  SearchApi searchApi = SearchApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFECECEC),
      child: ListTile(
        title: Text(
          widget.subcategoryName,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchProductPage(
                  cat1: widget.categoryName,
                  cat2: widget.subcategoryName,
                  order: " "),
            ),
          );
        },
      ),
    );
  }
}
