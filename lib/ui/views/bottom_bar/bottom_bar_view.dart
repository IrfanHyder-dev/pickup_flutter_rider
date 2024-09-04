import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/ui/views/bottom_bar/bottom_bar_viewmodel.dart';
import 'package:pickup/ui/widgets/pop_scope_dialog_widget.dart';
import 'package:stacked/stacked.dart';

class BottomBarView extends StatefulWidget {
  final int index;

  BottomBarView({super.key, this.index = 2});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {

  @override
  Widget build(BuildContext context) {
    //print('8888888888888888 ${viewModle.pageIndex}');
    final theme = Theme.of(context);
    return ViewModelBuilder<BottomBarViewModel>.reactive(
      builder: (context, viewModel, child) {
        return WillPopScope(
          onWillPop: () async {
            bool? shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) {
                return PopScopeDialogWidget();
              },
            );
            if (shouldPop == true) {
              MoveToBackground.moveTaskToBack();
              return false;
            } else {
              return false;
            }
          },
          child: Scaffold(
              body: PageView(
                controller: viewModel.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(viewModel.bottomBarPages.length,
                    (index) => viewModel.bottomBarPages[index]),
              ),
              extendBody: true,
              bottomNavigationBar: CircleNavBar(
                onTap: (v) => viewModel.onTap(v),
                //     (v) {
                //   setState(() {
                //     widget.index = v;
                //     viewModel.pageController.jumpToPage(widget.index);
                //   });
                // },

                activeIcons: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/navbar_first_icon_white.svg',
                      height: 20,
                      width: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child:
                        SvgPicture.asset('assets/subscription_white_icon.svg'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/home_white_icon.svg'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SvgPicture.asset(
                      'assets/history_white_icon.svg',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/setting_white_icon.svg'),
                  ),
                ],
                inactiveIcons: [
                  SvgPicture.asset('assets/navbar_first_icon.svg'),
                  SvgPicture.asset('assets/subscription_black_icon.svg'),
                  SvgPicture.asset('assets/home_black_icon.svg'),
                  SvgPicture.asset('assets/history_black_icon.svg'),
                  SvgPicture.asset('assets/setting_black_icon.svg'),
                ],
                color: Colors.white,
                circleColor: theme.primaryColor,
                height: 60,
                circleWidth: 55,
                iconCurve: Curves.fastOutSlowIn,

                // tabCurve: ,
                //padding: const EdgeInsets.only(left: 16, right: 16,),
                cornerRadius: BorderRadius.only(
                  topLeft: viewModel.pageIndex == 0
                      ? Radius.circular(2)
                      : Radius.circular(8),
                  topRight: viewModel.pageIndex == 4
                      ? Radius.circular(2)
                      : Radius.circular(8),
                ),
                shadowColor: Colors.grey,
                //circleShadowColor: Colors.deepPurple,
                elevation: 5,
                activeIndex: viewModel.pageIndex,
              )
              //   gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     colors: [ Colors.blue, Colors.red ],
              //   ),
              //   circleGradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     colors: [ Colors.blue, Colors.red ],
              //   ), activeIndex: 1,
              // ),
              ),
        );
      },
      viewModelBuilder: () => locator<BottomBarViewModel>(),
      disposeViewModel: false,
      // fireOnViewModelReadyOnce: true,
      // initialiseSpecialViewModelsOnce: true,
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.init(widget.index)),
    );
  }
}
