import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheckWrapper extends StatefulWidget {
  final Widget child;
  const VersionCheckWrapper({super.key, required this.child});

  @override
  _VersionCheckWrapperState createState() => _VersionCheckWrapperState();
}

class _VersionCheckWrapperState extends State<VersionCheckWrapper> {
  final bool _shouldForceUpdate = false;

  @override
  void initState() {
    super.initState();
    //  _checkVersion();
  }

  // Future<void> _checkVersion() async {
  //   final remoteConfig = FirebaseRemoteConfig.instance;
  //   await remoteConfig.setDefaults({'force_update_current_version': '1.0.0+21'});
  //   await remoteConfig.fetchAndActivate();

  //   final latestVersion = remoteConfig.getString('force_update_current_version');
  //   final packageInfo = await PackageInfo.fromPlatform();
  //   final currentVersion = packageInfo.buildNumber;

  //   if (int.parse(currentVersion) < int.parse(latestVersion.split('+').last)) {
  //     setState(() {
  //       _shouldForceUpdate = true;
  //     });
  //   }
  // }

  Future<void> _launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.app.nammasavari.android&hl=en_IN';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldForceUpdate) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: AlertDialog(
              title: const Text("Update Required"),
              content: const Text("Please update the app to continue."),
              actions: [
                ElevatedButton(
                  onPressed: _launchURL,
                  child: const Text("Update Now"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
