import 'package:auto_route/auto_route.dart';
import 'package:blogspace/features/auth/notifers/auth_controller.dart';
import 'package:blogspace/features/profile/notifers/profile_notifier.dart';
import 'package:blogspace/shared/dialog.dart';
import 'package:blogspace/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(profileNotiferProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showConfirmationDialog(
                context: context,
                title: "Logout",
                content: "Do you want to logout",
                onConfirm: () {
                  ref.read(authNotifierProvider.notifier).logout();
                },
              );
            },
            icon: Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => LoadingWidget(),
        error: (err, stack) => Center(
          child: Text(
            'Something went wrong\n$err',
            textAlign: TextAlign.center,
          ),
        ),
        data: (user) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  CircleAvatar(
                    radius: 50,
                    child: Text(
                      user.username![0].toUpperCase(),
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    user.username!,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
