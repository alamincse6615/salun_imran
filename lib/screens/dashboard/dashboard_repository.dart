import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../network/network_utils.dart';
import '../../utils/api_end_points.dart';
import 'models/dashboard_model.dart';

Future<DashboardResponse> userDashboard({required int branchId}) async {
  /// If any below condition not satisfied, call this
  String endPoint = '${APIEndPoints.dashboardDetail}?branch_id=$branchId';

  try {
    dashboardResponseCached = DashboardResponse.fromJson(await handleResponse(await buildHttpResponse(endPoint, method: HttpMethodType.GET)));

    appStore.setLoading(false);

    return dashboardResponseCached!;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}
