import 'package:auto_route/auto_route.dart';
import 'package:blogspace/core/routes/router.gr.dart';
import 'package:blogspace/core/services/sl_service.dart';
import 'package:blogspace/features/onboarding/services/onboarding_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@RoutePage()
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Your Voice, Your Space',
      description:
          'Start your own blog to enhance and share your unique ideas with the world.',
      imagePath: 'assets/onboarding1.png', // Illustration of person with laptop
      backgroundColor: Colors.white,
      buttonText: 'Next',
      showSkip: true,
    ),
    OnboardingData(
      title: 'Discover & Connect',
      description:
          'Connect with a vibrant community of readers and writers. Share ideas and find new perspectives.',
      imagePath: 'assets/onboarding2.png', // Social icons illustration
      backgroundColor: const Color(0xFFFDB94E),
      buttonText: 'Next',
      showSkip: true,
    ),
    OnboardingData(
      title: 'Start Your Creative Journey',
      description: 'Join now to start creating, reading, and connecting.',
      imagePath: 'assets/onboarding3.png', // Laptop on desk
      backgroundColor: Colors.white,
      buttonText: 'Get Started',
      showSkip: false,
      showLogin: true,
    ),
  ];

  void _onNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      $sl.get<OnboardingStorageService>().saveOnboardingPassed(true);
      context.router.replace(AuthRoute());
    }
  }

  void _onSkipPressed() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            return _buildPage(_pages[index]);
          },
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Container(
      color: data.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header with title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Onboarding Screen',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Image/Illustration placeholder
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 300),
                  decoration: BoxDecoration(
                    color: data.backgroundColor == Colors.white
                        ? Colors.grey[100]
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      _getIconForPage(),
                      size: 120,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Title
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              data.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),

            const Spacer(),

            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFF3B82F6)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Column(
              children: [
                ShadButton(
                  onPressed: _onNextPressed,
                  width: double.infinity,
                  backgroundColor: data.buttonText == 'Get Started'
                      ? const Color(0xFFFF7A59)
                      : const Color(0xFF3B82F6),
                  child: Text(
                    data.buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                if (data.showSkip || data.showLogin) const SizedBox(height: 16),

                if (data.showSkip)
                  ShadButton.outline(
                    onPressed: _onSkipPressed,
                    width: double.infinity,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),

                if (data.showLogin)
                  ShadButton.ghost(
                    onPressed: () {
                      context.router.replace(AuthRoute());
                    },
                    width: double.infinity,
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  IconData _getIconForPage() {
    switch (_currentPage) {
      case 0:
        return Icons.person_outline;
      case 1:
        return Icons.share_outlined;
      case 2:
        return Icons.laptop_outlined;
      default:
        return Icons.star_outline;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final String buttonText;
  final bool showSkip;
  final bool showLogin;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.buttonText,
    this.showSkip = false,
    this.showLogin = false,
  });
}
