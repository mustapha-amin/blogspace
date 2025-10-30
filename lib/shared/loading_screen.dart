import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true),
      body: Center(
        child: SpinKitWaveSpinner(
          color: ShadTheme.of(context).primaryButtonTheme.backgroundColor!,
          size: 80,
        ),
      ),
    );
  }
}
