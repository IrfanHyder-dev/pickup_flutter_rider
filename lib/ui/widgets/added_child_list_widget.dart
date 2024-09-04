import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup/models/all_child_model.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';

class AddedChildListWidget extends StatelessWidget {
   AddedChildListWidget({super.key, required this.childName,required this.childPickUp, required this.childDropOf});


  String childName;
  String childPickUp;
  String childDropOf;

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      height: mediaH * 0.215,
      width: mediaW,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.unselectedWidgetColor,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.only(
                  start: 34, top: 18),
              child: Text(
                childName,
                style: textTheme.bodyLarge,
              ),
            ),
            20.vSpace(),
            Padding(
              padding:
              const EdgeInsetsDirectional.only(start: 29),
              child: Row(
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                          'assets/pickup_icon.svg'),
                      5.vSpace(),
                      SvgPicture.asset('assets/line_icon.svg'),
                      5.vSpace(),
                      SvgPicture.asset(
                          'assets/dropoff_icon.svg'),
                    ],
                  ),
                  16.hSpace(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        pickUpKey.tr,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyLarge!
                            .copyWith(color: theme.cardColor),
                      ),
                      10.vSpace(),
                      SizedBox(
                        width: mediaW * 0.68,
                        child: Text(
                          childPickUp,
                          style: textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      20.vSpace(),
                      Text(
                        dropOffKey.tr,
                        style: textTheme.bodyLarge!
                            .copyWith(color: theme.cardColor),
                      ),
                      10.vSpace(),
                      SizedBox(
                        width: mediaW * 0.68,
                        child: Text(
                          childDropOf,
                          style: textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ]),
    );
  }
}
