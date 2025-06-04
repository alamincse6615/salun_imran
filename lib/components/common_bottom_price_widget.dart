import 'package:flutter/material.dart';
import 'package:frezka/components/price_widget.dart';
import 'package:frezka/utils/colors.dart';
import 'package:frezka/utils/extensions/num_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class CommonBottomPriceWidget extends StatelessWidget {
  final String? title;
  final num? price;
  final String? buttonText;
  final Function? onTap;

  CommonBottomPriceWidget({this.title, this.price, this.buttonText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return !bookingRequestStore.isCouponApplied
        ? Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: secondaryColor, borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Marquee(child: Text(title.validate(), style: boldTextStyle(size: 14, color: Colors.white))),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PriceWidget(price: price.validate(), color: Colors.white),
                        8.width,
                        bookingRequestStore.totalTax != 0
                            ? Marquee(
                                child: Text(
                                  '(${bookingRequestStore.totalTax.toPriceFormat()} ${locale.taxIncluded})',
                                  style: primaryTextStyle(color: Colors.white70),
                                ),
                              ).expand()
                            : Offstage(),
                      ],
                    ),
                  ],
                ).expand(),
                16.width,
                AppButton(
                  color: Colors.white,
                  child: Text(buttonText.validate(), style: boldTextStyle(color: Colors.black)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  onTap: onTap,
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: secondaryColor, borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${locale.subtotal} :- ', style: secondaryTextStyle(size: 12, color: Colors.white)),
                        8.width,
                        PriceWidget(price: price.validate(), color: Colors.white, size: 12),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${locale.couponDiscount} :- ', style: secondaryTextStyle(size: 12, color: Colors.white)),
                        8.width,
                        Row(
                          children: [
                            PriceWidget(price: bookingRequestStore.finalDiscountCouponAmount.validate(), isDiscountedPrice: true, size: 12),
                            8.width,
                            if (!bookingRequestStore.isFixedDiscountCoupon)
                              Marquee(
                                child: Text(
                                  '(${bookingRequestStore.couponDiscountPercentage} %)',
                                  style: secondaryTextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${locale.total} :- ', style: secondaryTextStyle(size: 14, color: Colors.white)),
                        8.width,
                        PriceWidget(price: bookingRequestStore.calculateTotalAmountWithCouponAndTaxAndTip.validate(), color: Colors.white, size: 16),
                        8.width,
                        bookingRequestStore.totalTax != 0
                            ? Marquee(
                                child: Text(
                                  '(${bookingRequestStore.totalTax.toPriceFormat()} ${locale.taxIncluded})',
                                  style: primaryTextStyle(color: Colors.white70),
                                ),
                              ).expand()
                            : Offstage(),
                      ],
                    ),
                  ],
                ).expand(),
                16.width,
                AppButton(
                  color: Colors.white,
                  child: Text(buttonText.validate(), style: boldTextStyle(color: Colors.black)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  onTap: onTap,
                ),
              ],
            ),
          );
  }
}
