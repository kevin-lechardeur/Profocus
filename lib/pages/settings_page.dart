import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/appcontroller.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<AppController>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Paramètres")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text("Mode Sombre"),
            value: appController.isDarkMode,
            onChanged: (value) => appController.toggleTheme(),
          ),
        ],
      ),
    );
  }
}