import 'package:A.N.R/app/core/themes/colors.dart';
import 'package:A.N.R/app/routes/routes.dart';
import 'package:A.N.R/app/store/favorites_store.dart';
import 'package:A.N.R/app/store/historic_store.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:A.N.R/app/initialBinding/Initial_binding.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated = FirebaseAuth.instance.currentUser != null;
    if (kDebugMode) {
      debugInvertOversizedImages = true;
    }

    return MultiProvider(
      providers: [
        Provider(create: (_) => FavoritesStore()),
        Provider(create: (_) => HistoricStore()),
      ],
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          // ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          if (lightDynamic != null && darkDynamic != null) {
            // lightColorScheme = lightDynamic.harmonized();

            darkColorScheme = darkDynamic.harmonized();
          } else {
            // lightColorScheme = RootCor().lightColorScheme;
            darkColorScheme = ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: CustomColors.primary,
              background: CustomColors.background,
            );
          }
          return GetMaterialApp(
            title: 'A.N.R',
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
            // darkTheme: CustomTheme.dark,
            debugShowCheckedModeBanner: false,
            initialRoute: isAuthenticated ? RoutesName.HOME : RoutesName.LOGIN,
            getPages: AppPages.pages,
            initialBinding: InitialBinding(),
          );
        },
      ),
    );
  }
}
