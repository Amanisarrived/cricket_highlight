import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppVersionScreen extends StatefulWidget {
  const AppVersionScreen({super.key});

  @override
  State<AppVersionScreen> createState() => _AppVersionScreenState();
}

class _AppVersionScreenState extends State<AppVersionScreen> {
  String version = "";
  String buildNumber = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const AppText(
          "App Version",
          fontSize: 22,
          color: Colors.white,
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent.withAlpha(80), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withAlpha(40),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.badgeInfo,
                size: 60,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 20),
              AppText(
                "Version: $version",
                fontSize: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              AppText(
                "Build: $buildNumber",
                fontSize: 16,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
