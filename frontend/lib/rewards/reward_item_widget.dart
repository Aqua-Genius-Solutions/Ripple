// import 'package:flutter/material.dart';

// class RewardItemWidget extends StatelessWidget {
//   final RewardItem rewardItem;
//   final VoidCallback onTap;

//   RewardItemWidget({required this.rewardItem, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//               child: Image.network( // Use Image.network instead of Image.asset
//                 rewardItem.imageUrl,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: 150,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     rewardItem.name,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text('Price: ${rewardItem.price} points'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RewardItem {
//   String name;
//   String imageUrl;
//   int price;

//   RewardItem({required this.name, required this.imageUrl, required this.price});

//   factory RewardItem.fromJson(Map<String, dynamic> json) {
//     return RewardItem(
//       name: json['name'] as String,
//       imageUrl: json['imageUrl'] as String,
//       price: json['price'] as int,
//     );
//   }
// }