import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/src/theme/base_theme.dart';
import 'package:pickup/ui/views/make_offer/make_anOffer/make_anOffer_viewModel.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:pickup/ui/widgets/make_offer/school_subscription_detail.dart';
import 'package:pickup/ui/widgets/pickup_dropoff_infro_widget.dart';

class OffersListWidget extends StatelessWidget {
  MakeAnOfferViewModel viewModel;

  OffersListWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return FadingEdgeScrollView.fromScrollView(
        child: ListView.separated(
      controller: viewModel.scrollController,
      physics: const BouncingScrollPhysics(),
      padding:
          EdgeInsets.only(top: 42, left: hMargin, right: hMargin, bottom: 80),
      itemCount: viewModel.offers.length,
      itemBuilder: (context, index) {
        int outerListIndex = index;
        var data = viewModel.offers[index];
        return Container(
//height: 390,
          decoration: BoxDecoration(
            color: theme.unselectedWidgetColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff000000).withOpacity(0.1),
//Color.fromARGB(120, 0, 0, 0),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.unselectedWidgetColor,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff000000).withOpacity(0.1),
//Color.fromARGB(120, 0, 0, 0),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 41,
                      width: 41,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: (data.parentImage.isNotEmpty)
                                  ? Image.network(
                                      data.parentImage,
                                      fit: BoxFit.cover,
                                    ).image
                                  : Image.asset('assets/person_placeholder.png')
                                      .image)),
                    ),
                    10.hSpace(),
                    Container(
                      width: 120,
                      child: Text(
                        data.parentName,
                        style: textTheme.displayMedium!.copyWith(fontSize: 14),
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 41,
                      width: 85,
                      decoration: BoxDecoration(
                        color: lightThemeHistoryColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(
                          child: Text(
                        data.amount.toStringAsFixed(0),
                        style: textTheme.displayMedium!.copyWith(fontSize: 20),
                      )),
                    ),
                  ],
                ),
              ),
              6.vSpace(),
              ListView.separated(
                //controller: viewModel.childScrollController,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: (viewModel.showSeeMoreText &&
                        viewModel.outerListIndex == outerListIndex)
                    ? data.children.length
                    : 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      if(viewModel.showSeeMoreText &&
                          viewModel.outerListIndex == outerListIndex)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 19, bottom: 5, top: 15),
                            child: Text(
                              data.children[index].name,
                              style: textTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          )),
                      Container(
                          margin:
                              EdgeInsetsDirectional.only(start: 45, end: 45),
                          alignment: Alignment.center,
                          child: PickupDropOffInfoWidget(
                            dividerWidth: mediaW * 0.5,
                            locationWidth: mediaW * 0.5,
                            dropOffTime: data.children[index].end,
                            pickupTime: data.children[index].start,
                            pickupAddress: data.children[index].pickUp.address,
                            dropOffAddress:
                                data.children[index].dropOff.address,
                          )),
                      18.vSpace(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Divider(
                          color: theme.dividerColor,
                          thickness: 1,
                        ),
                      ),
                      SchoolSubscriptionDetail(
                        schoolName: data.children[index].schoolName,
                        numOfChild: (viewModel.showSeeMoreText &&
                                viewModel.outerListIndex == outerListIndex)
                            ? 1
                            : data.children.length,
                      ),
                      SvgPicture.asset('assets/dash_divider.svg'),
                    ],
                  );
                },
                separatorBuilder: (context, index) => 5.vSpace(),
              ),

              if(data.isLocationSame == false)
              Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => viewModel.seeMoreTextStatus(index),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          end: 19, top: 10, bottom: 5),
                      child: Text(
                        (viewModel.outerListIndex == outerListIndex)
                            ? (!viewModel.showSeeMoreText)
                                ? seeMoreKey.tr
                                : showLessKey.tr
                            : seeMoreKey.tr,
                        style: textTheme.titleSmall!.copyWith(
                            color: (viewModel.outerListIndex == outerListIndex)
                                ? (!viewModel.showSeeMoreText)
                                    ? theme.primaryColor
                                    : theme.cardColor
                                : theme.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
              Padding(
                padding:  EdgeInsets.only(top:(!data.isLocationSame)?10 : 18, bottom: 13),
                child: (data.status == 'accept')
                    ? Text(
                        offerInPendingKey.tr,
                        style: textTheme.bodyLarge,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonWidget(
                            btnText: acceptKey.tr,
                            textStyle: textTheme.titleLarge!
                                .copyWith(color: theme.unselectedWidgetColor),
                            radius: 84,
                            onTap: () => viewModel.acceptOffer(
                                offerId: data.id, index: index),
                          ),
                          12.hSpace(),
                          ButtonWidget(
                            btnText: rejectKey.tr,
                            textStyle: textTheme.titleLarge!
                                .copyWith(color: theme.unselectedWidgetColor),
                            radius: 84,
                            onTap: () => viewModel.rejectOffer(
                                offerId: data.id, index: index),
                          )
                        ],
                      ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => 20.vSpace(),
    ));
  }
}
