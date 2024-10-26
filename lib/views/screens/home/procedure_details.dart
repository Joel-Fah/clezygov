import 'package:cached_network_image/cached_network_image.dart';
import 'package:clezigov/controllers/procedures_controller.dart';
import 'package:clezigov/controllers/reactions_controller.dart';
import 'package:clezigov/models/procedures/procedures.dart';
import 'package:clezigov/utils/routes.dart';
import 'package:clezigov/utils/utility_functions.dart';
import 'package:clezigov/views/screens/home/procedure_action_card.dart';
import 'package:clezigov/views/screens/home/read_more_text.dart';
import 'package:clezigov/views/screens/home/sliver_appbar_delegate.dart';
import 'package:clezigov/views/widgets/home_feeds/procedures/contacts_modal.dart';
import 'package:clezigov/views/widgets/home_feeds/procedures/todo_modal.dart';
import 'package:clezigov/views/widgets/home_feeds/procedures_feed.dart';
import 'package:clezigov/views/widgets/loading_builder.dart';
import 'package:clezigov/views/widgets/buttons/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../models/procedures/document.dart';
import '../../../utils/constants.dart';
import '../../widgets/home_feeds/procedures/agent_request.dart';
import '../../widgets/home_feeds/procedures/directions_modal.dart';
import 'invisible_expanded_header.dart';

class ProcedureDetailsPage extends StatefulWidget {
  const ProcedureDetailsPage({super.key, required this.procedureId});

  static const routeName = '/procedure-details';
  final String procedureId;

  @override
  State<ProcedureDetailsPage> createState() => _ProcedureDetailsPageState();
}

class _ProcedureDetailsPageState extends State<ProcedureDetailsPage>
    with SingleTickerProviderStateMixin {
  bool _isAppBarExpanded = true;
  final ProceduresController proceduresController =
      Get.find<ProceduresController>();

  @override
  Widget build(BuildContext context) {
    Procedure procedure =
        proceduresController.getProcedureById(widget.procedureId);

    final BoxDecoration _cardDecoration = BoxDecoration(
      color: Colors.white,
      boxShadow: [shadow],
      borderRadius: borderRadius * 2,
    );

    // Reactions
    final List<String> _reactions = [
      angryFace,
      frowningFace,
      neutralFace,
      slightlySmilingFace,
      grinningFace,
    ];

    // Other info
    final List<String> otherInfoLabels = [
      "Bookmarks",
      "Rating",
      "Added on",
      "Last updated",
    ];

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          setState(() {
            _isAppBarExpanded = scrollNotification.metrics.pixels <=
                mediaHeight(context) / 2.75;
          });
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: mediaHeight(context) / 2,
              pinned: true,
              snap: false,
              floating: false,
              backgroundColor: scaffoldBgColor,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: procedure.images[1].path,
                  placeholder: (context, url) => Center(
                    child: DefaultLoadingBuilder(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: mediaHeight(context),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          backgroundColor.withOpacity(0.1),
                          backgroundColor.withOpacity(0.9),
                          backgroundColor,
                        ],
                        stops: [0.0, 0.75, 0.96],
                      ),
                    ),
                  ),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: mediaHeight(context) / 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        color: backgroundColor,
                      ),
                      child: Container(
                        padding: allPadding * 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              backgroundColor.withOpacity(0.0),
                              backgroundColor.withOpacity(0.9),
                              backgroundColor,
                            ],
                            stops: [0.0, 0.75, 0.96],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              getMonthAndYear(procedure.lastUpdatedAt),
                              style: AppTextStyles.small.copyWith(
                                color: scaffoldBgColor.withOpacity(0.5),
                              ),
                            ),
                            Gap(8.0),
                            Hero(
                              tag: procedure.id,
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  procedure.title,
                                  style: AppTextStyles.h2.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Gap(16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ProcedureActionCard(
                                    onTap: () =>
                                        showContactsModal(context, procedure),
                                    icon: HugeIcons
                                        .strokeRoundedCustomerService01,
                                    title: "Contacts",
                                  ),
                                ),
                                Gap(8.0),
                                Expanded(
                                  child: ProcedureActionCard(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Animate(
                                            effects: [
                                              FadeEffect(),
                                              MoveEffect()
                                            ],
                                            child: BackdropFilter(
                                              filter: blurFilter,
                                              child: DefaultLoadingBuilder(),
                                            ),
                                          );
                                        },
                                      );

                                      Future.delayed(duration * 5, () {
                                        context.pop();
                                        showDirectionsModal(context);
                                      });
                                    },
                                    icon: HugeIcons.strokeRoundedRoute02,
                                    title: "Directions",
                                  ),
                                ),
                                Gap(8.0),
                                Expanded(
                                  child: ProcedureActionCard(
                                    onTap: () {
                                      showTodoModal(context, procedure);
                                    },
                                    icon: HugeIcons
                                        .strokeRoundedLeftToRightListTriangle,
                                    title: "ToDo",
                                  ),
                                ),
                                Gap(8.0),
                                Expanded(
                                  child: ProcedureActionCard(
                                    onTap: () {
                                      context.goPush(AgentPage.routeName);
                                    },
                                    icon: HugeIcons.strokeRoundedLabor,
                                    title: "Agent",
                                    backgroundColor: seedColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // forceMaterialTransparency: true,
              title: InvisibleExpandedHeader(
                child: Animate(
                  effects: [FadeEffect(), MoveEffect()],
                  child: Text("Procedure"),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(HugeIcons.strokeRoundedBookmark02),
                  onPressed: () {},
                ),
                PopupMenuButton<String>(
                  icon: Icon(HugeIcons.strokeRoundedMoreVertical),
                  tooltip: 'More',
                  clipBehavior: Clip.hardEdge,
                  itemBuilder: (context) {
                    return [
                      PopupMenuDivider(),
                      PopupMenuItem(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedFlag01,
                              size: 20.0,
                              color: dangerColor,
                            ),
                            Gap(8.0),
                            Text(
                              "Report",
                              style: AppTextStyles.body.copyWith(
                                color: dangerColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        value: "report",
                      ),
                    ];
                  },
                ),
              ],
            ),
            if (!_isAppBarExpanded)
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  minHeight: kToolbarHeight,
                  maxHeight: kToolbarHeight,
                  child: Animate(
                    effects: [FadeEffect(), MoveEffect()],
                    child: Material(
                      elevation: 4.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHigh,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  showContactsModal(context, procedure),
                              icon: Icon(
                                  HugeIcons.strokeRoundedCustomerService01),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(HugeIcons.strokeRoundedRoute02),
                            ),
                            IconButton(
                              onPressed: () {
                                showTodoModal(context, procedure);
                              },
                              icon: Icon(HugeIcons
                                  .strokeRoundedLeftToRightListTriangle),
                            ),
                            IconButton(
                              onPressed: () {
                                context.goPush(AgentPage.routeName);
                              },
                              icon: Icon(
                                HugeIcons.strokeRoundedLabor,
                                color: seedColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListView(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      // Places
                      Container(
                        padding: allPadding * 1.5,
                        decoration: _cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Place(s) where you can achieve this",
                              style: AppTextStyles.small.copyWith(
                                color: disabledColor,
                              ),
                            ),
                            Gap(8.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: CircleAvatar(
                                      radius: 2.5,
                                      backgroundColor: darkColor,
                                    ),
                                  ),
                                  Gap(8.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sub-divisional office (SDO)",
                                        style: AppTextStyles.body,
                                      ),
                                      Gap(4.0),
                                      Text(
                                        "open (Mon - Fri, 8:00am - 3:00pm)",
                                        style: AppTextStyles.small.copyWith(
                                          color: successColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Gap(16.0),
                      // Description
                      AnimatedContainer(
                        duration: duration,
                        padding: allPadding * 1.5,
                        decoration: _cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Procedure description",
                              style: AppTextStyles.small.copyWith(
                                color: disabledColor,
                              ),
                            ),
                            Gap(8.0),
                            ReadMoreText(
                              trimLines: 2,
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                              "Praesent scelerisque lorem sit amet elit volutpat, "
                              "nec vulputate sapien mollis. Phasellus ullamcorper "
                              "vulputate sapien, vel hendrerit enim pellentesque a. "
                              "Vestibulum ante ipsum primis in faucibus orci luctus "
                              "et ultrices posuere cubilia curae; Praesent suscipit "
                              "orci ac lectus hendrerit, a convallis libero pellentesque.",
                            ),
                          ],
                        ),
                      ),
                      Gap(16.0),
                      // Price
                      Container(
                        padding: allPadding * 1.5,
                        decoration: _cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Service cost",
                              style: AppTextStyles.small.copyWith(
                                color: disabledColor,
                              ),
                            ),
                            Gap(8.0),
                            Text(
                              "${addThousandSeparator(procedure.price.toString())} FCFA",
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                      ),
                      Gap(16.0),
                      // Documents
                      Container(
                        padding: allPadding * 1.5,
                        decoration: _cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Documents to provide (x${procedure.documents.length})",
                              style: AppTextStyles.small.copyWith(
                                color: disabledColor,
                              ),
                            ),
                            Gap(8.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                children: List.generate(
                                  procedure.documents.length,
                                  (index) {
                                    final Document document =
                                        procedure.documents[index];

                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 2.5,
                                          backgroundColor: seedColor,
                                        ),
                                        Gap(8.0),
                                        Expanded(
                                          child: TertiaryButton.child(
                                            onPressed: () {},
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  document.name,
                                                  style: AppTextStyles.body
                                                      .copyWith(
                                                    color: seedColor,
                                                  ),
                                                ),
                                                Icon(HugeIcons
                                                    .strokeRoundedSquareArrowExpand01)
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Gap(16.0),
                      // Estimated time to complete
                      Container(
                        padding: allPadding * 1.5,
                        decoration: _cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Estimated time to spend",
                              style: AppTextStyles.small.copyWith(
                                color: disabledColor,
                              ),
                            ),
                            Gap(8.0),
                            Text(
                              convertToReadableTimeExtended(
                                  procedure.estimatedTimeToComplete),
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                      ),
                      Gap(16.0),
                      // Category and tags
                      Container(
                        padding: allPadding * 1.5,
                        decoration: _cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Category and tags",
                              style: AppTextStyles.small.copyWith(
                                color: disabledColor,
                              ),
                            ),
                            Gap(8.0),
                            Text(
                              procedure.category.name,
                              style: AppTextStyles.body,
                            ),
                            Gap(8.0),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children:
                                  List.generate(procedure.tags.length, (index) {
                                final tag = procedure.tags[index];

                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: scaffoldBgColor,
                                    borderRadius: borderRadius,
                                  ),
                                  child: Text(
                                    tag.name,
                                    style: AppTextStyles.small.copyWith(
                                      color: seedColor,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Gap(16.0),
                      // Reactions and ratings
                      Container(
                        padding: allPadding * 1.5,
                        decoration: _cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rate this procedure",
                              style: AppTextStyles.small.copyWith(
                                color: disabledColor,
                              ),
                            ),
                            Gap(8.0),
                            Text(
                              "How satisfied are you with this procedure?",
                              style: AppTextStyles.body,
                            ),
                            Gap(8.0),
                            GetBuilder<ReactionsController>(
                                builder: (reactionsController) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                  _reactions.length,
                                  (index) {
                                    final reaction = _reactions[index];
                                    final hasReaction = reactionsController
                                        .hasReaction(procedure.id);
                                    final currentReaction = reactionsController
                                        .getReaction(procedure.id);

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
                                                : scaffoldBgColor
                                                    .withOpacity(0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: hasReaction &&
                                                      currentReaction ==
                                                          reaction
                                                  ? seedColor
                                                  : scaffoldBgColor
                                                      .withOpacity(0.1),
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
                              );
                            }),
                          ],
                        ),
                      ),
                      Gap(24.0),
                      // Other relevant info
                      ListHeader(title: "Other relevant information"),
                      Gap(16.0),
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: otherInfoLabels.length,
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Divider(),
                        ),
                        itemBuilder: (context, index) {
                          final String label = otherInfoLabels[index];

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  label,
                                  style: AppTextStyles.body.copyWith(
                                    color: disabledColor,
                                  ),
                                ),
                                Text(
                                  (() {
                                    switch (label) {
                                      case "Bookmarks":
                                        return "56";
                                      case "Rating":
                                        return "3.7 / 5";
                                      case "Added on":
                                        return getFormattedDate(
                                            procedure.createdAt);
                                      case "Last updated":
                                        return getFormattedDate(
                                            procedure.lastUpdatedAt);
                                      default:
                                        return "";
                                    }
                                  })(),
                                  style: AppTextStyles.body,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
