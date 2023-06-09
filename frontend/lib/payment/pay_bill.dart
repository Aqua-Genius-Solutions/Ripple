// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:namer_app/profile/Card/addcard.dart';
import 'package:namer_app/slide_transition.dart';

import '../classes.dart';

class CreditCard {
  final int id;
  final int number;
  final int cvc;
  final DateTime expDate;
  final String ownerId;

  CreditCard({
    required this.id,
    required this.number,
    required this.cvc,
    required this.expDate,
    required this.ownerId,
  });
}

class PaymentScreen extends StatefulWidget {
  final Map<dynamic, dynamic> user;
  final Bill bill;

  PaymentScreen({required this.user, required this.bill});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<CreditCard> creditCards = [];
  late Map<dynamic, dynamic> user = {};
  final String apiUrl = dotenv.env["API_URL"]!;

  @override
  void initState() {
    super.initState();
    print(widget.user);
    fetchCreditCards();
  }

  Future<void> fetchCreditCards() async {
    try {
      final response = await http
          .get(Uri.parse('$apiUrl/payment/user/${widget.user["uid"]}'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        setState(() {
          creditCards = responseData
              .map((item) => CreditCard(
                    id: item['id'] as int,
                    number: int.parse(item['number']),
                    cvc: item['CVC'] as int,
                    expDate: DateTime.parse(item['expDate']),
                    ownerId: item['ownerId'] as String,
                  ))
              .toList();
        });

        final userResponse = await http.get(
            Uri.parse('$apiUrl/auth/getOne/${responseData[0]["ownerId"]}'));

        setState(() {
          user = jsonDecode(userResponse.body);
        });
      } else {
        print("failed to fetch");
      }
    } catch (error) {
      print("error occured : $error");
    }
  }

  Future<void> pay(int billId, int cardId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Are you sure you want to use this card?'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await http
                      .put(Uri.parse("$apiUrl/payment/pay/$billId/$cardId"));
                  Navigator.of(context).pop();
                } catch (error) {
                  print("error occured : $error");
                }
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4),
          child: IconButton(
            icon: Image.asset('images/left-chevron.png', height: 50, width: 60),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      body: Stack(children: [
        Image.asset(
          'images/bg.png',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(34),
                child: Image.network(
                  widget.bill.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text("Price to pay :${widget.bill.price.toStringAsFixed(2)}TND"),
            creditCards.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            SlidePageRoute(builder: (context) => AddCard()));
                      },
                      child: Text("You haven't added any credit cards yet."),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: creditCards.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              pay(widget.bill.id, creditCards[index].id);
                            },
                            child: CreditCardWidget(
                              cardNumber: creditCards[index].number.toString(),
                              expiryDate: creditCards[index].expDate.toString(),
                              cardHolderName: "${user['name'] ?? 'Wael Dghim'}",
                              cvvCode: creditCards[index].cvc.toString(),
                              showBackView: false,
                              obscureCardNumber: true,
                              obscureCardCvv: true,
                              isHolderNameVisible: true,
                              onCreditCardWidgetChange:
                                  (CreditCardBrand creditCardBrand) {},
                              customCardTypeIcons: <CustomCardTypeIcon>[
                                CustomCardTypeIcon(
                                  cardType: CardType.mastercard,
                                  cardImage: Image.asset(
                                    'images/mastercard.png',
                                    height: 48,
                                    width: 48,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SlidePageRoute(
                                        builder: (context) => AddCard()));
                              },
                              child: Text("Add a card!"),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ],
        ),
      ]),
    );
  }
}
