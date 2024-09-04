import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/src/theme/base_theme.dart';

class SubscriptionPackageListTileWidget extends StatefulWidget {
  final bool isPackageSelected;
  const SubscriptionPackageListTileWidget({super.key, required this.isPackageSelected});

  @override
  State<SubscriptionPackageListTileWidget> createState() => _SubscriptionPackageListTileWidgetState();
}

class _SubscriptionPackageListTileWidgetState extends State<SubscriptionPackageListTileWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    const Color packageClr = lightThemeHistoryColor;
    return Container(
      width: 97,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:(widget.isPackageSelected)? theme.primaryColor : theme.dialogBackgroundColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            decoration: BoxDecoration(
                color:(widget.isPackageSelected)? packageClr : theme.dialogBackgroundColor,
                borderRadius:const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset('assets/calendar_icon.png')),
                11.hSpace(),
                Container(
                  height: 17,
                  width: 17,
                  margin:const  EdgeInsetsDirectional.only(end: 5,top: 5),
                  padding:const EdgeInsets.all(2),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(70),
                      border: Border.all(color: (widget.isPackageSelected)?theme.primaryColor : theme.cardColor),
                      color:(widget.isPackageSelected)? theme.primaryColor: theme.dialogBackgroundColor,
                  ),
                  child:(widget.isPackageSelected)? Image.asset('assets/check.png') : null,
                )
              ],),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.vSpace(),
                Text(monthlyKey.tr,style: textTheme.displayMedium!.copyWith(fontSize: 14),),
                13.vSpace(),
                Text(oneMonthKey.tr,style: textTheme.bodySmall,),
                4.vSpace(),
                Text('6000/Pkr',style: textTheme.displayMedium,)
              ],),
          ),


        ],
      ),
    );
  }
}
