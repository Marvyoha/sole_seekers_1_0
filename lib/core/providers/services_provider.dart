// ignore_for_file: use_build_context_synchronously, unnecessary_getters_setters

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class ServicesProvider extends ChangeNotifier {
  ServicesProvider() {
    getCurrentUserDoc();
    getCatalogs();
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? docId;

  List<QueryDocumentSnapshot>? _catalogs;
  Map<String, dynamic>? _currentUserDoc;
  bool _loader = false;

  //Getters
  FirebaseFirestore? get firestore => _firestore;
  FirebaseAuth? get auth => _auth;
  User? get user => _auth.currentUser;
  List<QueryDocumentSnapshot>? get catalogs => _catalogs;
  Map<String, dynamic>? get currentUserDoc => _currentUserDoc;
  bool get loader => _loader;

  //Setters
  set loader(bool newLoader) {
    _loader = newLoader;
  }

  set currentUserDoc(Map<String, dynamic>? newUserDoc) {
    _currentUserDoc = newUserDoc;
  }

// FIREBASE AUTHENTICATION FUNCTIONS
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    loader = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      // To check if the user is valid
      auth?.authStateChanges().listen((user) {
        if (user != null) {
          // Navigate to home
          Navigator.pushReplacementNamed(
            context,
            'mainNav',
          );
        }
      });
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint('Authentication Error: [${e.code}]' ' ${e.message}');
      // Fluttertoast.showToast(
      //     msg: '${e.message}',
      //     gravity: ToastGravity.TOP,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.black,
      //     fontSize: 20.sp);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              e.message!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
      notifyListeners();
    }
    loader = false;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String confirmPassword,
      String username, BuildContext context) async {
    loader = true;
    notifyListeners();
    if (confirmPassword == password) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim());

        storeUserDetails(email: email, username: username);
        Navigator.pushReplacementNamed(
          context,
          'login',
        );
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        debugPrint('Authentication Error: [${e.code}]' ' ${e.message}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                e.message!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
        notifyListeners();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
          content: Center(
            child: Text(
              'Password does not match',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
    }
    loader = false;
    notifyListeners();
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    loader = true;
    notifyListeners();
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Center(
            child: Text(
              'Password reset link sent, check your email',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.pushReplacementNamed(context, 'login');
      });
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      debugPrint('Authentication Error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              e.message!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
      notifyListeners();
    }
    loader = false;
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();

    Future.delayed(const Duration(milliseconds: 1700), () {
      Navigator.pushReplacementNamed(context, 'login');
    });
    notifyListeners();
  }

  Future<void> deleteUser(BuildContext context, String password) async {
    loader = true;
    notifyListeners();
    try {
      if (user != null) {
        // TO DELETE FROM FIREBASE AUTH
        var credential = await EmailAuthProvider.credential(
          email: user!.email!,
          password: password,
        );
        await user?.reauthenticateWithCredential(credential);
        await user?.delete();

        // TO DELETE FROM FIREBASE FIRESTORE
        await firestore?.collection('users').doc(docId).delete();

        // TO CLEAR LOCAL DATA
        currentUserDoc = {};
        docId = '';
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Deletion Error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              e.message!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    loader = false;
    notifyListeners();
  }

// FIREBASE CLOUD FIRESTORE DATABASE FUNTIONS

  Future getCatalogs() async {
    QuerySnapshot<Map<String, dynamic>>? data =
        await firestore?.collection('catalogs').orderBy('id').get();
    _catalogs = data?.docs;
    return catalogs;
  }

  Future<void> storeUserDetails(
      {required String email, required String username}) async {
    try {
      await user?.updateDisplayName(username);
      await firestore?.collection('users').add({
        'uid': user?.uid,
        'email': email.trim(),
        'username': username.trim(),
        'wishlist': [],
        'cart': [],
        'purchase_history': [],
      });
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserDoc() async {
    try {
      var collection = await firestore?.collection('users').get();
      if (collection != null) {
        for (var element in collection.docs) {
          if (element['uid'] == user?.uid) {
            docId = element.id;
            _currentUserDoc = element.data();
            break;
          }
        }
      }
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    return currentUserDoc;
  }

  Future<void> updateUserName({
    required String? username,
  }) async {
    try {
      if (docId != null) {
        await user?.updateDisplayName(username);
        await firestore?.collection('users').doc(docId).update({
          'username': username?.trim(),
        });
      }
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
  }

  Future<void> addToWishlist({required int id}) async {
    try {
      await firestore?.collection('users').doc(docId).update({
        'wishlist': FieldValue.arrayUnion([id]),
      });
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    notifyListeners();
  }

  Future<void> removeFromWishlist({required int id}) async {
    try {
      await firestore?.collection('users').doc(docId).update({
        'wishlist': FieldValue.arrayRemove([id]),
      });
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    notifyListeners();
  }

  Future<void> addToCart({required Map cartDetails}) async {
    try {
      await firestore?.collection('users').doc(docId).update({
        'cart': FieldValue.arrayUnion([cartDetails]),
      });
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    notifyListeners();
  }

  Future<void> removeFromCart({required Map cartDetails}) async {
    try {
      await firestore?.collection('users').doc(docId).update({
        'cart': FieldValue.arrayRemove([cartDetails]),
      });
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    notifyListeners();
  }

  List<Map> getWishlist() {
    List<Map> wishlist = [];
    try {
      for (int id in _currentUserDoc?['wishlist']) {
        for (var element in catalogs!) {
          if (element['id'] == id) {
            wishlist.add(element.data() as Map<dynamic, dynamic>);
          }
        }
      }
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    notifyListeners();
    return wishlist;
  }

  Future<List<Map>> getCart() async {
    List<Map> cart = [];
    try {
      await getCurrentUserDoc();
      await getCatalogs();
      for (int id in _currentUserDoc?['cart']) {
        for (var element in catalogs!) {
          if (element['id'] == id) {
            cart.add(element.data() as Map<dynamic, dynamic>);
          }
        }
      }
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    notifyListeners();
    return cart;
  }
}
