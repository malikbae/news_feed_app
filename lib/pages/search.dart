import 'package:flutter/material.dart';
import 'package:news_feed_app/models/article_model.dart';
import 'package:news_feed_app/models/search_model.dart';
import 'package:news_feed_app/models/show_category.dart';
import 'package:news_feed_app/pages/article_news.dart';
import 'package:news_feed_app/services/news.dart';
import 'package:news_feed_app/services/search_news.dart';
import 'package:news_feed_app/services/show_category_news.dart';
import 'package:news_feed_app/widgets/bottom_nav_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  static const routeName = '/';

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = "papua"; // default keyword

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      "Pencarian",
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo-nama.png',
                height: 40.0,
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        bottomNavigationBar: const BottomNavBar(index: 1),
        body: Column(
          children: [
            _SearchNews(
              searchController: _searchController,
              onSearch: (keyword) {
                setState(() {
                  _searchKeyword = keyword;
                });
              },
            ),
            SizedBox(height: 20.0),
            Container(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
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
            Expanded(
              child: TabBarView(
                children: tabs.map((tab) {
                  if (tab == "Pencarian") {
                    return _SearchResultNews(searchKeyword: _searchKeyword);
                  } else {
                    return _CategoryNews(category: tab.toLowerCase());
                  }
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryNews extends StatelessWidget {
  const _CategoryNews({super.key, required this.category});
  final String category;

  Future<List<ShowCategoryModel>> fetchArticles(String category) async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCategoriesNews(category);
    return showCategoryNews.categories;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ShowCategoryModel>>(
      future: fetchArticles(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada artikel'));
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
    );
  }
}

class _SearchResultNews extends StatelessWidget {
  final String searchKeyword;
  const _SearchResultNews({super.key, required this.searchKeyword});

  Future<List<SearchNewsModel>> fetchArticles(String search) async {
    SearchNewsData searchNewsData = SearchNewsData();
    await searchNewsData.getSearchNews(search);
    return searchNewsData.searchNews;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SearchNewsModel>>(
      future: fetchArticles(searchKeyword),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada artikel'));
        } else {
          List<SearchNewsModel> articles = snapshot.data!;
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
    );
  }
}

class _SearchNews extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  const _SearchNews(
      {super.key, required this.searchController, required this.onSearch});

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
              controller: searchController,
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
              onFieldSubmitted: onSearch,
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
