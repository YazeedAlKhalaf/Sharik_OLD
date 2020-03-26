import 'package:sharik/constants/config.dart';
import 'package:sharik/screens/home_screen.dart';
import 'package:sharik/screens/intro_screen.dart';
import 'package:sharik/screens/language_screen.dart';
import 'package:sharik/screens/share_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Platform;
import 'package:hive_flutter/hive_flutter.dart';

typedef Callback = void Function(String data);

String locale = 'en';
List<dynamic> file = [];

Box latestBox;

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('app');
  latestBox = await Hive.openBox('latest');

  getTemporaryDirectory().then((value) => value.deleteSync(recursive: true));

  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  MediaQueryData queryData;

  TabController pager;
  TabController pagerGlobal;
  bool back = false;

  void lang() async {
    String _locale = Hive.box('app').get('locale', defaultValue: null);

    await Future.delayed(const Duration(seconds: 1), () {});

    if (_locale != null) {
      locale = _locale;
      pagerGlobal.animateTo(3);
    } else
      pagerGlobal.animateTo(1);
  }

  Widget logo() {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/sharik_logo_512x512.png',
            semanticLabel: 'app icon',
            height: 65,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            "Sharik",
            overflow: TextOverflow.clip,
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  // ignore: missing_return
  Future<bool> _onWillPop() {
    setState(() {
      back = false;
    });
    pager.animateTo(0);

    getTemporaryDirectory().then((value) => value.deleteSync(recursive: true));
  }

  @override
  void initState() {
    pager = TabController(
      initialIndex: 0,
      vsync: this,
      length: 2,
    );
    pagerGlobal = TabController(
      initialIndex: 0,
      vsync: this,
      length: 4,
    );
    lang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Config.whiteColor,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: pagerGlobal,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Config.whiteColor,
            child: Center(
              child: Image.asset(
                'assets/sharik_logo_512x512.png',
                height: queryData.size.width * 0.5,
                semanticLabel: 'app icon',
              ),
            ),
          ),
          Column(
            children: <Widget>[
              SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: queryData.size.width * 0.06,
                    horizontal: queryData.size.width * 0.03,
                  ),
                  child: logo(),
                ),
              ),
              LanguageScreen((lang) async {
                pagerGlobal.animateTo(2);
                locale = lang;
                Hive.box('app').put('locale', locale);
              }),
            ],
          ),
          IntroScreen(() {
            pagerGlobal.animateTo(3);
          }),
          Column(
            children: <Widget>[
              SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: queryData.size.width * 0.06,
                    horizontal: queryData.size.width * 0.03,
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      logo(),
                      back
                          ? IconButton(
                              tooltip: "back",
                              onPressed: () {
                                setState(() {
                                  back = false;
                                });
                                pager.animateTo(0);

                                getTemporaryDirectory().then((value) {
                                  value.deleteSync(recursive: true);
                                });
                              },
                              icon: SvgPicture.asset(
                                'assets/icon_back.svg',
                                width: queryData.size.width * 0.06,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: pager,
                  children: <Widget>[
                    HomeScreen((e) {
                      if (e == '_help') {
                        pagerGlobal.animateTo(2);
                      } else if (e == '_locale') {
                        pagerGlobal.animateTo(1);
                      } else {
                        setState(() {
                          back = true;
                        });

                        pager.animateTo(1);
                      }
                    }),
                    WillPopScope(
                      onWillPop: _onWillPop,
                      child: ShareScreen(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
