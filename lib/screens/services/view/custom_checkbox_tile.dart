import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frezka/main.dart';
import 'package:frezka/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomCheckboxListTile extends StatelessWidget {
  final bool value;
  final String title;
  final String? imageUrl;
  final bool isDarkMode;
  final Function(bool?) onChanged;
  final double height; // Custom height control

  const CustomCheckboxListTile({
    Key? key,
    required this.value,
    required this.title,
    required this.onChanged,
    this.imageUrl,
    this.isDarkMode = false,
    this.height = 55.0, // Default height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        onChanged(!value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: value?Colors.black26:Colors.transparent
        ),
        height: height, // Control height here
        child: Row(
          children: [
            /*Checkbox(
              value: value,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              activeColor: appStore.isDarkMode ? textPrimaryColorGlobal : secondaryColor,
              side: BorderSide(color: textSecondaryColorGlobal),
              onChanged: onChanged,
            ),*/
            imageUrl != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 25,
                height: 25,
                fit: BoxFit.cover,
              ),
            )
                : Icon(Icons.category, size: 25, color: !value?Colors.white: context.iconColor),
            SizedBox(width: 10,),
            Expanded(
              child: Text(
                title,
                  style: boldTextStyle(
                      color: !value?Colors.white:appStore.isDarkMode ? textPrimaryColorGlobal : secondaryColor,
                      size: 12
                  )
              ),
            ),
            //Icon(Icons.arrow_forward_ios,size: 16,color:  value?Colors.white:Colors.black)
          ],
        ),
      ),
    );
  }
}
