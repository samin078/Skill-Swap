import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../Widgets/appbar/appbar.dart';
import '../Widgets/shape_widgets/NCurvedEdgeWidget.dart';
import 'circular_container.dart';

class NPrimaryHeaderContainer extends StatelessWidget {
  const NPrimaryHeaderContainer({
    super.key, required this.child,  NAppBar? appBar,this.height=400,
  });
  final Widget child;
  final double height;
  @override
  Widget build(BuildContext context) {
    return NCurvedEdgesWidget(
      child:Container(
        color: NColors.primary,
        padding: EdgeInsets.all(0),
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned(
                  top: -150,
                  right: -250,
                  child: NCircularContainer(backgroundColor: NColors.textWhite.withOpacity(0.1),)),
              Positioned(top:100,
                  right: -300,
                  child: NCircularContainer(backgroundColor: NColors.textWhite.withOpacity(0.1),)),
              child
            ],

          ),
        ),

      ),
    );
  }
}



