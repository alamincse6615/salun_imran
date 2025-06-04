import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frezka/components/app_scaffold.dart';
import 'package:frezka/screens/category/component/category_item_component.dart';
import 'package:frezka/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/empty_error_state_widget.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../services/view/view_all_service_screen.dart';
import '../category_repository.dart';
import '../model/category_response.dart';
import '../shimmer/category_shimmer.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  UniqueKey key = UniqueKey();

  Future<List<CategoryData>>? future;

  List<CategoryData> categoryList = [];

  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getCategoryList(
      page: page,
      list: categoryList,
      isStoreCached: true,
      lastPageCallBack: (val) {
        isLastPage = val;
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarWidget: commonAppBarWidget(
        context,
        title: locale.ourCategory,
        appBarHeight: 70,
        roundCornerShape: true,
        showLeadingIcon: Navigator.canPop(context),
      ),
      body: Stack(
        children: [
          SnapHelperWidget<List<CategoryData>>(
            future: future,
            initialData: categoryListCached,
            loadingWidget: CategoryShimmer(),
            onSuccess: (list) {
              if (list.isEmpty) {
                return NoDataWidget(
                  title: locale.noCategoryFound,
                  retryText: locale.reload,
                  onRetry: () {
                    page = 1;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  },
                );
              }

              return AnimatedScrollView(
                onSwipeRefresh: () async {
                  page = 1;

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                physics: AlwaysScrollableScrollPhysics(),
                listAnimationType: ListAnimationType.Scale,
                padding: EdgeInsets.all(16),
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  }
                },
                children: [
                  AnimatedWrap(
                    key: key,
                    runSpacing: 16,
                    spacing: 16,
                    itemCount: list.length,
                    listAnimationType: ListAnimationType.Scale,
                    scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
                    itemBuilder: (_, index) {
                      CategoryData? data = list[index];
                      return GestureDetector(
                        onTap: () {
                          ViewAllServiceScreen(categoryData: data,serviceTitle: data.name.validate(), categoryId: data.id.validate()).launch(context);
                        },
                        child: CategoryItemWidget(categoryData: data, width: context.width() / 3 - 22),
                      );
                    },
                  ),
                ],
              );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.reload,
                imageWidget: ErrorStateWidget(),
                onRetry: () {
                  page = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                },
              );
            },
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
