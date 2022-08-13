import 'package:flutter/material.dart';
import 'package:todo/auth_widget_builder.dart';
import 'package:todo/models/user_model.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/routes/routes.dart';
import 'package:todo/services/firestore_database.dart';
import 'package:todo/ui/auth/sign_in_screen.dart';
import 'package:todo/ui/home/home.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({required Key key, required this.databaseBuilder})
      : super(key: key);

  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirestoreDatabase Function(BuildContext context, String uid)
  databaseBuilder;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProviderRef, __) {
        //{context, data, child}

            return AuthWidgetBuilder(
              databaseBuilder: databaseBuilder,
              builder: (BuildContext context,
                  AsyncSnapshot<UserModel> userSnapshot) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  routes: Routes.routes,
                  theme: ThemeData.light(),
                  darkTheme: ThemeData.dark(),
                  themeMode: themeProviderRef.isDarkModeOn
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  home: Consumer<AuthProvider>(
                    builder: (_, authProviderRef, __) {
                      //{context, data, child}
                      if (userSnapshot.connectionState ==
                          ConnectionState.active) {
                        return userSnapshot.hasData
                            ? const HomeScreen()
                            : const SignInScreen();
                      }
                      return const Material(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                );
              },
              key: const Key('AuthWidget'),
            );

      },
    );
  }
}