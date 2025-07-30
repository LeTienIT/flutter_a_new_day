// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatDaysMeta = const VerificationMeta(
    'repeatDays',
  );
  @override
  late final GeneratedColumn<String> repeatDays = GeneratedColumn<String>(
    'repeat_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    repeatDays,
    icon,
    color,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('repeat_days')) {
      context.handle(
        _repeatDaysMeta,
        repeatDays.isAcceptableOrUnknown(data['repeat_days']!, _repeatDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatDaysMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      repeatDays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}repeat_days'],
          )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final int id;
  final String name;
  final String repeatDays;
  final String? icon;
  final String? color;
  final DateTime createdAt;
  const Habit({
    required this.id,
    required this.name,
    required this.repeatDays,
    this.icon,
    this.color,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['repeat_days'] = Variable<String>(repeatDays);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      repeatDays: Value(repeatDays),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      repeatDays: serializer.fromJson<String>(json['repeatDays']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'repeatDays': serializer.toJson<String>(repeatDays),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Habit copyWith({
    int? id,
    String? name,
    String? repeatDays,
    Value<String?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
    DateTime? createdAt,
  }) => Habit(
    id: id ?? this.id,
    name: name ?? this.name,
    repeatDays: repeatDays ?? this.repeatDays,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
    createdAt: createdAt ?? this.createdAt,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      repeatDays:
          data.repeatDays.present ? data.repeatDays.value : this.repeatDays,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, repeatDays, icon, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.name == this.name &&
          other.repeatDays == this.repeatDays &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> repeatDays;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<DateTime> createdAt;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.repeatDays = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String repeatDays,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       repeatDays = Value(repeatDays);
  static Insertable<Habit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? repeatDays,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (repeatDays != null) 'repeat_days': repeatDays,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HabitsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? repeatDays,
    Value<String?>? icon,
    Value<String?>? color,
    Value<DateTime>? createdAt,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      repeatDays: repeatDays ?? this.repeatDays,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (repeatDays.present) {
      map['repeat_days'] = Variable<String>(repeatDays.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HabitStatusTable extends HabitStatus
    with TableInfo<$HabitStatusTable, HabitStatusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitStatusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitTitleMeta = const VerificationMeta(
    'habitTitle',
  );
  @override
  late final GeneratedColumn<String> habitTitle = GeneratedColumn<String>(
    'habit_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    habitTitle,
    date,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_status';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitStatusData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('habit_title')) {
      context.handle(
        _habitTitleMeta,
        habitTitle.isAcceptableOrUnknown(data['habit_title']!, _habitTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_habitTitleMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {habitId, date},
  ];
  @override
  HabitStatusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitStatusData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      habitId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}habit_id'],
          )!,
      habitTitle:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}habit_title'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      completed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}completed'],
          )!,
    );
  }

  @override
  $HabitStatusTable createAlias(String alias) {
    return $HabitStatusTable(attachedDatabase, alias);
  }
}

class HabitStatusData extends DataClass implements Insertable<HabitStatusData> {
  final int id;
  final int habitId;
  final String habitTitle;
  final DateTime date;
  final bool completed;
  const HabitStatusData({
    required this.id,
    required this.habitId,
    required this.habitTitle,
    required this.date,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_id'] = Variable<int>(habitId);
    map['habit_title'] = Variable<String>(habitTitle);
    map['date'] = Variable<DateTime>(date);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  HabitStatusCompanion toCompanion(bool nullToAbsent) {
    return HabitStatusCompanion(
      id: Value(id),
      habitId: Value(habitId),
      habitTitle: Value(habitTitle),
      date: Value(date),
      completed: Value(completed),
    );
  }

  factory HabitStatusData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitStatusData(
      id: serializer.fromJson<int>(json['id']),
      habitId: serializer.fromJson<int>(json['habitId']),
      habitTitle: serializer.fromJson<String>(json['habitTitle']),
      date: serializer.fromJson<DateTime>(json['date']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'habitId': serializer.toJson<int>(habitId),
      'habitTitle': serializer.toJson<String>(habitTitle),
      'date': serializer.toJson<DateTime>(date),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  HabitStatusData copyWith({
    int? id,
    int? habitId,
    String? habitTitle,
    DateTime? date,
    bool? completed,
  }) => HabitStatusData(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    habitTitle: habitTitle ?? this.habitTitle,
    date: date ?? this.date,
    completed: completed ?? this.completed,
  );
  HabitStatusData copyWithCompanion(HabitStatusCompanion data) {
    return HabitStatusData(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      habitTitle:
          data.habitTitle.present ? data.habitTitle.value : this.habitTitle,
      date: data.date.present ? data.date.value : this.date,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitStatusData(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('habitTitle: $habitTitle, ')
          ..write('date: $date, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, habitTitle, date, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitStatusData &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.habitTitle == this.habitTitle &&
          other.date == this.date &&
          other.completed == this.completed);
}

class HabitStatusCompanion extends UpdateCompanion<HabitStatusData> {
  final Value<int> id;
  final Value<int> habitId;
  final Value<String> habitTitle;
  final Value<DateTime> date;
  final Value<bool> completed;
  const HabitStatusCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.habitTitle = const Value.absent(),
    this.date = const Value.absent(),
    this.completed = const Value.absent(),
  });
  HabitStatusCompanion.insert({
    this.id = const Value.absent(),
    required int habitId,
    required String habitTitle,
    required DateTime date,
    this.completed = const Value.absent(),
  }) : habitId = Value(habitId),
       habitTitle = Value(habitTitle),
       date = Value(date);
  static Insertable<HabitStatusData> custom({
    Expression<int>? id,
    Expression<int>? habitId,
    Expression<String>? habitTitle,
    Expression<DateTime>? date,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (habitTitle != null) 'habit_title': habitTitle,
      if (date != null) 'date': date,
      if (completed != null) 'completed': completed,
    });
  }

  HabitStatusCompanion copyWith({
    Value<int>? id,
    Value<int>? habitId,
    Value<String>? habitTitle,
    Value<DateTime>? date,
    Value<bool>? completed,
  }) {
    return HabitStatusCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      habitTitle: habitTitle ?? this.habitTitle,
      date: date ?? this.date,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (habitTitle.present) {
      map['habit_title'] = Variable<String>(habitTitle.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitStatusCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('habitTitle: $habitTitle, ')
          ..write('date: $date, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

class $MoodsTable extends Moods with TableInfo<$MoodsTable, Mood> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioMeta = const VerificationMeta('audio');
  @override
  late final GeneratedColumn<String> audio = GeneratedColumn<String>(
    'audio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _videoMeta = const VerificationMeta('video');
  @override
  late final GeneratedColumn<String> video = GeneratedColumn<String>(
    'video',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    emoji,
    image,
    audio,
    video,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Mood> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('audio')) {
      context.handle(
        _audioMeta,
        audio.isAcceptableOrUnknown(data['audio']!, _audioMeta),
      );
    }
    if (data.containsKey('video')) {
      context.handle(
        _videoMeta,
        video.isAcceptableOrUnknown(data['video']!, _videoMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date},
  ];
  @override
  Mood map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mood(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      emoji:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}emoji'],
          )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      audio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio'],
      ),
      video: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $MoodsTable createAlias(String alias) {
    return $MoodsTable(attachedDatabase, alias);
  }
}

class Mood extends DataClass implements Insertable<Mood> {
  final int id;
  final DateTime date;
  final String emoji;
  final String? image;
  final String? audio;
  final String? video;
  final String? note;
  const Mood({
    required this.id,
    required this.date,
    required this.emoji,
    this.image,
    this.audio,
    this.video,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['emoji'] = Variable<String>(emoji);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || audio != null) {
      map['audio'] = Variable<String>(audio);
    }
    if (!nullToAbsent || video != null) {
      map['video'] = Variable<String>(video);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MoodsCompanion toCompanion(bool nullToAbsent) {
    return MoodsCompanion(
      id: Value(id),
      date: Value(date),
      emoji: Value(emoji),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      audio:
          audio == null && nullToAbsent ? const Value.absent() : Value(audio),
      video:
          video == null && nullToAbsent ? const Value.absent() : Value(video),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Mood.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mood(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      emoji: serializer.fromJson<String>(json['emoji']),
      image: serializer.fromJson<String?>(json['image']),
      audio: serializer.fromJson<String?>(json['audio']),
      video: serializer.fromJson<String?>(json['video']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'emoji': serializer.toJson<String>(emoji),
      'image': serializer.toJson<String?>(image),
      'audio': serializer.toJson<String?>(audio),
      'video': serializer.toJson<String?>(video),
      'note': serializer.toJson<String?>(note),
    };
  }

  Mood copyWith({
    int? id,
    DateTime? date,
    String? emoji,
    Value<String?> image = const Value.absent(),
    Value<String?> audio = const Value.absent(),
    Value<String?> video = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Mood(
    id: id ?? this.id,
    date: date ?? this.date,
    emoji: emoji ?? this.emoji,
    image: image.present ? image.value : this.image,
    audio: audio.present ? audio.value : this.audio,
    video: video.present ? video.value : this.video,
    note: note.present ? note.value : this.note,
  );
  Mood copyWithCompanion(MoodsCompanion data) {
    return Mood(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      image: data.image.present ? data.image.value : this.image,
      audio: data.audio.present ? data.audio.value : this.audio,
      video: data.video.present ? data.video.value : this.video,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mood(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('emoji: $emoji, ')
          ..write('image: $image, ')
          ..write('audio: $audio, ')
          ..write('video: $video, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, emoji, image, audio, video, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mood &&
          other.id == this.id &&
          other.date == this.date &&
          other.emoji == this.emoji &&
          other.image == this.image &&
          other.audio == this.audio &&
          other.video == this.video &&
          other.note == this.note);
}

class MoodsCompanion extends UpdateCompanion<Mood> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> emoji;
  final Value<String?> image;
  final Value<String?> audio;
  final Value<String?> video;
  final Value<String?> note;
  const MoodsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.emoji = const Value.absent(),
    this.image = const Value.absent(),
    this.audio = const Value.absent(),
    this.video = const Value.absent(),
    this.note = const Value.absent(),
  });
  MoodsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String emoji,
    this.image = const Value.absent(),
    this.audio = const Value.absent(),
    this.video = const Value.absent(),
    this.note = const Value.absent(),
  }) : date = Value(date),
       emoji = Value(emoji);
  static Insertable<Mood> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? emoji,
    Expression<String>? image,
    Expression<String>? audio,
    Expression<String>? video,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (emoji != null) 'emoji': emoji,
      if (image != null) 'image': image,
      if (audio != null) 'audio': audio,
      if (video != null) 'video': video,
      if (note != null) 'note': note,
    });
  }

  MoodsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? emoji,
    Value<String?>? image,
    Value<String?>? audio,
    Value<String?>? video,
    Value<String?>? note,
  }) {
    return MoodsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      emoji: emoji ?? this.emoji,
      image: image ?? this.image,
      audio: audio ?? this.audio,
      video: video ?? this.video,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (audio.present) {
      map['audio'] = Variable<String>(audio.value);
    }
    if (video.present) {
      map['video'] = Variable<String>(video.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('emoji: $emoji, ')
          ..write('image: $image, ')
          ..write('audio: $audio, ')
          ..write('video: $video, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $EmojiTableTable extends EmojiTable
    with TableInfo<$EmojiTableTable, EmojiTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmojiTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enableMeta = const VerificationMeta('enable');
  @override
  late final GeneratedColumn<bool> enable = GeneratedColumn<bool>(
    'enable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nangLuongMeta = const VerificationMeta(
    'nangLuong',
  );
  @override
  late final GeneratedColumn<int> nangLuong = GeneratedColumn<int>(
    'nang_luong',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, path, name, enable, nangLuong];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emoji_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmojiTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('enable')) {
      context.handle(
        _enableMeta,
        enable.isAcceptableOrUnknown(data['enable']!, _enableMeta),
      );
    }
    if (data.containsKey('nang_luong')) {
      context.handle(
        _nangLuongMeta,
        nangLuong.isAcceptableOrUnknown(data['nang_luong']!, _nangLuongMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmojiTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmojiTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      path:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}path'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      enable:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}enable'],
          )!,
      nangLuong:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}nang_luong'],
          )!,
    );
  }

  @override
  $EmojiTableTable createAlias(String alias) {
    return $EmojiTableTable(attachedDatabase, alias);
  }
}

class EmojiTableData extends DataClass implements Insertable<EmojiTableData> {
  final int id;
  final String path;
  final String name;
  final bool enable;
  final int nangLuong;
  const EmojiTableData({
    required this.id,
    required this.path,
    required this.name,
    required this.enable,
    required this.nangLuong,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    map['name'] = Variable<String>(name);
    map['enable'] = Variable<bool>(enable);
    map['nang_luong'] = Variable<int>(nangLuong);
    return map;
  }

  EmojiTableCompanion toCompanion(bool nullToAbsent) {
    return EmojiTableCompanion(
      id: Value(id),
      path: Value(path),
      name: Value(name),
      enable: Value(enable),
      nangLuong: Value(nangLuong),
    );
  }

  factory EmojiTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmojiTableData(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      name: serializer.fromJson<String>(json['name']),
      enable: serializer.fromJson<bool>(json['enable']),
      nangLuong: serializer.fromJson<int>(json['nangLuong']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'name': serializer.toJson<String>(name),
      'enable': serializer.toJson<bool>(enable),
      'nangLuong': serializer.toJson<int>(nangLuong),
    };
  }

  EmojiTableData copyWith({
    int? id,
    String? path,
    String? name,
    bool? enable,
    int? nangLuong,
  }) => EmojiTableData(
    id: id ?? this.id,
    path: path ?? this.path,
    name: name ?? this.name,
    enable: enable ?? this.enable,
    nangLuong: nangLuong ?? this.nangLuong,
  );
  EmojiTableData copyWithCompanion(EmojiTableCompanion data) {
    return EmojiTableData(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      name: data.name.present ? data.name.value : this.name,
      enable: data.enable.present ? data.enable.value : this.enable,
      nangLuong: data.nangLuong.present ? data.nangLuong.value : this.nangLuong,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmojiTableData(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('enable: $enable, ')
          ..write('nangLuong: $nangLuong')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, name, enable, nangLuong);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmojiTableData &&
          other.id == this.id &&
          other.path == this.path &&
          other.name == this.name &&
          other.enable == this.enable &&
          other.nangLuong == this.nangLuong);
}

class EmojiTableCompanion extends UpdateCompanion<EmojiTableData> {
  final Value<int> id;
  final Value<String> path;
  final Value<String> name;
  final Value<bool> enable;
  final Value<int> nangLuong;
  const EmojiTableCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.name = const Value.absent(),
    this.enable = const Value.absent(),
    this.nangLuong = const Value.absent(),
  });
  EmojiTableCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    required String name,
    this.enable = const Value.absent(),
    this.nangLuong = const Value.absent(),
  }) : path = Value(path),
       name = Value(name);
  static Insertable<EmojiTableData> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<String>? name,
    Expression<bool>? enable,
    Expression<int>? nangLuong,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (name != null) 'name': name,
      if (enable != null) 'enable': enable,
      if (nangLuong != null) 'nang_luong': nangLuong,
    });
  }

  EmojiTableCompanion copyWith({
    Value<int>? id,
    Value<String>? path,
    Value<String>? name,
    Value<bool>? enable,
    Value<int>? nangLuong,
  }) {
    return EmojiTableCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      enable: enable ?? this.enable,
      nangLuong: nangLuong ?? this.nangLuong,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (enable.present) {
      map['enable'] = Variable<bool>(enable.value);
    }
    if (nangLuong.present) {
      map['nang_luong'] = Variable<int>(nangLuong.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmojiTableCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('enable: $enable, ')
          ..write('nangLuong: $nangLuong')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitStatusTable habitStatus = $HabitStatusTable(this);
  late final $MoodsTable moods = $MoodsTable(this);
  late final $EmojiTableTable emojiTable = $EmojiTableTable(this);
  late final HabitDAO habitDAO = HabitDAO(this as AppDatabase);
  late final MoodDAO moodDAO = MoodDAO(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    habits,
    habitStatus,
    moods,
    emojiTable,
  ];
}

typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      required String name,
      required String repeatDays,
      Value<String?> icon,
      Value<String?> color,
      Value<DateTime> createdAt,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> repeatDays,
      Value<String?> icon,
      Value<String?> color,
      Value<DateTime> createdAt,
    });

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
          Habit,
          PrefetchHooks Function()
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> repeatDays = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                name: name,
                repeatDays: repeatDays,
                icon: icon,
                color: color,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String repeatDays,
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                name: name,
                repeatDays: repeatDays,
                icon: icon,
                color: color,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
      Habit,
      PrefetchHooks Function()
    >;
typedef $$HabitStatusTableCreateCompanionBuilder =
    HabitStatusCompanion Function({
      Value<int> id,
      required int habitId,
      required String habitTitle,
      required DateTime date,
      Value<bool> completed,
    });
typedef $$HabitStatusTableUpdateCompanionBuilder =
    HabitStatusCompanion Function({
      Value<int> id,
      Value<int> habitId,
      Value<String> habitTitle,
      Value<DateTime> date,
      Value<bool> completed,
    });

class $$HabitStatusTableFilterComposer
    extends Composer<_$AppDatabase, $HabitStatusTable> {
  $$HabitStatusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habitTitle => $composableBuilder(
    column: $table.habitTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitStatusTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitStatusTable> {
  $$HabitStatusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habitTitle => $composableBuilder(
    column: $table.habitTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitStatusTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitStatusTable> {
  $$HabitStatusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get habitTitle => $composableBuilder(
    column: $table.habitTitle,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);
}

class $$HabitStatusTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitStatusTable,
          HabitStatusData,
          $$HabitStatusTableFilterComposer,
          $$HabitStatusTableOrderingComposer,
          $$HabitStatusTableAnnotationComposer,
          $$HabitStatusTableCreateCompanionBuilder,
          $$HabitStatusTableUpdateCompanionBuilder,
          (
            HabitStatusData,
            BaseReferences<_$AppDatabase, $HabitStatusTable, HabitStatusData>,
          ),
          HabitStatusData,
          PrefetchHooks Function()
        > {
  $$HabitStatusTableTableManager(_$AppDatabase db, $HabitStatusTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$HabitStatusTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$HabitStatusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$HabitStatusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> habitId = const Value.absent(),
                Value<String> habitTitle = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => HabitStatusCompanion(
                id: id,
                habitId: habitId,
                habitTitle: habitTitle,
                date: date,
                completed: completed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int habitId,
                required String habitTitle,
                required DateTime date,
                Value<bool> completed = const Value.absent(),
              }) => HabitStatusCompanion.insert(
                id: id,
                habitId: habitId,
                habitTitle: habitTitle,
                date: date,
                completed: completed,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitStatusTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitStatusTable,
      HabitStatusData,
      $$HabitStatusTableFilterComposer,
      $$HabitStatusTableOrderingComposer,
      $$HabitStatusTableAnnotationComposer,
      $$HabitStatusTableCreateCompanionBuilder,
      $$HabitStatusTableUpdateCompanionBuilder,
      (
        HabitStatusData,
        BaseReferences<_$AppDatabase, $HabitStatusTable, HabitStatusData>,
      ),
      HabitStatusData,
      PrefetchHooks Function()
    >;
typedef $$MoodsTableCreateCompanionBuilder =
    MoodsCompanion Function({
      Value<int> id,
      required DateTime date,
      required String emoji,
      Value<String?> image,
      Value<String?> audio,
      Value<String?> video,
      Value<String?> note,
    });
typedef $$MoodsTableUpdateCompanionBuilder =
    MoodsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> emoji,
      Value<String?> image,
      Value<String?> audio,
      Value<String?> video,
      Value<String?> note,
    });

class $$MoodsTableFilterComposer extends Composer<_$AppDatabase, $MoodsTable> {
  $$MoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audio => $composableBuilder(
    column: $table.audio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get video => $composableBuilder(
    column: $table.video,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodsTable> {
  $$MoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audio => $composableBuilder(
    column: $table.audio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get video => $composableBuilder(
    column: $table.video,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodsTable> {
  $$MoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get audio =>
      $composableBuilder(column: $table.audio, builder: (column) => column);

  GeneratedColumn<String> get video =>
      $composableBuilder(column: $table.video, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$MoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodsTable,
          Mood,
          $$MoodsTableFilterComposer,
          $$MoodsTableOrderingComposer,
          $$MoodsTableAnnotationComposer,
          $$MoodsTableCreateCompanionBuilder,
          $$MoodsTableUpdateCompanionBuilder,
          (Mood, BaseReferences<_$AppDatabase, $MoodsTable, Mood>),
          Mood,
          PrefetchHooks Function()
        > {
  $$MoodsTableTableManager(_$AppDatabase db, $MoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> audio = const Value.absent(),
                Value<String?> video = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => MoodsCompanion(
                id: id,
                date: date,
                emoji: emoji,
                image: image,
                audio: audio,
                video: video,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String emoji,
                Value<String?> image = const Value.absent(),
                Value<String?> audio = const Value.absent(),
                Value<String?> video = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => MoodsCompanion.insert(
                id: id,
                date: date,
                emoji: emoji,
                image: image,
                audio: audio,
                video: video,
                note: note,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodsTable,
      Mood,
      $$MoodsTableFilterComposer,
      $$MoodsTableOrderingComposer,
      $$MoodsTableAnnotationComposer,
      $$MoodsTableCreateCompanionBuilder,
      $$MoodsTableUpdateCompanionBuilder,
      (Mood, BaseReferences<_$AppDatabase, $MoodsTable, Mood>),
      Mood,
      PrefetchHooks Function()
    >;
typedef $$EmojiTableTableCreateCompanionBuilder =
    EmojiTableCompanion Function({
      Value<int> id,
      required String path,
      required String name,
      Value<bool> enable,
      Value<int> nangLuong,
    });
typedef $$EmojiTableTableUpdateCompanionBuilder =
    EmojiTableCompanion Function({
      Value<int> id,
      Value<String> path,
      Value<String> name,
      Value<bool> enable,
      Value<int> nangLuong,
    });

class $$EmojiTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmojiTableTable> {
  $$EmojiTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enable => $composableBuilder(
    column: $table.enable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nangLuong => $composableBuilder(
    column: $table.nangLuong,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmojiTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmojiTableTable> {
  $$EmojiTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enable => $composableBuilder(
    column: $table.enable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nangLuong => $composableBuilder(
    column: $table.nangLuong,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmojiTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmojiTableTable> {
  $$EmojiTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get enable =>
      $composableBuilder(column: $table.enable, builder: (column) => column);

  GeneratedColumn<int> get nangLuong =>
      $composableBuilder(column: $table.nangLuong, builder: (column) => column);
}

class $$EmojiTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmojiTableTable,
          EmojiTableData,
          $$EmojiTableTableFilterComposer,
          $$EmojiTableTableOrderingComposer,
          $$EmojiTableTableAnnotationComposer,
          $$EmojiTableTableCreateCompanionBuilder,
          $$EmojiTableTableUpdateCompanionBuilder,
          (
            EmojiTableData,
            BaseReferences<_$AppDatabase, $EmojiTableTable, EmojiTableData>,
          ),
          EmojiTableData,
          PrefetchHooks Function()
        > {
  $$EmojiTableTableTableManager(_$AppDatabase db, $EmojiTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EmojiTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EmojiTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$EmojiTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> enable = const Value.absent(),
                Value<int> nangLuong = const Value.absent(),
              }) => EmojiTableCompanion(
                id: id,
                path: path,
                name: name,
                enable: enable,
                nangLuong: nangLuong,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String path,
                required String name,
                Value<bool> enable = const Value.absent(),
                Value<int> nangLuong = const Value.absent(),
              }) => EmojiTableCompanion.insert(
                id: id,
                path: path,
                name: name,
                enable: enable,
                nangLuong: nangLuong,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmojiTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmojiTableTable,
      EmojiTableData,
      $$EmojiTableTableFilterComposer,
      $$EmojiTableTableOrderingComposer,
      $$EmojiTableTableAnnotationComposer,
      $$EmojiTableTableCreateCompanionBuilder,
      $$EmojiTableTableUpdateCompanionBuilder,
      (
        EmojiTableData,
        BaseReferences<_$AppDatabase, $EmojiTableTable, EmojiTableData>,
      ),
      EmojiTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitStatusTableTableManager get habitStatus =>
      $$HabitStatusTableTableManager(_db, _db.habitStatus);
  $$MoodsTableTableManager get moods =>
      $$MoodsTableTableManager(_db, _db.moods);
  $$EmojiTableTableTableManager get emojiTable =>
      $$EmojiTableTableTableManager(_db, _db.emojiTable);
}
