import 'package:com_joaojsrbr_reader/app/core/constants/app_theme.dart';
import 'package:com_joaojsrbr_reader/app/global_variable.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/stores/favorites_store.dart';
import 'package:com_joaojsrbr_reader/app/stores/historic_store.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final bool isAuthenticated = FirebaseAuth.instance.currentUser != null;
    if (kDebugMode) {
      // debugInvertOversizedImages = true;
      // debugDumpApp();
    }

    return MultiProvider(
      providers: [
        Provider(
          create: (_) => FavoritesStore(),
        ),
        Provider(
          create: (_) => HistoricStore(),
        ),
      ],
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          // ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          if (lightDynamic != null && darkDynamic != null) {
            // darkColorScheme = AppThemeData.darkcolorScheme.harmonized();

            // darkColorScheme = AppThemeData.darkcolorScheme.harmonized();
            darkColorScheme = darkDynamic.harmonized();
          } else {
            darkColorScheme = AppThemeData.darkcolorScheme.harmonized();
          }
          return GetMaterialApp(
            navigatorKey: GlobalVariable.navState,
            key: GlobalVariable.mtAppKey,
            title: 'JReader',
            darkTheme: ThemeData(
              fontFamily: 'Poppins',
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                surfaceTintColor: darkColorScheme.background,
                elevation: 0,
              ),
              scaffoldBackgroundColor: darkColorScheme.background,
              colorScheme: darkColorScheme,
            ),
            themeMode: ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            initialRoute: isAuthenticated ? RoutesName.HOME : RoutesName.LOGIN,
            getPages: AppPages.pages,
          );
        },
      ),
    );
  }
}
