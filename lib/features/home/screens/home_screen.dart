import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtiwy/core/helpers/spacing.dart';

import 'package:shtiwy/core/routes/routes.dart';
import 'package:shtiwy/core/utils/app_sizes.dart';
import 'package:shtiwy/core/widgets/loading_overlay.dart';

import 'package:shtiwy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shtiwy/features/auth/presentation/cubit/auth_state.dart';
import 'package:shtiwy/features/booking/screens/booking_screen.dart';
import 'package:shtiwy/features/home/screens/nav_bar.dart';
import 'package:shtiwy/features/packages/presentation/screens/packedge_screen.dart';

import 'package:shtiwy/features/settings/presentation/screens/settings_screen.dart';

import 'package:shtiwy/features/home/widgets/category_row.dart';
import 'package:shtiwy/features/home/widgets/hero_header.dart';
import 'package:shtiwy/features/home/widgets/latest_offer_header.dart';
import 'package:shtiwy/features/home/widgets/offer_card.dart';
import 'package:shtiwy/features/home/widgets/secondary_offer_card.dart';
import 'package:shtiwy/core/widgets/app_header.dart';
import 'package:url_launcher/url_launcher.dart'
    show canLaunchUrl, launchUrl, LaunchMode;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Future<void> openWhatsApp() async {
    final Uri url = Uri.parse(
      'https://wa.me/201003300351?text=${Uri.encodeComponent("السلام عليكم، أريد الاستفسار عن الرحلات المتاحة")}',
    );

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  /// Height the floating navbar occupies so content can pad accordingly.
  static const double _navBarHeight =
      88; // 64.h pill + 12.h bottom margin + 12 top buffer

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'errors.unexpected_error'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (!state.isAuthenticated && !state.isLoading) {
          Navigator.of(context).pushReplacementNamed(Routes.splash);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: Scaffold(
            // No bottomNavigationBar — navbar floats inside body Stack
            body: SafeArea(
              child: Stack(
                children: [
                  // ── Tab content — padded so last items clear the navbar ──
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: _navBarHeight),
                      child: Stack(
                        children: [
                          Offstage(
                            offstage: _currentIndex != 0,
                            child: _HomeView(userName: state.user?.name),
                          ),
                          Offstage(
                            offstage: _currentIndex != 1,
                            child: PackageScreen(),
                          ),
                          Offstage(
                            offstage: _currentIndex != 2,
                            child: BookingsScreen(),
                          ),
                          Offstage(
                            offstage: _currentIndex != 3,
                            child: SettingsScreen(embedded: true),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Floating navbar overlapping the content ──────────────
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: CustomBottomNavBar(
                      currentIndex: _currentIndex,
                      onTap: (index) => setState(() => _currentIndex = index),
                    ),
                  ),

                  // ── WhatsApp FAB (home tab only) ─────────────────────────
                  // Home tab is the FIRST item → leftmost in LTR, rightmost in RTL.
                  // FAB must go on the OPPOSITE end so they never overlap.
                  if (_currentIndex == 0)
                    Builder(
                      builder: (context) {
                        final isRtl =
                            Directionality.of(context) == TextDirection.LTR;
                        return Positioned(
                          bottom: _navBarHeight + 15,
                          // LTR → FAB on right; RTL → FAB on left
                          left: isRtl ? 20 : null,
                          right: isRtl ? null : 20,
                          child: FloatingActionButton(
                            heroTag: 'whatsapp_fab',
                            onPressed: openWhatsApp,
                            backgroundColor: const Color(0xFF25D366),
                            child: const Icon(Icons.chat, color: Colors.white),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HomeView extends StatelessWidget {
  final String? userName;

  const _HomeView({this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.screenPadding8),
      child: Column(
        children: [
          buildHeader(context),

          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              cacheExtent: 300,
              children: [
                buildHeroBanner(context),
                verticalSpace(16),

                buildCategoryRow(context),

                verticalSpace(10),

                buildLatestOffersHeader(context),

                verticalSpace(10),

                buildFeaturedOfferCard(context),

                verticalSpace(20),

                buildSecondaryOffersRow(context),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
