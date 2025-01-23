import 'dart:developer';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Application> _apps = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getInstalledApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(top: kToolbarHeight, left: 8, right: 8),
        child: Stack(
          children: [
            // app icons
            _appIconGrid(),
            // loading
            _loadingIcon()
          ],
        ),
      ),
    );
  }

  _getInstalledApp() async {
    _apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );

    setState(() {
      _loading = false;
      log('found ${_apps.length} apps');
    });
  }

  GridView _appIconGrid() {
    return GridView.builder(
      itemCount: _apps.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        // show app icon
        final app = _apps[index] as ApplicationWithIcon;
        return _buildAppIcon(app);
      },
    );
  }

  SingleChildRenderObjectWidget _loadingIcon() {
    return (_loading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SizedBox();
  }

  InkWell _buildAppIcon(ApplicationWithIcon app) {
    return InkWell(
      onTap: () {
        //
        app.openApp();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(
                app.icon,
              ),
            ),
            Text(
              app.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
