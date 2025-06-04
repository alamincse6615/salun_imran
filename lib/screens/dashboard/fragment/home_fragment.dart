import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frezka/components/app_scaffold.dart';
import 'package:frezka/components/loader_widget.dart';
import 'package:frezka/network/rest_apis.dart';
import 'package:frezka/screens/booking/component/quick_book_component.dart';
import 'package:frezka/screens/dashboard/component/category_component.dart';
import 'package:frezka/screens/dashboard/component/common_app_component.dart';
import 'package:frezka/screens/dashboard/component/dashboard_appbar_component.dart';
import 'package:frezka/screens/dashboard/component/horizontal_slider_component.dart';
import 'package:frezka/screens/dashboard/component/near_you_component.dart';
import 'package:frezka/screens/dashboard/component/top_experts_component.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/empty_error_state_widget.dart';
import '../../../main.dart';
import '../../auth/auth_repository.dart';
import '../../services/view/view_all_service_screen.dart';
import '../dashboard_repository.dart';
import '../models/dashboard_model.dart';
import '../shimmer/dashboard_shimmer.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  UniqueKey keyForBranchList = UniqueKey();
  Future<DashboardResponse>? future;

  @override
  void initState() {
    super.initState();
    init();
    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
    });

    1.seconds.delay.then((value) {
      if (appStore.isLoggedIn) {
        viewProfile().then((value) {
          //
        }).catchError(onError);
      }
    });
  }

  void init() async {
    future = userDashboard(branchId: appStore.branchId);

    if (appConfigurationResponseCached == null) {
      try{
        getAppConfigurations();
      }catch(e){
        print(e.toString());
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: Stack(
        children: [
          SnapHelperWidget<DashboardResponse>(
            future: future,
            initialData: dashboardResponseCached,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.reload,
                imageWidget: ErrorStateWidget(),
                onRetry: () {
                  appStore.setLoading(true);

                  init();
                  onQuickBookingDataUpdate?.call();
                  keyForBranchList = UniqueKey();
                  setState(() {});
                },
              );
            },
            loadingWidget: DashboardShimmer(),
            onSuccess: (snap) {
              return CommonAppComponent(
                innerWidget: DashboardAppBarComponent(
                  hintText: locale.searchForServices,
                  onTapSearch: () {
                    hideKeyboard(context);
                    ViewAllServiceScreen(serviceTitle: locale.searchServices).launch(context);
                  },
                ),
                mainWidgetHeight: 190,
                onSwipeRefresh: () async {
                  init();
                  onQuickBookingDataUpdate?.call();
                  keyForBranchList = UniqueKey();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                subWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Quick Book Appointment
                    /*QuickBookingComponent(
                      serviceListData: snap.data!.service.validate(),
                      callback: () {
                        init();
                        setState(() {});
                      },
                    ),*/

                    16.height,
                    /// Horizontal
                    HorizontalSliderComponent(sliderList: snap.data!.sliderData.validate()),
                    ///Category List
                    CategoryComponent(categoryList: snap.data!.category),



                    /// Experts
                   // TopExpertsComponent(topExpertList: snap.data!.topExperts.validate()),

                    /// Near You
                   // NearYouComponent(title: locale.nearbyBranches, key: keyForBranchList),
                  ],
                ).paddingOnly(top: context.statusBarHeight + 24),
              );
            },
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
