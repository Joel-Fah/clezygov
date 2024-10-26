import 'package:clezigov/utils/utility_functions.dart';
import 'package:clezigov/views/widgets/buttons/primary_button.dart';
import 'package:clezigov/views/widgets/home_feeds/procedures/todo_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../models/procedures/procedures.dart';
import '../../../../utils/constants.dart';
import '../../tilt_icon.dart';

void showAgentModal(BuildContext context, Procedure procedure) {
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
      bool showItNextTime = true;
      return Stack(
        children: [
          Column(children: [
            SvgPicture.asset(
              agentCap,
              width: mediaWidth(context) / 2,
            ),
            Gap(10.0),
            Text(
              "Request an agent for physical assistance in the procedures",
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            Gap(15.0),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "An agent will reach out to you physically and will help you complete your procedure without you intervening and you later on get it delivered to you.",
                style: AppTextStyles.body,
                textAlign: TextAlign.left,
              ),
            ),
            Gap(8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(value: showItNextTime, onChanged: (onChanged) {}),
                Gap(8.0),
                Text(
                  "Do not show this next time",
                  style: AppTextStyles.small.copyWith(
                    color: disabledColor,
                  ),
                )
              ],
            ),
            Gap(18.0),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: PrimaryButton.label(
                onPressed: () {
                  context.pushNamed(
                    removeBeginningSlash(TodoModePage.routeName),
                    pathParameters: {'id': procedure.id},
                  );
                },
                label: "Read more",
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
