import 'package:flutter/material.dart';
import 'package:sole_seekers_1_0/screens/main_screens/cartpage/widgets/process_showcase.dart';

import '../../../../constant/font_styles.dart';
import '../../../../constant/global_variables.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Payment',
          style: WriteStyles.headerMedium(context)
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Container(
        padding: GlobalVariables.normPadding,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProcessShowcase(
              isPersonalDetails: true,
              isCardDetails: true,
            )
          ],
        ),
      ),
    );
  }
}
