import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'reward_item_widget.dart';
import 'animated_dialog.dart';
import 'water_wave_painter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RewardsPage extends StatefulWidget {
  @override
  RewardsPageState createState() => RewardsPageState();
}

class RewardsPageState extends State<RewardsPage> with SingleTickerProviderStateMixin {
  int points = 10;
  List<RewardItem> items = [];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    fetchRewardsFromAPI();

    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> handleRefresh() async {
    // Reloading takes some time...
    return await Future.delayed(Duration(seconds: 2));
  }

  Future<void> fetchRewardsFromAPI() async {
    try {
      final response = await http.get(Uri.parse('https://ripple-4wg9.onrender.com/rewards'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonItems = json.decode(response.body);
        items = jsonItems.map((item) => RewardItem.fromJson(item)).toList();
        setState(() {});
      } else {
        throw Exception('Failed to load rewards from the API');
      }
    } catch (e) {
      print('Error: $e');
      // You can show an error message to the user or handle it differently here
    }
  }

  void _showAlert(BuildContext context, String message) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return AnimatedDialog(
          message: message,
          onOkPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }

  void _redeemItem(RewardItem item) {
    setState(() {
      user.points -= item.price;
      user.redeemedItems.add(item);
    });
    _showAlert(context, 'You have successfully redeemed "${item.name}" for ${item.price} points.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards'),
      ),
      body: Stack(
        children: [
        AnimatedBuilder(
  animation: _animationController,
  builder: (BuildContext context, Widget? child) {
    return CustomPaint(
      painter: WaterWavePainter(
        waveAmplitude: 10,
        waveFrequency: 0.01,
        wavePhase: _animationController.value * 2 * pi,
        waveColor: Color.fromARGB(255, 0, 133, 241), // Removed the '!' operator
      ),
      child: Container(),
    );
  },
),

          LiquidPullToRefresh(
            onRefresh: handleRefresh,
            color: Color.fromARGB(255, 13, 184, 231),
            backgroundColor: Color.fromARGB(255, 255, 251, 2),
            animSpeedFactor: 2,
            showChildOpacityTransition: true,
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (BuildContext context, int index) {
                return RewardItemWidget(
                  rewardItem: items[index],
                  onTap: () {
                    var item = items[index];
                    if (points >= item.price) {
                      points -= item.price;
                      _showAlert(context, 'You have successfully redeemed "${item.name}" for ${item.price} points.');
                    } else {
                      _showAlert(context,
                          'Sorry, you do not have enough points to redeem "${item.name}".');
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
