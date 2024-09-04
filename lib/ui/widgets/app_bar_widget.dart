import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarWidget extends StatefulWidget {
  final String title;
  final String? leadingIcon;
  final String? actionIcon;
  final Widget? iconWidget;
  final Function()? leadingIconOnTap;
  final Function()? actonIconOnTap;
  final TextStyle titleStyle;
  final Color? bgColor;
  final List<Widget> actions;

  const AppBarWidget({
    super.key,
    required this.title,
    this.leadingIcon,
    this.actionIcon,
    this.leadingIconOnTap,
    this.actonIconOnTap,
    this.iconWidget,
    required this.titleStyle,
    this.bgColor,
    this.actions = const [],
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      backgroundColor:
          (widget.bgColor != null) ? widget.bgColor : Colors.transparent,
      elevation: 0,
      title: Text(
        widget.title,
        style: widget.titleStyle,
      ),
      leading: GestureDetector(
        onTap: widget.leadingIconOnTap,
        child: Container(
          padding: const EdgeInsetsDirectional.only(start: 20),
          height: 18,
          width: 18,
          child: (widget.leadingIcon != null)
              ? SvgPicture.asset(widget.leadingIcon!)
              : null,
        ),
      ),
      actions: [
        ...widget.actions,
        GestureDetector(
          onTap: widget.actonIconOnTap,
          child: Container(
            // height: 18,
            // width: 18,
            padding: const EdgeInsetsDirectional.only(end: 20),
            child: (widget.actionIcon != null)
                ? SvgPicture.asset(widget.actionIcon!)
                : (widget.iconWidget != null)
                    ? widget.iconWidget
                    : null,
          ),
        ),
      ],
    );
  }
}
