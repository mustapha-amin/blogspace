import 'package:auto_route/auto_route.dart';
import 'package:blogspace/core/routes/router.gr.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/core/services/token_storage_service.dart';

class AuthGuard extends AutoRouteGuard {

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final hasToken = await $sl.get<TokenStorageService>().hasTokens();

    if (hasToken) {
      resolver.next();
    } else {
      router.push(const AuthRoute());
    }
  }
}
