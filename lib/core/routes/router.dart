import 'package:auto_route/auto_route.dart';
import 'package:blogspace/core/routes/auth_guard.dart';
import 'package:blogspace/core/routes/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: AuthRoute.page),
    AutoRoute(
      page: ProtectedWrapperRoute.page,
      guards: [AuthGuard()],
      children: [
        AutoRoute(page: BlogCreationRoute.page),
        AutoRoute(page: BlogDetailRoute.page),
        AutoRoute(page: BlogsRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
  ];
}
