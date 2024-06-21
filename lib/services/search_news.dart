import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_feed_app/models/search_model.dart';
import 'package:news_feed_app/models/show_category.dart';

class SearchNewsData {
  List<SearchNewsModel> searchNews = [];

  Future<void> getSearchNews(String search) async {
    String url =
        "https://berita-indo-api-next.vercel.app/api/antara-news/terkini?search='$search'";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    jsonData["data"].forEach((element) {
      if (element['image'] != null && element['description'] != null) {
        SearchNewsModel searchNewsModel = SearchNewsModel(
            title: element['title'],
            link: element["link"],
            isoDate: element['isoDate'],
            image: element['image'],
            description: element['description']);
        searchNews.add(searchNewsModel);
      }
    });
  }
}
