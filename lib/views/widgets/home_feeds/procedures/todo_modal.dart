import 'package:clezigov/utils/utility_functions.dart';
import 'package:clezigov/views/widgets/buttons/primary_button.dart';
import 'package:clezigov/views/widgets/home_feeds/procedures/todo_mode.dart';
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
            Gap(10.0),
            Text(
              "Welcome to the \n ToDo mode",
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            Gap(15.0),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "We aim at assisting you the best we can. This mode will enable you to complete your procedures step wise without having to worry about work-arounds. Get straight to your target.",
                style: AppTextStyles.body,
                textAlign: TextAlign.left,
              ),
            ),
            Gap(28.0),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: PrimaryButton.label(
                onPressed: () {
                  context.pushNamed(
                    removeBeginningSlash(TodoModePage.routeName),
                    pathParameters: {'id': procedure.id},
                  );
                },
                label: "Understood",
              ),
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
