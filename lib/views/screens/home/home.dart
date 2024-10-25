import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clezigov/controllers/clezy_controller.dart';
import 'package:clezigov/utils/routes.dart';
import 'package:clezigov/utils/utility_functions.dart';
import 'package:clezigov/views/widgets/alert_dialog.dart';
import 'package:clezigov/views/widgets/notification_snackbar.dart';
import 'package:clezigov/views/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pie_menu/pie_menu.dart';

import '../../../controllers/auth_controller.dart';
import '../../../utils/constants.dart';
import '../../widgets/home_feeds/clezi_bot.dart';
import '../../widgets/home_feeds/community_feed.dart';
import '../../widgets/home_feeds/procedures/procedures_add.dart';
import '../../widgets/home_feeds/procedures_feed.dart';
import '../../widgets/home_feeds/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentPage = 0;
  double tabBarHeight = 80.0;
  late TabController tabController;
  late AnimationController _hideTabBarAnimationController;
  late Animation<double> _offsetAnimation;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> _borderRadiusAnimation;

  final ClezyController clezyController = Get.find<ClezyController>();
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController cleziController = TextEditingController();
  bool isCleziMessageFilled = false;
  final FocusNode cleziFocusNode = FocusNode();

  String image = "https://avatars.githubusercontent.com/u/69576717?v=4";
  Color _primaryColor = seedColor;

  // Tabs names
  final List<String> tabNames = [
    'Procedures',
    'Community',
    'Clezi',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();

    _updatePrimaryColor(image: authController.user?.photoURL ?? image);

    tabController = TabController(
      length: tabNames.length,
      vsync: this,
    );

    _hideTabBarAnimationController = AnimationController(
      duration: duration,
      vsync: this,
    );
    _offsetAnimation = Tween(begin: 0.0, end: tabBarHeight)
        .animate(_hideTabBarAnimationController)
      ..addListener(() {
        setState(() {});
      });
    _borderRadiusAnimationController = AnimationController(
      duration: duration,
      vsync: this,
    );
    _borderRadiusAnimation =
        Tween(begin: 28.0, end: 0.0).animate(_borderRadiusAnimationController)
          ..addListener(() {
            setState(() {});
          });
    tabController = TabController(
      length: tabNames.length,
      vsync: this,
    );

    cleziController.addListener(() {
      setState(() {
        isCleziMessageFilled = cleziController.text.isNotEmpty;
      });
    });

    clezyController.getTextFieldValue(clezyPromptTemplate);
    clezyController.generateContent(clezyPromptTemplate);
  }

  @override
  void dispose() {
    _hideTabBarAnimationController.dispose();
    _borderRadiusAnimationController.dispose();
    cleziController.dispose();
    tabController.dispose();
    super.dispose();
  }

  // Extract primary color from image
  Future<void> _updatePrimaryColor({required String image}) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(image),
      size: Size(200, 200),
    );
    if (generator.dominantColor != null) {
      setState(() {
        _primaryColor = generator.dominantColor!.color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPortraitOrientation =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    // Page widgets
    final List<Widget> _kTabPages = <Widget>[
      ProceduresFeed(),
      CommunityFeed(),
      CleziBot(),
      ProfilePage(
        image: image,
        imageColor: _primaryColor,
      ),
    ];

    final List<Widget> tabIcons = [
      Icon(HugeIcons.strokeRoundedScroll),
      Icon(HugeIcons.strokeRoundedMessageMultiple01),
      Icon(HugeIcons.strokeRoundedChatBot),
      AnimatedContainer(
        duration: duration,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: currentPage == 3 ? scaffoldBgColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: authController.user?.photoURL ?? pfp,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              radius: 16.0,
              backgroundColor: seedColorPalette.shade700,
              backgroundImage: authController.user?.photoURL == null ? AssetImage(pfp) : NetworkImage(authController.user!.photoURL!),
            );
          },
          placeholder: (context, url) {
            return CircleAvatar(
              radius: 16.0,
              backgroundColor: seedColorPalette.shade700,
              backgroundImage: AssetImage(pfp),
            );
          },
          errorWidget: (context, url, error) {
            return CircleAvatar(
              radius: 16.0,
              backgroundColor: seedColorPalette.shade700,
              backgroundImage: AssetImage(pfp),
            );
          },
        ),
      )
    ];

    return PieCanvas(
      theme: PieTheme(
        delayDuration: duration,
        overlayStyle: PieOverlayStyle.around,
        buttonThemeHovered: PieButtonTheme(
          backgroundColor: seedColorPalette.shade50,
          iconColor: seedColor,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [shadow],
            color: seedColorPalette.shade100,
          ),
        ),
        pointerColor: Colors.transparent,
        angleOffset: 5,
        childTiltEnabled: false,
        rightClickShowsMenu: true,
        tooltipTextStyle: AppTextStyles.h2,
      ),
      child: Scaffold(
        extendBody: true,
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            final ScrollDirection direction = notification.direction;
            if (direction == ScrollDirection.reverse) {
              _hideTabBarAnimationController.forward();
              _borderRadiusAnimationController.forward();
            } else if (direction == ScrollDirection.forward) {
              _hideTabBarAnimationController.reverse();
              _borderRadiusAnimationController.reverse();
            }
            return true;
          },
          child: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: _kTabPages,
          ),
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: Size.fromHeight(88.0),
          child: UnconstrainedBox(
            child: AnimatedContainer(
              duration: duration,
              curve: Curves.decelerate,
              height: isPortraitOrientation
                  ? tabBarHeight - _offsetAnimation.value
                  : 56 - _offsetAnimation.value,
              constraints: BoxConstraints(
                // maxWidth: mediaWidth(context) - 50.0,
                maxWidth: isPortraitOrientation
                    ? mediaWidth(context) - 50.0
                    : mediaWidth(context) / 1.5,
              ),
              margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 16.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius:
                    BorderRadius.circular(_borderRadiusAnimation.value),
                boxShadow: [
                  BoxShadow(
                    color: seedColorPalette.shade100.withOpacity(0.5),
                    blurRadius: 8.0,
                    offset: Offset(0, 4.0),
                  ),
                ],
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  physics: const BouncingScrollPhysics(),
                  splashBorderRadius: borderRadius * 5,
                  overlayColor:
                      WidgetStateProperty.all<Color>(seedColorPalette.shade100),
                  splashFactory: InkRipple.splashFactory,
                  indicator: isPortraitOrientation
                      ? Theme.of(context).tabBarTheme.indicator
                      : BoxDecoration(
                          color: seedColor,
                          borderRadius: borderRadius * 4,
                        ),
                  onTap: (index) {
                    setState(() {
                      currentPage = index;
                    });

                    if (index == 2 &&
                        !Get.find<ClezyController>().isClezyDialogShown) {
                      Future.delayed(duration * 1.5, () {
                        showDefaultDialog(
                          context: context,
                          icon: HugeIcons.strokeRoundedChatBot,
                          title: "Before you proceed...",
                          message:
                              "Clezy provides guidance on administrative procedures in Cameroon. "
                                  "While we strive for accuracy, please verify details with official sources, "
                                  "as information may change. Clezy is not liable for actions taken based on this advice.",
                          actions: [
                            PrimaryButton.label(
                              onPressed: () {
                                context.pop();
                              },
                              label: "Agree and continue",
                            ),
                            // Do not show this dialog again
                            GestureDetector(
                              onTap: () => clezyController.toggleClezyDialog(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GetBuilder<ClezyController>(
                                      builder: (clezyController) {
                                    return Checkbox(
                                      value: clezyController.isClezyDialogShown,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: borderRadius / 1.25,
                                      ),
                                      activeColor: seedColor,
                                      onChanged: (value) =>
                                          clezyController.toggleClezyDialog(),
                                    );
                                  }),
                                  Text(
                                    "Do not show this dialog again",
                                    style: AppTextStyles.small
                                        .copyWith(color: disabledColor),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      });
                    }
                  },
                  tabs: List.generate(
                    _kTabPages.length,
                    (index) {
                      final icon = tabIcons[index];
                      final title = tabNames[index];
                      return TabBuilder(
                        index: index,
                        currentIndex: currentPage,
                        icon: icon,
                        title: title,
                      );
                    },
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                  dividerHeight: 0.0,
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
            currentPage == 2 ? FloatingActionButtonLocation.centerFloat : null,
        floatingActionButton: Visibility(
          visible: currentPage == 2,
          child: OrientationBuilder(builder: (context, orientation) {
            bool isLandscape = orientation == Orientation.landscape;

            return Animate(
              effects: [
                FadeEffect(delay: duration),
                MoveEffect(),
              ],
              child: AnimatedContainer(
                duration: duration,
                width: cleziFocusNode.hasFocus
                    ? mediaWidth(context) - 50.0
                    : mediaWidth(context) - 80.0,
                constraints: BoxConstraints(
                  maxWidth: isLandscape
                      ? cleziFocusNode.hasFocus
                          ? (mediaWidth(context) / 1.5) - 50.0
                          : (mediaWidth(context) / 1.5) - 80.0
                      : cleziFocusNode.hasFocus
                          ? mediaWidth(context) - 50.0
                          : mediaWidth(context) - 80.0,
                ),
                decoration: formFieldDecoration.copyWith(
                    borderRadius: borderRadius * 2.75),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    TextField(
                      controller: cleziController,
                      focusNode: cleziFocusNode,
                      onTap: () {
                        setState(() {
                          cleziFocusNode.requestFocus();
                        });
                      },
                      onTapOutside: (event) {
                        setState(() {
                          cleziFocusNode.unfocus();
                        });
                      },
                      onSubmitted: (value) {
                        if (isCleziMessageFilled) {
                          clezyController
                              .getTextFieldValue(cleziController.text.trim());
                          clezyController
                              .generateContent(cleziController.text.trim());

                          // Clear controller
                          cleziController.clear();
                        }
                      },
                      maxLines: 5,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      textCapitalization: TextCapitalization.sentences,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        hintText: "Ask Clezy...",
                        suffixIcon: SizedBox(),
                        constraints: BoxConstraints(
                          minHeight: 48.0,
                          // maxHeight: 56.0,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                        border: AppInputBorders.border.copyWith(
                          borderRadius: borderRadius * 2.75,
                        ),
                        focusedBorder: AppInputBorders.focusedBorder.copyWith(
                          borderRadius: borderRadius * 2.75,
                        ),
                        errorBorder: AppInputBorders.errorBorder.copyWith(
                          borderRadius: borderRadius * 2.75,
                        ),
                        focusedErrorBorder:
                            AppInputBorders.focusedErrorBorder.copyWith(
                          borderRadius: borderRadius * 2.75,
                        ),
                        enabledBorder: AppInputBorders.enabledBorder.copyWith(
                          borderRadius: borderRadius * 2.75,
                        ),
                        disabledBorder: AppInputBorders.disabledBorder.copyWith(
                          borderRadius: borderRadius * 2.75,
                        ),
                      ),
                    ),
                    // IconButton(
                    //   padding: allPadding * 2,
                    //   onPressed: isCleziMessageFilled
                    //       ? () {
                    //     final String text = cleziController.text;
                    //         clezyController.getTextFieldValue(text);
                    //       }
                    //       : null,
                    //   icon: Transform.rotate(
                    //     angle:
                    //         cleziFocusNode.hasFocus ? (45.0 * pi / 180.0) : 0,
                    //     child: Icon(
                    //       HugeIcons.strokeRoundedSent,
                    //       color:
                    //           isCleziMessageFilled ? seedColor : disabledColor,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class TabBuilder extends StatelessWidget {
  const TabBuilder({
    super.key,
    required this.icon,
    required this.title,
    required this.currentIndex,
    required this.index,
  });

  final Widget icon;
  final String title;
  final int index, currentIndex;

  @override
  Widget build(BuildContext context) {
    if (index == currentIndex) {
      // Community tab
      if (index == 1) {
        return PieMenu(
          onPressed: () {
            // show flutter toast
            Fluttertoast.showToast(
              msg: "Long press for options",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: disabledColor.withOpacity(0.8),
              textColor: scaffoldBgColor,
              fontSize: 16.0,
            );
          },
          onToggle: (menuOpen) {
            if (menuOpen) {
              HapticFeedback.lightImpact();
            }
          },
          actions: [
            PieAction(
              tooltip: const Text('Submit procedure'),
              onSelect: () {
                showNotificationSnackBar(
                  context: context,
                  backgroundColor: successColor,
                  icon: successIcon,
                  message: "Submit procedure selected successfully",
                );
              },
              child: const Icon(HugeIcons.strokeRoundedSent),
            ),
            PieAction(
              tooltip: const Text('Request procedure'),
              onSelect: () {
                showNotificationSnackBar(
                  context: context,
                  backgroundColor: successColor,
                  icon: successIcon,
                  message: "Request procedure selected successfully",
                );
              },
              child: const Icon(HugeIcons.strokeRoundedIdea),
            ),
          ],
          child: Animate(
            effects: [FadeEffect()],
            child: Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  Gap(8.0),
                  Text(
                    title,
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Procedures tab
      if (index == 0 && authController.userProfile?.role.toLowerCase() == "admin") {
        return PieMenu(
          onPressed: () {
            // show flutter toast
            Fluttertoast.showToast(
              msg: "Long press for options ${authController.userProfile?.role.toLowerCase()}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: disabledColor.withOpacity(0.8),
              textColor: scaffoldBgColor,
              fontSize: 16.0,
            );
          },
          onToggle: (menuOpen) {
            if (menuOpen) {
              HapticFeedback.lightImpact();
            }
          },
          actions: [
            PieAction(
              tooltip: Text('Add procedure'),
              onSelect: () => context.pushNamed(removeBeginningSlash(ProcedureAddPage.routeName)),
              child: Icon(HugeIcons.strokeRoundedPlusSign),
            ),
          ],
          child: Animate(
            effects: [FadeEffect()],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                Gap(8.0),
                Text(
                  title,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        );
      }

      return Tooltip(
        message: title,
        child: Tab(
          child: Animate(
            effects: [FadeEffect()],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                Gap(8.0),
                Text(
                  title,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Tooltip(
      message: title,
      child: Tab(
        child: Row(
          children: [
            icon,
            Gap(8.0),
            Text(
              title,
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
