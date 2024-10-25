import 'package:clezigov/utils/utility_functions.dart';
import 'package:clezigov/views/screens/auth/forgot%20password/email_verification.dart';
import 'package:clezigov/views/screens/auth/forgot%20password/forgot_password.dart';
import 'package:clezigov/views/screens/auth/forgot%20password/reset_password.dart';
import 'package:clezigov/views/screens/auth/login/login.dart';
import 'package:clezigov/views/screens/auth/register/account_setup.dart';
import 'package:clezigov/views/screens/auth/register/points_of_interests.dart';
import 'package:clezigov/views/screens/home/home.dart';
import 'package:clezigov/views/screens/home/procedure_details.dart';
import 'package:clezigov/views/screens/home/profile_details.dart';
import 'package:clezigov/views/screens/home/verify_account.dart';
import 'package:clezigov/views/screens/onboarding.dart';
import 'package:clezigov/views/screens/settings/appearance.dart';
import 'package:clezigov/views/screens/settings/community_activity.dart';
import 'package:clezigov/views/screens/settings/notifications.dart';
import 'package:clezigov/views/widgets/home_feeds/procedures/agent_request.dart';
import 'package:clezigov/views/widgets/home_feeds/procedures/procedures_add.dart';
import 'package:clezigov/views/widgets/home_feeds/procedures/todo_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

import '../controllers/auth_controller.dart';
import '../views/screens/auth/register/user_registration.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final AuthController authController = Get.find<AuthController>();
final GetStorage storage = GetStorage();

final GoRouter router = GoRouter(
  // initialLocation: OnboardPage.routeName,
  // if user is signed in, redirect to home page
  // else if user is not signed in and has not completed onboarding, redirect to onboarding page
  // else if user is not signed in and has completed onboarding, redirect to login page
  initialLocation: authController.isUserSignedIn()
      ? HomePage.routeName
      : storage.read('hasOnboarded') == true
          ? LoginPage.routeName
          : OnboardPage.routeName,
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: OnboardPage.routeName,
      name: removeBeginningSlash(OnboardPage.routeName),
      builder: (context, state) => const OnboardPage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: LoginPage.routeName,
      name: removeBeginningSlash(LoginPage.routeName),
      builder: (context, state) => const LoginPage(),
    ),
    // Forgot password route
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: ForgotPasswordPage.routeName,
      name: removeBeginningSlash(ForgotPasswordPage.routeName),
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: EmailVerificationPage.routeName,
      name: removeBeginningSlash(EmailVerificationPage.routeName),
      builder: (context, state) {
        Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return EmailVerificationPage(
        email: extra['email'],
      );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: ResetPasswordPage.routeName,
      name: removeBeginningSlash(ResetPasswordPage.routeName),
      builder: (context, state) => const ResetPasswordPage(),
    ),
    // Registration routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: UserRegistrationPage.routeName,
      name: removeBeginningSlash(UserRegistrationPage.routeName),
      builder: (context, state) => const UserRegistrationPage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AccountSetup.routeName,
      name: removeBeginningSlash(AccountSetup.routeName),
      builder: (context, state) => const AccountSetup(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: PointsOfInterestsPage.routeName,
      name: removeBeginningSlash(PointsOfInterestsPage.routeName),
      builder: (context, state) => const PointsOfInterestsPage(),
    ),
    // Home page routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: HomePage.routeName,
      name: "home",
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: ProcedureAddPage.routeName,
      name: removeBeginningSlash(ProcedureAddPage.routeName),
      builder: (context, state) => const ProcedureAddPage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: ProfileDetailsPage.routeName,
      name: removeBeginningSlash(ProfileDetailsPage.routeName),
      builder: (context, state) {
        Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return ProfileDetailsPage(
          imageColor: extra['imageColor'],
          image: extra['image'],
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: VerifyAccountPage.routeName,
      name: removeBeginningSlash(VerifyAccountPage.routeName),
      builder: (context, state) => const VerifyAccountPage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppearancePage.routeName,
      name: removeBeginningSlash(AppearancePage.routeName),
      builder: (context, state) => const AppearancePage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: NotificationsPage.routeName,
      name: removeBeginningSlash(NotificationsPage.routeName),
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: CommunityActivityPage.routeName,
      name: removeBeginningSlash(CommunityActivityPage.routeName),
      builder: (context, state) => const CommunityActivityPage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: "${ProcedureDetailsPage.routeName}/:id",
      name: removeBeginningSlash(ProcedureDetailsPage.routeName),
      builder: (context, state) {
        // Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return ProcedureDetailsPage(
          key: state.pageKey,
          procedureId: state.pathParameters['id']!,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AgentPage.routeName,
      name: removeBeginningSlash(AgentPage.routeName),
      builder: (context, state) => const AgentPage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: "${TodoModePage.routeName}/:id",
      name: removeBeginningSlash(TodoModePage.routeName),
      builder: (context, state) {
        return TodoModePage(
          key: state.pageKey,
          procedureId: state.pathParameters['id']!,
        );
      },
    ),
  ],
);

// Extension to push routes
extension GoRouteExtension on BuildContext {
  goPush<T>(String route) =>
      kIsWeb ? GoRouter.of(this).go(route) : GoRouter.of(this).push(route);
}
