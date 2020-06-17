import 'package:background_fetch/background_fetch.dart';
import 'package:hanitesting4_alarm_manager/screens/homepage.dart';
import 'package:hanitesting4_alarm_manager/services/firestoreDataBase.dart';
import 'package:health/health.dart';


void backroundFetch() {
    BackgroundFetch.configure(
            BackgroundFetchConfig(
              minimumFetchInterval: 15,
              forceAlarmManager: false,
              stopOnTerminate: false,
              startOnBoot: true,
              enableHeadless: true,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.NONE,
            ),
            _onBackgroundFetch)
        .then((int status) {
      print('[BackgroundFetch] configure success: $status');
      
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
      
    });
  }

  void _onBackgroundFetch(String taskId) async {
    DateTime startDate = DateTime.utc(2001, 01, 01);
    DateTime endDate = DateTime.now();


    print("data from request auth is " +  Health.requestAuthorization().toString());

    //initPlatformState();
    Future.delayed(Duration(seconds: 2), () async {
      isAuthorized = await Health.requestAuthorization();

      if (isAuthorized) {
        print('Authorized');

        bool weightAvailable =
            Health.isDataTypeAvailable(HealthDataType.WEIGHT);
        print("is WEIGHT data type available?: $weightAvailable");

        /// Specify the wished data types
        List<HealthDataType> types = [
          HealthDataType.WEIGHT,
          HealthDataType.HEIGHT,
          //          HealthDataType.STEPS,
          //          HealthDataType.BODY_MASS_INDEX,
          //          HealthDataType.WAIST_CIRCUMFERENCE,
          //          HealthDataType.BODY_FAT_PERCENTAGE,
          //          HealthDataType.ACTIVE_ENERGY_BURNED,
          //          HealthDataType.BASAL_ENERGY_BURNED,
                  //  HealthDataType.HEART_RATE,
          //          HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
          //          HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
          //          HealthDataType.RESTING_HEART_RATE,
          //          HealthDataType.BLOOD_GLUCOSE,
          //          HealthDataType.BLOOD_OXYGEN,
        ];
         healthDataList = [];
        for (HealthDataType type in types) {
          /// Calls to 'Health.getHealthDataFromType'
          /// must be wrapped in a try catch block.b
          try {
            List<HealthDataPoint> healthData =
                await Health.getHealthDataFromType(startDate, endDate, type);
            healthDataList.addAll(healthData);
          } catch (exception) {
            print(exception.toString());
          }
        }

        /// Print the results
        for (var x in healthDataList) {
          print("Data point: $x");
        }

        try{
        FirestoreService service = new FirestoreService();
        await service.addHealthModel(healthDataList);
        // await service.addHealthModelTesting();

        }catch(e){}
       
        /// Update the UI to display the results
      } else {
        print('Not authorized');
      }
    });

    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }


  