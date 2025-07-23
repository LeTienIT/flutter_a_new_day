import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a_new_day/data/database/dao/emoji_dao.dart';
import 'package:a_new_day/data/models/emoji_model.dart';
import 'package:a_new_day/data/database/providers/database_providers.dart'; // để lấy appDatabaseProvider

final emojiRepositoryProvider = Provider<EmojiRepository>((ref) {
  final emojiDao = ref.read(emojiDaoProvider); // dùng dao đã khai báo
  return EmojiRepository(emojiDao);
});

class EmojiRepository {
  final EmojiDAO emojiDao;
  List<EmojiModel>? _cachedEmojis;

  EmojiRepository(this.emojiDao);

  Future<List<EmojiModel>> getEmojis() async {
    if (_cachedEmojis != null) return _cachedEmojis!;
    _cachedEmojis = await emojiDao.getAllEmoji();
    return _cachedEmojis!;
  }
}

class EmojiNotifier extends AsyncNotifier<List<EmojiModel>> {
  late final EmojiRepository repo;

  @override
  Future<List<EmojiModel>> build() async {
    repo = ref.read(emojiRepositoryProvider);
    return repo.getEmojis();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final emojis = await repo.getEmojis();
      state = AsyncValue.data(emojis);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final emojisNotifierProvider = AsyncNotifierProvider<EmojiNotifier, List<EmojiModel>>(EmojiNotifier.new);
