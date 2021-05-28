import 'dart:async';

import 'package:flutter/material.dart';
import '../models/track_details_class.dart';
import '../models/track_lyrics_class.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class LyricsDetailsScreen extends StatefulWidget {
  // static const id = 'LyricsDetailsScreen';
  final int track_Id;
  final String track_Name;
  LyricsDetailsScreen({
    required this.track_Id,
    required this.track_Name,
  });
  @override
  _LyricsDetailsScreenState createState() => _LyricsDetailsScreenState();
}

class _LyricsDetailsScreenState extends State<LyricsDetailsScreen> {
  late Future<TrackDetails> trackDetailing;
  late Future<TrackLyrics> trackLyrics;
  // var _connectionStatus = 'Unknown';
  late Connectivity connectivity;
  // late Future<List<TrackList>> futureTracks;
  late StreamSubscription<ConnectivityResult> subscription;

  Future<TrackDetails> fetchTrackDetails(trackId) async {
    final response = await http.get(
      Uri.parse(
        'https://api.musixmatch.com/ws/1.1/track.get?track_id=${trackId}&apikey=ea94a519ff823a088d2606ce723af50b',
      ),
    );
    if (response.statusCode == 200) {
      final tracksDetails = trackDetailsFromJson(response.body);
      return tracksDetails;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<TrackLyrics> fetchTrackLyrics(trackId) async {
    final response = await http.get(
      Uri.parse(
        'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=${trackId}&apikey=ea94a519ff823a088d2606ce723af50b',
      ),
    );
    if (response.statusCode == 200) {
      final trackLyrics = trackLyricsFromJson(response.body);
      return trackLyrics;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    // trackDetailing = fetchTrackDetails(widget.track_Id);
    // trackLyrics = fetchTrackLyrics(widget.track_Id);
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
        centerTitle: true,
        title: Text(widget.track_Name),
        backgroundColor: Colors.yellow,
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0),
              margin: EdgeInsets.only(left: 15.0),
              child: Text(
                'General Details',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25.0,
                  color: Colors.black54,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: FutureBuilder(
                future: fetchTrackDetails(widget.track_Id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var data = snapshot.data;
                  if (data == null) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black87,
                      ),
                    );
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15.0),
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Track Name: ' + data.message.body.track.trackName,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Track Rating: ' +
                              data.message.body.track.trackRating.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Total favorites: ' +
                              data.message.body.track.numFavourite.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Album name: ' + data.message.body.track.albumName,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Artist name: ' + data.message.body.track.artistName,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Updated time: ' +
                              data.message.body.track.updatedTime.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        if (data.message.body.track.primaryGenres.musicGenreList
                                .length >
                            0)
                          Text(
                            'Music Genre name: ' +
                                data
                                    .message
                                    .body
                                    .track
                                    .primaryGenres
                                    .musicGenreList[0]
                                    .musicGenre
                                    .musicGenreName,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    );
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15.0),
              child: Text(
                'Track Lyrics',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25.0,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.50,
              child: FutureBuilder(
                future: fetchTrackLyrics(widget.track_Id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var data = snapshot.data;
                  if (data == null) {
                    return Container(
                        // height: 0.0,
                        );
                  } else {
                    return ListView(
                      padding: EdgeInsets.all(15.0),
                      children: [
                        Text(
                          data.message.body.lyrics.lyricsBody,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0,
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
