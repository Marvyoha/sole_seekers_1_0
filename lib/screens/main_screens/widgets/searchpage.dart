import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constant/font_styles.dart';
import '../../../constant/widgets/custom_textfield.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List catalogs = []; // Initializing a list to store catalog data
  List resultList = []; // Initializing a list to store search results
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    searchController.addListener(
        onSearchChanged); // Adding a listener to the search input field
    super.initState();
  }

  onSearchChanged() {
    // Method to handle search input changes
    debugPrint(
        searchController.text); // Printing the search input text to the console
    searchResultList(); // Calling the method to update search results
  }

  searchResultList() {
    // Method to update the search results list
    var showResults = []; // Initializing a list to store filtered results
    if (searchController.text == '') {
      // If search input is empty
      showResults =
          List.from(catalogs); // Copying all catalog data to results list
    } else {
      // If the search input is not empty
      for (var snapshot in catalogs) {
        // Iterating through the catalog data
        var name = snapshot['name']
            .toString()
            .toLowerCase(); // Getting the name from the catalog data
        if (name.contains(searchController.text.toLowerCase())) {
          // Checking if the name contains the search input
          showResults.add(snapshot); // Adding the snapshot to the results list
        }
      }
    }
    setState(() {
      // Updating the state
      resultList = showResults; // Setting the search results list
    });
  }

  getCatalog() async {
    // Method to fetch catalog data asynchronously
    var data = await FirebaseFirestore
        .instance // Getting data from Firestore collection
        .collection('catalogs')
        .orderBy('brand')
        .get();
    setState(() {
      // Updating the state
      catalogs = data.docs; // Setting the catalog data from Firestore
    });
    searchResultList(); // Updating the search results list
  }

  @override
  void dispose() {
    searchController.removeListener(
        onSearchChanged); // Removing the listener from the search input field
    searchController.dispose(); // Disposing the search input controller
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getCatalog(); // Fetching catalog data when dependencies change
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomTextField(
            hintText: 'Search catalog',
            controller: searchController,
          ),
        ),
        body: ListView.builder(
          itemCount: resultList.length,
          itemBuilder: (BuildContext context, int index) {
            var items = resultList[index];
            return ListTile(
              leading: CircleAvatar(
                  radius: 24, backgroundImage: NetworkImage(items['image'])),
              title: Text(
                items['name'],
                style: WriteStyles.cardSubtitle(context).copyWith(),
              ),
              subtitle: Text(
                '\$${items['price'].toString()}',
                style: WriteStyles.cardSubtitle(context).copyWith(),
              ),
            );
          },
        ));
  }
}
