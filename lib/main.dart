import 'package:blogspace/core/routes/router.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() async {
  await setupServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = $sl.get<AppRouter>();
  @override
  Widget build(BuildContext context) {
    return ShadApp.router(
      routerConfig: router.config(),
      theme: ShadThemeData(
        colorScheme: ShadStoneColorScheme.dark(),
        textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.poppins)
      ),
    );
  }
}
