import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safetracker/bindings/general_bindings.dart';
import 'package:safetracker/routes/app_routes.dart';
import 'package:safetracker/routes/routes.dart';
import 'package:safetracker/utils/constants/colors.dart';
import 'package:safetracker/utils/constants/text_strings.dart';
import 'package:safetracker/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: STexts.appName,
      theme: SAppTheme.lightTheme,
      themeMode: ThemeMode.system,
      darkTheme: SAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(),
      initialRoute: SRoutes.homeMenu,
      getPages: AppRoutes.pages,
      unknownRoute: GetPage(
        name: '/page not found',
        page: () => const Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        ),
      ),
      /// Show Loader or Circular Progress Indicator meanwhile Authentication Repository is deciding to show relevant screen.
      home: const Scaffold(backgroundColor: SColors.primary, body: Center(child: CircularProgressIndicator(color: Colors.white))),
    );
  }
}