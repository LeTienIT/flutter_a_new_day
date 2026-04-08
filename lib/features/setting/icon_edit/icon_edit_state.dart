import '../../../data/database/app_database.dart';

class FileIconState {
  final List<FileIcon> icons;
  final bool isLoading;
  final int selectedPage;

  const FileIconState({
    this.icons = const [],
    this.isLoading = false,
    this.selectedPage = 1,
  });

  FileIconState copyWith({
    List<FileIcon>? icons,
    bool? isLoading,
    int? selectedPage,
  }) {
    return FileIconState(
      selectedPage: selectedPage ?? this.selectedPage,
      icons: icons ?? this.icons,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}