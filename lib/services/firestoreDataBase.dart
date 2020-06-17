import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hanitesting4_alarm_manager/models/bpmModel.dart';
import 'package:hanitesting4_alarm_manager/models/heightModel.dart';
import 'package:hanitesting4_alarm_manager/models/myHealthModel.dart';
import 'package:hanitesting4_alarm_manager/models/weightModel.dart';

class FirestoreService {

  Firestore firestore = Firestore.instance;

  
 HealthModel convertToHealthModel(_healthDataList){

    List<Weight> weight = new List();
    List<Height> height = new List();
    List<HeartRate> heartRate = new List();

     for (int i = 0; i < _healthDataList.length; i++) {
      if (_healthDataList.elementAt(i).dataType == "WEIGHT") {
        weight.add(new Weight(dateFrom:  DateTime.fromMillisecondsSinceEpoch(_healthDataList.elementAt(i).dateFrom), weight:_healthDataList.elementAt(i).value.toString() ));
        //print(_healthDataList.elementAt(i).value);
      } else  if (_healthDataList.elementAt(i).dataType == "HEIGHT") {
        height.add(new Height(dateFrom:  DateTime.fromMillisecondsSinceEpoch(_healthDataList.elementAt(i).dateFrom), height:_healthDataList.elementAt(i).value.toString() ));
        //print(_healthDataList.elementAt(i).value);
      } else  if (_healthDataList.elementAt(i).dataType == "HEART_RATE") {
        heartRate.add(new HeartRate(dateFrom:  DateTime.fromMillisecondsSinceEpoch(_healthDataList.elementAt(i).dateFrom), heartRate:_healthDataList.elementAt(i).value.toString() ));
        //print(_healthDataList.elementAt(i).value);
      } else {
        print("not the type we want , type is  " + _healthDataList.elementAt(i).dataType);
      }
    }

    HealthModel healthModel = new HealthModel(weight: weight,height: height,bpm: heartRate,);
    return healthModel;
    //print(healthModel);
    
  }
  
  addHealthModel(_healthDataList) async {

    HealthModel model = convertToHealthModel(_healthDataList);
    print("starting firestore");
    print(model.weight.elementAt(model.weight.length - 1 ).weight);

    DateTime date = DateTime.now();
    DocumentReference productDocRef =
        firestore.collection("HealthModelData").document();

    await productDocRef.setData({
      'Date': date,
      'weight': model.weight.elementAt(model.weight.length - 1 ).weight,
      'height': model.height.elementAt(model.height.length - 1 ).height,
      // 'bpm': model.bpm.elementAt(model.bpm.length - 1 ).heartRate,
      
    }); // add the model to the database ,
    print("endedFirestore");

  }


  addHealthModelTesting() async {
    print("starting firestore");

    String weight = "60";
    String height = "170";
    String heartRate = "90";
    DateTime date = DateTime.now();


    DocumentReference productDocRef =
        firestore.collection("HealthModelData").document();

    await productDocRef.setData({
      'Date': date,
      'weight': weight,
      'height': height,
      'bpm': heartRate
      
    }); // add the model to the database ,
    //print("endedFirestore");

  }


   


}
