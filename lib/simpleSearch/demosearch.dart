import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:json_api/model/model.dart';
import 'package:json_api/simpleSearch/demosearchdetail.dart';

class DemoSearch extends StatefulWidget {
  @override
  _DemoSearchState createState() => _DemoSearchState();
}

class _DemoSearchState extends State<DemoSearch> {
  TextEditingController _controller;
  List<Post> _posts = List<Post>();
  List<Post> _postsToDisplay = List<Post>();

  Future<List<Post>> fetchPosts() async {
    var url = 'https://jsonplaceholder.typicode.com/posts';
    var response = await http.get(url);

    var posts = List<Post>();

    if (response.statusCode == 200) {
      var postsJson = json.decode(response.body);
      for (var postJson in postsJson) {
        posts.add(Post.fromJson(postJson));
      }
    }
    return posts;
  }

  @override
  void initState() {
    fetchPosts().then((value) {
      setState(() {
        _posts.addAll(value);
        _postsToDisplay = _posts;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: fetchPosts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return index == 0 ? _searchBar() : _listItem(index - 1);
                },
                itemCount: _postsToDisplay.length + 1,
              );
            }
          },
        ),
      ),
    );
  }

  _searchBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search...',
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _postsToDisplay = _posts.where((post) {
              var postTitle = post.title.toLowerCase();
              return postTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DemoSearchDetail(
                    id: _postsToDisplay[index].id,
                    title: _postsToDisplay[index].title,
                    body: _postsToDisplay[index].body),
              ),
            );
          },
          leading: CircleAvatar(
            child: Text(_postsToDisplay[index].id.toString()),
          ),
          title: Text(
            _postsToDisplay[index].title.toString(),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
