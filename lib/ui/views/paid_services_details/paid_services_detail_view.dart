import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/notification/notification_view.dart';
import 'package:pickup/ui/views/paid_services_details/paid_services_detail_viewModel.dart';
import 'package:pickup/ui/widgets/app_bar_widget.dart';
import 'package:pickup/ui/widgets/paid_services_detail/services_list_widget.dart';
import 'package:stacked/stacked.dart';

class PaidServicesDetailView extends StatelessWidget {
  const PaidServicesDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<PaidServicesDetailViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(
              title: servicesDetailKey.tr,
              titleStyle: textTheme.titleLarge!,
              // leadingIcon: 'assets/back_arrow_light.svg',
              actionIcon: 'assets/black_bell_icon.svg',
              actonIconOnTap: () => Get.to(() => const NotificationView()),
            ),
          ),
          body: (viewModel.isDataLoad)
              ? (viewModel.paidServicesDetailModel == null ||
                      viewModel.paidServicesDetailModel!.data.isEmpty)
                  ? Center(
                      child: Text(
                        'No Services',
                        style: textTheme.displayMedium,
                      ),
                    )
                  : Container(
                      child: FadingEdgeScrollView.fromScrollView(
                        child: ListView.separated(
                            padding: EdgeInsets.only(top: 40,bottom: 90),
                            controller: viewModel.scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                viewModel.paidServicesDetailModel!.data.length,
                            itemBuilder: (context, index) {
                              var data = viewModel
                                  .paidServicesDetailModel!.data[index];
                                return ServicesListWidget(
                                  parentImage: data.parentImage,
                                  parentName: data.parentName,
                                  children: data.children,
                                );
                            },
                            separatorBuilder: (context, index) => 20.vSpace()),
                      ),
                    )
              : Container(),
        );
      },
      viewModelBuilder: () => PaidServicesDetailViewModel(),
      onViewModelReady: (viewModel) => SchedulerBinding.instance
          .addPostFrameCallback((_) => viewModel.initialise()),
    );
  }
}
