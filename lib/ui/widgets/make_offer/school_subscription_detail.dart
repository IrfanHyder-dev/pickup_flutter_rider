import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup/src/language/language_keys.dart';

class SchoolSubscriptionDetail extends StatelessWidget {
  final String schoolName;
  final int numOfChild;
  const SchoolSubscriptionDetail({super.key, required this.schoolName,required this.numOfChild});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Padding(
      padding: EdgeInsets.only(
        top: 18,
        left: 27,
        right: 27,
        bottom: 31,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 45,
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(schoolKey.tr,style: textTheme.displaySmall!.copyWith(fontSize: 11,color: theme.cardColor),),
                Spacer(),
                Text(schoolName,style: textTheme.displaySmall!.copyWith(fontSize: 12,height: 1,),maxLines: 2,),
              ],
            ),
          ),
          Container(
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset('assets/vertical_divider.svg')),
          SizedBox(
            height: 45,
            width: 63,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(numberOfSeatKey.tr,style: textTheme.displaySmall!.copyWith(fontSize: 11,color: theme.cardColor),),
                Spacer(),
                Text('$numOfChild',style: textTheme.displaySmall!.copyWith(fontSize: 12,height: 1),),
              ],
            ),
          ),
          Container(
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset('assets/vertical_divider.svg')),
          SizedBox(
            height: 45,
            width: 88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subscriptionForKey.tr,style: textTheme.displaySmall!.copyWith(fontSize: 11,color: theme.cardColor),),
                Spacer(),
                Text('1 Month',style: textTheme.displaySmall!.copyWith(fontSize: 12,height: 1),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
