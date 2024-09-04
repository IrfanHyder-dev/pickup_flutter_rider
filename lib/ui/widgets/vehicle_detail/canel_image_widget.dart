import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CancelImageWidget extends StatelessWidget {
  final double containerHeight;
  final double containerWidth;
  final  double padding;
  final Function()? onTap;
   CancelImageWidget({super.key, required this.padding, required this.containerHeight, required this.containerWidth, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Positioned(
        top: 0,
        right: 0,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: containerHeight,
            width: containerWidth,
            padding: EdgeInsets.all(padding),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: theme.canvasColor, width: 1),
                shape: BoxShape.circle,
                color: theme.unselectedWidgetColor,
              ),
              child: SvgPicture.asset('assets/x-close.svg'),
            ),
          ),
        ));
  }
}
