import 'package:cached_network_image/cached_network_image.dart';
import 'package:clezigov/controllers/clezy_controller.dart';
import 'package:clezigov/utils/utility_functions.dart';
import 'package:clezigov/views/widgets/formatted_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controllers/auth_controller.dart';
import '../../../models/prompt.dart';
import '../../../utils/constants.dart';
import '../squiggle_pattern.dart';

class CleziBot extends StatelessWidget {
  const CleziBot({
    super.key,
  });

  static const String routeName = '/clezy';

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final ScrollController scrollController = ScrollController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          title: Text.rich(
            TextSpan(children: [
              TextSpan(text: "Hi I'm "),
              TextSpan(
                text: "Clezi",
                style: AppTextStyles.h2.copyWith(
                  color: seedColor,
                ),
              ),
              TextSpan(text: "\nHow can I help you?"),
            ]),
            style: AppTextStyles.h2.copyWith(
              fontFamily: nohemiFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10.0),
            child: SizedBox(),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                color: seedColorPalette.shade50,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                splashColor: seedColorPalette.shade100,
                highlightColor: seedColorPalette.shade100,
                padding: allPadding * 2,
                icon: Icon(
                  HugeIcons.strokeRoundedSearch01,
                  color: seedColor,
                ),
              ),
            )
          ],
        ),
        body: GetBuilder<ClezyController>(builder: (clezyController) {
          // Group prompts by date
          final Map<String, List<Prompt>> groupedPrompts = {};
          for (var prompt in clezyController.prompts) {
            final dateKey = getFormattedDate(prompt.date);
            if (!groupedPrompts.containsKey(dateKey)) {
              groupedPrompts[dateKey] = [];
            }
            groupedPrompts[dateKey]!.add(prompt);
          }

          // Scroll to the top when a new prompt is added
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if (scrollController.hasClients) {
          //     scrollController.animateTo(
          //       0.0,
          //       duration: duration,
          //       curve: Curves.easeOut,
          //     );
          //   }
          // });

          // Check if groupedPrompts is empty or if there's only one Prompt object that starts with '__InitialiseClezyGov__'
          if (groupedPrompts.isEmpty ||
              (groupedPrompts.length == 1 &&
                  groupedPrompts.values.first.length == 1 &&
                  groupedPrompts.values.first.first.text
                      .startsWith('__InitialiseClezyGov__'))) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SvgPicture.asset(cleziChat),
                  ),
                  Gap(8.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Your discussion with Clezi is still empty. You can ask anything about your procedures and he will assist with the required information.",
                      style: AppTextStyles.body.copyWith(
                        color: disabledColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return Scrollbar(
            controller: scrollController,
            radius: Radius.circular(8.0),
            thickness: 6.0,
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.only(top: 16.0, bottom: 72.0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: groupedPrompts.length,
              itemBuilder: (context, index) {
                final date = groupedPrompts.keys.elementAt(index);
                final prompts = groupedPrompts[date]!
                    .where((prompt) =>
                        !prompt.text.startsWith('__InitialiseClezyGov__'))
                    .toList()
                    .reversed;
                if (prompts.isEmpty) return SizedBox.shrink();

                return Animate(
                  effects: const [FadeEffect(), MoveEffect()],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SquigglePattern(),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              date,
                              style: AppTextStyles.small.copyWith(
                                color: disabledColor,
                              ),
                            ),
                          ),
                          Expanded(child: SquigglePattern()),
                        ],
                      ),
                      Gap(8.0),
                      ...prompts.map((prompt) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          // add color to the last user prompt
                          decoration: BoxDecoration(
                            color: prompt == prompts.first
                                ? seedColorPalette.shade50.withOpacity(0.5)
                                : Colors.transparent,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: authController.user!.photoURL!,
                                      width: 28.0,
                                      height: 28.0,
                                      alignment: Alignment.center,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 16.0,
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) => Container(
                                        padding: allPadding / 2,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: seedColorPalette.shade50,
                                        ),
                                        child: Icon(
                                          HugeIcons.strokeRoundedUser,
                                          size: 14.0,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        padding: allPadding / 2,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: seedColorPalette.shade50,
                                        ),
                                        child: Icon(
                                          HugeIcons.strokeRoundedUser,
                                          size: 14.0,
                                        ),
                                      ),
                                    ),
                                    Gap(16.0),
                                    Expanded(
                                      child: SelectableText(
                                        prompt.text,
                                        style: AppTextStyles.body,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(16.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Animate(
                                      onPlay: (controller) => controller.repeat(
                                        reverse: true,
                                      ),
                                      effects: [
                                        ShimmerEffect(
                                          delay: duration * 5,
                                          duration: duration * 10,
                                        )
                                      ],
                                      child: Container(
                                        padding: allPadding / 2,
                                        width: 28.0,
                                        height: 28.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              seedColor,
                                              seedColorPalette.shade400,
                                              seedColorPalette.shade600,
                                            ],
                                          ),
                                        ),
                                        child: Icon(
                                          HugeIcons.strokeRoundedChatBot,
                                          color: scaffoldBgColor,
                                          size: 14.0,
                                        ),
                                      ),
                                    ),
                                    Gap(16.0),
                                    Expanded(
                                      child: formatMarkdownText(
                                          prompt.generatedContent),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(8.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      tooltip: 'Copy',
                                      onPressed: () {
                                        final data = '${prompt.text}\n\n\n${prompt.generatedContent}';
                                        Clipboard.setData(ClipboardData(text: data));

                                        // Show toast
                                        Fluttertoast.showToast(
                                          msg: 'Copied to clipboard',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: seedColorPalette.shade50,
                                          textColor: seedColor,
                                          fontSize: 16.0,
                                        );
                                      },
                                      icon: Icon(HugeIcons.strokeRoundedCopy01),
                                      iconSize: 20.0,
                                      color: disabledColor,
                                    ),
                                    IconButton(
                                      tooltip: 'Share',
                                      onPressed: () {
                                        final data = '${prompt.text}\n\n\n${prompt.generatedContent}';
                                        Share.share(data);
                                      },
                                      icon:
                                          Icon(HugeIcons.strokeRoundedShare08),
                                      iconSize: 20.0,
                                      color: disabledColor,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
