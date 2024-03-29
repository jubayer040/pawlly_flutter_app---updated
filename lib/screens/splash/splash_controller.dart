// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/screens/auth/services/auth_service_apis.dart';
import '../auth/model/login_response.dart';
import '../dashboard/dashboard_screen.dart';
import '../walkthrough/walkthrough_screen.dart';
import '../../utils/app_common.dart';
import '../../utils/constants.dart';
import '../../utils/local_storage.dart';
import '../home/home_controller.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() {
    getAppConfigurations();
  }

  ///Get ChooseService List
  getAppConfigurations() {
    AuthServiceApis.getAppConfigurations().then((value) {
      appCurrency(value.currency);
      appConfigs(value);
      print('All data is ${value.appStatus}');

      ///Navigation logic
      navigationLogic(appStatus: value.appStatus);
    }).onError((error, stackTrace) {
      toast(error.toString());

      ///Navigation logic
      navigationLogic(appStatus: '0');
    });
  }

  void navigationLogic({dynamic appStatus}) {
    if ((getValueFromLocal(SharedPreferenceConst.FIRST_TIME) ?? false) ==
        false) {
      Get.offAll(() => WalkthroughScreen());
    } else if (appStatus != null && appStatus == '1') {
      Get.defaultDialog(
        backgroundColor: white,
        title: 'Please complete payment',
        content: const Text('To continue using this app please clear the payment first'),
        barrierDismissible: false,
      );
    } else if (getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true) {
      try {
        final userData = getValueFromLocal(SharedPreferenceConst.USER_DATA);
        isLoggedIn(true);
        loginUserData(UserData.fromJson(userData));
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(HomeScreenController());
        }));
      } catch (e) {
        log('SplashScreenController Err: $e');
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(HomeScreenController());
        }));
      }
    } else {
      Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
        Get.put(HomeScreenController());
      }));
    }
  }
}
