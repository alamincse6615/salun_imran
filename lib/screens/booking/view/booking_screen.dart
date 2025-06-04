import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frezka/components/custom_stepper.dart';
import 'package:frezka/screens/booking/component/booking_step1_component.dart';
import 'package:frezka/screens/booking/component/booking_step3_component.dart';
import 'package:frezka/store/booking_request_store.dart';
import 'package:frezka/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../../services/models/service_response.dart';
import '../component/booking_step2_component.dart';

class CustomStep {
  final String? title;
  final Widget? page;

  CustomStep({this.title, this.page});
}

class BookingScreen extends StatefulWidget {
  final List<ServiceListData> services;
  final bool isReschedule;

  const BookingScreen({super.key, required this.services, this.isReschedule = false});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<CustomStep>? stepsList;
  int currentStep = 0;
  bool staffSelectionLoading = true;
  bool staffSelectionStatus = true;

  @override
  void initState() {
    //https://admin.rinzindivinebeauty.com.au/api/app-configuration
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((Duration value) async{
      staffSelectionStatus = await fetchStaffSelection();
      init();
      staffSelectionLoading = false;
      setState((){});
    });

    bookingRequestStore = BookingRequestStore();

    bookingRequestStore.setSelectedServiceListInRequest(widget.services, isRescheduleInRequest: widget.isReschedule);
    if (branchConfigurationCached != null) {
      bookingRequestStore.setTaxPercentageInRequest(branchConfigurationCached!.tax.validate());
    }
  }

  Future<bool> fetchStaffSelection() async {
    const String url = 'https://admin.rinzindivinebeauty.com.au/api/app-configuration';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Return the staff_selection value if it exists, else return true
        return data['staff_selection'] ?? true;
      } else {
        // Return true if status code is not 200
        return true;
      }
    } catch (e) {
      // Return true if any error occurs (e.g., network issue, parsing error)
      return true;
    }
  }

  void init() async {
    stepsList = [
     if(staffSelectionStatus) CustomStep(title: locale.staff, page: BookingStep1Component(isReschedule: widget.isReschedule)),
      CustomStep(title: '${locale.date} & ${locale.time}', page: BookingStep2Component(isReschedule: widget.isReschedule)),
      CustomStep(title: locale.payment, page: BookingStep3Component(isReschedule: widget.isReschedule)),
    ];
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
    return WillPopScope(
      onWillPop: () {
        if (currentStep == 0) {
          return Future.value(true);
        } else {
          bookingRequestStore.time = '';
          customStepperController.previousPage(duration: 300.milliseconds, curve: Curves.linear);
          LiveStream().emit(LiveStreamKeyConst.LIVESTREAM_CHANGE_STEP, currentStep);
          return Future.value(false);
        }
      },
      child: Scaffold(
        body: staffSelectionLoading?Center(child: CircularProgressIndicator(),):CustomStepper(
          stepsList: stepsList.validate(),
          onChange: (p0) {
            currentStep = p0;
          },
        ),
      ),
    );
  }
}
