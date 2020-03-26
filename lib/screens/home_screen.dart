import 'dart:async';
import 'dart:io';

import 'package:sharik/constants/config.dart';
import 'package:sharik/locale.dart';
import 'package:sharik/main.dart';
import 'package:sharik/screens/app_selector_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  Callback back;

  HomeScreen(this.back);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MediaQueryData queryData;

  var latest = [];

  @override
  void initState() {
    pref();
    super.initState();
  }

  void pref() async {
    setState(() {
      latest = latestBox.get(
        'data',
        defaultValue: [],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Column(
      crossAxisAlignment:
          locale == 'ar' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: queryData.size.width * 0.06,
            right: queryData.size.width * 0.06,
            top: queryData.size.width * 0.02,
          ),
          height: queryData.size.width * 0.2,
          child: Material(
            borderRadius: BorderRadius.circular(
              queryData.size.width * 0.03,
            ),
            color: Config.primaryColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(
                queryData.size.width * 0.03,
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      L.get(
                        'dict_select_file',
                        locale,
                      ),
                      overflow: TextOverflow.clip,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          color: Config.whiteColor,
                          fontSize: queryData.size.width * 0.06,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(
                      queryData.size.width * 0.04,
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SvgPicture.asset(
                        'assets/icon_file.svg',
                      ),
                    ),
                  )
                ],
              ),
              onTap: () async {
                File f = await FilePicker.getFile();
                if (f != null) {
                  file = ['file', f.path];

                  if (file.length == 0) return;

                  setState(() {
                    if (latest.contains(file)) latest.remove(file);

                    latest.insert(0, file);
                  });

                  latestBox.put('data', latest);

                  widget.back('file');
                }
              },
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Platform.isAndroid
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: queryData.size.width * 0.06,
                        top: queryData.size.width * 0.02,
                      ),
                      height: queryData.size.width * 0.12,
                      child: Material(
                        borderRadius: BorderRadius.circular(
                          queryData.size.width * 0.03,
                        ),
                        color: Config.primaryColor,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            queryData.size.width * 0.03,
                          ),
                          child: Center(
                            child: Text(
                              L.get(
                                'dict_app',
                                locale,
                              ),
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.tajawal(
                                textStyle: TextStyle(
                                  color: Config.whiteColor,
                                  fontSize: queryData.size.width * 0.06,
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            showDialog(
                              context: context,
                              child: AppSelectorScreen(
                                (String selected) async {
                                  Application app =
                                      await DeviceApps.getApp(selected);
                                  file = [
                                    'app',
                                    [
                                      app.appName,
                                      app.packageName,
                                      app.apkFilePath,
                                    ]
                                  ];

                                  setState(() {
                                    if (latest.contains(file))
                                      latest.remove(file);

                                    latest.insert(0, file);
                                  });

                                  latestBox.put('data', latest);

                                  widget.back('file');
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              width: Platform.isAndroid
                  ? queryData.size.width * 0.02
                  : queryData.size.width * 0.06,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: queryData.size.width * 0.06,
                  top: queryData.size.width * 0.02,
                ),
                height: queryData.size.width * 0.12,
                child: Material(
                  borderRadius: BorderRadius.circular(
                    queryData.size.width * 0.03,
                  ),
                  color: Config.primaryColor,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      queryData.size.width * 0.03,
                    ),
                    child: Center(
                      child: Text(
                        L.get(
                          'dict_text',
                          locale,
                        ),
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.tajawal(
                          textStyle: TextStyle(
                            color: Config.whiteColor,
                            fontSize: queryData.size.width * 0.06,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      // flutter defined function
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController c = TextEditingController();
                          return AlertDialog(
                            title: Text(
                              L.get(
                                'dict_type_text',
                                locale,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                            content: TextField(
                              controller: c,
                              maxLines: null,
                              minLines: null,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  L.get(
                                    'dict_close',
                                    locale,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  L.get(
                                    'dict_send',
                                    locale,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  file = ['text', c.text];

                                  if (file[1].length == 0) return;

                                  setState(() {
                                    if (latest.contains(file))
                                      latest.remove(file);

                                    latest.insert(0, file);
                                  });

                                  latestBox.put('data', latest);

                                  widget.back('file');
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: queryData.size.width * 0.06,
        ),
        Container(
          margin: EdgeInsets.only(
            left: queryData.size.width * 0.06,
            right: queryData.size.width * 0.06,
          ),
          child: Text(
            L.get(
              'dict_latest',
              locale,
            ),
            textDirection:
                locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            overflow: TextOverflow.clip,
            style: GoogleFonts.tajawal(
              textStyle: TextStyle(
                fontSize: queryData.size.width * 0.06,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: queryData.size.width * 0.06,
              right: queryData.size.width * 0.06,
            ),
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: queryData.size.width * 0.04,
              ),
              itemCount: latest.length,
              itemBuilder: (BuildContext context, int index) {
                return card(
                  latest[index],
                );
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: queryData.size.width * 0.045,
          ),
          height: queryData.size.width * 0.135,
          decoration: BoxDecoration(
            color: Config.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                queryData.size.width * 0.06,
              ),
              topRight: Radius.circular(
                queryData.size.width * 0.06,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              Material(
                color: Config.primaryColor,
                borderRadius: BorderRadius.circular(
                  queryData.size.width * 0.02,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    queryData.size.width * 0.02,
                  ),
                  splashColor: Config.secondaryColor,
                  child: Container(
                    margin: EdgeInsets.all(
                      queryData.size.width * 0.03,
                    ),
                    child: SvgPicture.asset(
                      'assets/icon_locale.svg',
                      semanticsLabel: 'locale',
                      height: queryData.size.width * 0.045,
                      color: Config.whiteColor,
                    ),
                  ),
                  onTap: () => widget.back('_locale'),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Material(
                color: Config.primaryColor,
                borderRadius:
                    BorderRadius.circular(queryData.size.width * 0.02),
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(queryData.size.width * 0.02),
                  splashColor: Config.secondaryColor,
                  child: Container(
                    margin: EdgeInsets.all(
                      queryData.size.width * 0.03,
                    ),
                    child: SvgPicture.asset(
                      'assets/icon_help.svg',
                      semanticsLabel: 'help',
                      height: 14,
                      color: Config.whiteColor,
                    ),
                  ),
                  onTap: () => widget.back('_help'),
                ),
              ),
              Spacer(),
              Material(
                color: Config.primaryColor,
                borderRadius:
                    BorderRadius.circular(queryData.size.width * 0.02),
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(queryData.size.width * 0.02),
                  splashColor: Config.secondaryColor,
                  child: Container(
                    margin: EdgeInsets.all(
                      queryData.size.width * 0.03,
                    ),
                    child: SvgPicture.asset(
                      'assets/icon_email.svg',
                      semanticsLabel: 'email',
                      height: 14,
                      color: Config.whiteColor,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch('mailto:yazeedfady@gmail.com'))
                      await launch('mailto:yazeedfady@gmail.com');
                  },
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Material(
                color: Config.primaryColor,
                borderRadius: BorderRadius.circular(
                  queryData.size.width * 0.02,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    queryData.size.width * 0.02,
                  ),
                  splashColor: Config.secondaryColor,
                  child: Container(
                    margin: EdgeInsets.all(
                      queryData.size.width * 0.03,
                    ),
                    child: SvgPicture.asset(
                      'assets/icon_instagram.svg',
                      semanticsLabel: 'instagram',
                      height: queryData.size.width * 0.045,
                      color: Config.whiteColor,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch('https://instagram.com/yazeedalkhalaf'))
                      await launch('https://instagram.com/yazeedalkhalaf');
                  },
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Container(
                color: Config.primaryColor,
                height: double.infinity,
                margin: EdgeInsets.symmetric(
                  vertical: queryData.size.width * 0.03,
                ),
                width: 1,
              ),
              SizedBox(
                width: 2,
              ),
              Material(
                color: Config.primaryColor,
                borderRadius: BorderRadius.circular(
                  queryData.size.width * 0.02,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    queryData.size.width * 0.02,
                  ),
                  splashColor: Config.secondaryColor,
                  child: Container(
                    margin: EdgeInsets.all(queryData.size.width * 0.03),
                    child: SvgPicture.asset(
                      'assets/icon_github.svg',
                      semanticsLabel: 'play store',
                      height: queryData.size.width * 0.045,
                      color: Config.whiteColor,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch(
                        'https://github.com/yazeedalkhalaf/sharik'))
                      await launch('https://github.com/yazeedalkhalaf/sharik');
                  },
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Material(
                color: Config.primaryColor,
                borderRadius: BorderRadius.circular(
                  queryData.size.width * 0.02,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    queryData.size.width * 0.02,
                  ),
                  splashColor: Config.secondaryColor,
                  child: Container(
                    margin: EdgeInsets.all(
                      queryData.size.width * 0.03,
                    ),
                    child: SvgPicture.asset(
                      'assets/icon_store.svg',
                      semanticsLabel: 'play store',
                      height: queryData.size.width * 0.045,
                      color: Config.whiteColor,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch(
                        'https://play.google.com/store/apps/details?id=dev.alkhalaf.sharik'))
                      await launch(
                          'https://play.google.com/store/apps/details?id=dev.alkhalaf.sharik');
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget card(List f) {
    //weird stuff goes here, but it works :D
    ScrollController controller = ScrollController();

    // print('displaying card...');
    int n = 0;
    void set() {
      if (controller.positions.isNotEmpty) {
        controller.jumpTo(controller.position.maxScrollExtent);
        n++;
        // print(n);
        if (n < 5) Timer(Duration(milliseconds: 100), () => set());
      } else
        Timer(Duration(milliseconds: 100), () => set());
    }

    // print(latest);
    if (!Platform.isAndroid) set();

    List<String> s = getIconText(f);
    String icon = s[0];
    String text = s[1];
    return Container(
      height: queryData.size.width * 0.11,
      margin: EdgeInsets.only(
        bottom: queryData.size.width * 0.03,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(
          queryData.size.width * 0.03,
        ),
        color: Config.secondaryColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            queryData.size.width * 0.03,
          ),
          onTap: () async {
            file = f;

            if (f.length == 0) {
              latest.remove(file);
              return;
            }

            setState(() {
              if (latest.contains(file)) latest.remove(file);

              latest.insert(0, file);
            });

            latestBox.put('data', latest);

            widget.back('file');
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: queryData.size.width * 0.04,
            ),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  icon,
                  semanticsLabel: 'file ',
                  width: queryData.size.width * 0.045,
                ),
                SizedBox(
                  width: queryData.size.width * 0.03,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      text,
                      overflow: TextOverflow.clip,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          color: Config.whiteColor,
                          fontSize: queryData.size.width * 0.045,
                        ),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<String> getIconText(List f) {
  String icon;
  String text;

  switch (f[0]) {
    case 'file':
      icon = 'assets/icon_folder2.svg';
      text = (Platform.isAndroid ? f[1].split('/').last : f[1]);
      break;
    case 'text':
      icon = 'assets/icon_file_word.svg';
      text = f[1].replaceAll('\n', ' ');
      break;
    case 'app':
      icon = 'assets/icon_file_app.svg';
      text = f[1][0];
      break;
  }
  return [icon, text];
}
