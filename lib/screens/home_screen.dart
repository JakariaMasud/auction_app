import 'package:auction_app/components/pop_up_menu.dart';
import 'package:auction_app/components/product_item_card.dart';
import 'package:auction_app/models/ProductModel.dart';
import 'package:auction_app/screens/add_product_screen.dart';
import 'package:auction_app/services/cloud_firestore_service.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"),actions: [PopUpMenu()],),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProductScreen()));
          },
        child: Icon(Icons.add),
          ),

      body: StreamBuilder<List<ProductModel>>(
        stream: FirestoreService.instance.allProductStream(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Container(
              color: Colors.grey[100],
              child: GridView.count(
              crossAxisCount: 2,
              children: snapshot.data.map((singleProduct) => ProductItemCard(productModel: singleProduct)).toList(),
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )

    );
  }
}
