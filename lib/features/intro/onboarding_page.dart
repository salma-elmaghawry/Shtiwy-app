import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/core/injection/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/resources/app_images.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  double _page = 0.0;

  final List<String> _images = [
    AppImages.onboard1,
    AppImages.onboard2,
    AppImages.onboard3,
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _page = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    final nextPage = (_pageController.page ?? 0).toInt() + 1;
    if (nextPage < 3) {
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    } else {
      // mark onboarding as seen and continue to splash so splash handles auth flow
      final prefs = getIt<SharedPreferences>();
      prefs.setBool('onboarding_seen', true);
      Navigator.of(context).pushReplacementNamed(Routes.splash);
    }
  }

  void _skip() {
    // mark onboarding as seen and continue to splash
    final prefs = getIt<SharedPreferences>();
    prefs.setBool('onboarding_seen', true);
    Navigator.of(context).pushReplacementNamed(Routes.splash);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skip,
                child: Text('onboarding.skip'.tr()),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (context, index) {
                  final delta = (_page - index).abs();
                  // scale and translate based on page position
                  final scale = 1.0 - (delta * 0.15).clamp(0.0, 0.15);
                  final translateY = (delta * 40).clamp(0.0, 40.0);

                  final title = 'onboarding.screen${index + 1}.title'.tr();
                  final desc = 'onboarding.screen${index + 1}.desc'.tr();

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.l24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: AppSizes.s8),
                        Transform.translate(
                          offset: Offset(0, translateY),
                          child: Transform.scale(
                            scale: scale,
                            child: Image.asset(
                              _images[index],
                              height: MediaQuery.of(context).size.height * 0.36,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.l24),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: AppSizes.m16),
                        Text(
                          desc,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.l24,
                vertical: AppSizes.m16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(3, (i) {
                      final selected = (_page - i).abs() < 0.5;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: selected ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: selected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  ElevatedButton(
                    onPressed: _next,
                    child: Text(
                      (_page.round() == 2)
                          ? 'onboarding.get_started'.tr()
                          : 'onboarding.next'.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
