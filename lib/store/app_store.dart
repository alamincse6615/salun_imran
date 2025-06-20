import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frezka/screens/branch/branch_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs.dart';
import '../locale/app_localizations.dart';
import '../main.dart';
import '../screens/services/models/service_response.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  bool isSpeechActivated = false;

  @observable
  String selectedLanguageCode = DEFAULT_LANGUAGE;

  @observable
  String currencyCode = 'USD';

  @observable
  int countryId = 0;

  @observable
  int stateId = 0;

  @observable
  int cityId = 0;

  @observable
  String currencyCountryId = '';

  @observable
  String currencySymbol = '';

  @observable
  String privacyPolicy = '';

  @observable
  String termConditions = '';

  @observable
  String inquiryEmail = '';

  @observable
  String helplineNumber = '';

  @observable
  int branchId = UNSELECTED_BRANCH_ID;

  @observable
  List<ServiceListData> _selectedService = [];
  @computed
  List<ServiceListData> get selectedServiceList => _selectedService;

  @computed
  List<ServiceListData> selectedServiceListByCategoryId({int? categoryId}) {
    if (categoryId == null) {
      return _selectedService;
    } else {
      return _selectedService.where((service) => service.categoryId == categoryId).toList();
    }
  }

  @computed
  bool get isBranchSelected => branchId != UNSELECTED_BRANCH_ID;

  @observable
  String branchAddress = '';

  @observable
  String branchName = '';

  @observable
  String branchContactNumber = '';

  @action
  Future<void> setBranchAddress(String val, {bool isInitializing = false}) async {
    branchAddress = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.BRANCH_ADDRESS, val);
  }

  @action
  Future<void> setBranchName(String val, {bool isInitializing = false}) async {
    branchName = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.BRANCH_NAME, val);
  }

  @action
  Future<void> setService1(ServiceListData id, {bool isInitializing = false}) async {
    _selectedService.add(id);
    if (!isInitializing) await setValue(SharedPreferenceConst.SELECTED_SERVICES, _selectedService);
  }
  @action
  Future<void> setService(ServiceListData newService, {bool isInitializing = false}) async {

    //_selectedService.add(service);

    bool alreadyExists = _selectedService.any(
          (service) => service.id == newService.id,
    );

    if (!alreadyExists) {
      _selectedService.add(newService);
    }


    /*if (!isInitializing) {
      // Convert List<int> to List<String>
      await setValue(
          SharedPreferenceConst.SELECTED_SERVICES,
          _selectedService.map((e) => e.toString()).toList()
      );
    }*/
  }

  @action
  Future<void> deleteService(ServiceListData serviceData, {bool isInitializing = false}) async {
    _selectedService.removeWhere((e)=>e.id == serviceData.id);


    try{
      int index = _selectedService.indexWhere((e)=>e.id == serviceData.id);
      _selectedService.removeAt(index);
    }catch(e){

    }
    print(_selectedService);
   // if (!isInitializing) await setValue(SharedPreferenceConst.SELECTED_SERVICES, _selectedService);
  }
  @action
  Future<void> deleteAllService() async {
    _selectedService = [];
    _selectedService.clear();
    //removeKey(SharedPreferenceConst.SELECTED_SERVICES);

     //await setValue(SharedPreferenceConst.SELECTED_SERVICES, _selectedService);
  }


  @action
  Future<void> setBranchContactNumber(String val, {bool isInitializing = false}) async {
    branchContactNumber = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.BRANCH_CONTACT_NUMBER, val);
  }

  @action
  Future<void> setBranchId(int val, {bool isInitializing = false}) async {
    branchId = val;
    if (!isInitializing) {
      await setValue(SharedPreferenceConst.BRANCH_ID, val);

      getBranchConfiguration(val).then((value) => null).catchError(onError);
    }
  }

  @action
  Future<void> setHelplineNumber(String val, {bool isInitializing = false}) async {
    helplineNumber = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.HELPLINE_NUMBER, val);
  }

  @action
  Future<void> setInquiryEmail(String val, {bool isInitializing = false}) async {
    inquiryEmail = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.INQUIRY_EMAIL, val);
  }

  @action
  Future<void> setTermConditions(String val, {bool isInitializing = false}) async {
    termConditions = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.TERM_CONDITIONS, val);
  }

  @action
  Future<void> setPrivacyPolicy(String val, {bool isInitializing = false}) async {
    privacyPolicy = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.PRIVACY_POLICY, val);
  }

  @action
  Future<void> setCurrencySymbol(String val, {bool isInitializing = false}) async {
    currencySymbol = val;
    if (!isInitializing) await setValue(ConfigurationKeyConst.CURRENCY_COUNTRY_SYMBOL, val);
  }

  @action
  Future<void> setCurrencyCountryId(String val, {bool isInitializing = false}) async {
    currencyCountryId = val;
    if (!isInitializing) await setValue(ConfigurationKeyConst.CURRENCY_COUNTRY_ID, val);
  }

  @action
  Future<void> setCountryId(int val, {bool isInitializing = false}) async {
    countryId = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.COUNTRY_ID, val);
  }

  @action
  Future<void> setStateId(int val, {bool isInitializing = false}) async {
    stateId = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.STATE_ID, val);
  }

  @action
  Future<void> setCityId(int val, {bool isInitializing = false}) async {
    cityId = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.CITY_ID, val);
  }

  @action
  Future<void> setCurrencyCode(String val, {bool isInitializing = false}) async {
    currencyCode = val;
    if (!isInitializing) await setValue(ConfigurationKeyConst.CURRENCY_COUNTRY_CODE, val);
  }

  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(SharedPreferenceConst.IS_LOGGED_IN, val);
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  void setSpeechStatus(bool val) {
    isSpeechActivated = val;
  }

  @action
  Future<void> setDarkMode(bool val) async {
    isDarkMode = val;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;
      defaultLoaderBgColorGlobal = scaffoldDarkColor;
      appButtonBackgroundColorGlobal = appButtonColorDark;
      shadowColorGlobal = Colors.white12;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: cardDarkColor,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;
      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.black12;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: cardColor,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  @action
  Future<void> setLanguage(String val) async {
    selectedLanguageCode = val;
    selectedLanguageDataModel = getSelectedLanguageModel();

    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);

    locale = await AppLocalizations().load(Locale(selectedLanguageCode));

    errorMessage = locale.pleaseTryAgain;
    errorSomethingWentWrong = locale.somethingWentWrong;
    errorThisFieldRequired = locale.thisFieldIsRequired;
    errorInternetNotAvailable = locale.yourInternetIsNotWorking;
  }
}
