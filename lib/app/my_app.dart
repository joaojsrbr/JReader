import 'package:com_joaojsrbr_reader/app/core/constants/app_theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/stores/favorites_store.dart';
import 'package:com_joaojsrbr_reader/app/stores/historic_store.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated = FirebaseAuth.instance.currentUser != null;
    if (kDebugMode) {
      debugInvertOversizedImages = true;
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
            // lightColorScheme = lightDynamic.harmonized();

            darkColorScheme = darkDynamic.harmonized();
            // darkColorScheme = CustomTheme.colorScheme;
          } else {
            // lightColorScheme = RootCor().lightColorScheme;
            darkColorScheme = AppThemeData.darkcolorScheme;
          }
          return GetMaterialApp(
            defaultTransition: Transition.fadeIn,
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
