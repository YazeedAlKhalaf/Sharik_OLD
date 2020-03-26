import 'package:sharik/constants/config.dart';
import 'package:sharik/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class LanguageScreen extends StatefulWidget {
  Callback back;

  LanguageScreen(this.back);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  MediaQueryData queryData;

  Widget button(String locale) {
    String text;
    switch (locale) {
      case 'en':
        text = 'English';
        break;
      case 'ar':
        text = 'Arabic';
        break;
      case 'tr':
        text = 'Turkish';
        break;
    }

    return Container(
      height: queryData.size.width * 0.25,
      child: Material(
        borderRadius: BorderRadius.circular(
          queryData.size.width * 0.075,
        ),
        color: Config.primaryColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            queryData.size.width * 0.075,
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(
                  text,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      color: Config.whiteColor,
                      fontSize: queryData.size.width * 0.065,
                    ),
                  ),
                ),
              ),
            ],
          ),
          onTap: () => widget.back(locale),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: queryData.size.width * 0.06,
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: queryData.size.width * 0.065,
              bottom: queryData.size.width * 0.065,
            ),
            child: Text(
              "Select the language you are familiar with",
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: queryData.size.width * 0.07,
              ),
            ),
          ),
          button('en'),
          SizedBox(
            height: queryData.size.width * 0.06,
          ),
          button('ar'),
          SizedBox(
            height: queryData.size.width * 0.06,
          ),
          button('tr'),
        ],
      ),
    );
  }
}
