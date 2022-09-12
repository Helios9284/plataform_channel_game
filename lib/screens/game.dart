import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plataform_channel_game/constants/colors.dart';

class GameWindget extends StatefulWidget {
  const GameWindget({Key? key}) : super(key: key);

  @override
  State<GameWindget> createState() => _GameWindget();
}

class _GameWindget extends State<GameWindget> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(700, 1400));

    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(550),
                    height: ScreenUtil().setHeight(550),
                    color: colorLightBlue1,
                  ),
                  Container(
                    width: ScreenUtil().setWidth(150),
                    height: ScreenUtil().setHeight(550),
                    color: colorMidiumBlue2,
                  ),
                ],
              ),
              Container(
                width: ScreenUtil().setWidth(700),
                height: ScreenUtil().setHeight(850),
                color: colorDarkBlue3,
              )
            ],
          )
        ],
      ),
    ));
  }
}
