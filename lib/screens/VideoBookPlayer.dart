import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';

// ignore: must_be_immutable
class VideoBookPlayer extends StatefulWidget {
  DownloadModel downloads;

  VideoBookPlayer(this.downloads);

  @override
  _VideoBookPlayerState createState() => _VideoBookPlayerState();
}

class _VideoBookPlayerState extends State<VideoBookPlayer> {
  late VideoPlayerController _videoPlayerController1;
  late ChewieController _chewieController;

  bool fileExist = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(widget.downloads.file!);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
      placeholder: Container(color: screenBackgroundColor),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  checkFileIsExist() async {
    fileExist = await isFileExist(widget.downloads);
    setState(() {});
    if (fileExist) {
      log("Play from Local File");
      _videoPlayerController1 = VideoPlayerController.file(await getFilePathFile(widget.downloads));
    } else {
      log("Play from Server");
      _videoPlayerController1 = VideoPlayerController.network(widget.downloads.file!);
    }
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
      placeholder: Container(color: screenBackgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, title: widget.downloads.name),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(child: Chewie(controller: _chewieController)),
          ),
        ],
      ),
    );
  }
}
