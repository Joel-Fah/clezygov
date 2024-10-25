import 'package:clezigov/controllers/procedures_controller.dart';
import 'package:clezigov/controllers/task_controller.dart';
import 'package:clezigov/models/procedures/procedures.dart';
import 'package:clezigov/utils/constants.dart';
import 'package:clezigov/utils/routes.dart';
import 'package:clezigov/utils/utility_functions.dart';
import 'package:clezigov/views/screens/home/procedure_details.dart';
import 'package:clezigov/views/widgets/home_feeds/procedures/agent_request.dart';
import 'package:clezigov/views/widgets/rating_modal.dart';
import 'package:clezigov/views/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class TodoModePage extends StatefulWidget {
  const TodoModePage({super.key, required this.procedureId});

  static const String routeName = '/todo-mode';
  final String procedureId;

  @override
  State<TodoModePage> createState() => _TodoModePageState();
}

class _TodoModePageState extends State<TodoModePage> {
  final TaskController controller = Get.put(TaskController());
  int _checkedCount = 0;

  int total = 6;
  var percentageOfTasks;

  var current;
  String upNextTask =
      "Tortor arcu libero massa dui vel duis. In justo integer morbi a dapibus euismod venenatis. Urna malesuada amet quis sem. Tellus.";

  bool isComplete = true;

  void _onCheckboxChanged(bool value) {
    setState(() {
      if (value) {
        _checkedCount++;
      } else {
        _checkedCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ProceduresController proceduresController = ProceduresController();
    Procedure procedure =
        proceduresController.getProcedureById(widget.procedureId);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 28.0,
            )),
        title: Text(
          "ToDo Mode ",
          style: AppTextStyles.h1,
        ),
        actions: [Icon(Icons.more_vert)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(8),
              Center(
                child: Text(
                  "${((_checkedCount / total) * 100).ceil()} %",
                  style: AppTextStyles.h1.copyWith(fontSize: 44),
                  textAlign: TextAlign.center,
                ),
              ),
              Gap(18),
              Center(
                child: Text("Completed - (${current} of ${total})",
                    style: AppTextStyles.body
                        .copyWith(color: const Color(0xFF8D8D8D)),
                    textAlign: TextAlign.center),
              ),
              Gap(18),
              Row(
                  children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                        color: ((_checkedCount / total) * 100 >= 33.33 &&
                                    (index == 0)) ||
                                ((_checkedCount / total) * 100 >= 66.66 &&
                                    (index == 1)) ||
                                ((_checkedCount / total) * 100 >= 97.33 &&
                                    (index == 2))
                            ? successColor
                            : disabledColor,
                        borderRadius: borderRadius * 2),
                  ),
                ),
              )),
              Gap(9),
              Text("Up next"),
              Gap(8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                        color: (_checkedCount / total) * 100 >= 98
                            ? successColor
                            : disabledColor,
                        width: 2.0,
                        style: BorderStyle.solid)),
                child: Text(upNextTask),
              ),
              Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      HugeIcons.strokeRoundedCheckmarkCircle02,
                      color: (_checkedCount / total) * 100 >= 98
                          ? successColor
                          : disabledColor,
                      size: 32.0,
                    ),
                  ),
                  Gap(8),
                  InkWell(
                    onTap: () {
                      showRatingModal(context, procedure);
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      size: 32.0,
                    ),
                  ),
                ],
              ),
              Gap(8),
              Text(
                "Tasks",
                style: AppTextStyles.h2,
              ),
              Gap(8),
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 3.5, vertical: 1.0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          TaskItem(
                            onChanged: (bool) {
                              _onCheckboxChanged(bool);
                            },
                          ),
                          Gap(8),
                          Divider(
                            height: 1,
                            color: disabledColor,
                            thickness: 2,
                          ),
                          Gap(8),
                        ],
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
