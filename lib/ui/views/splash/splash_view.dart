import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/ui/views/splash/splash_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_svg/svg.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override

  @override
  Widget build(BuildContext context) {

    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<SplashViewModel>.reactive(
      viewModelBuilder: () => SplashViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Center(
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // (mediaH * 0.4).vSpace(),
                Spacer(),
                Center(
                  child: Container(
                    //color: Colors.red,
                    //padding: EdgeInsets.symmetric(horizontal: 50),
                    //   height: 100,
                      width: 250,
                      child:Image.asset('assets/papne_cab.png')
                      // SvgPicture.asset('assets/logo.svg')
                  ),
                ),
                //(mediaH * 0.03).vSpace(),
                // Text('PAPNE CAB',style: textTheme.displayLarge!.copyWith(fontSize: 30,),),
                (mediaH * 0.26).vSpace(),
                Text('RIDE IN A NEW WAY',style: textTheme.displayLarge!.copyWith(fontSize: 26,color: Color(0xff4d4d4d),),),
                5.vSpace(),
                Text('A Fairer ride for your child',style: textTheme.titleMedium!.copyWith(color: Color(0xff4d4d4d)),),
                (mediaH * 0.04).vSpace(),
              ],
            ),
          ),
        );
      },
      onViewModelReady: (model) =>
          SchedulerBinding.instance.addPostFrameCallback((_) => model.initialise()),
    );
  }
}
