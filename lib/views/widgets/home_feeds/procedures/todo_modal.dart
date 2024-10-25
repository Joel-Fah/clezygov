import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../models/procedures/procedures.dart';
import '../../../../utils/constants.dart';
import '../../tilt_icon.dart';

void showTodoModal(BuildContext context, Procedure procedure) {
  showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.orientationOf(context) == Orientation.portrait
          ? mediaHeight(context) / 1.5
          : mediaHeight(context) - 20.0,
      maxWidth: MediaQuery.orientationOf(context) == Orientation.portrait
          ? mediaWidth(context)
          : mediaWidth(context) / 1.5,
    ),
    builder: (context) {
      return Stack(
        children: [
          Column(children: [
            TiltIcon(
              icon: HugeIcons.strokeRoundedLeftToRightListTriangle,
            ),
            Gap(8.0),
            Text(
              "Welcome to the \n ToDo mode",
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            Text(
              "We aim at assisting you the best we can. This mode will enable you to complete your procedures step wise without having to worry about work-arounds. Get straight to your target.",
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ]),
          Positioned(
            top: -10.0,
            right: 10.0,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                HugeIcons.strokeRoundedCancel01,
              ),
            ),
          ),
        ],
      );
    },
  );
}
