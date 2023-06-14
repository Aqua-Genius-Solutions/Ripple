import 'package:flutter/material.dart';

class RewardItem {
  final String imageUrl;
  final String name;
  final int price;

  RewardItem({required this.imageUrl, required this.name, required this.price});

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      imageUrl: json['imageUrl'],
      name: json['name'],
      price: json['price'],
    );
  }
}

class RewardItemWidget extends StatelessWidget {
  final RewardItem rewardItem;
  final VoidCallback onTap;

  RewardItemWidget({required this.rewardItem, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                rewardItem.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rewardItem.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Price: ${rewardItem.price} points'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}