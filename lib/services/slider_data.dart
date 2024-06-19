import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_feed_app/models/slider_model.dart';

class Sliders {
  List<SliderModel> sliders = [];

  Future<void> getSlider() async {
    String url =
        'https://berita-indo-api-next.vercel.app/api/antara-news/top-news';

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    jsonData["data"].forEach((element) {
      if (element['image'] != null && element['description'] != null) {
        SliderModel sliderModel = SliderModel(
            title: element['title'],
            link: element["link"],
            isoDate: element['isoDate'],
            image: element['image'],
            description: element['description']);
        sliders.add(sliderModel);
      }
    });
  }
}
