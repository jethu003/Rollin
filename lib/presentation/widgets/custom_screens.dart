import 'package:flutter/widgets.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';




class CustomScreens extends StatelessWidget{
  const CustomScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
     child: Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            color: AppColours.insideGrey,
            image:DecorationImage(image: AssetImage('assets/aavesham.jpg'),),
          ),
        ),
        Container(
             height: 100,
          width: 100,
          color: AppColours.primaryColor,
        ),
      ],
     ),
    );
  }
   
}