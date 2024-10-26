import 'package:clezigov/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

Widget formatMarkdownText(String markdownText) {
  return MarkdownBody(
    data: markdownText,
    selectable: true,
    styleSheet: MarkdownStyleSheet(
      p: AppTextStyles.body,
      h1: AppTextStyles.h1,
      h2: AppTextStyles.h2,
      h3: AppTextStyles.h3,
      h4: AppTextStyles.h4,
      h5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      h6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      em: TextStyle(fontStyle: FontStyle.italic),
      strong: TextStyle(fontWeight: FontWeight.bold),
      blockquote: TextStyle(color: disabledColor),
      code: TextStyle(fontFamily: 'monospace', color: dangerColor),
    ),
  );
}