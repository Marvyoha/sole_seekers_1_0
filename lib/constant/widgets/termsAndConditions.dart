// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sole_seekers_1_0/constant/font_styles.dart';
import 'package:sole_seekers_1_0/constant/global_variables.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Terms & Conditions",
          style: WriteStyles.headerMedium(context),
        ),
      ),
      body: Padding(
        padding: GlobalVariables.normPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalVariables.spaceSmall(),
              const InfoBody(
                  text:
                      'Welcome to SoleSeekers! These Terms and Conditions outline the rules and regulations for using our e-commerce platform.'),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Acceptance of Terms'),
              const InfoBody(
                  text:
                      '''By accessing or using SoleSeekers, you agree to be bound by these Terms and Conditions and our Privacy Policy. If you do not agree with any part of these terms, you must not use our platform.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Account Registration'),
              const InfoBody(
                  text:
                      '''To use certain features of SoleSeekers, you must register for an account. You agree to provide accurate, current, and complete information during registration and to update your account details as needed. You are responsible for safeguarding your account credentials and for any activities under your account.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Product Listings and Pricing'),
              const InfoBody(
                  text:
                      '''SoleSeekers strives to provide accurate product information, including descriptions, images, and prices. However, errors may occur, and we reserve the right to revoke any stated offer and correct any errors, inaccuracies, or omissions at any time without prior notice.\n\nProduct prices are subject to change without notice. We are not responsible for typographical errors or product pricing mistakes. SoleSeekers reserves the right to limit product quantities and refuse service to anyone at our discretion.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Orders and Payment'),
              const InfoBody(
                  text:
                      '''By placing an order, you represent that the payment details you provide are true and accurate, and that you are authorized to use the payment method provided. We reserve the right to cancel any order due to pricing errors, product unavailability, or other reasons at our discretion.\n\nAll purchases on SoleSeekers are subject to applicable taxes and other charges, which are added to the total purchase price.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Shipping and Delivery'),
              const InfoBody(
                  text:
                      '''SoleSeekers ships orders within the United States. Shipping rates and delivery estimates are provided at checkout. We are not responsible for any delays caused by shipping carriers or other circumstances beyond our control.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Returns and Refunds'),
              const InfoBody(
                  text:
                      '''You may return most products within 30 days of delivery for a full refund, provided the products are in their original, unworn condition with all tags and packaging intact. Custom or personalized orders are non-refundable.\n\nTo initiate a return, please contact our customer service team for instructions. You are responsible for paying return shipping costs unless the return is due to our error.\n\nRefunds will be credited to the original payment method within 5-10 business days after we receive and process the returned item.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Intellectual Property'),
              const InfoBody(
                  text:
                      '''All content and materials on SoleSeekers, including but not limited to text, graphics, logos, images, and software, are the property of SoleSeekers or our licensors and are protected by intellectual property laws. You may not use, copy, reproduce, distribute, or modify any content from SoleSeekers without our prior written consent.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Third-Party Links and Content'),
              const InfoBody(
                  text:
                      '''SoleSeekers may contain links to third-party websites or resources. We do not endorse or assume any responsibility for the content, privacy policies, or practices of any third-party websites or resources.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Limitation of Liability'),
              const InfoBody(
                  text:
                      '''To the maximum extent permitted by law, SoleSeekers shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or relating to your use of our platform or any products purchased through SoleSeekers.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Governing Law and Disputes'),
              const InfoBody(
                  text:
                      '''These Terms and Conditions shall be governed by and construed in accordance with the laws of Lagos, Nigeria. Any disputes arising out of or relating to these Terms and Conditions shall be resolved through binding arbitration in accordance with the rules.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Modifications'),
              const InfoBody(
                  text:
                      '''SoleSeekers reserves the right to modify these Terms and Conditions at any time. Your continued use of our platform after any changes constitutes your acceptance of the updated terms.\n\nIf you have any questions or concerns about these Terms and Conditions, please contact our customer service team.\n\nBy using SoleSeekers, you acknowledge that you have read, understood, and agreed to be bound by these Terms and Conditions.'''),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoHeader extends StatelessWidget {
  final String text;
  const InfoHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: WriteStyles.cardHeader(context),
    );
  }
}

class InfoBody extends StatelessWidget {
  final String text;
  const InfoBody({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: WriteStyles.bodyMedium(context)
          .copyWith(color: Theme.of(context).colorScheme.primary),
    );
  }
}
