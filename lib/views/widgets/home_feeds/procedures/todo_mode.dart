import 'package:clezigov/controllers/procedures_controller.dart';
import 'package:clezigov/models/procedures/procedures.dart';
import 'package:clezigov/utils/constants.dart';
import 'package:clezigov/views/widgets/rating_modal.dart';
import 'package:clezigov/views/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';

class TodoModePage extends StatefulWidget {
  const TodoModePage({super.key});

  static const String routeName = '/todo-mode';

  @override
  State<TodoModePage> createState() => _TodoModePageState();
}

class _TodoModePageState extends State<TodoModePage> {
  var total;

  var current;

  bool isComplete = true;

  @override
  Widget build(BuildContext context) {
    
     ProceduresController proceduresController = ProceduresController();
     Procedure procedure =
        proceduresController.getProcedureById("1");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => {},
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
                  "33.8%",
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
                        color: index == 0 ? successColor : disabledColor,
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
                        color: Colors.lightGreen,
                        width: 2.0,
                        style: BorderStyle.solid)),
                child: Text(
                    "Tortor arcu libero massa dui vel duis. In justo integer morbi a dapibus euismod venenatis. Urna malesuada amet quis sem. Tellus."),
              ),
              Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      HugeIcons.strokeRoundedCheckmarkCircle02,
                      color: successColor,
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
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          TaskItem(),
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
