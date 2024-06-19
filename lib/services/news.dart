import 'dart:convert';

import 'package:news_feed_app/models/article_model.dart';
import 'package:http/http.dart' as http;

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    String url =
        'https://berita-indo-api-next.vercel.app/api/antara-news/terkini';

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    jsonData["data"].forEach((element) {
      if (element['image'] != null && element['description'] != null) {
        ArticleModel articleModel = ArticleModel(
            title: element['title'],
            link: element["link"],
            isoDate: element['isoDate'],
            image: element['image'],
            description: element['description']);
        news.add(articleModel);
      }
    });
  }
}
