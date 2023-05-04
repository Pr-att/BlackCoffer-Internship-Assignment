import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;

import '../services/networkVideoPlayer.dart';

const kURI = "https://www.youtube.com/watch?v=";

class VideoPage extends StatelessWidget with ChangeNotifier {
  VideoPage({Key? key}) : super(key: key);

  void exportCsv() async {
    final CollectionReference videos =
        FirebaseFirestore.instance.collection('youtube-videos');
    // final data = await rootBundle.loadString('assets/youtube.csv');
    //
    // List<List<dynamic>> csvTable = const CsvToListConverter().convert(data);
    // List<List<dynamic>> myData = [];
    // myData = csvTable;
    //
    // for (var i = 0; i < myData.length; i++) {
    //   var record = {
    //     "video_id": myData[i][0],
    //     "last_trending_date": myData[i][1],
    //     "publish_date": myData[i][2],
    //     "publish_hour": myData[i][3],
    //     "category_id": myData[i][4],
    //     "channel_title": myData[i][5],
    //     "views": myData[i][6],
    //     "likes": myData[i][7],
    //     "dislikes": myData[i][8],
    //     "comment_count": myData[i][9],
    //     "comments_disabled": myData[i][10],
    //     "ratings_disabled": myData[i][11],
    //     "tag_appeared_in_title_count": myData[i][12],
    //     "tag_appeared_in_title": myData[i][13],
    //     "title": myData[i][14],
    //     "tags": myData[i][15],
    //     "description": myData[i][16],
    //     "trend_day_count": myData[i][17],
    //     "trend.publish.diff": myData[i][18],
    //     "trend_tag_highest": myData[i][19],
    //     "trend_tag_total": myData[i][20],
    //     "tags_count": myData[i][21],
    //     "subscriber": myData[i][22],
    //   };
    //   await videos.add(record);
    //   print("Added Successfully");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Video Page'),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Filter'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('youtube-videos')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                onLongPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NetworkVideo(
                                              title: data['title'],
                                              views: data['views'],
                                              daysAgo: data['publish_date'],
                                              category: data['category_id'],
                                            ),),
                                  );
                                },
                                leading: const Icon(Icons.video_collection),
                                title: Text(data['title']),
                                subtitle: Text(
                                    'Views: ${(data['views'] / 1000000).toString()}M'),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     TextButton(
                              //       onPressed: () {
                              //         Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //             builder: (context) => VideoPlayerScreen(
                              //               videoUrl: URI + data['video_id'],
                              //             ),
                              //           ),
                              //         );
                              //       },
                              //       child: const Text('Play'),
                              //     ),
                              //     TextButton(
                              //       onPressed: () {},
                              //       child: const Text('Add to Playlist'),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: Align(
      //   alignment: Alignment.bottomCenter,
      //   child: FloatingActionButton(
      //     onPressed: () async {
      //       // exportCsv();
      //       FilePickerResult? result = await FilePicker.platform.pickFiles();
      //
      //       if (result != null) {
      //         File file = File(result.files.single.path!!);
      //       } else {
      //         // User canceled the picker
      //       }
      //     },
      //
      //     child: const Icon(Icons.add),
      //   ),
      // ),
    );
  }
}

class AssetVideo extends StatefulWidget {
  const AssetVideo({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  State<AssetVideo> createState() => _AssetVideoState();
}

class _AssetVideoState extends State<AssetVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
