// Events
class Event {
  final int id; // Add the id property
  final String title;
  final String date;
  final int participants;
  int likedBy;
  final String image;

  Event({
    required this.id, // Include the id parameter in the constructor
    required this.title,
    required this.date,
    required this.participants,
    required this.likedBy,
    required this.image,
  });

  factory Event.fromJson(Map<String, dynamic> event) {
    print(event["id"].runtimeType);
    return Event(
      id: event['id'],
      title: event['title'] as String,
      date: event['date'] as String? ?? '',
      participants: event['participants'].length ?? 0,
      likedBy: event['LikedBy'].length ?? 0,
      image: event['image'] as String,
    );
  }
}

//Bills
class Bill {
  final int id;
  final double price;
  final double consumption;
  final bool paid;
  final String startDate;
  final String endDate;
  final String imageUrl;
  final String uid;

  Bill({
    required this.id,
    required this.price,
    required this.consumption,
    required this.paid,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.uid,
  });

  factory Bill.fromJson(Map<dynamic, dynamic> bill) {
    return Bill(
      id: int.tryParse(bill["id"].toString()) ?? 4,
      price: double.tryParse(bill["price"].toString()) ?? 14.3,
      consumption: double.tryParse(bill['consumption'].toString()) ?? 33,
      paid: bill['paid'] as bool? ?? false,
      startDate: bill['startDate'] as String? ?? '',
      endDate: bill['endDate'] as String? ?? '',
      imageUrl: bill['imageUrl'] as String? ?? '',
      uid: bill['userId'] as String? ?? '',
    );
  }
}

//Credit Cards
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

// Rewards
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
