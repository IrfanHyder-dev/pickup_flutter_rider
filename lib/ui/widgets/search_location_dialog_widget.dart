import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/src/language/language_keys.dart';

import 'input_field_widget.dart';

class SearchLocationDialogWidget extends StatefulWidget {
  const SearchLocationDialogWidget({
    super.key,
    this.searchResult,
  });

  final Function(String searchData)? searchResult;

  @override
  State<SearchLocationDialogWidget> createState() =>
      _SearchLocationDialogWidgetState();
}

class _SearchLocationDialogWidgetState
    extends State<SearchLocationDialogWidget> {
  ScrollController listViewCont = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Dialog(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10,top: 15),
            child: InputField(
              fillColor: theme.primaryColorDark,
              hint: setLocationKey.tr,
              hintStyle:
                  textTheme.displayMedium!.copyWith(color: theme.cardColor),
              prefixImage: 'assets/location_icon.svg',
              borderRadius: 10,
              borderColor: theme.primaryColorDark,
              maxLines: 1,
              validator: (val) {
                if (val.toString().isEmpty) {
                  return 'Email is required';
                } else if (!val.toString().contains("@")) {
                  return 'Enter valid email';
                } else {
                  return null;
                }
              },
            ),
          ),
          SizedBox(
              height: 500,
              child: FadingEdgeScrollView.fromScrollView(
                  child: ListView.separated(
                    controller: listViewCont,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      itemBuilder: (context, index) {
                        return Text('Gulberg');
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: theme.dividerColor,
                        );
                      },
                      itemCount: 20)))
        ],
      ),
    );
  }
}
