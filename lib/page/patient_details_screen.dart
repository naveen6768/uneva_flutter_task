import 'dart:async';

import 'package:flutter/material.dart';
import '../models/patient_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String pid;
  final String pname;
  PatientDetailsScreen({
    required this.pid,
    required this.pname,
  });
  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  late Connectivity connectivity;

  late StreamSubscription<ConnectivityResult> subscription;

  Future<PatientDetails> fetchPatientDetails(String patientId) async {
    final response = await http.get(
      Uri.parse(
        'https://dev.uneva.in/task_721/patient.php?id=$patientId',
      ),
    );

    if (response.statusCode == 200) {
      // print(response);
      final patientDetails = patientDetailsFromJson(response.body);

      return patientDetails;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult event) {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Icon(Icons.edit),
          SizedBox(
            width: 15.0,
          ),
        ],
        centerTitle: true,
        title: Text(
          widget.pname,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        backgroundColor: Colors.green[400],
      ),
      body: FutureBuilder(
        future: fetchPatientDetails(widget.pid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var data = snapshot.data;
          if (data == null) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else {
            print(data.personPic.runtimeType);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.0,
                ),
                data.personPic.runtimeType != Null
                    ? Center(
                        child: CircleAvatar(
                          child: Image.network(data.personPic),
                          radius: 70.0,
                        ),
                      )
                    : Center(
                        child: Container(
                          height: 160.0,
                          width: 160.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    'https://i.pinimg.com/originals/f6/35/d5/f635d506d7c6de9511fd0c2fd835c1ad.png',
                                  ))),
                        ),
                      ),
                SizedBox(
                  height: 30.0,
                ),
                Divider(
                  color: Colors.black,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'PID : ' + data.personPid,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Name : ' + data.personFullName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Gender : ' + data.personGender,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Age : ' + data.personAge,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Phone : ' + data.personPhone,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  data.personRelation,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Address' + data.personAddress,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
