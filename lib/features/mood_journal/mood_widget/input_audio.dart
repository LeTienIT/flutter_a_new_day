import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/tool.dart';

class AudioRecorderWidget extends StatefulWidget {
  late String? initialAudioPath;
  final ValueChanged<String?> onAudioSaved;

  bool enableEdit;

   AudioRecorderWidget({
    super.key,
    this.initialAudioPath,
    required this.onAudioSaved,this.enableEdit = true
  });

  @override
  _AudioRecorderWidgetState createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  late FlutterSoundRecorder _recorder;
  late FlutterSoundPlayer _player;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _tempAudioPath;
  String? _currentAudioPath;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  StreamSubscription<PlaybackDisposition>? _playerSub;
  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;
  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder(logLevel: Level.off);
    _player = FlutterSoundPlayer(logLevel: Level.off);
    _initAudio();
    _currentAudioPath = widget.initialAudioPath;
  }

  Future<void> _initAudio() async {
    try{
      await _recorder.openRecorder();
    }catch(e){
      print("Lỗi open recorder: $e");
    }

    await _player.openPlayer();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _startRecording() async {
    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/audio_temp_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );

      widget.onAudioSaved(path);

      setState(() {
        _isRecording = true;
        _tempAudioPath = path;
        _currentAudioPath = null;
        _recordDuration = Duration.zero;
      });
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordDuration += const Duration(seconds: 1);
        });
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _currentAudioPath = _tempAudioPath;
      });
      widget.onAudioSaved(_tempAudioPath!);
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _playAudio() async {
    if (_currentAudioPath == null) return;
    await _player.setSubscriptionDuration(const Duration(milliseconds: 200));
    try {
      await _player.startPlayer(
        fromURI: _currentAudioPath!,
        codec: Codec.aacADTS,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
            _currentPosition = Duration.zero;
          });
        },
      );
      _playerSub = _player.onProgress!.listen((e) {
        setState(() {
          _currentPosition = e.position;
          _totalDuration = e.duration;
        });
      });
      setState(() => _isPlaying = true);
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> _stopPlaying() async {
    await _player.stopPlayer();
    _playerSub?.cancel();
    setState(() => _isPlaying = false);
  }

  Future<void> _deleteAudio() async {
    // if (_currentAudioPath != null && await File(_currentAudioPath!).exists()) {
    //   await File(_currentAudioPath!).delete();
    // }

    setState(() {
      _currentAudioPath = null;
      widget.initialAudioPath = null;
      widget.onAudioSaved(null);
    });
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_currentAudioPath == null && widget.initialAudioPath == null && !_isRecording && widget.enableEdit)
              Text(
                'Âm thanh của trái tim',
                style: Theme.of(context).textTheme.titleMedium,
              )
            else if ((_currentAudioPath != null || widget.initialAudioPath != null) && !_isRecording)
              Text(
                '${_currentAudioPath != null ? _currentAudioPath?.split('/').last : 'Không có file'}',
                style: Theme.of(context).textTheme.titleMedium,
              )
            else if (_isRecording)
                Text(
                  'Đang ghi âm... ${formatDuration(_recordDuration)}',
                  style: TextStyle(color: Colors.red),
                )
              else
                const Text('Chưa có bản ghi âm'),

            if (_isPlaying || _currentPosition > Duration.zero)
              Text(
                '${formatDuration(_currentPosition)} / ${formatDuration(_totalDuration)}',
                style: const TextStyle(fontSize: 14),
              ),
            const SizedBox(height: 16),

            // Nút điều khiển
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút ghi âm/dừng
                if(!_isPlaying && widget.enableEdit)
                  IconButton(
                    icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                    color: _isRecording ? Colors.red : Colors.blue,
                    onPressed: () {
                      if (_isRecording) {
                        _stopRecording();
                      } else {
                        _startRecording();
                      }
                    },
                  ),

                // Nút phát/dừng (chỉ hiện khi có audio)
                if ((_currentAudioPath != null || widget.initialAudioPath != null) && !_isRecording)
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                    color: Colors.green,
                    onPressed: () {
                      if (_isPlaying) {
                        _stopPlaying();
                      } else {
                        _playAudio();
                      }
                    },
                  ),
              ],
            ),

            const SizedBox(height: 16),

            if ((_currentAudioPath != null || _isRecording) && widget.enableEdit)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _isRecording ? null : _deleteAudio,
                    child: const Text('Xóa file'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}