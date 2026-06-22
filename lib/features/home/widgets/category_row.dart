 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shtiwy/features/home/widgets/category_card.dart';

Widget buildCategoryRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCategoryCard(context, Icons.mosque, 'home.hajj_offers'.tr()),
          buildCategoryCard(
            context,
            Icons.brightness_3,
            'home.umrah_trips'.tr(),
          ),
          buildCategoryCard(
            context,
            Icons.explore_outlined,
            'home.external_tourism'.tr(),
          ),
        ],
      ),
    );
  }
