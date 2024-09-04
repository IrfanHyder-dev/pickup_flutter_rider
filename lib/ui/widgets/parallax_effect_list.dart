import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class ParallaxEffectListWidget extends StatefulWidget {
  final double hideHeaderMaxH;
  final double hideHeaderMinH;
  final double? stickHeaderMax;
  final double? stickHeaderMin;
  Widget hideHeaderWidget;
  Widget? stickHeaderWidget;
  Widget sliverList;
  bool? isPined = false;

  ParallaxEffectListWidget({
    super.key,
    required this.hideHeaderMaxH,
    required this.hideHeaderMinH,
    required this.hideHeaderWidget,
    required this.sliverList,
    this.isPined,
    this.stickHeaderMax,
    this.stickHeaderMin,
    this.stickHeaderWidget,
  });

  @override
  State<ParallaxEffectListWidget> createState() => _ParallaxEffectListWidgetState();
}

class _ParallaxEffectListWidgetState extends State<ParallaxEffectListWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FadingEdgeScrollView.fromScrollView(
      child: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(

            delegate: _CustomHideHeaderDelegate(
                minExtent: widget.hideHeaderMinH,
                maxExtent: widget.hideHeaderMaxH,
                hideHeaderWidget: widget.hideHeaderWidget),
          ),
          if (widget.isPined == true)
            SliverAppBar(
              expandedHeight: 40,
              pinned: true,
              floating: false,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: widget.stickHeaderWidget
              ),
            ),
          // SliverPersistentHeader(
          //   pinned: true,
          //   floating: false,
          //   delegate: _ParallaxHeaderDelegate(stickHeaderWidget: stickHeaderWidget!,maxExtent1: stickHeaderMax!,minExtent1: stickHeaderMin!),
          //   // _CustomStickHeaderDelegate(
          //   //   minExtent1: stickHeaderMin!,
          //   //   maxExtent1: stickHeaderMax!,
          //   //   stickHeaderWidget: stickHeaderWidget!,
          //   // ),
          // ),
          widget.sliverList,
        ],
      ),
    );
  }
}

class _CustomHideHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double minExtent;
  @override
  final double maxExtent;
  Widget hideHeaderWidget;

  _CustomHideHeaderDelegate(
      {required this.minExtent,
      required this.maxExtent,
      required this.hideHeaderWidget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return hideHeaderWidget;
  }

  double get extentMax => maxExtent;

  double get extentMin => minExtent;

  @override
  bool shouldRebuild(_CustomHideHeaderDelegate oldDelegate) {
    return maxExtent != oldDelegate.extentMax ||
        minExtent != oldDelegate.extentMin;
  }
}

class _ParallaxHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent1;
  final double maxExtent1;
  Widget stickHeaderWidget;

  _ParallaxHeaderDelegate(
      {required this.minExtent1,
      required this.maxExtent1,
      required this.stickHeaderWidget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double opacity = 1 - shrinkOffset / maxExtent;
    return stickHeaderWidget;
  }

  @override
  double get maxExtent => maxExtent1; // Adjust the header's maximum extent

  @override
  double get minExtent => minExtent1; //// Adjust the header's minimum extent

  @override
  bool shouldRebuild(_ParallaxHeaderDelegate oldDelegate) {
    return false;
  }
}

// class _CustomStickHeaderDelegate extends SliverPersistentHeaderDelegate {
//   @override
//   final double minExtent1;
//   @override
//   final double maxExtent1;
//   Widget stickHeaderWidget;
//
//   _CustomStickHeaderDelegate(
//       {required this.minExtent1,
//       required this.maxExtent1,
//       required this.stickHeaderWidget});
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return stickHeaderWidget;
//   }
//
//   // double get extentMax => maxExtent;
//   //
//   // double get extentMin => minExtent;
//   //
//   //
//   // @override
//   // bool shouldRebuild(_CustomStickHeaderDelegate oldDelegate) {
//   //   return false;
//   // }
//   @override
//   double get maxExtent => 50; // Adjust the header's maximum extent
//
//   @override
//   double get minExtent => 50; // Adjust the header's minimum extent
//
//   @override
//   bool shouldRebuild(_CustomStickHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
