import 'package:a_new_day/data/database/providers/database_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/show_dialog.dart';
import '../../../core/utils/tool.dart';
import '../../../data/models/mood_model.dart';
import '../emoji_repository.dart';
import '../mood_list/mood_list_controller.dart';
import '../mood_widget/input_audio.dart';
import '../mood_widget/pick_image.dart';
import '../mood_widget/video_input.dart';

class AddMoodScreen extends ConsumerStatefulWidget {
  const AddMoodScreen({super.key});

  @override
  ConsumerState<AddMoodScreen> createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends ConsumerState<AddMoodScreen> {
  String? selectedEmojiPath;
  String slogan = '';
  String note = '';
  final _sloganController = TextEditingController();
  final _noteController = TextEditingController();

  String? iconPath , _savedAudioPath, videoPath ;


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
      appBar: AppBar(title: const Text('Ghi lại cảm xúc hôm nay')),
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
                  formatVietnameseDate(DateTime.now()),
                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                const Text('Tâm trạng của bạn?', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: emojis.map((emoji) {
                    final isSelected = selectedEmojiPath == emoji.path;
                    return ChoiceChip(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      avatar: Image.asset(emoji.path, width: 20, height: 20),
                      label: Text(
                        emoji.name,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.blue,
                      onSelected: (_) {
                        setState(() {
                          selectedEmojiPath = emoji.path;
                          slogan = emoji.name;
                          _sloganController.text = emoji.name;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _sloganController,
                  decoration: const InputDecoration(
                    labelText: 'Hôm nay thế nào?',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => slogan = val,
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _noteController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Có nên ghi lại nhật ký không?',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => note = val,
                ),

                const SizedBox(height: 30),

                ImageInput(
                  initialIconPath: '',
                  onIconPicked: (path) {
                    if(path!=null){
                      iconPath = path;
                      // print("Đã nhận ảnh: $iconPath");
                    }
                  },
                ),
                const SizedBox(height: 30),

                VideoInput(
                    initialVideoPath: videoPath,
                    onVideoPicked: (path){
                      if(path!=null){
                        videoPath = path;
                      }
                }),

                const SizedBox(height: 30),

                AudioRecorderWidget(
                  initialAudioPath: _savedAudioPath,
                  onAudioSaved: (path) {
                    setState(() {
                      _savedAudioPath = path;
                      // print("Đã nhận file: $_savedAudioPath");
                    });
                    // print('Đường dẫn audio đã lưu: $path');
                  },
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedEmojiPath == null || slogan.isEmpty ? null : () async {
                      if(selectedEmojiPath?.isEmpty == true || slogan?.isEmpty == true){
                        await CustomDialog.showMessageDialog(
                            context: context,
                            title: 'Lỗi!',
                            message: '- Biểu tượng cảm xúc\n\n "- Hôm nay thế nào" \n\n LÀ HAI DỮ LIỆU BẮT BUỘC - KHÔNG ĐỂ TRỐNG'
                        );
                        return;
                      }
                      final newMood = MoodModel(
                        date: DateTime.now(),
                        emoji: '$selectedEmojiPath|$slogan',
                        note: note.isEmpty ? null : note,
                        image: iconPath ?? null,
                        audio: _savedAudioPath ?? null,
                        video: videoPath ?? null,
                      );
                      // print(newMood.toString());
                      await ref.read(moodListProvider.notifier).insertMood(newMood);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nhật ký đã được lưu trữ')));
                      Navigator.pushNamedAndRemoveUntil(context, '/mood-home', (router)=>false);
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
