// ignore_for_file: use_build_context_synchronously, unnecessary_getters_setters
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_info.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
final Box locale = Hive.box('localStorage');

class ServicesProvider extends ChangeNotifier {
  ServicesProvider() {
    // checkInternetConnection();
    getCurrentUserDoc();
    // locale.delete('catalogs');
    loadData();
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _imageFile;
  String? _imageUrl;
  String? docId;
  // final Connectivity _connectivity = Connectivity();
  List<QueryDocumentSnapshot>? _catalogs;
  UserDetails? _userDetails;
  bool _loader = false;

  //Getters
  // Connectivity? get connectionStatus => _connectionStatus;
  FirebaseFirestore? get firestore => _firestore;
  FirebaseAuth? get auth => _auth;
  FirebaseStorage? get storage => _storage;
  User? get user => _auth.currentUser;
  List<QueryDocumentSnapshot>? get catalogs => _catalogs;
  UserDetails? get userDetails => _userDetails;
  bool get loader => _loader;
  File? get imageFile => _imageFile;
  String? get imageUrl => _imageUrl;

  //Setters

  // set connectionStatus(Connectivity? newStatus) {
  //   _connectionStatus = newStatus;
  // }

  set loader(bool newLoader) {
    _loader = newLoader;
  }

  set imageFile(File? newImageFile) {
    _imageFile = newImageFile;
  }

  set catalogs(List<QueryDocumentSnapshot>? newCatalogs) {
    _catalogs = newCatalogs;
  }

  set userDetails(UserDetails? newUserDetails) {
    _userDetails = newUserDetails;
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
    // loader = true;
    // notifyListeners();
    try {
      if (user != null) {
        // TO DELETE FROM FIREBASE AUTH
        // ignore: await_only_futures
        var credential = await EmailAuthProvider.credential(
          email: user!.email!,
          password: password,
        );
        await user?.reauthenticateWithCredential(credential);
        await user?.delete();

        // TO DELETE FROM FIREBASE FIRESTORE
        await firestore?.collection('users').doc(docId).delete();

        // TO DELETE FROM FIREBASE STORAGE
        final snap = storage?.refFromURL(userDetails!.profilePicture);
        // Delete the image file
        await snap?.delete();
        final folderRef = snap?.parent;
        // Check if the folder is empty
        final folderList = await folderRef?.listAll();
        if (folderList!.items.isEmpty) {
          // If the folder is empty, delete the folder
          await folderRef?.delete();
        }
        // TO CLEAR LOCAL DATA
        userDetails = null;
        locale.delete('catalogs');
        docId = '';

        // loader = false;
        // notifyListeners();
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
    // loader = false;
    // notifyListeners();
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
        'profilePicture': '',
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

  Future<void> getCurrentUserDoc() async {
    try {
      var collection = await firestore?.collection('users').get();
      if (collection != null) {
        for (var element in collection.docs) {
          if (element['uid'] == user?.uid) {
            docId = element.id;
            Map<String, dynamic> rawData = element.data();
            userDetails = UserDetails.fromJson(rawData);
            break;
          }
        }
      }
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
  }

  Future<void> updateUserName({
    required String? username,
  }) async {
    try {
      if (docId != null) {
        await user?.updateDisplayName(username);
        userDetails?.username = username!.trim();
        updateUserDetails();
        notifyListeners();
      }
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
  }

  List<Map> getWishlist() {
    List<Map> wishlist = [];
    try {
      for (int id in userDetails!.wishlist) {
        for (var element in catalogs!) {
          if (element['id'] == id) {
            wishlist.add(element.data() as Map<dynamic, dynamic>);
          }
        }
      }
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }

    return wishlist;
  }

  void addToWishlist({required int id}) {
    try {
      userDetails?.wishlist.add(id);
      updateUserDetails();
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    notifyListeners();
  }

  void removeFromWishlist({required int id}) {
    try {
      userDetails?.wishlist.remove(id);
      updateUserDetails();
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    notifyListeners();
  }

  List<Map> getCart() {
    List<Map> cart = [];
    try {
      for (Cart item in userDetails!.cart) {
        for (var element in catalogs!) {
          if (element['id'] == item.id) {
            cart.add(element.data() as Map<dynamic, dynamic>);
          }
        }
      }
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}] ${e.message}');
    }
    return cart;
  }

  void addToCart({required Cart cartDetails}) {
    try {
      for (Cart element in userDetails!.cart) {
        if (element.id == cartDetails.id) {
          cartDetails.quantity += element.quantity;
          cartDetails.total += element.total;
          userDetails!.cart
              .removeWhere((element) => element.id == cartDetails.id);
          break;
        }
      }

      userDetails?.cart.add(cartDetails);
      updateUserDetails();
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    notifyListeners();
  }

  void removeFromCart({required int id}) {
    try {
      for (var item in userDetails!.cart) {
        if (item.id == id) {
          userDetails?.cart.remove(item);
          break;
        }
      }
      updateUserDetails();
    } on FirebaseException catch (e) {
      debugPrint('Database Error: [${e.code}]' ' ${e.message}');
    }
    notifyListeners();
  }

  int getSubTotal() {
    int cartTotal = 0;
    for (Cart element in userDetails!.cart) {
      cartTotal += element.total;
    }

    return cartTotal;
  }

  Future<void> updateUserDetails() async {
    try {
      await user?.updateDisplayName(userDetails?.username);
      var updateUser = userDetails?.toJson();
      await firestore
          ?.collection('users')
          .doc(docId)
          .update(updateUser!.cast<Object, Object?>());
    } on FirebaseException catch (e) {
      debugPrint('Updating user_info Error: [${e.code}]' ' ${e.message}');
    }
  }

  // LOCAL STORAGE FUNCTIONS (HIVE)
  loadData() async {
    //  var raw = locale.get('catalogs');
    if (locale.isEmpty) {
      await getCatalogs();
      locale.put('catalogs', catalogs);
    }
    catalogs = locale.get('catalogs');
    return locale.get('catalogs');
  }

// IMAGE PICKER FUNCTION
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  // FIREBASE STORAGE FUNCTIONS
  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    if (userDetails!.profilePicture.isNotEmpty) {
      final snap = storage?.refFromURL(userDetails!.profilePicture);
      await snap?.delete();
      userDetails?.profilePicture = '';
    }

    final ref = storage?.ref().child(
        'profilePictures/${user?.email}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref?.putFile(_imageFile!);
    _imageUrl = await ref?.getDownloadURL();

    userDetails?.profilePicture = _imageUrl!;
    updateUserDetails();
    _imageFile = null;

    notifyListeners();
  }
}
