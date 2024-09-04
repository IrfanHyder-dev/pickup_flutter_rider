import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickup/models/paid_services_detail_model.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/ui/widgets/pickup_dropoff_infro_widget.dart';

class ServicesListWidget extends StatelessWidget {
  final String parentImage;
  final String parentName;
  List<Child> children = [];
  ScrollController scrollController = ScrollController();

  ServicesListWidget(
      {super.key,
      required this.parentImage,
      required this.parentName,
      required this.children});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      // height: 192,
      // width: 335,
      margin: EdgeInsets.symmetric(horizontal: hMargin),
      padding: EdgeInsets.only(top: 18, bottom: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.unselectedWidgetColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.13),
            blurRadius: 33,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 28),
            child: Row(
              children: [
                Container(
                  height: 41,
                  width: 41,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: (parentImage.isNotEmpty)
                              ? Image.network(
                                  parentImage,
                                  fit: BoxFit.cover,
                                ).image
                              : Image.asset('assets/person_placeholder.png')
                                  .image)),
                ),
                10.hSpace(),
                Container(
                  width: 210,
                  child: Text(
                    parentName,
                    style: textTheme.displayMedium!.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          12.vSpace(),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 70, end: 10),
            child: Container(
              width: mediaW * 0.9,
              height: 22,
              //padding: EdgeInsetsDirectional.only(start: 70,end: 10),
              child: FadingEdgeScrollView.fromScrollView(
                child: ListView.separated(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: theme.primaryColor),
                      child: Text(
                        children[index].name,
                        style: textTheme.titleMedium!
                            .copyWith(fontSize: 11, height: 0),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => 4.hSpace(),
                ),
              ),
            ),
          ),
          14.vSpace(),
          Container(
              margin: EdgeInsetsDirectional.only(start: 65, end: 45),
              alignment: Alignment.center,
              child: PickupDropOffInfoWidget(
                dividerWidth: mediaW * 0.45,
                locationWidth: mediaW * 0.45,
                dropOffTime: children[0].end,
                pickupTime: children[0].start,
                pickupAddress: children[0].pickUp.address,
                dropOffAddress: children[0].dropOff.address,
              )),
        ],
      ),
    );
  }
}
