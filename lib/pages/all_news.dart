import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_feed_app/models/article_model.dart';
import 'package:news_feed_app/models/slider_model.dart';
import 'package:news_feed_app/pages/article_news.dart';
import 'package:news_feed_app/services/news.dart';
import 'package:news_feed_app/services/slider_data.dart';

class AllNews extends StatefulWidget {
  String news;
  AllNews({required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];

  @override
  void initState() {
    getSlider();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {});
  }

  getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider();
    sliders = slider.sliders;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Berita " + widget.news,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount:
                widget.news == "Trending" ? sliders.length : articles.length,
            itemBuilder: (context, index) {
              return AllNewsSection(
                  image: widget.news == "Trending"
                      ? sliders[index].image!
                      : articles[index].image!,
                  description: widget.news == "Trending"
                      ? sliders[index].description!
                      : articles[index].description!,
                  title: widget.news == "Trending"
                      ? sliders[index].title!
                      : articles[index].title!,
                  link: widget.news == "Trending"
                      ? sliders[index].link!
                      : articles[index].link!);
            }),
      ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  String image, description, title, link;
  AllNewsSection(
      {super.key,
      required this.image,
      required this.description,
      required this.title,
      required this.link});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(blogUrl: link)));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(description),
            SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}
