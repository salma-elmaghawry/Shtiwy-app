import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shtiwy/core/routes/routes.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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
            body: SafeArea(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _HomeView(userName: state.user?.name),

                  PackageScreen(),

                  BookingsScreen(),

                  SettingsScreen(embedded: true),
                ],
              ),
            ),

            floatingActionButton: _currentIndex == 0
                ? FloatingActionButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('جاري الاتصال عبر واتساب...'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    backgroundColor: const Color(0xFF25D366),
                    child: const Icon(Icons.chat, color: Colors.white),
                  )
                : null,

            floatingActionButtonLocation: context.locale.languageCode == 'ar'
                ? FloatingActionButtonLocation.endFloat
                : FloatingActionButtonLocation.startFloat,

            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
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
    return Column(
      children: [
        buildHeader(context),

        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              buildHeroBanner(context),

              buildCategoryRow(context),

              buildLatestOffersHeader(context),

              buildFeaturedOfferCard(context),

              buildSecondaryOffersRow(context),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
