# 📁 models/

Thư mục này chứa các Model thuần Dart, không phụ thuộc vào cơ sở dữ liệu (SQLite/Drift).

## Mục đích:
- Dùng cho UI, controller, logic ứng dụng
- Có thể thêm `fromJson`, `toJson`, `copyWith` nếu cần
- Tách biệt khỏi Drift để dễ dùng lại với API nếu có

## File:
- `habit_model.dart`: Thói quen
- `habit_status_model.dart`: Trạng thái hoàn thành theo ngày
- `mood_model.dart`: Ghi chú & cảm xúc hằng ngày
