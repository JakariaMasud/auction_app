import 'package:auction_app/Helpers/size_config.dart';
import 'package:auction_app/components/custom_text.dart';
import 'package:auction_app/models/BidModel.dart';
import 'package:auction_app/models/ProductModel.dart';
import 'package:auction_app/services/cloud_firestore_service.dart';
import 'package:auction_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductModel product;

  ProductDetailScreen(this.product);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Detail"),
      ),
      body: StreamBuilder<List<BidModel>>(
          stream: FirestoreService.instance.bidsStream(widget.product.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      widget.product.productPhoto,
                      fit: BoxFit.fitWidth,
                      height: SizeConfig.height * 0.30,
                      width: SizeConfig.width,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CustomText(
                      text: widget.product.productName,
                      size: 22.0,
                    ),
                    CustomText(
                      text: widget.product.productDescription,
                      size: 17.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CustomText(
                      text:
                          'Minimum Bid Price : ${widget.product.minBidPrice} Taka',
                      size: 17.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CustomText(
                      text:
                          'Auction End Date : ${DateFormat('d MMM y').format(DateTime.fromMicrosecondsSinceEpoch(widget.product.auctionEndDatetime))}',
                      size: 17.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    widget.product.auctionEndDatetime <
                            DateTime.now().microsecondsSinceEpoch
                        ? CustomText(text: 'Auction Time Has been Expired')
                        : SizedBox(
                            height: 5.0,
                          ),
                    SizedBox(
                      height: 5.0,
                    ),
                    FirebaseAuthService.instance.getCurrentUser().uid !=
                                widget.product.ownerId &&
                            widget.product.auctionEndDatetime >
                                DateTime.now().microsecondsSinceEpoch
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () async {
                                  await showDialogForBid(context: context);
                                },
                                child: Text("Bid For The Product")),
                          )
                        : SizedBox(
                            height: 10.0,
                          ),
                    snapshot.data.length > 0
                        ? CustomText(
                            text:
                                "Current Bid winner : ${snapshot.data[0].bidderName} with price of ${snapshot.data[0].bidPrice} Taka",
                            size: 15,
                          )
                        : Container(),
                    snapshot.data.length > 0
                        ? DataTable(
                            columns: [
                                DataColumn(
                                  label: Text(
                                    'Bidder',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Bidding Price',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            rows: snapshot.data.map((bid) {
                              bool editIconShouldShow = widget
                                          .product.auctionEndDatetime >
                                      DateTime.now().microsecondsSinceEpoch &&
                                  bid.bidderId ==
                                      FirebaseAuthService.instance
                                          .getCurrentUser()
                                          .uid;
                              return DataRow(cells: [
                                DataCell(Text(bid.bidderName)),
                                DataCell(Text(bid.bidPrice),
                                    showEditIcon: editIconShouldShow,
                                    onTap: () {
                                  showDialogForBid(context: context, bid: bid);
                                })
                              ]);
                            }).toList())
                        : CustomText(text: "No One Has bid for this Product")
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<void> showDialogForBid({BuildContext context, BidModel bid}) async {
    String bidValue;
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController = bid == null
              ? TextEditingController()
              : TextEditingController(text: bid.bidPrice);
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Enter Price For Product"),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _textEditingController,
                        validator: (value) {
                          return value.isNotEmpty &&
                                  int.parse(value) >
                                      int.parse(widget.product.minBidPrice)
                              ? null
                              : "Invalid Field Or Price is Below Base Price";
                        },
                        onChanged: (value) {
                          bidValue = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  )),
              actions: <Widget>[
                ElevatedButton(
                    child: Text('Done'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (bid == null) {
                          //new Bid
                          String currentUserId =
                              FirebaseAuthService.instance.getCurrentUser().uid;
                          String currentUserName =
                              await FirestoreService.instance.getUserName();
                          BidModel bidObj = BidModel(
                              bidderName: currentUserName,
                              bidPrice: bidValue,
                              bidderId: currentUserId);
                          await FirestoreService.instance.addBid(bidObj,
                              widget.product.id, widget.product.ownerId);
                          Navigator.of(context).pop();
                        } else {
                          //update existing bid
                          bid.bidPrice = bidValue;
                          await FirestoreService.instance.updateBid(
                              bid, widget.product.id, widget.product.ownerId);
                          Navigator.of(context).pop();
                        }
                      }
                    }),
                ElevatedButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
        });
  }
}
