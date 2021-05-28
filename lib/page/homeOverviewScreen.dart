import 'package:flutter/material.dart';
import '../models/dart_json_class.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import './lyrics_details_screen.dart';
import 'package:connectivity/connectivity.dart';

class HomeOverviewScreen extends StatefulWidget {
  // static const id = 'HomeOverviewScreen';
  @override
  _HomeOverviewScreenState createState() => _HomeOverviewScreenState();
}

class _HomeOverviewScreenState extends State<HomeOverviewScreen> {
  // var _connectionStatus = 'Unknown';
  late Connectivity connectivity;
  late Future<List<TrackList>> futureTracks;
  late StreamSubscription<ConnectivityResult> subscription;
  // var netOff;

  Future<List<TrackList>> fetchTracks() async {
    final response = await http.get(
      Uri.parse(
        'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=ea94a519ff823a088d2606ce723af50b',
      ),
    );
    if (response.statusCode == 200) {
      final tracks = tracksFromJson(response.body);

      return tracks.message.body.trackList;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    // futureTracks = ;
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult event) {
      // _connectionStatus = event.toString();
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
        title: Text('Trending'),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchTracks(),
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
                  var track = data[index].track;
                  if (track.hasLyrics == 0) {
                    return Container(
                      height: 0.0,
                    );
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return LyricsDetailsScreen(
                          track_Id: track.trackId,
                          track_Name: track.trackName,
                        );
                      }));
                    },
                    child: Card(
                      elevation: 5.0,
                      child: ListTile(
                        title: Text(track.trackName),
                        subtitle: Text(track.albumName),
                        leading: Icon(Icons.music_note),
                        trailing: Text(track.artistName),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
