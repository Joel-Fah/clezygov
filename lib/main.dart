import 'package:clezigov/controllers/auth_controller.dart';
import 'package:clezigov/controllers/bookmarks_controller.dart';
import 'package:clezigov/controllers/clezy_controller.dart';
import 'package:clezigov/controllers/notifications_controller.dart';
import 'package:clezigov/controllers/procedures_controller.dart';
import 'package:clezigov/controllers/profile_page_controller.dart';
import 'package:clezigov/controllers/reactions_controller.dart';
import 'package:clezigov/controllers/select_categories_controller.dart';
import 'package:clezigov/utils/app_theme.dart';
import 'package:clezigov/utils/constants.dart';
import 'package:clezigov/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'controllers/endorsements_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  // Initialise Firebase options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize GetStorage
  await GetStorage.init();

  // Set color of status bar to scaffold bg
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: scaffoldBgColor.withOpacity(0),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: scaffoldBgColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Lock device orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    // GetX Controllers
    Get.put(InterestsController());
    Get.put(BookmarksController());
    Get.put(NotificationsController());
    Get.put(EndorsementsController());
    Get.put(ReactionsController());
    Get.put(ProceduresController());
    Get.put(ProfilePageController());
    Get.put(AuthController());
    Get.put(ClezyController());

    return GetMaterialApp.router(
      title: 'CleziGov',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
