import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/review/review_viewmodel.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:stacked/stacked.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({super.key});

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ViewModelBuilder<ReviewViewModel>.reactive(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          child: Container(
            //height: 570,
            padding: MediaQuery.of(context).viewInsets,
            width: mediaW,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: theme.unselectedWidgetColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                25.vSpace(),
                Container(
                  height: 123,
                  width: 123,
                  decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(76),
                      border: Border.all(color: theme.primaryColor, width: 1)),
                  child: CircleAvatar(
                    backgroundColor: theme.primaryColor,
                    backgroundImage: const AssetImage('assets/profile_image.png'),
                  ),
                ),
                20.vSpace(),
                Text('Fawad Admad',style: textTheme.headlineLarge!.copyWith(fontSize: 24),),
                10.vSpace(),
                RatingBar.builder(
                  itemSize: 30,
                  initialRating: 3.5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  maxRating: 5,
                  unratedColor: theme.cardColor,
                  itemCount: 5,
                  // itemPadding: const EdgeInsets.symmetric(
                  //     horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: theme.primaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                15.vSpace(),
                Text(shareExperKey.tr, style: textTheme.displayMedium!.copyWith(fontSize: 20),),
                15.vSpace(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(yourFeedBackKey.tr, style: textTheme.bodyMedium!.copyWith(color: theme.cardColor,fontSize: 14,),textAlign: TextAlign.center),
                ),
                30.vSpace(),
                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 35),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    maxLines: 5,
                    cursorColor: theme.primaryColor,
                    decoration: InputDecoration(
                      fillColor: theme.scaffoldBackgroundColor,
                      filled: true,
                      border: outlineBorder(theme),
                      focusedBorder: outlineBorder(theme),
                      errorBorder: outlineBorder(theme),
                      enabledBorder: outlineBorder(theme),
                      hintText: writeReviewKey.tr,
                      hintStyle: textTheme.bodyMedium!.copyWith(fontSize: 14,color: theme.cardColor)
                    ),
                  ),
                ),
                23.vSpace(),
                ButtonWidget(
                  btnText: submitRevKey.tr,
                  textStyle: textTheme.titleLarge!.copyWith(color: theme.unselectedWidgetColor),
                  height: 48,
                  width: 184,
                  radius: 84,
                ),
                20.vSpace(),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => ReviewViewModel(),
    );
  }

  OutlineInputBorder outlineBorder(ThemeData theme) => OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: theme.scaffoldBackgroundColor));
}
