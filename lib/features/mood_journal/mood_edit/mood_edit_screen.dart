import 'package:a_new_day/data/database/providers/database_providers.dart';
import 'package:a_new_day/features/mood_journal/mood_widget/video_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/tool.dart';
import '../../../data/models/mood_model.dart';
import '../emoji_repository.dart';
import '../mood_list/mood_list_controller.dart';
import '../mood_widget/input_audio.dart';
import '../mood_widget/pick_image.dart';

class MoodEditScreen extends ConsumerStatefulWidget {
  MoodModel mood;
  MoodEditScreen({super.key, required this.mood});

  @override
  ConsumerState<MoodEditScreen> createState() => _MoodEditScreenState();
}

class _MoodEditScreenState extends ConsumerState<MoodEditScreen> {
  String? selectedEmojiPath;
  String slogan = '';
  String note = '';
  late TextEditingController _sloganController;
  late TextEditingController _noteController;

  String? iconPath , _savedAudioPath, videoPath ;

  @override
  void initState() {
    final parts = widget.mood.emoji.split('|');
    final imagePath = parts.first;
    slogan = parts.length > 1 ? parts.last : '';
    _sloganController = TextEditingController(text: slogan);
    _noteController = TextEditingController(text: widget.mood.note);
    selectedEmojiPath = imagePath;
    iconPath = widget.mood.image;
    _savedAudioPath = widget.mood.audio;
    videoPath = widget.mood.video;
    // print(("load edit: ${widget.mood.toString()}"));
    super.initState();
  }
  @override
  void dispose() {
    _sloganController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emojiAsync = ref.watch(emojisNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa nhật ký')),
      body: emojiAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Lỗi tải emoji: $e')),
        data: (emojis) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatVietnameseDate(widget.mood.date),
                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    final maxChipWidth = (screenWidth - 3 * 6) / 3;

                    return Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: emojis.map((emoji) {
                        final isSelected = selectedEmojiPath == emoji.path;
                        return ChoiceChip(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          avatar: Image.asset(emoji.path, width: 20, height: 20),
                          label: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxChipWidth),
                            child: Text(
                              emoji.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[200],
                          onSelected: (_) {
                            setState(() {
                              selectedEmojiPath = emoji.path;
                              slogan = emoji.name;
                              _sloganController.text = emoji.name;
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _sloganController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Hôm nay thế nào?',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => slogan = val,
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _noteController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Nhật ký',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => note = val,
                ),

                const SizedBox(height: 30),

                ImageInput(
                  initialIconPath: iconPath,
                  onIconPicked: (path) {
                    iconPath = path;
                  },
                ),
                const SizedBox(height: 30),

                VideoInput(
                  initialVideoPath: videoPath,
                  onVideoPicked: (path){
                    videoPath = path;
                }),

                const SizedBox(height: 30),

                AudioRecorderWidget(
                  initialAudioPath: _savedAudioPath,
                  onAudioSaved: (path) {
                    setState(() {
                      _savedAudioPath = path;
                    });
                  },
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedEmojiPath == null || slogan.isEmpty ? null : () async {
                      final newMood = MoodModel(
                        id: widget.mood.id,
                        date: widget.mood.date,
                        emoji: '$selectedEmojiPath|$slogan',
                        note: _noteController.text.isEmpty ? null : _noteController.text,
                        image: iconPath ?? null,
                        audio: _savedAudioPath ?? null,
                        video: videoPath ?? null,
                      );
                      // print('mood: ${widget.mood.toString()}\nnew: ${newMood.toString()}');
                      await ref.read(moodListProvider.notifier).updateMood(widget.mood, newMood);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nhật ký đã được cập nhật')));
                      // Navigator.pushNamedAndRemoveUntil(context, '/mood-home', (router)=>false);
                    },
                    child: const Text('Lưu nhật ký'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
