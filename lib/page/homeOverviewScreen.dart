import 'package:flutter/material.dart';
import 'package:musixmatch/page/patient_details_screen.dart';
import 'package:musixmatch/widgets/switch_sort.dart';
import '../models/dart_json_class.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';

class HomeOverviewScreen extends StatefulWidget {
  @override
  _HomeOverviewScreenState createState() => _HomeOverviewScreenState();
}

class _HomeOverviewScreenState extends State<HomeOverviewScreen> {
  late Connectivity connectivity;
  late Future<List<PatientInfo>> futureTracks;
  late StreamSubscription<ConnectivityResult> subscription;

  Future<List<PatientInfo>> fetchPatients() async {
    final response = await http.get(
      Uri.parse(
        'https://dev.uneva.in/task_721/list.php',
      ),
    );

    if (response.statusCode == 200) {
      final patientInfo = patientInfoFromJson(response.body);
      return patientInfo;
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

  bool toggler = false;
  void switchButtonToggler(bool event) {
    if (event == true) {
      setState(() {
        toggler = true;
      });
    } else {
      setState(() {
        toggler = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('token'),
            SwitchScreen(
              toggleHandler: switchButtonToggler,
            ),
            Text('alphabet'),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchPatients(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            final data = snapshot.data;
            if (data == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black87,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  toggler == true
                      ? data.sort((a, b) {
                          return a.name.toString().compareTo(b.name.toString());
                        })
                      : data.sort((a, b) {
                          return int.parse(a.tokenName)
                              .compareTo(int.parse(b.tokenName));
                        });

                  var patient = data[index];

                  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
                      .format(patient.createdAt);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return PatientDetailsScreen(
                          pid: patient.other.pid.toString(),
                          pname: patient.name,
                        );
                      }));
                    },
                    child: Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                patient.name,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(patient.description),
                              leading: Text(
                                patient.tokenName,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0,
                                ),
                              ),
                              trailing: Icon(
                                Icons.location_city,
                              ),
                            ),
                            Text(formattedDate),
                          ],
                        ),
                      ),
                    ),
                  );
                  // );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
