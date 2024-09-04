import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String? btnText;
  final double? height;
  final double? width;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Function()? onTap;
  final TextStyle? textStyle;
  final double? radius;
  final Color? bgColor;

  const ButtonWidget(
      {this.bgColor,
      this.radius,
      this.height,
      this.width,
      this.btnText,
      this.onTap,
      this.horizontalPadding,
      this.verticalPadding,
      this.textStyle});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  void handleButtonTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: handleButtonTap,
      style: TextButtonTheme.of(context).style!.copyWith(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                horizontal: (widget.horizontalPadding != null)
                    ? widget.horizontalPadding!
                    : 32,
                vertical: (widget.verticalPadding != null)
                    ? widget.verticalPadding!
                    : 16,
              ),
            ),
            backgroundColor: MaterialStateProperty.all((widget.bgColor)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 10),
              ),
            ),
          ),
      child: Text(widget.btnText!, style: widget.textStyle),
    );
  }
}
