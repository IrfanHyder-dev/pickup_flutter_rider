import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/notification/notification_viewmodel.dart';
import 'package:pickup/ui/widgets/app_bar_widget.dart';
import 'package:pickup/ui/widgets/notification_list_widget.dart';
import 'package:stacked/stacked.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final ScrollController newNotificationController = ScrollController();
  final ScrollController earlierNotificationController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<NotificationViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(
              title: notificationKey.tr,
              titleStyle: textTheme.titleLarge!,
              leadingIcon: 'assets/back_arrow_light.svg',
              leadingIconOnTap: () => Get.back(),
            ),
          ),
          body:(viewModel.isDataLoad)
              ?(viewModel.notificationModel == null)
              ? Center(
              child: Text(
                'No Notifications',
                style: textTheme.displayMedium,
              ))
              : FadingEdgeScrollView.fromScrollView(
            child: ListView(
              controller: newNotificationController,
              padding: const EdgeInsets.only(
                  left: hMargin, right: hMargin, top: 17, bottom: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                if (viewModel.newNotificationList.isNotEmpty)
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: 20, top: (0.038 * mediaH), bottom: 15),
                    child: Text(
                      newKey.tr,
                      style: textTheme.displayMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                //15.vSpace(),
                if (viewModel.newNotificationList.isNotEmpty)
                  Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: viewModel.newNotificationList.length,
                      itemBuilder: (context, index) {
                        var data = viewModel.newNotificationList[index];
                        return NotificationListWidget(
                          id: data.id,
                          index: index,
                          isRead: data.isRead,
                          listName: 'newList',
                          viewModel: viewModel,
                          notificationBody: data.body!,
                          date: data.notificationDetail.createdDate,
                          time: data.notificationDetail.createdTime,
                        );
                      },
                      separatorBuilder: (context, index) => 10.vSpace(),
                    ),
                  ),
                //20.vSpace(),
                if (viewModel.earlierNotificationList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 20, top: 20, bottom: 15),
                    child: Text(
                      earlierKey.tr,
                      style: textTheme.displayMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                if (viewModel.earlierNotificationList.isNotEmpty)
                  Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.earlierNotificationList.length,
                      itemBuilder: (context, index) {
                        var data =
                        viewModel.earlierNotificationList[index];
                        return NotificationListWidget(
                          viewModel: viewModel,
                          listName: 'earlierList',
                          index: index,
                          isRead: data.isRead,
                          id: data.id,
                          notificationBody: data.body!,
                          date: data.notificationDetail.createdDate,
                          time: data.notificationDetail.createdTime,
                        );
                      },
                      separatorBuilder: (context, index) => 10.vSpace(),
                    ),
                  ),
              ],
            ),
          )
              :Container(),
        );
      },
      viewModelBuilder: () => NotificationViewModel(),
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialise()),
    );
  }
}
