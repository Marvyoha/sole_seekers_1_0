import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sole_seekers_1_0/constant/global_variables.dart';

import '../../../../constant/font_styles.dart';
import '../../../../constant/widgets/custom_textfield.dart';
import '../../../misc_screens/product_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List catalogs = []; // Initializing a list to store catalog data
  List resultList = []; // Initializing a list to store search results
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []); // Hide the status bar
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    }); // Request focus and open the keyboard when the modal dialog is shown
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
    if (int.tryParse(searchController.text) != null) {
      // If the search input is not empty
      for (var snapshot in catalogs) {
        // Iterating through the catalog data
        var price = snapshot['price']
            .toString(); // Getting the price from the catalog data
        if (price.contains(searchController.text)) {
          // Checking if the name contains the search input
          showResults.add(snapshot); // Adding the snapshot to the results list
        }
      }
    } else {
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // Restore the status bar
    _focusNode.dispose();

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
        body: SafeArea(
      child: Column(
        children: [
          GlobalVariables.spaceMedium(),
          Padding(
            padding: GlobalVariables.normPadding,
            child: CustomTextField(
              hintText: 'Search catalog',
              focusNode: _focusNode,
              controller: searchController,
            ),
          ),
          GlobalVariables.spaceSmall(),
          searchController.text.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      GlobalVariables.spaceLarge(context),
                      const Icon(
                        CarbonIcons.search,
                        size: 90,
                      ),
                      Text(
                        'Search for Shoes... ',
                        style: WriteStyles.cardSubtitle(context).copyWith(),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: resultList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var items = resultList[index];
                      var id = items['id'];
                      return GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProductDetailsPage(
                                      item: items,
                                      id: id,
                                    ))),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Hero(
                              tag: 'CatalogItem $id',
                              child: CachedNetworkImage(
                                key: UniqueKey(),
                                height: 50.h,
                                width: 50.w,
                                placeholder: (context, url) {
                                  return Image.asset(
                                    GlobalVariables.appIcon,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  );
                                },
                                imageUrl: items['image'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          title: Text(
                            items['name'],
                            style: WriteStyles.cardSubtitle(context).copyWith(),
                          ),
                          subtitle: Text(
                            '\$${items['price'].toString()}',
                            style: WriteStyles.cardSubtitle(context).copyWith(),
                          ),
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
    ));
  }
}
