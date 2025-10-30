// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:blogspace/core/routes/protected_route.dart' as _i7;
import 'package:blogspace/features/auth/views/auth_screen.dart' as _i1;
import 'package:blogspace/features/blog/views/blog_creation_screen.dart' as _i2;
import 'package:blogspace/features/blog/views/blog_detail_screen.dart' as _i3;
import 'package:blogspace/features/blog/views/blogs_screen.dart' as _i4;
import 'package:blogspace/features/onboarding/views/onboarding_screen.dart'
    as _i5;
import 'package:blogspace/features/profile/views/profile_screen.dart' as _i6;
import 'package:blogspace/features/splash_screen.dart' as _i8;

/// generated route for
/// [_i1.AuthScreen]
class AuthRoute extends _i9.PageRouteInfo<void> {
  const AuthRoute({List<_i9.PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthScreen();
    },
  );
}

/// generated route for
/// [_i2.BlogCreationScreen]
class BlogCreationRoute extends _i9.PageRouteInfo<void> {
  const BlogCreationRoute({List<_i9.PageRouteInfo>? children})
    : super(BlogCreationRoute.name, initialChildren: children);

  static const String name = 'BlogCreationRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.BlogCreationScreen();
    },
  );
}

/// generated route for
/// [_i3.BlogDetailScreen]
class BlogDetailRoute extends _i9.PageRouteInfo<void> {
  const BlogDetailRoute({List<_i9.PageRouteInfo>? children})
    : super(BlogDetailRoute.name, initialChildren: children);

  static const String name = 'BlogDetailRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i3.BlogDetailScreen();
    },
  );
}

/// generated route for
/// [_i4.BlogsScreen]
class BlogsRoute extends _i9.PageRouteInfo<void> {
  const BlogsRoute({List<_i9.PageRouteInfo>? children})
    : super(BlogsRoute.name, initialChildren: children);

  static const String name = 'BlogsRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i4.BlogsScreen();
    },
  );
}

/// generated route for
/// [_i5.OnboardingScreen]
class OnboardingRoute extends _i9.PageRouteInfo<void> {
  const OnboardingRoute({List<_i9.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i5.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i6.ProfileScreen]
class ProfileRoute extends _i9.PageRouteInfo<void> {
  const ProfileRoute({List<_i9.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i6.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i7.ProtectedWrapperPage]
class ProtectedWrapperRoute extends _i9.PageRouteInfo<void> {
  const ProtectedWrapperRoute({List<_i9.PageRouteInfo>? children})
    : super(ProtectedWrapperRoute.name, initialChildren: children);

  static const String name = 'ProtectedWrapperRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i7.ProtectedWrapperPage();
    },
  );
}

/// generated route for
/// [_i8.SplashScreen]
class SplashRoute extends _i9.PageRouteInfo<void> {
  const SplashRoute({List<_i9.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.SplashScreen();
    },
  );
}
