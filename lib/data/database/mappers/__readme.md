# 📁 mappers/ – Chuyển đổi dữ liệu giữa Drift và Model UI

Thư mục này chứa các extension/hàm để chuyển đổi dữ liệu giữa:

✅ `HabitData` (từ Drift) ⇄ `HabitModel` (dùng cho UI, controller)

## Mục đích:
- Tách logic chuyển đổi khỏi DAO/Controller
- Tránh phụ thuộc trực tiếp Drift trong tầng UI
- Dễ test, dễ reuse

## Trong mỗi file:
- Extension: `HabitData.toModel()`
- Extension: `HabitModel.toCompanion()` để insert/update vào Drift

## Ví dụ:
```dart
extension HabitMapper on HabitData {
  HabitModel toModel() => HabitModel(
    id: id,
    title: title,
    repeatOnDays: jsonDecode(repeatOnDays),
    ...
  );
}

extension HabitModelMapper on HabitModel {
  HabitsCompanion toCompanion() => HabitsCompanion(
    id: Value(id),
    title: Value(title),
    repeatOnDays: Value(jsonEncode(repeatOnDays)),
  );
}
