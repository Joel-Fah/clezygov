import 'package:clezigov/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';

class TaskItem extends StatefulWidget {
    TaskItem({super.key, required this.onChanged, required this.isChecked});
    final VoidCallback onChanged;
        bool isChecked;



  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.isChecked
            ? InkWell(
                onTap: () => {
                  setState(() {
                    widget.isChecked = false;
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
                value: widget.isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isChecked = value ?? false;
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
                  widget.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ),
      ],
    );

  }
}


/*
class TaskItem extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onChanged;

  const TaskItem({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isChecked, 1 
      onChanged: onChanged,
      // ... other properties
    );
  }
}
 */