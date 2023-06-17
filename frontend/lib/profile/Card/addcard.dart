import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;

class AppColors {
  static const cardBgColor = Color.fromARGB(195, 16, 142, 226);
  static const colorE5D1B2 = Color(0xFFE5D1B2);
  static const colorB58D67 = Color(0xFFB58D67);
  static const colorF9EED2 = Color(0xFFF9EED2);
  static const colorFFFFFD = Color(0xFFFFFFFD);
  static List<Color> customColors = [
    Color.fromARGB(255, 4, 67, 144),
    Color.fromARGB(255, 111, 176, 255),
    Color.fromARGB(255, 129, 222, 248),
  ];
}

class AddCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddCardState();
  }
}

class AddCardState extends State<AddCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
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
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(246, 246, 246, 1),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                CreditCardWidget(
                  glassmorphismConfig:
                      useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName: 'Axis Bank',
                  frontCardBorder:
                      !useGlassMorphism ? Border.all(color: Colors.grey) : null,
                  backCardBorder:
                      !useGlassMorphism ? Border.all(color: Colors.grey) : null,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: AppColors.cardBgColor,
                  backgroundImage:
                      useBackgroundImage ? 'images/card_bg.png' : null,
                  isSwipeGestureEnabled: true,
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          themeColor: Colors.blue,
                          textColor: Colors.grey.withOpacity(0.7),
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.7)),
                            labelStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.7)),
                            focusedBorder: border,
                            enabledBorder: border,
                          ),
                          expiryDateDecoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.7)),
                            labelStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.7)),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.7)),
                            labelStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.7)),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.7)),
                            labelStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.7)),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Card Holder',
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: _onValidate,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColors.customColors,
                                begin: Alignment(-1, -4),
                                end: Alignment(1, 4),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'Validate',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontFamily: 'halter',
                                fontSize: 14,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onValidate() async {
    if (formKey.currentState!.validate()) {
      print('valid!');
      try {
        print("number $cardNumber,\n cvc $cvvCode,\n exp date $expiryDate");
        final res = await http.post(
            Uri.parse(
                "https://6cbe-197-29-180-115.ngrok-free.app/payment/add/${user?.uid}"),
            body: jsonEncode({"number": cardNumber, "CVC": cvvCode, "expDate": expiryDate}),
            headers: {"Content-Type": "application/json"});

        print("card added : ${res.body}");
      } catch (error) {
        print("error occured : $error");
      }
    } else {
      print('invalid!');
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
