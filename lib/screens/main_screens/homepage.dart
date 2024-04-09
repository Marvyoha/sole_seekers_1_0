import 'package:carbon_icons/carbon_icons.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant/font_styles.dart';
import '../../core/providers/services_provider.dart';
import '../../core/providers/theme_provider.dart';
import 'widgets/delete_account_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.getCurrentUserDoc();

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'searchPage');
                },
                icon: const Icon(CarbonIcons.search)),
            backgroundColor: Colors.transparent,
            title: Text('Hello ${servicesProvider.user?.displayName}'),
            actions: [
              IconButton(
                  onPressed: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                  icon: const Icon(CarbonIcons.light)),
              IconButton(
                  onPressed: () {
                    deleteAccountDialog(context, servicesProvider);
                  },
                  icon: const Icon(CarbonIcons.delete)),
              IconButton(
                  onPressed: () {
                    servicesProvider.signOut(context);
                  },
                  icon: const Icon(CarbonIcons.logout))
            ]),
        body: FirestoreQueryBuilder(
            query: servicesProvider.shoesPGDb.orderBy('id'),
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Pagination Error: ${snapshot.error}');
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 6, mainAxisSpacing: 6),
                itemCount: snapshot.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  // if we reached the end of the currently obtained items, we try to
                  // obtain more items
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    // Telling FirestoreQueryBuilder to try to obtain more items.
                    // It is safe to call this function from within the build method.
                    snapshot.fetchMore();
                  }
                  final item = snapshot.docs[index];
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(item['image'])),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            item['id'].toString(),
                            style: WriteStyles.cardSubtitle(context).copyWith(),
                          ),
                          Text(
                            item['name'],
                            style: WriteStyles.cardSubtitle(context).copyWith(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
/*  ListView.builder(
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index) {
                  // if we reached the end of the currently obtained items, we try to
                  // obtain more items
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    // Telling FirestoreQueryBuilder to try to obtain more items.
                    // It is safe to call this function from within the build method.
                    snapshot.fetchMore();
                  }

                  final item = snapshot.docs[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text(item['description']),
                    leading: Image.network(item['image']),
                    trailing: Text(item['id'].toString()),
                  );
                },
              );
              */
