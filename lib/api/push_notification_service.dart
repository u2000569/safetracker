import 'dart:convert';

import 'package:flutter/widgets.dart';
// import 'package:googleapis/connectors/v1.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:provider/provider.dart';
import 'package:safetracker/utils/logging/logger.dart';

class PushNotificationService{

  static Future<String> getAccessToken() async{
    final serviceAccountJson = 
    {
    "type": "service_account",
    "project_id": "pickready",
    "private_key_id": "bc6fdc5edfe129bad58070718d0c78c9f30284bc",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCdLbRiLGI8Ye2c\nan6odpg//Ky7naGA14qCeqkumNedqMmRVStgyrd95Wpyvo9Hp4vbdMXYREgXyjPS\nf56QtY5Gy9S8v30dU7CuTZmfOHr0QI+9zHP5jwn8Yf/YB2A6LNQwtORLq9zMalv0\nKvvJIzjm5YDkk7Q7Xdr2tEURuu8T7iBS01EbTsjJsMhw9RzXUuOJ1oYB4QoMt8qw\nUC9SX+0CUVp+ZvJUB7bLHfVwwAyjdjxn4v5/Rf1l1PlWf3CBzjPE9x32qTX30f6r\nLmNPL0v+lKxySk9yDFZ02laACaW5aTEXrwggGmX80lRQF5vZ7hC7BjJKTHX18fEZ\nE8hUtJPZAgMBAAECggEAEQUIcdL9hi1SdewAMAy7er5JE/3DJbjxOiS/GhkZy+wh\ne3e9/TqmON81MhyZVjh5x/cyjzMBnXXbO7FvAZtvPxJGRHP1v822pYEon9mVUsqE\n5hfz/PN0sNwJwKI31MTS6z1DNUB0ZbwkneFjp0mFmVcDqHyn+P+2PJ2TlxJnXgBw\n8RZIdCDW0w6OYuiiVEqszL2xW9NuRkVf5vrFbC7L12eMKgCA9fMBCrnd8Fm9ogE1\nXPcrKN6pjCG2h7bsx3tYnPvKnho3sXSzo/+iJAXF61+mEVPi6nG8q2G05Uut69Wc\nGSTfhtRYOx9zaArHwcAiuSqIXLkZ1u50mKDh7YbcewKBgQC5BdMtv91mSoXc4DS0\ntwyZee2ci/upqoYn3qSUBtk0NDBACcX1h2GHbbR25nTxGc78A/szUTYSilQtzrV4\nGEk8xP98HN4FucGUdOuDAr1C1sB53Nb7ZPq41E20K7nlMWRFnb1V9TFJbgMujdN3\nxuTYKghiVmDrXFhx+Wi+VhRelwKBgQDZeW+NM629C+pHA7yzV+H2wILM8Xm6SoF/\ndB+29y1UUECvCwiqdkC+snXKJMrYvNSHgQ1cQCjm17S3yE8jYTxhWj8JjLWRwzet\nl1hH+FLerEplhXQKgIS9/9f3A2UCi+VkuvgAtjKJyp0OuczQokEQjJ4ENwmNhVVV\nYgb4zv9fDwKBgQCz+ZOLC/gL2W/PA5ShOPGblPvp7EyXpJUs0SicCPFdE2rfz+Hs\nzIy1FKSXh+K26BjsEd9W8qc7b60khc8Fi/Ipl6LBEr9xKFjB1N2GKbL6AjVmFMhV\n78rm4TTYjjQcWmgkQ6T5qTERMV8M+M5700+laXWQWl+acdBixW36v3a+7wKBgEtc\n6Mpe6UtE8MfxRJhF0TmIVwucdtmW7i9z13W5TI0WToQaZ8NivWcYQvdtLppTPbdD\ngpTAaywr/iVeFgalsJ3v/z5Y86bypr3SX7Z5GIav4Aw0ZhUpmlaZbYbdN0jdn/37\nSOw+N19GxoyO2KpIQBHzGONPC1FurjarhMz+NsMDAoGATtwd2AIVf/Xd2IuPpfSR\nieh5pm4b57bsLoYueG/FqC9AxF+D0v+xAJviggfb6eyKen3Q0+TJjB9/VrPbeUB3\n6x/snFZdJZsIUKy8JMUUc/dx5c2Yy/HHmTErWR9GS79Zuvm8whsRGMWm/7t221sY\nxd60KatpuG5B5CQTS3gLbrk=\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-369i7@pickready.iam.gserviceaccount.com",
    "client_id": "117864604859535067745",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-369i7%40pickready.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"

  };

  List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson), 
      scopes,
    );

    // get access token
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson), 
      scopes, 
      client
    );

    client.close();

    return credentials.accessToken.data;
  }

  static sendNotificationToSelecteDriver(String deviceToken, BuildContext context, String tripID) async{

    // String dropOffDestinationAddress = Provider.of<AppInfo>(context, listen: false).dropOffLocation!.placeName.toString();
    // String pickUpAddress = Provider.of<AppInfo>(context, listen: false).pickUpLocation!.placeName.toString();

    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/pickready/messages:send';

    final Map<String, dynamic> message = {
      'message':
      {
        'token': deviceToken,
        'notification':{
          'title': 'Alert SafeTrack',
          'body': 'Parent Have arrived :  \nDropOff Location: '
        },
        'data' :{
          'tripID': tripID,
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json; UTF-8',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },

      body: jsonEncode(message),
    );

    if(response.statusCode == 200){
      SLoggerHelper.info('Notification sent successfully');
    } else{
      SLoggerHelper.error('Failed to send notification');
      throw Exception('Failed to send notification');
    }
  }
}