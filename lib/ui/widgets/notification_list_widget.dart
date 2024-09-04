import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/notification/notification_viewmodel.dart';

class NotificationListWidget extends StatefulWidget {
  final String notificationBody;
  final String date;
  final String time;
  final int id;
  final int index;
  final bool isRead;
  final NotificationViewModel viewModel;
  final String listName;

  const NotificationListWidget({
    super.key,
    required this.notificationBody,
    required this.date,
    required this.time,
    required this.viewModel,
    required this.listName,
    required this.id,
    required this.index,
    required this.isRead,
  });

  @override
  State<NotificationListWidget> createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    print('is read ${widget.isRead}  ${widget.listName}');
    return Container(
      width: mediaW,
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.unselectedWidgetColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            width: 20,
            //color: Colors.red,
            padding: const EdgeInsetsDirectional.only(
              top: 15,
            ),
            child:(widget.isRead == false)?Center(
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ): Container(),
          ),
          4.hSpace(),
          Container(
            width:(widget.isRead)?mediaW * 0.8 :mediaW * 0.8,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: mediaW * 0.65,
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        widget.notificationBody,
                        style: textTheme.displayMedium,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          builder: (context) {
                            return notificationOptions(
                              theme: theme,
                              mediaH: mediaH,
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        //color: Colors.lightBlue,
                        padding: const EdgeInsets.only(
                            left: 7, right: 7, bottom: 4, top: 7),
                        child: SvgPicture.asset('assets/three_dots_icon.svg'),
                      ),
                    ),
                  ],
                ),
                10.vSpace(),
                Row(
                  children: [
                    Text(
                      widget.date,
                      style: textTheme.titleSmall!
                          .copyWith(color: theme.cardColor),
                    ),
                    const Spacer(),
                    Text(
                      widget.time,
                      style: textTheme.titleSmall!
                          .copyWith(color: theme.cardColor),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget notificationOptions({
    required ThemeData theme,
    required double mediaH,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.unselectedWidgetColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Container(
        padding: EdgeInsetsDirectional.only(
            top: (mediaH * 0.059), start: 28, bottom: 34),
        child: Wrap(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
                widget.viewModel.markNotificationRead(
                    id: widget.id,
                    listName: widget.listName,
                    index: widget.index);
              },
              child: Row(
                children: [
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset('assets/yellow_check_mark.svg')),
                  18.hSpace(),
                  Text(
                    markAsReadKey.tr,
                    style: theme.textTheme.displayMedium,
                  ),
                ],
              ),
            ),
            35.vSpace(),
            GestureDetector(
              onTap: () {
                Get.back();
                widget.viewModel.deleteNotification(id: widget.id, index: widget.index, listName: widget.listName);
              },
              child: Row(
                children: [
                  SvgPicture.asset('assets/yellow_cross_mark.svg'),
                  14.hSpace(),
                  Text(
                    deleteNotifiKey.tr,
                    style: theme.textTheme.displayMedium,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
