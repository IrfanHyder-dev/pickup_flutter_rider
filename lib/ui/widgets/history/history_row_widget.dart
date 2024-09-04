import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/theme/base_theme.dart';

class HistoryRowWidget extends StatelessWidget {
  final String image;
  final String heading;
  final String containerText;
  final double containerWidth;
  final Color historyColor = lightThemeHistoryColor;

  const HistoryRowWidget(
      {super.key,
      required this.image,
        this.containerWidth = 160,
      required this.containerText,
      required this.heading});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Row(
      children: [
        SizedBox(height: 18, width: 18, child: SvgPicture.asset(image)),
        6.hSpace(),
        Text(
          heading,
          style: textTheme.headlineSmall!.copyWith(fontSize: 12),
        ),
        const Spacer(),
        SizedBox(
          width: containerWidth,
          child: Wrap(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  decoration: BoxDecoration(
                      color: historyColor,
                      borderRadius: BorderRadius.circular(7)),
                  child: Text(
                    containerText,
                    style: textTheme.headlineSmall!.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
