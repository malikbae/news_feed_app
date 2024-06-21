import 'package:flutter/material.dart';
import 'package:news_feed_app/models/article_model.dart';
import 'package:news_feed_app/models/show_category.dart';
import 'package:news_feed_app/services/news.dart';
import 'package:news_feed_app/services/show_category_news.dart';
import 'package:news_feed_app/widgets/bottom_nav_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  static const routeName = '/search';

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      "Politik",
      "Hukum",
      "Ekonomi",
      "Metro",
      "Sepakbola",
      "Olahraga",
      "Humaniora",
      "Lifestyle",
      "Hiburan",
      "Dunia",
      "Tekno",
      "Otomotif"
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Flutter"),
              Text(
                "News",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              )
            ],
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        bottomNavigationBar: const BottomNavBar(index: 1),
        body: ListView(
          children: [
            const _SearchNews(),
            SizedBox(height: 20.0),
            _CategoryNews(tabs: tabs),
          ],
        ),
      ),
    );
  }
}

class _CategoryNews extends StatelessWidget {
  const _CategoryNews({super.key, required this.tabs});
  final List<String> tabs;

  Future<List<ShowCategoryModel>> fetchArticles(String category) async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCategoriesNews(category);
    return showCategoryNews.categories;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
          child: TabBar(
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.blue,
            isScrollable: true,
            tabs: tabs
                .map(
                  (tab) => Tab(
                    icon: Text(
                      tab,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: tabs
                .map(
                  (tab) => FutureBuilder<List<ShowCategoryModel>>(
                    future: fetchArticles(tab.toLowerCase()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No articles found'));
                      } else {
                        List<ShowCategoryModel> articles = snapshot.data!;
                        return ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: articles.length,
                          itemBuilder: ((context, index) {
                            return BlogTile(
                                link: articles[index].link!,
                                image: articles[index].image!,
                                title: articles[index].title!,
                                description: articles[index].description!);
                          }),
                        );
                      }
                    },
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}

class _SearchNews extends StatelessWidget {
  const _SearchNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cari Berita",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              "Temukan berita menarik disini",
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Cari",
                fillColor: Colors.grey.shade200,
                filled: true,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String image, title, description, link;
  const BlogTile(
      {required this.image,
      required this.title,
      required this.description,
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
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Text(
                            maxLines: 2,
                            title,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0)),
                      ),
                      const SizedBox(height: 7.0),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Text(
                            maxLines: 3,
                            description,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ArticleView extends StatelessWidget {
  final String blogUrl;
  const ArticleView({super.key, required this.blogUrl});

  @override
  Widget build(BuildContext context) {
    // Implement the ArticleView page to display article details.
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
      ),
      body: Center(
        child: Text('Article details for URL: $blogUrl'),
      ),
    );
  }
}
