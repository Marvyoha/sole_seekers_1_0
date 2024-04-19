import 'package:flutter/material.dart';
import 'package:sole_seekers_1_0/constant/font_styles.dart';
import 'package:sole_seekers_1_0/constant/global_variables.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Privacy Policy",
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
                      '''SoleSeekers operates the SoleSeekers mobile application. This page informs you of our policies regarding the collection, use and disclosure of Personal Information we receive from users of the App.

We use your Personal Information only for providing and improving the App. By using the App, you agree to the collection and use of information in accordance with this policy.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Information Collection And Use'),
              const InfoBody(
                text:
                    '''While using our App, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. Personally identifiable information may include, but is not limited to your name, email address,postal address, phone number.''',
              ),
              GlobalVariables.spaceSmall(),
              const InfoHeader(
                text: 'Log Data',
              ),
              const InfoBody(
                  text:
                      '''When you access the App, we may collect information that your browser sends whenever you visit a website ("Log Data"). This Log Data may include information such as your IP address, browser type, browser version, the pages of our App that you visit, the time and date of your visit, the time spent on those pages and other statistics.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Cookies'),
              const InfoBody(
                  text:
                      '''Cookies are files with small amount of data, which may include an anonymous unique identifier. Cookies are sent to your browser from a web site and stored on your computer's hard drive.\n\nWe use "cookies" to collect information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our App.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Security'),
              const InfoBody(
                  text:
                      '''The security of your Personal Information is important to us, but remember no method of transmission over the Internet, or method of electronic storage, is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Changes To This Privacy Policy'),
              const InfoBody(
                  text:
                      '''We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Contact Us'),
              const InfoBody(
                  text:
                      '''If you have any questions about this Privacy Policy, please contact us at privacy@soleseekers.''')
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
