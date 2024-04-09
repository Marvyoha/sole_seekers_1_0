import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constant/font_styles.dart';
import '../../constant/global_variables.dart';
import 'widgets/onBoard.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: GlobalVariables.onBoardPadding,
          child: Stack(
            children: [
              PageView(
                controller: _controller,
                onPageChanged: (value) {
                  setState(() {
                    onLastPage = (value == 2);
                  });
                },
                children: [
                  OnBoard(
                      image: GlobalVariables.onboardimage1,
                      phrase:
                          'Welcome to SoleSeekers! \nWhere shoes meet purpose.'),
                  OnBoard(
                      image: GlobalVariables.onboardimage2,
                      phrase:
                          'We carry all top brands and latest styles to fit your unique tastes.'),
                  OnBoard(
                      image: GlobalVariables.onboardimage3,
                      phrase:
                          'Let your feet guide you. Try on a new perspective with our shoes.')
                ],
              ),
              Align(
                alignment: const Alignment(0, 0.77),
                child: SmoothPageIndicator(
                  effect: ExpandingDotsEffect(
                      activeDotColor: Theme.of(context).colorScheme.primary,
                      dotColor: Theme.of(context).colorScheme.secondary),
                  controller: _controller,
                  count: 3,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: const Color(0xffF7FAF7),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            onLastPage
                ? const SizedBox()
                : TextButton(
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      'Skip',
                      style: WriteStyles.headerSmall(context)
                          .copyWith(fontSize: 20.sp),
                    )),
            onLastPage
                ? TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'login');
                    },
                    child: Text(
                      'Done',
                      style: WriteStyles.headerSmall(context)
                          .copyWith(fontSize: 20.sp),
                    ))
                : TextButton(
                    onPressed: () {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Next',
                          style: WriteStyles.headerSmall(context)
                              .copyWith(fontSize: 20.sp),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 28,
                        )
                      ],
                    )),
          ],
        ),
      ),
    );
  }
}
