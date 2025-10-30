import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:blogspace/core/routes/router.gr.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/core/services/token_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await Future.delayed(const Duration(seconds: 4));
      final tokenService = $sl<TokenStorageService>();
      final hasTokens = await tokenService.hasTokens();

      if (!mounted) return;

      if (hasTokens) {
        context.router.replace(const ProtectedWrapperRoute());
      } else {
        context.router.replace(const AuthRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(Iconsax.note, size: 50)),
            ),
            Gap(12),
            Text(
              "Blog space",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            Text(
              "Your space to create",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
