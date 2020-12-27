import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String title;

  const TitleCard(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.purple[700], width: 4))
      ),
      child: Text(title, style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Quicksand'
      )),
    );
  }
}