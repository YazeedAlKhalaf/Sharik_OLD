import 'package:sharik/locale.dart';
import 'package:sharik/main.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSelectorScreen extends StatefulWidget {
  final Function(String package) callback;

  AppSelectorScreen(this.callback);

  @override
  _AppSelectorScreenState createState() => _AppSelectorScreenState();
}

class _AppSelectorScreenState extends State<AppSelectorScreen> {
  MediaQueryData queryData;

  bool checkSystem = true;
  bool checkLaunch = true;
  List<Application> apps;
  String search;
  String selected;

  @override
  void initState() {
    getApps();
    super.initState();
  }

  void getApps() {
    setState(() => apps = null);

    DeviceApps.getInstalledApplications(
            onlyAppsWithLaunchIntent: !checkLaunch,
            includeSystemApps: !checkSystem,
            includeAppIcons: true)
        .then((value) {
      setState(
        () => apps = value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    List<Application> _apps = [];
    if (search == null || search.length == 0)
      _apps = apps;
    else
      apps.forEach(
        (element) {
          if (element.packageName.contains(search) ||
              element.appName.contains(search)) _apps.add(element);
        },
      );

    // print(selected);

    return AlertDialog(
//      title: Text("Type some text asdf asdfhba sdfhbfipsadfhbapsdihfbp"),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            CheckboxListTile(
              title: Text(
                L.get(
                  'dict_hide_system_apps',
                  locale,
                ),
                overflow: TextOverflow.clip,
              ),
              value: checkSystem,
              onChanged: (value) => setState(() {
                checkSystem = value;
                getApps();
              }),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: Text(
                L.get(
                  'dict_hide_nonlaunchable_apps',
                  locale,
                ),
                overflow: TextOverflow.clip,
              ),
              value: checkLaunch,
              onChanged: (value) => setState(() {
                checkLaunch = value;
                getApps();
              }),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            TextField(
              onChanged: (value) => setState(() => search = value),
              decoration: InputDecoration(
                hintText: L.get(
                  'dict_search',
                  locale,
                ),
              ),
            ),
            _apps != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _apps.length,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, item) {
                      ApplicationWithIcon app = _apps[item];
                      return ListTile(
                        leading: Image.memory(
                          app.icon,
                        ),
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            app.appName,
                          ),
                        ),
                        subtitle: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            app.packageName,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        onTap: () {
                          setState(
                            () => selected = app.packageName,
                          );
                        },
                        selected: selected == app.packageName,
                      );
                    },
                  )
                : Center(
                    child: Container(
                      padding: EdgeInsets.all(
                        queryData.size.width * 0.06,
                      ),
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
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
          onPressed: selected == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  widget.callback(selected);
                },
        ),
      ],
    );
  }
}
