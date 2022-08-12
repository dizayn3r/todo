import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/routes/routes.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settingAppTitle"),
      ),
      body: _buildLayoutSection(context),
    );
  }

  Widget _buildLayoutSection(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(
              "settingThemeListTitle"),
          subtitle: Text(
              "settingThemeListSubTitle"),
          trailing: Switch(
            activeColor: Theme.of(context).appBarTheme.backgroundColor,
            activeTrackColor: Theme.of(context).textTheme.titleMedium!.color,
            value: Provider.of<ThemeProvider>(context).isDarkModeOn,
            onChanged: (booleanValue) {
              Provider.of<ThemeProvider>(context, listen: false)
                  .updateTheme(booleanValue);
            },
          ),
        ),
        ListTile(
          title: Text(
              "settingLogoutListTitle"),
          subtitle: Text(
            "settingLogoutListSubTitle"),
          trailing: ElevatedButton(
              onPressed: () {
                _confirmSignOut(context);
              },
              child: Text(
                 "settingLogoutButton")),
        )
      ],
    );
  }

  _confirmSignOut(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
          material: (_, PlatformTarget target) => MaterialAlertDialogData(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
          title: Text(
             "alertDialogTitle"),
          content: Text(
             "alertDialogMessage"),
          actions: <Widget>[
            PlatformDialogAction(
              child: PlatformText("No"),
              onPressed: () => Navigator.pop(context),
            ),
            PlatformDialogAction(
              child: PlatformText("Yes"),
              onPressed: () {
                final authProvider =
                Provider.of<AuthProvider>(context, listen: false);

                authProvider.signOut();

                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.login, ModalRoute.withName(Routes.login));
              },
            )
          ],
        ));
  }
}