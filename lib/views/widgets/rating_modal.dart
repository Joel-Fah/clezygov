import 'package:clezigov/controllers/reactions_controller.dart';
import 'package:clezigov/utils/constants.dart';
import 'package:clezigov/views/widgets/buttons/primary_button.dart';
import 'package:clezigov/views/widgets/notification_snackbar.dart';
import 'package:clezigov/views/widgets/tilt_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../models/procedures/procedures.dart';

// Reactions
final List<String> _reactions = [
  angryFace,
  frowningFace,
  neutralFace,
  slightlySmilingFace,
  grinningFace,
];

void showRatingModal(BuildContext context, Procedure procedure) {
  showDialog(
    context: context,
    barrierColor: scaffoldBgColor,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: scaffoldBgColor,
        shadowColor: disabledColor,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 9.0),
          child: Container(
            width: mediaWidth(context) / 1.5,
            height: mediaWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TiltIcon(
                  icon: HugeIcons.strokeRoundedInLove,
                ),
                Gap(8.0),
                Text(
                  softWrap: true,
                  "How satisfied are you with the ToDo mode for this procedure?",
                  style: AppTextStyles.body,
                ),
                Gap(8.0),
                GetBuilder<ReactionsController>(builder: (reactionsController) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          _reactions.length,
                          (index) {
                            final reaction = _reactions[index];
                            final hasReaction =
                                reactionsController.hasReaction(procedure.id);
                            final currentReaction =
                                reactionsController.getReaction(procedure.id);

                            // return reactions as custom radio buttons
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: borderRadius * 4,
                                onTap: () {
                                  if (hasReaction &&
                                      currentReaction == reaction) {
                                    reactionsController
                                        .removeReaction(procedure.id);
                                  } else {
                                    reactionsController.addReaction(
                                        procedure.id, reaction);
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: duration,
                                  padding: allPadding * 0.5,
                                  decoration: BoxDecoration(
                                    color: hasReaction &&
                                            currentReaction == reaction
                                        ? seedColor.withOpacity(0.1)
                                        : scaffoldBgColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: hasReaction &&
                                              currentReaction == reaction
                                          ? seedColor
                                          : scaffoldBgColor.withOpacity(0.1),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    reaction,
                                    width: 32.0,
                                    height: 32.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Gap(16.0),
                      PrimaryButton.label(
                        onPressed: () {
                          if (context.mounted) {
                            showNotificationSnackBar(
                              context: context,
                              icon: successIcon,
                              message: 'Thanks for reviewing the ToDo mode!',
                              backgroundColor: successColor,
                            );
                            context.go('/');
                          }
                        },
                        label: "Submit",
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      );
    },
  );
}
