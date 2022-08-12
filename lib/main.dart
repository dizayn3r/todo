import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/my_app.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/providers/theme_provider.dart';
import 'package:todo/services/firestore_database.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) async {
      runApp(
        /*
      * MultiProvider for top services that do not depends on any runtime values
      * such as user uid/email.
       */
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (context) => ThemeProvider(),
            ),
            ChangeNotifierProvider<AuthProvider>(
              create: (context) => AuthProvider(),
            ),
          ],
          child: MyApp(
            databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
            key: const Key('MyApp'),
          ),
        ),
      );
    },
  );
}
