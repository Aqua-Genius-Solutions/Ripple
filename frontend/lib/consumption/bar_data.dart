import 'package:namer_app/consumption/individual_bar.dart';

class Bills {
  final double billOne;
  final double billTwo;
  final double billThree;
  final double billFour;


  
  Bills({
    required this.billOne,
    required this.billTwo,
    required this.billThree,
    required this.billFour,
  });

  List<IndividualBar> barData = [];
  void initializeBarData() {
    barData = [
      IndividualBar(x: 1, y: billOne),
      IndividualBar(x: 2, y: billTwo),
      IndividualBar(x: 3, y: billThree),
      IndividualBar(x: 4, y: billFour),
    ];
  }
}
