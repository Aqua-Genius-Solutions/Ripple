// Events
class Event {
  final int id; // Add the id property
  final String author;
  final String date;
  final int participants;
  final int likedBy;
  final String image;

  Event({
    required this.id, // Include the id parameter in the constructor
    required this.author,
    required this.date,
    required this.participants,
    required this.likedBy,
    required this.image,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int, // Initialize the id property from JSON
      author: json['author'] as String,
      date: json['date'] as String,
      participants: int.tryParse(json['participants'].toString()) ?? 0,
      likedBy: int.tryParse(json['likedBy'].toString()) ?? 0,
      image: json['image'] as String,
    );
  }
}

//Bills
class Bill {
  final String id;
  final double price;
  final int consumption;
  final bool paid;
  final DateTime startDate;
  final DateTime endDate;
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

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: int.parse(json['id']) as String? ?? "",
      price: double.parse(json["price"]),
      consumption: int.parse(json['consumption']),
      paid: json['paid'] as bool? ?? false,
      startDate: DateTime.parse(json['startDate'] as String? ?? ''),
      endDate: DateTime.parse(json['endDate'] as String? ?? ''),
      imageUrl: json['imageUrl'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
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
