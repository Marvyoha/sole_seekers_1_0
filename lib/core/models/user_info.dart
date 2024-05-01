class UserDetails {
  String uid;
  String profilePicture;
  String email;
  String username;
  List<int> wishlist;
  List<Cart> cart;
  List<PurchaseHistory> purchaseHistory;

  UserDetails({
    required this.uid,
    required this.profilePicture,
    required this.email,
    required this.username,
    required this.wishlist,
    required this.cart,
    required this.purchaseHistory,
  });
  UserDetails.nullify()
      : uid = '',
        profilePicture = '',
        email = '',
        username = '',
        wishlist = [],
        cart = [],
        purchaseHistory = [];

  UserDetails.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        profilePicture = json['profilePicture'],
        email = json['email'],
        username = json['username'],
        wishlist = List<int>.from(json['wishlist']),
        cart = json['cart'] != null
            ? List<Cart>.from(json['cart'].map((x) => Cart.fromJson(x)))
            : [],
        purchaseHistory = json['purchase_history'] != null
            ? List<PurchaseHistory>.from(json['purchase_history']
                .map((x) => PurchaseHistory.fromJson(x)))
            : [];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'profilePicture': profilePicture,
      'email': email,
      'username': username,
      'wishlist': wishlist,
      'cart': cart.map((x) => x.toJson()).toList(),
      'purchase_history': purchaseHistory.map((x) => x.toJson()).toList(),
    };
  }
}

class Cart {
  int id;
  int quantity;
  int total;

  Cart({
    required this.id,
    required this.quantity,
    required this.total,
  });

  Cart.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        quantity = json['quantity'],
        total = json['total'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'total': total,
    };
  }
}

class PurchaseHistory {
  String nameOfRecipient;
  List<OrderedItems> orderedItems;
  int grandTotal;
  String timeOrdered;
  Location location;

  PurchaseHistory({
    required this.nameOfRecipient,
    required this.orderedItems,
    required this.grandTotal,
    required this.timeOrdered,
    required this.location,
  });

  PurchaseHistory.fromJson(Map<String, dynamic> json)
      : nameOfRecipient = json['nameOfRecipient'],
        orderedItems = json['orderedItems'] != null
            ? List<OrderedItems>.from(
                json['orderedItems'].map((x) => OrderedItems.fromJson(x)))
            : [],
        grandTotal = json['grandTotal'],
        timeOrdered = json['timeOrdered'],
        location = json['location'] != null
            ? Location.fromJson(json['location'])
            : Location(address: '', city: '');

  Map<String, dynamic> toJson() {
    return {
      'nameOfRecipient': nameOfRecipient,
      'orderedItems': orderedItems.map((x) => x.toJson()).toList(),
      'grandTotal': grandTotal,
      'timeOrdered': timeOrdered,
      'location': location.toJson(),
    };
  }
}

class OrderedItems {
  int id;
  int quantity;
  int total;

  OrderedItems({
    required this.id,
    required this.quantity,
    required this.total,
  });

  OrderedItems.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        quantity = json['quantity'],
        total = json['total'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'total': total,
    };
  }
}

class Location {
  String address;
  String city;

  Location({
    required this.address,
    required this.city,
  });

  Location.fromJson(Map<String, dynamic> json)
      : address = json['address'],
        city = json['city'];

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
    };
  }
}
