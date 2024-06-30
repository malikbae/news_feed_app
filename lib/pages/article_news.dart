import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  String? blogUrl;
  ArticleView({super.key, required this.blogUrl});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                automaticallyImplyLeading: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
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
              Expanded(
                child: Stack(
                  children: [
                    WebView(
                      initialUrl: widget.blogUrl,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller = webViewController;
                      },
                      onPageFinished: (String url) {
                        // Hide the div after page finished loading
                        _controller.runJavascript('''
                          document.querySelector(".footer-download-bg").style.display="none";
                          document.querySelector(".footer-bg-black").style.display="none";
                          document.querySelector(".footer-bg-bold-black").style.display="none";
                          document.querySelector("#header").style.display="none";
                          document.querySelector("#main-container").style.marginTop="0px";
                          document.querySelector("ul.breadcrumbs").style.display="none";
                          document.querySelector(".slug").style.display="none";
                          document.querySelectorAll(".shareicon").forEach(function(element) {
                            element.style.display = "none";
                          });
                          document.querySelectorAll(".shareon").forEach(function(element) {
                            element.style.display = "none";
                          });
                          document.querySelectorAll(".baca-juga").forEach(function(element) {
                            element.style.display = "none";
                          });

                          let titles = document.querySelectorAll("h3.title-section");
                          titles.forEach(function(title) {
                              let parent = title.parentElement;

                              if (parent.classList.contains('section')) {
                                  parent.style.display = "none";
                              }

                              else if (parent.classList.contains('col-12')) {
                                let grandParent = parent.parentElement;

                                if (grandParent.classList.contains('section')) {
                                    grandParent.style.display = "none";
                                }
                            }
                          });

                          document.querySelector("ul.tags-list").style.display="none";
                          let divs = document.querySelectorAll("div");
                          divs.forEach(function(div) {
                            if (div.textContent.trim() === "Tags:") {
                                div.style.display = "none";
                            }
                          });
                          
                        ''').then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      },
                    ),
                    Visibility(
                      visible: _isLoading,
                      child: Container(
                        color: Colors.white,
                        alignment: FractionalOffset.center,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
