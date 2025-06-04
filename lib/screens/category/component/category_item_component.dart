import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../utils/constants.dart';
import '../model/category_response.dart';

class CategoryItemWidget extends StatelessWidget {
  final double? width;
  final CategoryData categoryData;

  CategoryItemWidget({this.width, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? context.width() / 3 - 20,
      padding: EdgeInsets.zero,
      decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
      child: Column(
        children: [
          CachedImageWidget(
            url: categoryData.categoryImage.validate(),
            width: width ?? context.width() / 3 - 20,
            height: CATEGORY_ICON_SIZE,
            fit: BoxFit.cover,
            radius: defaultRadius,
          ),
          Marquee(
            directionMarguee: DirectionMarguee.oneDirection,
            child: Text(
              categoryData.name.validate(),
              style: primaryTextStyle(size: 14),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ).paddingSymmetric(vertical: 8, horizontal: 8),
        ],
      ),
    );
  }
}
