// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/shoes_model.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class ServicesProvider extends ChangeNotifier {
  final _shoesPGDb = FirebaseFirestore.instance
      .collection('catalogs')
      .withConverter<Item>(
          fromFirestore: (snapshot, _) => Item.fromJson(snapshot.data()!),
          toFirestore: (item, _) => item.toJson());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? docId;

  List? _catalogs;
  Map<String, dynamic>? _currentUserDoc;
  bool _loader = false;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _specificBrand;

  //Getters
  FirebaseFirestore? get firestore => _firestore;
  FirebaseAuth? get auth => _auth;
  User? get user => _auth.currentUser;
  List? get catalogs => _catalogs;
  Map<String, dynamic>? get currentUserDoc => _currentUserDoc;
  bool get loader => _loader;
  CollectionReference<Item> get shoesPGDb => _shoesPGDb;
  Stream<QuerySnapshot<Map<String, dynamic>>>? get specificBrand =>
      _specificBrand;

  //Setters
  set loader(bool newLoader) {
    _loader = newLoader;
  }

  set specificBrand(
      Stream<QuerySnapshot<Map<String, dynamic>>>? newSpecificBrand) {
    _specificBrand = newSpecificBrand;
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
            'homePage',
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

  getCatalogs() async {
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
        'isFavorited': [],
        'checkout': [],
        'purchased': [],
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

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>?> getSpecificBrand(
      String brand) async {
    if (brand == 'all_items') {
      try {
        var collection = await firestore?.collection("catalogs").snapshots();
        _specificBrand = collection;
      } on FirebaseException catch (e) {
        debugPrint('Database Error: [${e.code}]' ' ${e.message}');
      }
    } else {
      try {
        var collection = await firestore
            ?.collection("catalogs")
            .where("brand", isEqualTo: brand)
            .snapshots();

        _specificBrand = collection;
      } on FirebaseException catch (e) {
        debugPrint('Database Error: [${e.code}]' ' ${e.message}');
      }
    }

    return specificBrand;
  }
}
