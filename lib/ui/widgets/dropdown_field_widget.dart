import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class DropdownFieldWidget extends StatefulWidget {
  final List<DropdownMenuItem<dynamic>> items;

  final Function(dynamic)? onChange;

  DropdownFieldWidget({
    super.key,
    required this.items,
    required this.prefixIcon,
    this.hintText,
    this.value,
    this.onChange,
    this.validator,
  });

  final String prefixIcon;
  final String? hintText;
  final dynamic? value;
  final String? Function(dynamic?)? validator;

  @override
  State<DropdownFieldWidget> createState() => _DropdownFieldWidgetState();
}

class _DropdownFieldWidgetState extends State<DropdownFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: widget.items,
      validator: widget.validator,
      onChanged: widget.onChange,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontSize: 16,
          ),
      icon: SvgPicture.asset('assets/dropdown_yellow.svg'),
      focusColor: Colors.transparent,
      dropdownColor: Colors.white,
      itemHeight: 50,
      decoration: InputDecoration(
        prefixIcon: Container(
            height: 24,
            width: 24,
            margin: EdgeInsetsDirectional.only(end: 15),
            child: SvgPicture.asset(
              widget.prefixIcon,
            )),
        hintText: widget.hintText,
        hintStyle:
            Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        prefixIconConstraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.width * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        suffixIconConstraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.width * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        focusedBorder: underLineFocusBorder(),
        focusedErrorBorder: underLineBorder(color: Colors.red),
        border: underLineBorder(),
        enabledBorder: underLineBorder(),
        errorBorder: underLineBorder(),
        disabledBorder: underLineBorder(),
      ),
    );
  }

  underLineBorder({Color? color}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
          color: (color != null) ? color : Theme.of(context).dividerColor),
    );
  }

  // underLineErrorBorder({Color? color}){
  //   return UnderlineInputBorder()
  // }

  underLineFocusBorder({Color? color}) {
    return UnderlineInputBorder(
        //borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(
      color: Theme.of(context).primaryColor,
      width: 1,
    ));
  }
}
