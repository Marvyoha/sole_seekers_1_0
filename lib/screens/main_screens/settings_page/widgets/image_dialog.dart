import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sole_seekers_1_0/constant/global_variables.dart';

import '../../../../constant/font_styles.dart';
import '../../../../constant/widgets/custom_button.dart';
import '../../../../constant/widgets/custom_textfield.dart';
import '../../../../core/providers/services_provider.dart';

imageDialog(BuildContext context, ServicesProvider provider) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          content: Container(
            padding: EdgeInsets.symmetric(),
            width: 100.w,
            height: 160.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                    text: 'Upload from Camera',
                    isLoading: provider.loader,
                    onTap: () {
                      provider.pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    }),
                GlobalVariables.spaceSmall(),
                CustomButton(
                    text: 'Upload from Gallery',
                    isLoading: provider.loader,
                    onTap: () {
                      provider.pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        );
      });
}
