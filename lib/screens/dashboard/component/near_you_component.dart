import 'package:flutter/material.dart';
import 'package:frezka/components/view_all_label_component.dart';
import 'package:frezka/screens/branch/view/branch_list_screen.dart';
import 'package:frezka/screens/dashboard/component/branch_item_component.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../branch/branch_repository.dart';
import '../../branch/model/branch_response.dart';
import '../../branch/view/branch_detail_screen.dart';

class NearYouComponent extends StatefulWidget {
  final String? title;

  NearYouComponent({required this.title, Key? key}) : super(key: key);

  @override
  _NearYouComponentState createState() => _NearYouComponentState();
}

class _NearYouComponentState extends State<NearYouComponent> {
  PageController controller = PageController(keepPage: true, initialPage: 0);

  Future<List<BranchData>>? future;

  List<BranchData> branchList = [];

  int page = 1;

  Position? currentLocation;

  @override
  void initState() {
    super.initState();
    init();
    getLocation();
  }

  void init() async {
    future = getBranchList(page: page, branchList: branchList);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void getLocation() {
    Geolocator.requestPermission().then((value) {
      if (value == LocationPermission.whileInUse || value == LocationPermission.always) {
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {
          currentLocation = value;
          setState(() {});
        }).catchError(onError);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BranchData>>(
      future: future,
      initialData: branchListCached,
      builder: (context, snap) {
        if (snap.data.validate().isEmpty) return Offstage();

        if (snap.hasData) {
          return Column(
            children: [
              ViewAllLabel(
                label: widget.title.validate(),
                list: snap.data,
                onTap: () {
                  BranchListScreen(position: currentLocation).launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              HorizontalList(
                controller: controller,
                itemCount: snap.data.validate().length,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                crossAxisAlignment: WrapCrossAlignment.start,
                itemBuilder: (context, i) {
                  BranchData branchData = snap.data![i];

                  if (branchData.id == appStore.branchId) return Offstage();

                  return Container(
                    width: context.width() * 0.85,
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius()),
                    margin: EdgeInsets.only(right: 8),
                    child: BranchItemComponent(branchData: branchData, position: currentLocation),
                  ).onTap(() {
                    BranchDetailScreen(branchId: branchData.id.validate()).launch(context);
                  }, borderRadius: radius(), splashColor: Colors.transparent, highlightColor: Colors.transparent);
                },
              ),
            ],
          );
        }

        return snapWidgetHelper(
          snap,
          loadingWidget: Offstage(),
          errorBuilder: (error) {
            return Offstage();
          },
        );
      },
    );
  }
}
