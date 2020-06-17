// import 'package:oauth2_custom_uri_scheme/oauth2_custom_uri_scheme.dart';
// import 'package:oauth2_custom_uri_scheme/oauth2_token_holder.dart';


// //
// // OAuth2Config can be app global to keep the OAuth configuration
// //
// final oauth2Config = OAuth2Config(
//   uniqueId: 'example.com#1', // NOTE: ID to identify the credential for box session
//   authorizationEndpoint: Uri.parse('https://example.com/authorize'),
//   tokenEndpoint: Uri.parse('https://example.com/token'),
//   // revocationEndpoint is optional
//   revocationEndpoint: Uri.parse('https://example.com/revoke'),
//   // NOTE: For Android, we also have corresponding intent-filter entry on example/android/app/src/main/AndroidManifest.xml
//   redirectUri: Uri.parse('com.example.redirect43763246328://callback'),
//   clientId: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
//   clientSecret: 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy',
//   useBasicAuth: false);


// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Simple OAuth Sample'),
//     ),
//     body: Center(
//       // OAuth2TokenHolder is the easiest way to create [authorize] button.
//       child: OAuth2TokenHolder(
//         config: oauth2Config,
//         builder: (context, accessToken, state, authorize, deauthorize, child) => ListTile(title: RaisedButton(
//           onPressed:() => accessToken == null ? authorize() : deauthorize(),
//           child: state == OAuth2TokenAvailability.Authorizing
//           ? const CircularProgressIndicator()
//           : Text(accessToken == null ? 'Authorize' : 'Deauthorize'))
//         )
//       )
//     )
//   );
// }

// // After [Authorize] on the UI, we can get the access token from cache.
// AccessToken token = await oauth2Config.getAccessTokenFromCache();

// // Or, of course, you can authorize the app
// // If reset=false, it may use the cache and the method returns immediately;
// // otherwise reset=true, it always tries to authorize the app.
// AccessToken token = await oauth2Config.authorize(reset: true);

// // OK, we can execute GET query
// final foobarResult = await token.getJsonFromUri('https://example.com/api/2.0/foobar');