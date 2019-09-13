import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  final int id;
  final String title;
  final String body;
  PostDetail({this.id, this.title, this.body});
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PostDetail'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                height: 200.0,
                child: CircleAvatar(
                  child: Text(
                    widget.title[0].toString().toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 100.0,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${widget.title}",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${widget.body}",
                  style: TextStyle(fontSize: 20.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
