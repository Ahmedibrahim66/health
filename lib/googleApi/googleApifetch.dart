// import 'package:oauth2_client/oauth2_helper.dart';
// //We are going to use the google client for this example...
// import 'package:oauth2_client/google_oauth2_client.dart';
// import 'package:http/http.dart' as http;




// getResponse()async {

// //Instantiate an OAuth2Client...
// GoogleOAuth2Client client = GoogleOAuth2Client(
// 	customUriScheme: 'com.example.hanitesting4_alarm_manager', //Must correspond to the AndroidManifest's "android:scheme" attribute
// 	redirectUri:  'com.example.hanitesting4_alarm_manager://callback', //Can be any URI, but the scheme part must correspond to the customeUriScheme
// );

// //Then, instantiate the helper passing the previously instantiated client
// OAuth2Helper oauth2Helper = OAuth2Helper(client,
// 	grantType: OAuth2Helper.AUTHORIZATION_CODE,
// 	clientId: '725003533598-scaq1787emkdita8vegkbb4f3cr3a7ht.apps.googleusercontent.com',
// 	scopes: ['https://www.googleapis.com/auth/fitness.blood_pressure.read']);

//   print(oauth2Helper.getToken());
//    //http.Response resp = await oauth2Helper.get('https://www.googleapis.com/fitness/v1/users/${oauth2Helper.clientId}/dataSources/dataType');
//   // print(resp);

// }
