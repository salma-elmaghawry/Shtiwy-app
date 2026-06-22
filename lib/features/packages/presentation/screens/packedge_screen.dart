import 'package:flutter/material.dart';
import 'package:shtiwy/core/resources/app_images.dart';
import 'package:shtiwy/core/widgets/app_header.dart';
import 'package:shtiwy/features/home/widgets/small_offer_card.dart';

class PackageScreen extends StatelessWidget {
  const PackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildHeader(context),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return buildSmallOfferCard(
                        context,
                        title: 'Package 1',
                        price: '\$1000',
                        date: '2024-12-01',
                        imageUrl: AppImages.Umrah1,
                      );
                    case 1:
                      return buildSmallOfferCard(
                        context,
                        title: 'Package 2',
                        price: '\$1500',
                        date: '2024-12-15',
                        imageUrl: AppImages.Umrah2,
                      );
                    case 2:
                      return buildSmallOfferCard(
                        context,
                        title: 'Package 3',
                        price: '\$2000',
                        date: '2025-01-10',
                        imageUrl: AppImages.hotel1,
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
