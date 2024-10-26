import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../utils/constants.dart';
import '../../form_fields/simple_text_field.dart';

class ProcedureAddPage extends StatefulWidget {
  const ProcedureAddPage({super.key});
  static const String routeName = '/procedures-add';

  @override
  State<ProcedureAddPage> createState() => _ProcedureAddPageState();
}

class _ProcedureAddPageState extends State<ProcedureAddPage> {
  // Form key
  final _addProcedureFormKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _procedureTitleController = TextEditingController();

  // Form fields
  String? procedureTitle;

  // Form validation
  bool isProcedureTitleFilled = false;

  @override
  void initState() {
    super.initState();
    _procedureTitleController.addListener(() {
      setState(() {
        isProcedureTitleFilled = _procedureTitleController.text.isNotEmpty;
      });
    },);
  }

  @override
  void dispose() {
    _procedureTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new procedure'),
      ),
      body: Form(
        key: _addProcedureFormKey,
        child: ListView(
          padding: allPadding * 1.5,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Animate(
              effects: const [FadeEffect(), MoveEffect()],
              child: SvgPicture.asset(
                procedureAddImage,
                height: mediaWidth(context) / 1.75,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Procedure title',
                style: AppTextStyles.small.copyWith(color: disabledColor),
              ),
            ),
            const Gap(4.0),
            SimpleTextFormField(
              controller: _procedureTitleController,
              hintText: 'Title of the procedure',
              textCapitalization: TextCapitalization.words,
              prefixIcon:
              const Icon(HugeIcons.strokeRoundedDirectionRight02),
              minLines: 1,
              maxLines: 2,
              onChanged: (value) => procedureTitle = value,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'You must specify a procedure title.';
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
