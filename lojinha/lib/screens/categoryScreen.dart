import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {

  //recebe o id da categoria e o titulo
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        //quantas tabs ira ter, no caso 2
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot['title']),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.grid_on),),
                Tab(icon: Icon(Icons.list),),

              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(color: Colors.red),
              Container(color: Colors.black,)
            ],
          ),
        ),
    );
  }
}
