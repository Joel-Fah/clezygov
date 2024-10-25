import 'package:clezigov/utils/constants.dart';
import 'package:clezigov/views/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../widgets/alert_dialog.dart';
import '../../../widgets/buttons/secondary_button.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                  height: mediaHeight(context) / 4,
                  width: mediaWidth(context),
                  constraints: BoxConstraints(
                    maxHeight: 160.0,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                  ),
                  child: SvgPicture.asset(
                    logoLightSvg,
                    width: mediaWidth(context) / 2,
                  ),
                ),
                Gap(24.0),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Welcome back",
                          style: AppTextStyles.h1,
                        ),
                      ),
                      Gap(8.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Please choose how you want to sign in.",
                          style: AppTextStyles.body,
                        ),
                      ),
                      Gap(24.0),
                      Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          PrimaryButton.child(
                            onPressed: () => authController.signInWithGoogle(context),
                            backgroundColor: dangerColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(googleLogo),
                                Gap(16.0),
                                Text(
                                  "Sign in with Google",
                                  style: AppTextStyles.body.copyWith(
                                    color: scaffoldBgColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(16.0),
                          PrimaryButton.child(
                            onPressed: () {},
                            backgroundColor: darkColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.apple,
                                  color: scaffoldBgColor,
                                  size: 32.0,
                                ),
                                Gap(16.0),
                                Text(
                                  "Sign in with Apple",
                                  style: AppTextStyles.body.copyWith(
                                    color: scaffoldBgColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(16.0),
                          SecondaryButton.label(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                isDismissible: false,
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.orientationOf(context) == Orientation.portrait
                                      ? mediaWidth(context)
                                      : mediaWidth(context) / 1.5,
                                ),
                                builder: (context) {
                                  return Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      LoginModal(),
                                      Positioned(
                                        top: -10.0,
                                        right: 10.0,
                                        child: IconButton(
                                          onPressed: () => context.pop(),
                                          icon: Icon(LucideIcons.x),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )..whenComplete(
                                  () => Future.delayed(
                                    duration * 2,
                                    () => showDefaultDialog(
                                      context: context,
                                      iconWidget: SvgPicture.asset(userAvatars),
                                      title: "Happy to have you among us!",
                                      message:
                                          "You are officially a member of of the CleziGov community. Make sure to explore all the features and information you get here.",
                                      actions: [
                                        PrimaryButton.label(
                                          onPressed: () {},
                                          label: "Explore right away!",
                                        ),
                                        // Gap(8.0),
                                        PrimaryButton.label(
                                          onPressed: () {},
                                          label: "Finish setting my profile",
                                          labelColor: seedColor,
                                          backgroundColor:
                                              seedColorPalette.shade50,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                            },
                            label: "Sign in with email/password",
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 20.0,
              child: Column(
                children: [
                  Animate(
                    effects: [
                      ShimmerEffect(
                        duration: duration * 0.025,
                      ),
                    ],
                    onPlay: (controller) => controller.repeat(
                      reverse: true,
                      period: duration * 3,
                    ),
                    child: IconButton(
                      tooltip: "Fingerprint login",
                      onPressed: () {},
                      iconSize: 72.0,
                      color: seedColor,
                      icon: Icon(HugeIcons.strokeRoundedFingerAccess),
                    ),
                  ),
                  Gap(20.0),
                  Text(
                    appVersionNumber,
                    style: AppTextStyles.small.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
