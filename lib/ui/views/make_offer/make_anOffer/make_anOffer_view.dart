import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/make_offer/make_anOffer/make_anOffer_viewModel.dart';
import 'package:pickup/ui/views/notification/notification_view.dart';
import 'package:pickup/ui/widgets/app_bar_widget.dart';
import 'package:pickup/ui/widgets/make_offer/offers_list_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class MakeAnOfferView extends StatelessWidget {
  const MakeAnOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<MakeAnOfferViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(
              title: makeAnOfferKey.tr,
              titleStyle: textTheme.titleLarge!,
              // leadingIcon: 'assets/back_arrow_light.svg',
              actionIcon: 'assets/black_bell_icon.svg',
              actonIconOnTap: () => Get.to(() => const NotificationView()),
            ),
          ),
          body: (viewModel.offersModel != null)
              ? (viewModel.offersModel!.data.isNotEmpty)
                  ? OffersListWidget(viewModel: viewModel)
                  : Center(
                      child: Text(
                        'No Offers',
                        style: textTheme.displayMedium,
                      ),
                    )
              : Container(),
        );
      },
      viewModelBuilder: () => MakeAnOfferViewModel(),
      onViewModelReady: (viewModel) => SchedulerBinding.instance
          .addPostFrameCallback((_) => viewModel.initialise()),
    );
  }
}
