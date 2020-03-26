import 'dart:async';
import 'dart:io';
import 'dart:math';

// import 'package:clipboard_manager/clipboard_manager.dart';
// import 'package:flutter_clipboard_manager/flutter_clipboard_manager.dart';
import 'package:sharik/constants/config.dart';
import 'package:sharik/locale.dart';
import 'package:sharik/main.dart';
import 'package:sharik/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:io' show Platform;

class ShareScreen extends StatefulWidget {
  @override
  ShareScreenState createState() => ShareScreenState();
}

class ShareScreenState extends State<ShareScreen>
    with TickerProviderStateMixin {
  MediaQueryData queryData;

  AnimationController ipController;
  Animation ipAnimation;
  AnimationController conController;
  Animation conAnimation;

  String ip = L.get(
    'dict_loading',
    locale,
  );
  String network = L.get(
    'dict_loading',
    locale,
  );
  bool wifi = false;
  bool tether = false;
  int port = 0;
  HttpServer server;

  Future<int> getUnusedPort([InternetAddress address]) {
    return HttpServer.bind(address ?? InternetAddress.anyIPv4, 0)
        .then((socket) {
      var port = socket.port;
      socket.close();
      return port;
    });
  }

  void serve() async {
    await for (var request in server) {
      if (file[0] == 'file' || file[0] == 'app') {
        var f = File(file[0] == 'file' ? file[1] : file[1][2]);
        var size = await f.length();

        request.response.headers.contentType = ContentType(
          'application',
          'octet-stream',
          charset: 'utf-8',
        );

        request.response.headers.add(
          'Content-Transfer-Encoding',
          'Binary',
        );

        request.response.headers.add(
          'Content-disposition',
          'attachment; filename=' +
              Uri.encodeComponent(
                file[0] == 'file'
                    ? file[1].split('/').last
                    : file[1][0] + '.apk',
              ),
        );
        request.response.headers.add(
          'Content-length',
          size,
        );

        f.openRead().pipe(request.response).catchError((e) {}).then((a) {
          request.response.close();
        });
      } else {
        request.response.headers.contentType =
            ContentType('text', 'plain', charset: 'utf-8');
        request.response.write(file[1]);
        request.response.close();
      }
    }
  }

  Future getIp() async {
    for (var interface in await NetworkInterface.list())
      for (var addr in interface.addresses) {
        if (addr.address.startsWith('192.168.')) return addr.address;
        if (addr.address.startsWith('10.')) return addr.address;
        if (addr.address.startsWith('172.16.')) return addr.address;
      }
  }

  void updIp() async {
    setState(() {
      ip = L.get('dict_loading', locale);
    });
    ipController.repeat();

    await Future.delayed(
      const Duration(milliseconds: 500),
      () {},
    );
    String _ip = await getIp();

    if (port == 0 && _ip != null) {
      server = await HttpServer.bind(
        InternetAddress(_ip),
        0,
        shared: true,
      );
      port = server.port;
      serve();
    }
    setState(() {
      ip = "http://$_ip:$port";
    });

    ipController.stop();
  }

  void updCon() async {
    setState(() {
      network = L.get(
        'dict_loading',
        locale,
      );
      wifi = false;
      tether = false;
    });
    conController.repeat();

    bool w = false;
    bool t = false;

    if (Platform.isAndroid) {
      w = await WiFiForIoTPlugin.isConnected();
      t = await WiFiForIoTPlugin.isWiFiAPEnabled();
    }

    await Future.delayed(const Duration(milliseconds: 500), () {});
    setState(() {
      wifi = w;
      tether = t;
      if (!Platform.isAndroid)
        network = L.get(
          'dict_undefined',
          locale,
        );
      else if (w)
        network = 'Wi-Fi';
      else if (t)
        network = L.get(
          'dict_mobile_hotspot',
          locale,
        );
      else
        network = L.get(
          'dict_not_connected',
          locale,
        );
    });
    conController.stop();

    updIp();
  }

  @override
  void dispose() {
    if (server != null) server.close();

    if (conController.isAnimating) conController.stop();

    if (ipController.isAnimating) ipController.stop();

    super.dispose();
  }

  @override
  void initState() {
    ipController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    ipAnimation = Tween(begin: 0, end: 2 * pi).animate(ipController);

    conController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    conAnimation = Tween(begin: 0, end: 2 * pi).animate(conController);

    updCon();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    List<String> s = getIconText(file);
    String icon = s[0];
    String text = s[1];

    return Container(
      margin: EdgeInsets.only(
        left: queryData.size.width * 0.06,
        right: queryData.size.width * 0.06,
        top: queryData.size.width * 0.04,
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: queryData.size.width * 0.115,
            margin: EdgeInsets.only(
              bottom: queryData.size.width * 0.045,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: queryData.size.width * 0.04,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                queryData.size.width * 0.03,
              ),
              color: Config.primaryColor,
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
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: queryData.size.width * 0.045,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                queryData.size.width * 0.03,
              ),
              color: Config.primaryColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: queryData.size.width * 0.04,
                  ),
                  margin: EdgeInsets.only(
                    top: queryData.size.width * 0.045,
                  ),
                  child: SvgPicture.asset(
                    'assets/icon_network.svg',
                    semanticsLabel: 'network ',
                    width: queryData.size.width * 0.045,
                  ),
                ),
                SizedBox(
                  width: queryData.size.width * 0.03,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: queryData.size.width * 0.025,
                    ),
                    child: Column(
                      crossAxisAlignment: locale == 'ar'
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            network,
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.tajawal(
                              textStyle: TextStyle(
                                color: Config.whiteColor,
                                fontSize: queryData.size.width * 0.045,
                              ),
                            ),
                          ),
                        ),
                        RichText(
                          overflow: TextOverflow.clip,
                          locale: Locale(locale),
                          text: TextSpan(
                            style: GoogleFonts.tajawal(
                              textStyle: TextStyle(
                                color: Config.whiteColor,
                                fontSize: queryData.size.width * 0.04,
                              ),
                            ),
                            children: [
                              TextSpan(
                                text: L.get(
                                  'dict_connect_to',
                                  locale,
                                ),
                              ),
                              Platform.isAndroid
                                  ? TextSpan(
                                      text: " Wi-Fi ",
                                      style: TextStyle(
                                        color: wifi
                                            ? Color(0xFFC8E6C9)
                                            : Color(0xFFFFCDD2),
                                      ),
                                    )
                                  : TextSpan(text: " Wi-Fi "),
                              TextSpan(
                                text: L.get('dict_or_enable', locale) + " ",
                              ),
                              Platform.isAndroid
                                  ? TextSpan(
                                      text: L.get(
                                        'dict_mobile_hotspot',
                                        locale,
                                      ),
                                      style: TextStyle(
                                        color: tether
                                            ? Color(0xFFC8E6C9)
                                            : Color(0xFFFFCDD2),
                                      ),
                                    )
                                  : TextSpan(
                                      text: L.get(
                                        'dict_mobile_hotspot',
                                        locale,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: queryData.size.width * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: queryData.size.width * 0.03,
                ),
                Material(
                  borderRadius: BorderRadius.circular(
                    queryData.size.width * 0.03,
                  ),
                  color: Config.primaryColor,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      queryData.size.width * 0.03,
                    ),
                    onTap: () {
                      updCon();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: queryData.size.width * 0.035,
                        horizontal: queryData.size.width * 0.035,
                      ),
                      child: AnimatedBuilder(
                        animation: conAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: conAnimation.value / 1,
                            child: child,
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/icon_update.svg',
                          semanticsLabel: 'update ',
                          height: queryData.size.width * 0.035,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              L.get(
                'dict_now_open',
                locale,
              ),
              overflow: TextOverflow.clip,
              textDirection:
                  locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              style: GoogleFonts.tajawal(
                textStyle: TextStyle(
                  fontSize: queryData.size.width * 0.05,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Config.primaryColor,
              borderRadius: BorderRadius.circular(
                queryData.size.width * 0.03,
              ),
            ),
            height: queryData.size.width * 0.105,
            margin: EdgeInsets.symmetric(
              horizontal: queryData.size.width * 0.005,
              vertical: queryData.size.width * 0.045,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: queryData.size.width * 0.035,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      ip,
                      style: GoogleFonts.tajawal(
                        textStyle: TextStyle(
                          color: Config.whiteColor,
                          fontSize: queryData.size.width * 0.045,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: queryData.size.width * 0.015,
                ),
                Material(
                  borderRadius: BorderRadius.circular(
                    queryData.size.width * 0.03,
                  ),
                  color: Config.primaryColor,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      queryData.size.width * 0.03,
                    ),
                    onTap: () {
                      final snackBar = SnackBar(
                        backgroundColor: Config.primaryColor,
                        duration: Duration(
                          seconds: 1,
                        ),
                        content: Text(
                          L.get(
                            'dict_will_be_implemented',
                            locale,
                          ),
                          textDirection: locale == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.tajawal(
                            color: Config.whiteColor,
                          ),
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                      // ClipboardManager.copyToClipBoard(ip).then((result) {
                      //   final snackBar = SnackBar(
                      //     backgroundColor: Config.primaryColor,
                      //     duration: Duration(
                      //       seconds: 1,
                      //     ),
                      //     content: Text(
                      //       L.get(
                      //         'copied',
                      //         locale,
                      //       ),
                      //       textDirection: locale == 'ar'
                      //           ? TextDirection.rtl
                      //           : TextDirection.ltr,
                      //        overflow: TextOverflow.clip,
                      //       style: GoogleFonts.tajawal(
                      //         color: Config.whiteColor,
                      //       ),
                      //     ),
                      //   );
                      //   Scaffold.of(context).showSnackBar(snackBar);
                      //   print(result);
                      // });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: queryData.size.width * 0.035,
                        horizontal: queryData.size.width * 0.03,
                      ),
                      child: SvgPicture.asset(
                        'assets/icon_copy.svg',
                        semanticsLabel: 'update',
                        width: queryData.size.width * 0.04,
                      ),
                    ),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(
                    queryData.size.width * 0.03,
                  ),
                  color: Config.primaryColor,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      queryData.size.width * 0.03,
                    ),
                    onTap: () {
                      updIp();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: queryData.size.width * 0.035,
                        horizontal: queryData.size.width * 0.03,
                      ),
                      child: AnimatedBuilder(
                        animation: ipAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: ipAnimation.value / 1,
                            child: child,
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/icon_update.svg',
                          semanticsLabel: 'update ',
                          height: queryData.size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              vertical: queryData.size.width * 0.045,
            ),
            padding: EdgeInsets.all(
              queryData.size.width * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                queryData.size.width * 0.03,
              ),
              color: Config.secondaryColor,
            ),
            child: Text(
              L.get(
                'dict_the_recipient',
                locale,
              ),
              overflow: TextOverflow.clip,
              textDirection:
                  locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                textStyle: TextStyle(
                  color: Config.whiteColor,
                  fontSize: queryData.size.width * 0.045,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
