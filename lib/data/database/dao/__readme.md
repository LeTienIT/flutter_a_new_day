# 📁 dao/ – Data Access Objects (DAO)

Thư mục này chứa các class xử lý toàn bộ thao tác với cơ sở dữ liệu thông qua Drift.

## Mục đích:
- Gộp toàn bộ logic truy vấn dữ liệu (CRUD) của từng bảng.
- Tránh lặp lại code query ở nhiều nơi.
- Dễ mở rộng, dễ test và bảo trì.

## Mỗi file:
- Đại diện cho 1 nhóm bảng hoặc 1 tính năng cụ thể.
- Thường là class `@DriftAccessor(table: [...])`, chứa các hàm như:
    - `getAllHabits()`
    - `insertHabit()`
    - `deleteHabitStatusByDate(DateTime date)`
    - `watchHabitsOfToday()`

## Gợi ý:
- Nếu logic Habit phức tạp, có thể tách DAO riêng cho Habit và HabitStatus.

## Ví dụ:
- `habit_dao.dart`
- `mood_dao.dart`
