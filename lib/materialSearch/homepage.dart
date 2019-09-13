import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_api/materialSearch/postdetail.dart';
import 'dart:convert';
import 'dart:async';

import 'package:json_api/model/model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts;
  Future<List<Post>> getPost() async {
    String url = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var jsonData = json.decode(response.body);
    posts = [];
    for (var p in jsonData) {
      Post post = Post(p['id'], p['title'], p['body']);
      posts.add(post);
    }
    print(posts.length);

    return posts;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MaterialSearch'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: SearchPost(searchPost: posts));
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<Post>>(
            future: getPost(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: posts == null ? 0 : posts.length,
                    itemBuilder: (BuildContext context, int i) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostDetail(
                                id: snapshot.data[i].id,
                                title: snapshot.data[i].title,
                                body: snapshot.data[i].body,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 32.0, horizontal: 16.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  snapshot.data[i].title[0]
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              title: Text(
                                snapshot.data[i].title.toString(),
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
      ),
    );
  }
}

class SearchPost extends SearchDelegate<Post> {
  final List<Post> searchPost;
  SearchPost({this.searchPost});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = searchPost
        .where((q) => q.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
        children: results
            .map<ListTile>(
              (f) => ListTile(
                title: Text(
                  f.title,
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(fontSize: 16.0),
                ),
                onTap: () {
                  query = f.title;

                  // close(context, f);
                  // Navigator.pop(context);
                },
              ),
            )
            .toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = searchPost
        .where((q) => q.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
        children: results
            .map<ListTile>(
              (f) => ListTile(
                title: Text(
                  f.title,
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(fontSize: 16.0),
                ),
                onTap: () {
                  query = f.title;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetail(
                        id: f.id,
                        title: f.title,
                        body: f.body,
                      ),
                    ),
                  );
                  // close(context, f);
                  // Navigator.pop(context);
                },
              ),
            )
            .toList());
  }
}
