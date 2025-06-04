import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frezka/components/app_scaffold.dart';
import 'package:frezka/components/cached_image_widget.dart';
import 'package:frezka/components/common_bottom_price_widget.dart';
import 'package:frezka/components/dotted_line.dart';
import 'package:frezka/components/loader_widget.dart';
import 'package:frezka/components/view_all_label_component.dart';
import 'package:frezka/main.dart';
import 'package:frezka/screens/booking/model/booking_request_model.dart';
import 'package:frezka/screens/booking/view/booking_screen.dart';
import 'package:frezka/screens/dashboard/component/common_app_component.dart';
import 'package:frezka/screens/dashboard/component/dashboard_appbar_component.dart';
import 'package:frezka/screens/experts/model/employee_detail_response.dart';
import 'package:frezka/screens/services/view/custom_checkbox_tile.dart';
import 'package:frezka/screens/services/view/custom_toolbar_shape.dart';
import 'package:frezka/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/empty_error_state_widget.dart';
import '../../../utils/common_base.dart';
import '../../category/category_repository.dart';
import '../../category/component/category_item_component.dart';
import '../../category/model/category_response.dart';
import '../component/services_info_list_component.dart';
import '../models/service_response.dart';
import '../service_repository.dart';
import '../shimmer/view_all_service_shimmer.dart';

class ViewAllServiceScreenWithMultiCatSelect extends StatefulWidget {
  final String serviceTitle;
  final String search;
  final int? categoryId;
  final CategoryData? categoryData;

  ViewAllServiceScreenWithMultiCatSelect(
      {required this.serviceTitle, this.categoryId, this.search = "",this.categoryData});

  @override
  _ViewAllServiceScreenWithMultiCatSelectState createState() => _ViewAllServiceScreenWithMultiCatSelectState();
}

class _ViewAllServiceScreenWithMultiCatSelectState extends State<ViewAllServiceScreenWithMultiCatSelect> {
  TextEditingController searchServiceCont = TextEditingController();

  Future<List<CategoryData>>? future;
  final List<CategoryData> selectedCategory = [];
  final List<int> selectedCategoryList = [];
  bool isSelectedCategory = false;
  Future<List<EmployeeData>>? futureEmployeeList;
  EmployeeData? selectedEmployee;
  BookingRequestModel taxRequest = BookingRequestModel();

  FocusNode myFocusNode = FocusNode();

  Future<List<CategoryData>>? futureCategory;
  List<CategoryData> categoryList = [];
  List<CategoryData> subCategoryList = [];

  Future<List<ServiceListData>>? futureService;
  List<ServiceListData> serviceListObj = [];
  List<ServiceListData> serviceListData = [];
  int page = 1;
  bool showEmployeeList = false;

  int? subCategoryId;
  int selectedSubCategoryIndex = -1;

  List<ServiceListData> selectedService = [];

  bool isLastPage = false;
  bool isSubCategorySelected = false;

  double containerHeight = 200;
  int totalItem = 0;

  @override
  void initState() {
    super.initState();

    if (widget.search.isNotEmpty) {
      searchServiceCont.text = widget.search;
    }
    initCategory();

    init();
  }

  void initCategory() async {
    try{
      categoryList = await getCategoryList(
        page: page,
        list: categoryList,
        isStoreCached: true,
        perPage: 200,
        lastPageCallBack: (val) {
          isLastPage = val;
        },
      );
      if(widget.categoryData != null){
        if(! categoryList.any((e)=>e.id == widget.categoryData!.id)){
          categoryList.add(widget.categoryData!);
        }
        if(widget.categoryData!.id != null){
          selectedCategoryList.add(widget.categoryData!.id!);
          selectedCategory.add(widget.categoryData!);
          try{
            categoryList.firstWhere((e)=>e.id == widget.categoryData!.id).isServiceChecked = true;
          }catch(e){
            debugPrint(e.toString());
          }
        }
      }
    }catch(e){
      debugPrint(e.toString());
    }finally{
      setState(() {});
    }

  }

  void init() async {
    fetchAllServiceData(subCategoryId != null ? '' : (widget.categoryId.validate() != 0 ? widget.categoryId!.toString() : ''),subCategoryId != null ? subCategoryId.validate().toString() : '');

    if (widget.categoryId != null) {
      fetchCategoryList(widget.categoryId);
    }
  }

  void fetchCategoryList(int? catId,{bool flag = false}) async {
    futureCategory = getCategoryList(categoryId: catId, list: subCategoryList);
    //futureCategory!.;



    print(" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& total category2: ${categoryList.length} &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");

    if (flag) setState(() {});
  }

  void fetchAllServiceData(String catId,String subCatId,{bool flag = false, bool isClear = false}) async {
    if (isClear) {
      selectedService.clear();
      bookingRequestStore.setSelectedServiceListInRequest(selectedService);
    }

    futureService = getServiceList(
      branchId: appStore.branchId,
      categoryId: catId,
      subCategoryId: subCatId,
      page: page,
      search: searchServiceCont.text,
      list: serviceListObj,
      lastPageCallBack: (p0) {
        isLastPage = p0;
      },
    );

    if (flag) setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    selectedService.clear();
    bookingRequestStore.setSelectedServiceListInRequest(selectedService);
    super.dispose();
  }


  bool isCatExpanded = false;

  @override
  Widget build(BuildContext context) {
    print(" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& total category: ${categoryList.length} &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    //return body();
    return AppScaffold(
      showAppBar: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CommonAppComponent(
            innerWidget: DashboardAppBarComponent(
              alignment: Alignment.center,
              hintText: '${locale.searchFor} ${widget.serviceTitle.validate()}',
              positionWidget: AppTextField(
                textFieldType: TextFieldType.OTHER,
                focus: myFocusNode,
                controller: searchServiceCont,
                suffix: CloseButton(
                  onPressed: () {
                    page = 1;
                    searchServiceCont.clear();

                    appStore.setLoading(true);
                    fetchAllServiceData(subCategoryId != null ? '' : (widget.categoryId.validate() != 0 ? widget.categoryId!.toString() : ''),subCategoryId != null ? subCategoryId.validate().toString() : '',flag: true);

                    //fetchAllServiceData(flag: true);
                  },
                ).visible(searchServiceCont.text.isNotEmpty),
                onFieldSubmitted: (s) {
                  page = 1;

                  appStore.setLoading(true);
                  fetchAllServiceData(subCategoryId != null ? '' : (widget.categoryId.validate() != 0 ? widget.categoryId!.toString() : ''),subCategoryId != null ? subCategoryId.validate().toString() : '',flag: true);

                 // fetchAllServiceData(flag: true);
                },
                decoration: inputDecoration(
                  context,
                  hint: locale.searchForServices,
                  prefixIcon:
                      Icon(Icons.search, color: textSecondaryColorGlobal),
                ),
              ),
              innerChild: AnimatedCrossFade(
                firstChild: AnimatedContainer(
                  decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: Colors.transparent,
                      borderRadius: radius()),
                  duration: 300.milliseconds,
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      fontFamily: GoogleFonts.lexendDeca().fontFamily,
                      textTheme: context.theme.textTheme,
                    ),
                    child: ExpansionTile(
                      // title: Text('${widget.serviceTitle.validate()}    (${categoryList.length})', style: secondaryTextStyle()),
                      title: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                )),
                            Expanded(
                              child: Observer(builder: (context) {
                                return Text(
                                  '${widget.serviceTitle.validate()}    (${categoryList.length})',
                                  textAlign: TextAlign.center,
                                  style: boldTextStyle(
                                      size: 18, color: Colors.white),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          isCatExpanded = expanded;
                        });
                      },
                      trailing: Icon(
                        isCatExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color:  Colors.white,
                        size: 35,

                        // Custom color
                      ),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      iconColor: context.iconColor,
                      collapsedIconColor: context.iconColor,
                      childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      children: [
                        SizedBox(
                          height: containerHeight,
                          child: SizeListener(
                            onSizeChange: (p0) {
                              containerHeight = p0.height;
                            },
                            child: ListView.separated(
                              itemCount: categoryList.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              // physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, i) {
                                return DottedLine(
                                    lineThickness: 1,
                                    dashLength: 2,
                                    dashColor: context.dividerColor);
                              },
                              itemBuilder: (context, index) {
                                return categoryListWidget(
                                    category: categoryList[index]
                                );
                              },
                            ),
                          ),
                        ),
                        if (selectedCategory.isNotEmpty) 4.height,
                        if (selectedCategory.isNotEmpty)
                          DottedLine(dashColor: lightPrimaryColor, dashGapLength: 0).paddingOnly(right: 10),
                        if (selectedCategory.isNotEmpty) 4.height,
                        if (selectedCategory.isNotEmpty)
                          SizedBox(
                            height: double.tryParse((30*totalItem).toString()),
                            child: AnimatedWrap(
                              spacing: 6,
                              runSpacing: 6,
                              itemCount: selectedCategory.length,
                              itemBuilder: (_, index) {
                                //containerHeight = containerHeight-(totalItem*30);
                                debugPrint("=====================total item $totalItem=================");
                                return selectedCategoryWidget(
                                    selectedServiceText: selectedCategory[index]);
                              },
                            ).paddingBottom(5),
                          ),

                      ],
                    ),
                  ),
                ),
                crossFadeState: showEmployeeList
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                secondCurve: Curves.linearToEaseOut,
                duration: 200.milliseconds,
                secondChild: AnimatedContainer(
                  duration: 300.milliseconds,
                  decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: context.cardColor,
                      borderRadius: radius()),
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      primaryColor: context.primaryColor,
                      fontFamily: GoogleFonts.lexendDeca().fontFamily,
                      textTheme: context.theme.textTheme,
                    ),
                    child: SnapHelperWidget<List<EmployeeData>>(
                      future: futureEmployeeList,
                      loadingWidget: LoaderWidget(),
                      useConnectionStateForLoader: true,
                      onSuccess: (employeeList) {
                        if (employeeList.isEmpty)
                          return Text(locale.noStaffFound,
                                  style: primaryTextStyle())
                              .center()
                              .paddingSymmetric(vertical: 50);

                        return ExpansionTile(
                          title: Text(locale.specialist,
                              style: secondaryTextStyle()),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          iconColor: context.iconColor,
                          collapsedIconColor: context.iconColor,
                          initiallyExpanded: true,
                          childrenPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          children: [
                            SizedBox(
                              height: employeeList.length >= 6 ? 300 : null,
                              child: ListView.separated(
                                itemCount: employeeList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder: (_, i) {
                                  return DottedLine(
                                      lineThickness: 1,
                                      dashLength: 4,
                                      dashColor: context.dividerColor);
                                },
                                itemBuilder: (context, index) {
                                  EmployeeData employeeData =
                                      employeeList[index];

                                  return RadioListTile<EmployeeData>(
                                    value: employeeList[index],
                                    groupValue: selectedEmployee,
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    activeColor: appStore.isDarkMode
                                        ? primaryColor
                                        : secondaryColor,
                                    title: Row(
                                      children: [
                                        CachedImageWidget(
                                            url: employeeData.profileImage
                                                .validate(),
                                            height: 24,
                                            width: 24,
                                            circle: true),
                                        16.width,
                                        Text(employeeData.fullName.validate(),
                                            style: boldTextStyle(
                                                color: appStore.isDarkMode
                                                    ? textPrimaryColorGlobal
                                                    : secondaryColor,
                                                size: 14)),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      selectedEmployee = value!;
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            ).paddingBottom(16),
                          ],
                        );
                      },
                      errorBuilder: (error) {
                        return NoDataWidget(
                          title: error,
                          imageWidget: ErrorStateWidget(),
                          retryText: locale.reload,
                          onRetry: () {
                            appStore.setLoading(true);
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              /*    innerChild: appBarWidget(
                widget.serviceTitle.validate(),
                center: true,
                color: context.primaryColor,
                textColor: white,
                backWidget: BackWidget(),
              ).cornerRadiusWithClipRRectOnly(
                  bottomLeft: 20,
                  bottomRight: 20
              ).paddingTop(10),

*/
            ),
            mainWidgetHeight: (isCatExpanded?containerHeight:0)+135+(totalItem*30),
            subWidgetHeight: (isCatExpanded?containerHeight:0)+120+(totalItem*30),
            onSwipeRefresh: () {
              page = 1;

              appStore.setLoading(true);
              selectedService.clear();
              bookingRequestStore
                  .setSelectedServiceListInRequest(selectedService);
              fetchAllServiceData(subCategoryId != null ? '' : (widget.categoryId.validate() != 0 ? widget.categoryId!.toString() : ''),subCategoryId != null ? subCategoryId.validate().toString() : '',isClear: true,flag: true);

              //fetchAllServiceData(isClear: true, flag: true);

              return Future.value(false);
            },
            onNextPage: () {
              if (!isLastPage) {
                page++;

                appStore.setLoading(true);
                fetchAllServiceData(subCategoryId != null ? '' : (widget.categoryId.validate() != 0 ? widget.categoryId!.toString() : ''),subCategoryId != null ? subCategoryId.validate().toString() : '',flag: true);

                //fetchAllServiceData(flag: true);
              }
            },
            subWidget: AnimatedScrollView(
              padding: EdgeInsets.only(top: 25, bottom: 80),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Subcategory List Api
                if (widget.categoryId != null)
                  SnapHelperWidget<List<CategoryData>>(
                    future: futureCategory,
                    loadingWidget: ViewAllServiceShimmer(),
                    onSuccess: (lista) {
                      if (lista.isEmpty) return Offstage();

                      //subCategoryList.addAll(List.from(lista));
                      for (var cat in lista) {
                        print(cat);
                        if (!subCategoryList.any((existing) => existing.id == cat.id)) {
                          if(selectedCategory.any((e)=>e.id == cat.parentId)){
                            subCategoryList.add(cat);
                          }
                          //subCategoryList.add(cat);
                        }
                      }

                      //subCategoryList.addAll(List.from(lista));
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.height,
                          ViewAllLabel(
                            label: locale.subCategories+"  (${subCategoryList.length})b",
                            trailingText: locale.clear,
                            isShowAll: isSubCategorySelected,
                            onTap: () {
                              selectedSubCategoryIndex = -1;
                              isSubCategorySelected = false;

                              subCategoryId = null;

                              appStore.setLoading(true);
                              fetchAllServiceData(subCategoryId != null ? '' : (widget.categoryId.validate() != 0 ? widget.categoryId!.toString() : ''),subCategoryId != null ? subCategoryId.validate().toString() : '',flag: true);

                              //fetchAllServiceData(flag: true);

                              setState(() {});
                            },
                          ).paddingLeft(16),
                          HorizontalList(
                            runSpacing: 16,
                            spacing: 16,
                            itemCount: subCategoryList.length,
                            padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: isSubCategorySelected ? 0 : 8),
                            itemBuilder: (_, i) {
                              CategoryData data = subCategoryList[i];

                              return GestureDetector(
                                onTap: () {
                                  selectedSubCategoryIndex = i;
                                  subCategoryId = data.id;
                                  isSubCategorySelected = true;

                                  page = 1;

                                  appStore.setLoading(true);
                                 // fetchAllServiceData();
                                  fetchAllServiceData(subCategoryId != null ? '' : (widget.categoryId.validate() != 0 ? widget.categoryId!.toString() : ''),subCategoryId != null ? subCategoryId.validate().toString() : '');

                                  setState(() {});
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CategoryItemWidget(
                                        categoryData: data,
                                        width: context.width() / 3 - 20),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: boxDecorationDefault(
                                            color: context.primaryColor),
                                        child: Icon(Icons.done,
                                            size: 16, color: Colors.white),
                                      ).cornerRadiusWithClipRRect(16).visible(
                                          selectedSubCategoryIndex == i),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),

                /// Service List Api
                SnapHelperWidget<List<ServiceListData>>(
                  future: futureService,
                  loadingWidget: Offstage(),
                  errorBuilder: (error) {
                    return NoDataWidget(
                      title: error,
                      retryText: locale.reload,
                      imageWidget: ErrorStateWidget(),
                      onRetry: () {
                        page = 1;
                        appStore.setLoading(true);
                        fetchAllServiceData(subCategoryId != null ? '' : (widget.categoryId.validate() != 0 ? widget.categoryId!.toString() : ''),subCategoryId != null ? subCategoryId.validate().toString() : '',flag: true);

                       // fetchAllServiceData(flag: true);
                      },
                    ).paddingTop(120).center();
                  },
                  onSuccess: (servicesInfoListData) {
                    for (var service in servicesInfoListData) {
                      if (!serviceListData.any((existing) => existing.id == service.id)) {

                        // Assuming 'id' is a unique identifier in CategoryData


                        if(selectedCategory.any((e)=>e.id == service.categoryId)){
                          serviceListData.add(service);
                        }


                      }
                    }

                    //serviceListData.addAll(List.from(servicesInfoListData));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.height,
                        Text(locale.services+"  (${serviceListData.length})A", style: boldTextStyle()),
                        16.height,
                        AnimatedListView(
                          itemCount: serviceListData.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          emptyWidget: NoDataWidget(
                            title: locale.noServicesFound,
                            imageWidget: EmptyStateWidget(),
                          ).paddingTop(
                              searchServiceCont.text.isNotEmpty ? 0 : 120),
                          itemBuilder: (context, index) {
                            ServiceListData serviceData =
                            serviceListData[index];
                            serviceData.isServiceChecked = bookingRequestStore
                                .selectedServiceList
                                .any((element) =>
                                    element.id.validate() ==
                                    serviceData.id.validate());

                            return ServicesInfoListComponent(
                              serviceInfo: serviceData,
                              onPressed: () {
                                serviceData.isServiceChecked =
                                    !serviceData.isServiceChecked;

                                if (serviceData.isServiceChecked) {
                                  selectedService.add(serviceData);
                                } else {
                                  selectedService.removeWhere((element) =>
                                      element.id.validate() ==
                                      serviceData.id.validate());
                                }

                                bookingRequestStore
                                    .setSelectedServiceListInRequest(
                                        selectedService);

                                setState(() {});
                              },
                            );
                          },
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Observer(
              builder: (context) => CommonBottomPriceWidget(
                buttonText: locale.bookNow,
                title: bookingRequestStore.selectedServiceList
                    .map((e) => e.name.validate())
                    .toList()
                    .join(', '),
                price: bookingRequestStore.totalAmount,
                onTap: () {
                  hideKeyboard(context);

                  BookingScreen(services: selectedService).launch(context);
                },
              ).visible(selectedService.isNotEmpty),
            ),
          ),
        ],
      ),
    );
  }





  final double height = 150;

  Widget appbar() {
    return Container(
        color: Colors.transparent,
        child: Stack(fit: StackFit.loose, children: <Widget>[
          Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: height,
              child: CustomPaint(
                painter: CustomToolbarShape(lineColor: Colors.deepOrange),
              )),
        ]));
  }

  double get maxExtent => height;

  double get minExtent => height;

  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  Widget categoryListWidget({required CategoryData category}) {

    return CustomCheckboxListTile(
      value: category.isServiceChecked,
      title: category.name.validate(),
      imageUrl: category.categoryImage,
      isDarkMode: appStore.isDarkMode,
      height: 28, // Adjust height as needed
      onChanged: (value) async {
        print(value);


        if((widget.categoryData != null && widget.categoryData!.id == category.id)){
          category.isServiceChecked = true;
        }else{
          category.isServiceChecked = !category.isServiceChecked;
          if (category.isServiceChecked) {
            selectedCategory.add(category);
            if (category.id != null) {
              fetchCategoryList(category.id);
              fetchAllServiceData(
                  (category.id.validate() != 0 ? category.id.toString() : ''),
                  subCategoryId != null ? subCategoryId.validate().toString() : ''
              );

              //await getService(category.id.toString());
            }
            selectedCategoryList.add(category.id.validate());
          }
          else {
            selectedCategory.removeWhere((element) => element.id.validate() == category.id.validate());
            selectedCategoryList.remove(category.id.validate());
            try {
              removeService(category.id.toString());
            } catch (e) {
              print(e.toString());
            }
          }
        }


        totalItem = calculateRows(MediaQuery.of(context).size.width, selectedCategory.length);

        setState((){});
      },
    );
  }

  int calculateRows(double maxWidth,int totalItemCount) {
    int itemsPerRow = (maxWidth / ((context.width() / 3 - 30) + 6)).floor();
    return (totalItemCount / (itemsPerRow > 0 ? itemsPerRow : 1)).ceil();
  }


  /// Selected Service Widget
  Widget selectedCategoryWidget({CategoryData? selectedServiceText}) {
    return Container(
      width: context.width() / 3 - 30,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: appStore.isDarkMode
            ? indicatorColor.withOpacity(0.5)
            : indicatorColor.withOpacity(1),
      ),
      child: Row(
        children: [
          Marquee(
            child: Text(
              '${selectedServiceText!.name}',
              style: secondaryTextStyle(
                  color: appStore.isDarkMode
                      ? textPrimaryColorGlobal : secondaryColor),
            ),
          ).expand(),
          4.width,
          Container(
            height: 16,
            width: 16,
            decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(5),
                backgroundColor: (widget.categoryData != null && widget.categoryData!.id == selectedServiceText.id)?Colors.black26:Colors.red),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if(widget.categoryData != null){
                  if(widget.categoryData!.id != selectedServiceText.id){
                    try {
                      categoryList.firstWhere((element) => element.name == selectedServiceText.name).isServiceChecked = false;
                    } catch (e) {
                      print(e);
                    }
                    selectedCategory.remove(selectedServiceText);
                    try {
                      removeService(categoryList.firstWhere((element) => element.name == selectedServiceText.name).id.toString());
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                }else{
                  try {
                    categoryList.firstWhere((element) => element.name == selectedServiceText.name).isServiceChecked = false;
                  } catch (e) {
                    print(e);
                  }
                  selectedCategory.remove(selectedServiceText);
                  try {
                    removeService(categoryList.firstWhere((element) => element.name == selectedServiceText.name).id.toString());
                  } catch (e) {
                    print(e.toString());
                  }
                }






                //todo::short service based on selected category
                //todo::remove service(category.id);

                setState(() {});
              },
              icon: Icon(Icons.close, color: cardColor, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  removeService(String catId) async {
    try {
      subCategoryList.removeWhere((e) => e.id.toString() == catId);
      serviceListData.removeWhere((e) => e.categoryId.toString() == catId);
    } catch (e) {
      print(e.toString());
    } finally {
      print("total service : ${serviceListData.length}");

      if (selectedCategory.isEmpty) {
        //serviceListData = widget.serviceListData;
      }
      totalItem = calculateRows(MediaQuery.of(context).size.width, selectedCategory.length);
      setState(() {});
    }
  }

  Future<void> getService(String catId) async {
    try {
      if (selectedCategoryList.isEmpty) {
        serviceListData = [];
      }
      serviceListData.addAll(await getServiceList(
        branchId: appStore.branchId,
        categoryId: catId,
        subCategoryId: '',
        page: 1,
        perPage: 200,
        search: '',
        list: [],
        lastPageCallBack: (p0) {
          isLastPage = p0;
        },
      ));
    } catch (e) {
      print(e.toString());
    } finally {
      // print(serviceListData);
      setState(() {});
    }
  }
}
