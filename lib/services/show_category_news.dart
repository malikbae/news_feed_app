import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_feed_app/models/show_category.dart';
import 'package:news_feed_app/models/slider_model.dart';

class ShowCategoryNews {
  List<ShowCategoryModel> categories = [];

  Future<void> getCategoriesNews(String category) async {
    String url =
        'https://berita-indo-api-next.vercel.app/api/antara-news/$category';

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    jsonData["data"].forEach((element) {
      if (element['image'] != null && element['description'] != null) {
        ShowCategoryModel categoryModel = ShowCategoryModel(
            title: element['title'],
            link: element["link"],
            isoDate: element['isoDate'],
            image: element['image'],
            description: element['description']);
        categories.add(categoryModel);
      }
    });
  }
}
