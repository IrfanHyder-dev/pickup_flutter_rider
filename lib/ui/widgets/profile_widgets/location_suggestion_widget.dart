import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/ui/views/profile/driver_profile/driver_profile_viewmodel.dart';

class LocationSuggestionWidget extends StatefulWidget {
  DriverProfileViewModel viewModel;
  final Function(int index) onTap;
   LocationSuggestionWidget({super.key,required this.viewModel, required this.onTap});

  @override
  State<LocationSuggestionWidget> createState() => _LocationSuggestionWidgetState();
}

class _LocationSuggestionWidgetState extends State<LocationSuggestionWidget> {
  final ScrollController placeListCon = ScrollController();
  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Positioned(
      top: mediaH * 0.219,
      left: 0,
      right: 0,
      //bottom: 0,
      child: Container(
        height: 300,
        //width: 200,
        decoration: BoxDecoration(
          color: theme.unselectedWidgetColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.1),
              //Color.fromARGB(120, 0, 0, 0),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),

        margin: const EdgeInsets.only(top: 5, left: 38, right: 38),
        //padding: const EdgeInsets.symmetric(horizontal: hMargin),
        child: FadingEdgeScrollView.fromScrollView(
          child: ListView.separated(
              controller: placeListCon,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                  horizontal: hMargin, vertical: 10),
              itemBuilder: (context, index) {
                return InkWell(
                    onTap:()=> widget.onTap(index),
                    child: Text(
                        widget.viewModel.suggestions[index].description));
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: theme.dividerColor,
                );
              },
              itemCount: widget.viewModel.suggestions.length),
        ),
      ),
    );
  }
}
