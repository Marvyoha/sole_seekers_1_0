import 'package:flutter/material.dart';
import 'package:sole_seekers_1_0/constant/font_styles.dart';
import 'package:sole_seekers_1_0/constant/global_variables.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "About SoleSeekers",
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
                      '''Welcome to SoleSeekers - the culmination of my final year project and a testament to my passion for mobile app development and e-commerce. Crafted using Flutter, a revolutionary cross-platform framework, SoleSeekers represents the perfect fusion of cutting-edge technology and an exceptional user experience.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'The Inspiration Behind SoleSeekers'),
              const InfoBody(
                  text:
                      '''As avid shoe enthusiasts myselves, I recognized the need for a seamless and immersive platform that caters to the diverse preferences of shoe lovers worldwide. Inspired by the ever-growing demand for convenient online shopping experiences, I embarked on a journey to create an e-commerce app that would redefine the way people discover and purchase their favorite shoes.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'The Power of Flutter'),
              const InfoBody(
                  text:
                      '''Flutter, an innovative open-source UI software development kit from Google, served as the backbone of our project. This powerful framework allowed us to develop a high-performance, visually stunning, and responsive app that runs seamlessly across multiple platforms, including iOS and Android devices.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Unparalleled User Experience'),
              const InfoBody(
                  text:
                      '''SoleSeekers is a testament to my unwavering commitment to delivering an exceptional user experience. From the moment you launch the app, you'll be greeted by a sleek and intuitive interface that seamlessly guides you through the world of shoes. My intuitive navigation system and advanced search filters ensure that you can effortlessly explore my vast collection, refining your search based on categories, brands, sizes, colors, and more.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Immersive Product Showcase'),
              const InfoBody(
                  text:
                      '''I understand that purchasing shoes online can be a daunting task, which is why I've dedicated considerable effort to creating an immersive product showcase. High-resolution images and detailed descriptions to provide you with a comprehensive understanding of each shoe, enabling you to make informed decisions with confidence.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'Secure and Seamless Transactions'),
              const InfoBody(
                  text:
                      '''Your security and satisfaction is my top priority. SoleSeekers implements industry-standard encryption and secure payment gateways to ensure that your personal and financial information is protected at all times. The user-friendly checkout process makes purchasing your dream shoes a breeze.'''),
              GlobalVariables.spaceSmall(),
              const InfoHeader(text: 'The Journey of SoleSeekers'),
              const InfoBody(
                  text:
                      '''SoleSeekers represents the culmination of my hard work, dedication, and passion for mobile app development and e-commerce. Throughout the development process, I faced numerous challenges, from implementing complex algorithms to optimizing performance across different devices. However, my commitment to excellence and my love for Flutter helped us overcome these obstacles, resulting in a truly remarkable final year project.'''),
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
