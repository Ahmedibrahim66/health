import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hanitesting4_alarm_manager/backgroundFetchPackage/backGroundfetch.dart';
import 'package:hanitesting4_alarm_manager/services/firestoreDataBase.dart';
import 'package:health/health.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

var healthKitOutput;
var healthDataList = List<HealthDataPoint>();
bool isAuthorized = false;
bool enabled = true;
int status = 0;

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();
    // _cancelNotification();
  }

  Future<void> initPlatformState() async {
    assignDatatoScreen();
    backroundFetch();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);

  //   switch (state) {
  //     case AppLifecycleState.detached:
  //       print("detached");
  //       // _repeatNotification();
  //       break;
  //     case AppLifecycleState.inactive:
  //       print("inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       print("paused");
  //       break;
  //     case AppLifecycleState.resumed:
  //       print("resumed");
  //       // _cancelNotification();
  //       break;
  //   }
  // }

  // @override
  // void dispose() {
  //   // _repeatNotification();
  //   // print("disposed");
  //   // WidgetsBinding.instance.removeObserver(this);
  //   // print("disposed");
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // Auth auth;
    // bool loggedIn = false;
    // String errorMessage = "";

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.sync),
              onPressed: () {
                assignDatatoScreen();
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            // Container(
            //   height: 100,
            //   width: 100,
            //   child: RaisedButton(
            //     onPressed: () {
            //       print("hello world");
            //       // useGoogleApi();
            //     },
            //   ),
            // ),
            healthDataList.isEmpty
                ? Text('$healthKitOutput\n')
                : Container(
                    height: 400,
                    child: ListView.builder(
                        itemCount: healthDataList.length,
                        itemBuilder: (_, index) => ListTile(
                              title: Text(
                                  "${healthDataList[index].dataType.toString()}: ${healthDataList[index].value.toString()}"),
                              trailing: Text('${healthDataList[index].unit}'),
                              subtitle: Text(
                                  '${DateTime.fromMillisecondsSinceEpoch(healthDataList[index].dateFrom)} - ${DateTime.fromMillisecondsSinceEpoch(healthDataList[index].dateTo)}'),
                            )),
                  ),
          ],
        ),
      ),
    );
  }

  void assignDatatoScreen() async {
    DateTime startDate = DateTime.utc(2001, 01, 01);
    DateTime endDate = DateTime.now();

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
          // HealthDataType.HEART_RATE,
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

        FirestoreService service = new FirestoreService();
        await service.addHealthModel(healthDataList);
        // await service.addHealthModelTesting();

        /// Update the UI to display the results
        setState(() {});
      } else {
        print('Not authorized');
      }
    });

    if (!mounted) return;
  }

  // Future<void> _showPublicNotification() async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'repeatingChannelHealth',
  //       'your channel name',
  //       'your channel description',
  //       importance: Importance.Max,
  //       priority: Priority.High,
  //       ticker: 'ticker',
  //       visibility: NotificationVisibility.Public);
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'public notification title',
  //     'public notification body',
  //     platformChannelSpecifics,
  //   );
  // }

  // Future<void> _repeatNotification() async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'repeating channel id',
  //       'repeating channel name',
  //       'repeating description');
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.periodicallyShow(
  //       0,
  //       'Health App is not Running!!',
  //       'Please open the health app to stay safe',
  //       RepeatInterval.EveryMinute,
  //       platformChannelSpecifics);
  // }

  // Future<void> _cancelNotification() async {
  //   await flutterLocalNotificationsPlugin.cancel(0);
  // }

//   useGoogleApi() async {

   

//     final _googleSignIn = new GoogleSignIn(
//       clientId: '725003533598-scaq1787emkdita8vegkbb4f3cr3a7ht.apps.googleusercontent.com',
//       scopes: [
//         'email',
//         FitnessApi.FitnessBloodPressureReadScope,
//         FitnessApi.FitnessActivityReadScope,
//         FitnessApi.FitnessLocationReadScope,
//         FitnessApi.FitnessNutritionReadScope,
//         FitnessApi.FitnessReproductiveHealthReadScope,

//       ],
//     );
//     await _googleSignIn.signIn();

//     print(_googleSignIn.currentUser.id);
//         print(_googleSignIn.currentUser.authentication.then((value)=>print(value.accessToken)));

//     // final authHeaders = await _googleSignIn.currentUser.authHeaders;


//     // // custom IOClient from below
//     // final httpClient = GoogleHttpClient(authHeaders);
//     // print("google client id is " + _googleSignIn.clientId.toString());
//     // print("google user id is "+_googleSignIn.currentUser.id);
//     // print(authHeaders);

//     // var data = await FitnessApi(httpClient).users.dataSources.list(
//     //       _googleSignIn.currentUser.id,
//     //     );
//     // print(data);
//     // var test = await PeopleApi(httpClient).people.connections.list(
//     //     'people/me',
//     //     personFields: 'names,addresses',
//     //     pageToken: nextPageToken,
//     //     pageSize: 100,
//     // );
//   }

 }
