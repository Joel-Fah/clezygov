import 'package:clezigov/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({super.key, required this.onChanged});
  final Function(bool) onChanged;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isChecked
            ? InkWell(
                onTap: () => {
                  widget.onChanged(false),
                  setState(() {
                    isChecked = false;
                  })
                },
                child: Icon(
                  HugeIcons.strokeRoundedCheckmarkCircle02,
                  color: successColor,
                  size: 28.0,
                ),
              )
            : Checkbox(
                splashRadius: 5,
                shape: CircleBorder(
                  side: BorderSide(),
                ),
                value: isChecked,
                onChanged: (bool? value) {
                  widget.onChanged(true);

                  setState(() {
                    isChecked = value ?? false;
                  });
                },
              ),
        Gap(6),
        Expanded(
          child: Text(
            softWrap: true,
            'Task description Venenatis urna eget a viverra vel dui egestas auctor magna. Lorem massa.',
            style: TextStyle(
              decoration:
                  isChecked ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
