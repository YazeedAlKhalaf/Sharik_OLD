import 'package:sharik/constants/config.dart';
import 'package:sharik/locale.dart';
import 'package:sharik/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class IntroScreen extends StatefulWidget {
  Function tap;

  IntroScreen(this.tap);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  MediaQueryData queryData;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return IntroSlider(
      nameDoneBtn: L.get(
        'dict_done',
        locale,
      ),
      nameNextBtn: L.get(
        'dict_next',
        locale,
      ),
      isShowSkipBtn: false,
      styleNameDoneBtn: GoogleFonts.tajawal(
        textStyle: TextStyle(
          color: Config.whiteColor,
        ),
      ),
      styleNamePrevBtn: GoogleFonts.tajawal(
        textStyle: TextStyle(
          color: Config.whiteColor,
        ),
      ),
      colorDot: Config.whiteColor,
      colorActiveDot: Config.whiteColor,
      slides: <Slide>[
        Slide(
          styleTitle: GoogleFonts.tajawal(
            textStyle: TextStyle(
              color: Config.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: queryData.size.width * 0.075,
            ),
          ),
          styleDescription: GoogleFonts.tajawal(
            textStyle: TextStyle(
              color: Config.whiteColor,
              fontSize: queryData.size.width * 0.045,
            ),
          ),
          title: L.get(
            'dict_slide1_title',
            locale,
          ),
          description: L.get(
            'dict_slide1_subtitle',
            locale,
          ),
          pathImage: 'assets/slide_1.png',
          backgroundColor: Config.slide1Color,
        ),
        Slide(
          styleTitle: GoogleFonts.tajawal(
            textStyle: TextStyle(
              color: Config.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: queryData.size.width * 0.075,
            ),
          ),
          styleDescription: GoogleFonts.tajawal(
            textStyle: TextStyle(
              color: Config.whiteColor,
              fontSize: queryData.size.width * 0.045,
            ),
          ),
          title: L.get(
            'dict_slide2_title',
            locale,
          ),
          description: L.get(
            'dict_slide2_subtitle',
            locale,
          ),
          pathImage: 'assets/slide_2.png',
          backgroundColor: Config.slide2Color,
        ),
        Slide(
          styleTitle: GoogleFonts.tajawal(
            textStyle: TextStyle(
              color: Config.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: queryData.size.width * 0.075,
            ),
          ),
          styleDescription: GoogleFonts.tajawal(
            textStyle: TextStyle(
              color: Config.whiteColor,
              fontSize: queryData.size.width * 0.045,
            ),
          ),
          title: L.get(
            'dict_slide3_title',
            locale,
          ),
          description: L.get(
            'dict_slide3_subtitle',
            locale,
          ),
          pathImage: 'assets/slide_3.png',
          backgroundColor: Config.slide3Color,
        ),
        Slide(
          styleTitle: GoogleFonts.tajawal(
            textStyle: TextStyle(
              color: Config.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: queryData.size.width * 0.075,
            ),
          ),
          title: L.get(
            'dict_slide4_title',
            locale,
          ),
          pathImage: 'assets/slide_4.png',
          backgroundColor: Config.slide4Color,
          widgetDescription: GestureDetector(
            onTap: () async {
              if (await canLaunch('https://github.com/yazeedalkhalaf/sharik'))
                await launch('https://github.com/yazeedalkhalaf/sharik');
            },
            child: Text(
              L.get(
                'dict_slide4_subtitle',
                locale,
              ),
              style: GoogleFonts.tajawal(
                textStyle: TextStyle(
                  color: Config.whiteColor,
                  fontSize: queryData.size.width * 0.045,
                ),
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
      ],
      onDonePress: widget.tap,
    );
  }
}
