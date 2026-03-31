import 'package:flutter/material.dart';
import 'package:app_web/controllers/buyer_controller.dart';
import 'package:app_web/models/buyer.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyerWidget extends StatefulWidget {
  const BuyerWidget({Key? key}) : super(key: key);

  @override
  _BuyerWidgetState createState() => _BuyerWidgetState();
}

class _BuyerWidgetState extends State<BuyerWidget> {
  // A future that will hold the list of buyers oncd loaded from the API.
  late Future<List<Buyer>> futureBuyers;

  @override
  void initState() {
    super.initState();
    futureBuyers = BuyerController().loadBuyers();
  }

  @override
  Widget build(BuildContext context) {
    Widget buyerData(int flex, Widget widget) {
      return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700, width: 1),
          ),
          child: Padding(padding: const EdgeInsets.all(8), child: widget),
        ),
      );
    }

    return FutureBuilder(
      future: futureBuyers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No buyers available'));
        } else {
          final buyers = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: buyers.length,
            itemBuilder: (context, index) {
              final buyer = buyers[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    buyerData(
                      1,
                      Text(
                        buyer.fullname[0],
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buyerData(
                      3,
                      Text(
                        buyer.fullname,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buyerData(
                      2,
                      Text(
                        buyer.email,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buyerData(
                      2,
                      Text(
                        "${buyer.state} ${buyer.city}",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buyerData(
                      1,
                      TextButton(onPressed: () {}, child: Text('DELETE')),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
