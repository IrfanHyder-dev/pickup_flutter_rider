import 'package:flutter/material.dart';
import 'package:pickup/src/app/constants/constants.dart';

class FormFieldHeadingWidget extends StatelessWidget {
  final String headingText;

  const FormFieldHeadingWidget({super.key, required this.headingText});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsetsDirectional.only(start: margin16),
      child: Text(
        headingText,
        style: textTheme.displayMedium,
      ),
    );
  }
}
