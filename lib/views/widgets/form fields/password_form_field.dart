import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../utils/constants.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    this.obscureText = true,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
  });

  final bool? obscureText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final Icon prefixIcon;
  final Icon? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool? _obscureText;

  @override
  void initState() {
    _obscureText = widget.obscureText ?? true;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: formFieldDecoration,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText!,
        obscuringCharacter: '●',
        style: AppTextStyles.body,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        inputFormatters: widget.inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          constraints: BoxConstraints(
            minHeight: 48.0,
            maxHeight: 56.0,
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0,),
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText! ? LucideIcons.eyeOff : LucideIcons.eye,
              // color: seedColor,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText!;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: borderRadius * 2,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius * 2,
            borderSide: BorderSide(
              color: seedColor,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius * 2,
            borderSide: BorderSide(
              color: dangerColor,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius * 2,
            borderSide: BorderSide(
              color: dangerColor,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius * 2,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius * 2,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 1.5,
            ),
          ),
        ),
        onChanged: widget.onChanged,
        validator: widget.validator,
      ),
    );
  }
}
