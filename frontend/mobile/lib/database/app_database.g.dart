// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedFestivalsTable extends CachedFestivals
    with TableInfo<$CachedFestivalsTable, CachedFestival> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedFestivalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _organiserNameMeta = const VerificationMeta(
    'organiserName',
  );
  @override
  late final GeneratedColumn<String> organiserName = GeneratedColumn<String>(
    'organiser_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _organiserProfilePictureMeta =
      const VerificationMeta('organiserProfilePicture');
  @override
  late final GeneratedColumn<String> organiserProfilePicture =
      GeneratedColumn<String>(
        'organiser_profile_picture',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    startDate,
    endDate,
    image,
    organiserName,
    organiserProfilePicture,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_festivals';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedFestival> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('organiser_name')) {
      context.handle(
        _organiserNameMeta,
        organiserName.isAcceptableOrUnknown(
          data['organiser_name']!,
          _organiserNameMeta,
        ),
      );
    }
    if (data.containsKey('organiser_profile_picture')) {
      context.handle(
        _organiserProfilePictureMeta,
        organiserProfilePicture.isAcceptableOrUnknown(
          data['organiser_profile_picture']!,
          _organiserProfilePictureMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedFestival map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedFestival(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      organiserName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organiser_name'],
      )!,
      organiserProfilePicture: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organiser_profile_picture'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $CachedFestivalsTable createAlias(String alias) {
    return $CachedFestivalsTable(attachedDatabase, alias);
  }
}

class CachedFestival extends DataClass implements Insertable<CachedFestival> {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String? image;
  final String organiserName;
  final String? organiserProfilePicture;
  final DateTime syncedAt;
  const CachedFestival({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.image,
    required this.organiserName,
    this.organiserProfilePicture,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    map['organiser_name'] = Variable<String>(organiserName);
    if (!nullToAbsent || organiserProfilePicture != null) {
      map['organiser_profile_picture'] = Variable<String>(
        organiserProfilePicture,
      );
    }
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  CachedFestivalsCompanion toCompanion(bool nullToAbsent) {
    return CachedFestivalsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      startDate: Value(startDate),
      endDate: Value(endDate),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      organiserName: Value(organiserName),
      organiserProfilePicture: organiserProfilePicture == null && nullToAbsent
          ? const Value.absent()
          : Value(organiserProfilePicture),
      syncedAt: Value(syncedAt),
    );
  }

  factory CachedFestival.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedFestival(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      image: serializer.fromJson<String?>(json['image']),
      organiserName: serializer.fromJson<String>(json['organiserName']),
      organiserProfilePicture: serializer.fromJson<String?>(
        json['organiserProfilePicture'],
      ),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'image': serializer.toJson<String?>(image),
      'organiserName': serializer.toJson<String>(organiserName),
      'organiserProfilePicture': serializer.toJson<String?>(
        organiserProfilePicture,
      ),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  CachedFestival copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    Value<String?> image = const Value.absent(),
    String? organiserName,
    Value<String?> organiserProfilePicture = const Value.absent(),
    DateTime? syncedAt,
  }) => CachedFestival(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    image: image.present ? image.value : this.image,
    organiserName: organiserName ?? this.organiserName,
    organiserProfilePicture: organiserProfilePicture.present
        ? organiserProfilePicture.value
        : this.organiserProfilePicture,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  CachedFestival copyWithCompanion(CachedFestivalsCompanion data) {
    return CachedFestival(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      image: data.image.present ? data.image.value : this.image,
      organiserName: data.organiserName.present
          ? data.organiserName.value
          : this.organiserName,
      organiserProfilePicture: data.organiserProfilePicture.present
          ? data.organiserProfilePicture.value
          : this.organiserProfilePicture,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedFestival(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('image: $image, ')
          ..write('organiserName: $organiserName, ')
          ..write('organiserProfilePicture: $organiserProfilePicture, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    startDate,
    endDate,
    image,
    organiserName,
    organiserProfilePicture,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedFestival &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.image == this.image &&
          other.organiserName == this.organiserName &&
          other.organiserProfilePicture == this.organiserProfilePicture &&
          other.syncedAt == this.syncedAt);
}

class CachedFestivalsCompanion extends UpdateCompanion<CachedFestival> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String?> image;
  final Value<String> organiserName;
  final Value<String?> organiserProfilePicture;
  final Value<DateTime> syncedAt;
  const CachedFestivalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.image = const Value.absent(),
    this.organiserName = const Value.absent(),
    this.organiserProfilePicture = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  CachedFestivalsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    this.image = const Value.absent(),
    this.organiserName = const Value.absent(),
    this.organiserProfilePicture = const Value.absent(),
    required DateTime syncedAt,
  }) : name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate),
       syncedAt = Value(syncedAt);
  static Insertable<CachedFestival> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? image,
    Expression<String>? organiserName,
    Expression<String>? organiserProfilePicture,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (image != null) 'image': image,
      if (organiserName != null) 'organiser_name': organiserName,
      if (organiserProfilePicture != null)
        'organiser_profile_picture': organiserProfilePicture,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  CachedFestivalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String?>? image,
    Value<String>? organiserName,
    Value<String?>? organiserProfilePicture,
    Value<DateTime>? syncedAt,
  }) {
    return CachedFestivalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      image: image ?? this.image,
      organiserName: organiserName ?? this.organiserName,
      organiserProfilePicture:
          organiserProfilePicture ?? this.organiserProfilePicture,
      syncedAt: syncedAt ?? this.syncedAt,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (organiserName.present) {
      map['organiser_name'] = Variable<String>(organiserName.value);
    }
    if (organiserProfilePicture.present) {
      map['organiser_profile_picture'] = Variable<String>(
        organiserProfilePicture.value,
      );
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedFestivalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('image: $image, ')
          ..write('organiserName: $organiserName, ')
          ..write('organiserProfilePicture: $organiserProfilePicture, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $CachedStagesTable extends CachedStages
    with TableInfo<$CachedStagesTable, CachedStage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedStagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _festivalIdMeta = const VerificationMeta(
    'festivalId',
  );
  @override
  late final GeneratedColumn<int> festivalId = GeneratedColumn<int>(
    'festival_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cached_festivals (id) ON DELETE CASCADE',
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
  @override
  List<GeneratedColumn> get $columns => [id, festivalId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_stages';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedStage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('festival_id')) {
      context.handle(
        _festivalIdMeta,
        festivalId.isAcceptableOrUnknown(data['festival_id']!, _festivalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_festivalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedStage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedStage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      festivalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}festival_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CachedStagesTable createAlias(String alias) {
    return $CachedStagesTable(attachedDatabase, alias);
  }
}

class CachedStage extends DataClass implements Insertable<CachedStage> {
  final int id;
  final int festivalId;
  final String name;
  const CachedStage({
    required this.id,
    required this.festivalId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['festival_id'] = Variable<int>(festivalId);
    map['name'] = Variable<String>(name);
    return map;
  }

  CachedStagesCompanion toCompanion(bool nullToAbsent) {
    return CachedStagesCompanion(
      id: Value(id),
      festivalId: Value(festivalId),
      name: Value(name),
    );
  }

  factory CachedStage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedStage(
      id: serializer.fromJson<int>(json['id']),
      festivalId: serializer.fromJson<int>(json['festivalId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'festivalId': serializer.toJson<int>(festivalId),
      'name': serializer.toJson<String>(name),
    };
  }

  CachedStage copyWith({int? id, int? festivalId, String? name}) => CachedStage(
    id: id ?? this.id,
    festivalId: festivalId ?? this.festivalId,
    name: name ?? this.name,
  );
  CachedStage copyWithCompanion(CachedStagesCompanion data) {
    return CachedStage(
      id: data.id.present ? data.id.value : this.id,
      festivalId: data.festivalId.present
          ? data.festivalId.value
          : this.festivalId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedStage(')
          ..write('id: $id, ')
          ..write('festivalId: $festivalId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, festivalId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedStage &&
          other.id == this.id &&
          other.festivalId == this.festivalId &&
          other.name == this.name);
}

class CachedStagesCompanion extends UpdateCompanion<CachedStage> {
  final Value<int> id;
  final Value<int> festivalId;
  final Value<String> name;
  const CachedStagesCompanion({
    this.id = const Value.absent(),
    this.festivalId = const Value.absent(),
    this.name = const Value.absent(),
  });
  CachedStagesCompanion.insert({
    this.id = const Value.absent(),
    required int festivalId,
    required String name,
  }) : festivalId = Value(festivalId),
       name = Value(name);
  static Insertable<CachedStage> custom({
    Expression<int>? id,
    Expression<int>? festivalId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (festivalId != null) 'festival_id': festivalId,
      if (name != null) 'name': name,
    });
  }

  CachedStagesCompanion copyWith({
    Value<int>? id,
    Value<int>? festivalId,
    Value<String>? name,
  }) {
    return CachedStagesCompanion(
      id: id ?? this.id,
      festivalId: festivalId ?? this.festivalId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (festivalId.present) {
      map['festival_id'] = Variable<int>(festivalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedStagesCompanion(')
          ..write('id: $id, ')
          ..write('festivalId: $festivalId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $CachedFestivalSetsTable extends CachedFestivalSets
    with TableInfo<$CachedFestivalSetsTable, CachedFestivalSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedFestivalSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _festivalIdMeta = const VerificationMeta(
    'festivalId',
  );
  @override
  late final GeneratedColumn<int> festivalId = GeneratedColumn<int>(
    'festival_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cached_festivals (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stageIdMeta = const VerificationMeta(
    'stageId',
  );
  @override
  late final GeneratedColumn<int> stageId = GeneratedColumn<int>(
    'stage_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageNameMeta = const VerificationMeta(
    'stageName',
  );
  @override
  late final GeneratedColumn<String> stageName = GeneratedColumn<String>(
    'stage_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
    'artist_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistNameMeta = const VerificationMeta(
    'artistName',
  );
  @override
  late final GeneratedColumn<String> artistName = GeneratedColumn<String>(
    'artist_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _displayImageMeta = const VerificationMeta(
    'displayImage',
  );
  @override
  late final GeneratedColumn<String> displayImage = GeneratedColumn<String>(
    'display_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLikedMeta = const VerificationMeta(
    'isLiked',
  );
  @override
  late final GeneratedColumn<bool> isLiked = GeneratedColumn<bool>(
    'is_liked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_liked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _likeCountMeta = const VerificationMeta(
    'likeCount',
  );
  @override
  late final GeneratedColumn<int> likeCount = GeneratedColumn<int>(
    'like_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    festivalId,
    stageId,
    stageName,
    artistId,
    artistName,
    startTime,
    endTime,
    image,
    displayImage,
    isLiked,
    likeCount,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_festival_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedFestivalSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('festival_id')) {
      context.handle(
        _festivalIdMeta,
        festivalId.isAcceptableOrUnknown(data['festival_id']!, _festivalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_festivalIdMeta);
    }
    if (data.containsKey('stage_id')) {
      context.handle(
        _stageIdMeta,
        stageId.isAcceptableOrUnknown(data['stage_id']!, _stageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stageIdMeta);
    }
    if (data.containsKey('stage_name')) {
      context.handle(
        _stageNameMeta,
        stageName.isAcceptableOrUnknown(data['stage_name']!, _stageNameMeta),
      );
    } else if (isInserting) {
      context.missing(_stageNameMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    if (data.containsKey('artist_name')) {
      context.handle(
        _artistNameMeta,
        artistName.isAcceptableOrUnknown(data['artist_name']!, _artistNameMeta),
      );
    } else if (isInserting) {
      context.missing(_artistNameMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('display_image')) {
      context.handle(
        _displayImageMeta,
        displayImage.isAcceptableOrUnknown(
          data['display_image']!,
          _displayImageMeta,
        ),
      );
    }
    if (data.containsKey('is_liked')) {
      context.handle(
        _isLikedMeta,
        isLiked.isAcceptableOrUnknown(data['is_liked']!, _isLikedMeta),
      );
    }
    if (data.containsKey('like_count')) {
      context.handle(
        _likeCountMeta,
        likeCount.isAcceptableOrUnknown(data['like_count']!, _likeCountMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedFestivalSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedFestivalSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      festivalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}festival_id'],
      )!,
      stageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stage_id'],
      )!,
      stageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage_name'],
      )!,
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}artist_id'],
      )!,
      artistName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_name'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      displayImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_image'],
      ),
      isLiked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_liked'],
      )!,
      likeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}like_count'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $CachedFestivalSetsTable createAlias(String alias) {
    return $CachedFestivalSetsTable(attachedDatabase, alias);
  }
}

class CachedFestivalSet extends DataClass
    implements Insertable<CachedFestivalSet> {
  final int id;
  final int festivalId;
  final int stageId;
  final String stageName;
  final int artistId;
  final String artistName;
  final DateTime startTime;
  final DateTime endTime;
  final String? image;
  final String? displayImage;
  final bool isLiked;
  final int likeCount;
  final DateTime syncedAt;
  const CachedFestivalSet({
    required this.id,
    required this.festivalId,
    required this.stageId,
    required this.stageName,
    required this.artistId,
    required this.artistName,
    required this.startTime,
    required this.endTime,
    this.image,
    this.displayImage,
    required this.isLiked,
    required this.likeCount,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['festival_id'] = Variable<int>(festivalId);
    map['stage_id'] = Variable<int>(stageId);
    map['stage_name'] = Variable<String>(stageName);
    map['artist_id'] = Variable<int>(artistId);
    map['artist_name'] = Variable<String>(artistName);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || displayImage != null) {
      map['display_image'] = Variable<String>(displayImage);
    }
    map['is_liked'] = Variable<bool>(isLiked);
    map['like_count'] = Variable<int>(likeCount);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  CachedFestivalSetsCompanion toCompanion(bool nullToAbsent) {
    return CachedFestivalSetsCompanion(
      id: Value(id),
      festivalId: Value(festivalId),
      stageId: Value(stageId),
      stageName: Value(stageName),
      artistId: Value(artistId),
      artistName: Value(artistName),
      startTime: Value(startTime),
      endTime: Value(endTime),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      displayImage: displayImage == null && nullToAbsent
          ? const Value.absent()
          : Value(displayImage),
      isLiked: Value(isLiked),
      likeCount: Value(likeCount),
      syncedAt: Value(syncedAt),
    );
  }

  factory CachedFestivalSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedFestivalSet(
      id: serializer.fromJson<int>(json['id']),
      festivalId: serializer.fromJson<int>(json['festivalId']),
      stageId: serializer.fromJson<int>(json['stageId']),
      stageName: serializer.fromJson<String>(json['stageName']),
      artistId: serializer.fromJson<int>(json['artistId']),
      artistName: serializer.fromJson<String>(json['artistName']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      image: serializer.fromJson<String?>(json['image']),
      displayImage: serializer.fromJson<String?>(json['displayImage']),
      isLiked: serializer.fromJson<bool>(json['isLiked']),
      likeCount: serializer.fromJson<int>(json['likeCount']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'festivalId': serializer.toJson<int>(festivalId),
      'stageId': serializer.toJson<int>(stageId),
      'stageName': serializer.toJson<String>(stageName),
      'artistId': serializer.toJson<int>(artistId),
      'artistName': serializer.toJson<String>(artistName),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'image': serializer.toJson<String?>(image),
      'displayImage': serializer.toJson<String?>(displayImage),
      'isLiked': serializer.toJson<bool>(isLiked),
      'likeCount': serializer.toJson<int>(likeCount),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  CachedFestivalSet copyWith({
    int? id,
    int? festivalId,
    int? stageId,
    String? stageName,
    int? artistId,
    String? artistName,
    DateTime? startTime,
    DateTime? endTime,
    Value<String?> image = const Value.absent(),
    Value<String?> displayImage = const Value.absent(),
    bool? isLiked,
    int? likeCount,
    DateTime? syncedAt,
  }) => CachedFestivalSet(
    id: id ?? this.id,
    festivalId: festivalId ?? this.festivalId,
    stageId: stageId ?? this.stageId,
    stageName: stageName ?? this.stageName,
    artistId: artistId ?? this.artistId,
    artistName: artistName ?? this.artistName,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    image: image.present ? image.value : this.image,
    displayImage: displayImage.present ? displayImage.value : this.displayImage,
    isLiked: isLiked ?? this.isLiked,
    likeCount: likeCount ?? this.likeCount,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  CachedFestivalSet copyWithCompanion(CachedFestivalSetsCompanion data) {
    return CachedFestivalSet(
      id: data.id.present ? data.id.value : this.id,
      festivalId: data.festivalId.present
          ? data.festivalId.value
          : this.festivalId,
      stageId: data.stageId.present ? data.stageId.value : this.stageId,
      stageName: data.stageName.present ? data.stageName.value : this.stageName,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      artistName: data.artistName.present
          ? data.artistName.value
          : this.artistName,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      image: data.image.present ? data.image.value : this.image,
      displayImage: data.displayImage.present
          ? data.displayImage.value
          : this.displayImage,
      isLiked: data.isLiked.present ? data.isLiked.value : this.isLiked,
      likeCount: data.likeCount.present ? data.likeCount.value : this.likeCount,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedFestivalSet(')
          ..write('id: $id, ')
          ..write('festivalId: $festivalId, ')
          ..write('stageId: $stageId, ')
          ..write('stageName: $stageName, ')
          ..write('artistId: $artistId, ')
          ..write('artistName: $artistName, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('image: $image, ')
          ..write('displayImage: $displayImage, ')
          ..write('isLiked: $isLiked, ')
          ..write('likeCount: $likeCount, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    festivalId,
    stageId,
    stageName,
    artistId,
    artistName,
    startTime,
    endTime,
    image,
    displayImage,
    isLiked,
    likeCount,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedFestivalSet &&
          other.id == this.id &&
          other.festivalId == this.festivalId &&
          other.stageId == this.stageId &&
          other.stageName == this.stageName &&
          other.artistId == this.artistId &&
          other.artistName == this.artistName &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.image == this.image &&
          other.displayImage == this.displayImage &&
          other.isLiked == this.isLiked &&
          other.likeCount == this.likeCount &&
          other.syncedAt == this.syncedAt);
}

class CachedFestivalSetsCompanion extends UpdateCompanion<CachedFestivalSet> {
  final Value<int> id;
  final Value<int> festivalId;
  final Value<int> stageId;
  final Value<String> stageName;
  final Value<int> artistId;
  final Value<String> artistName;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<String?> image;
  final Value<String?> displayImage;
  final Value<bool> isLiked;
  final Value<int> likeCount;
  final Value<DateTime> syncedAt;
  const CachedFestivalSetsCompanion({
    this.id = const Value.absent(),
    this.festivalId = const Value.absent(),
    this.stageId = const Value.absent(),
    this.stageName = const Value.absent(),
    this.artistId = const Value.absent(),
    this.artistName = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.image = const Value.absent(),
    this.displayImage = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  CachedFestivalSetsCompanion.insert({
    this.id = const Value.absent(),
    required int festivalId,
    required int stageId,
    required String stageName,
    required int artistId,
    required String artistName,
    required DateTime startTime,
    required DateTime endTime,
    this.image = const Value.absent(),
    this.displayImage = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.likeCount = const Value.absent(),
    required DateTime syncedAt,
  }) : festivalId = Value(festivalId),
       stageId = Value(stageId),
       stageName = Value(stageName),
       artistId = Value(artistId),
       artistName = Value(artistName),
       startTime = Value(startTime),
       endTime = Value(endTime),
       syncedAt = Value(syncedAt);
  static Insertable<CachedFestivalSet> custom({
    Expression<int>? id,
    Expression<int>? festivalId,
    Expression<int>? stageId,
    Expression<String>? stageName,
    Expression<int>? artistId,
    Expression<String>? artistName,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? image,
    Expression<String>? displayImage,
    Expression<bool>? isLiked,
    Expression<int>? likeCount,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (festivalId != null) 'festival_id': festivalId,
      if (stageId != null) 'stage_id': stageId,
      if (stageName != null) 'stage_name': stageName,
      if (artistId != null) 'artist_id': artistId,
      if (artistName != null) 'artist_name': artistName,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (image != null) 'image': image,
      if (displayImage != null) 'display_image': displayImage,
      if (isLiked != null) 'is_liked': isLiked,
      if (likeCount != null) 'like_count': likeCount,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  CachedFestivalSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? festivalId,
    Value<int>? stageId,
    Value<String>? stageName,
    Value<int>? artistId,
    Value<String>? artistName,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<String?>? image,
    Value<String?>? displayImage,
    Value<bool>? isLiked,
    Value<int>? likeCount,
    Value<DateTime>? syncedAt,
  }) {
    return CachedFestivalSetsCompanion(
      id: id ?? this.id,
      festivalId: festivalId ?? this.festivalId,
      stageId: stageId ?? this.stageId,
      stageName: stageName ?? this.stageName,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      image: image ?? this.image,
      displayImage: displayImage ?? this.displayImage,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (festivalId.present) {
      map['festival_id'] = Variable<int>(festivalId.value);
    }
    if (stageId.present) {
      map['stage_id'] = Variable<int>(stageId.value);
    }
    if (stageName.present) {
      map['stage_name'] = Variable<String>(stageName.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (artistName.present) {
      map['artist_name'] = Variable<String>(artistName.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (displayImage.present) {
      map['display_image'] = Variable<String>(displayImage.value);
    }
    if (isLiked.present) {
      map['is_liked'] = Variable<bool>(isLiked.value);
    }
    if (likeCount.present) {
      map['like_count'] = Variable<int>(likeCount.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedFestivalSetsCompanion(')
          ..write('id: $id, ')
          ..write('festivalId: $festivalId, ')
          ..write('stageId: $stageId, ')
          ..write('stageName: $stageName, ')
          ..write('artistId: $artistId, ')
          ..write('artistName: $artistName, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('image: $image, ')
          ..write('displayImage: $displayImage, ')
          ..write('isLiked: $isLiked, ')
          ..write('likeCount: $likeCount, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $PendingSetLikesTable extends PendingSetLikes
    with TableInfo<$PendingSetLikesTable, PendingSetLike> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingSetLikesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _setIdMeta = const VerificationMeta('setId');
  @override
  late final GeneratedColumn<int> setId = GeneratedColumn<int>(
    'set_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _festivalIdMeta = const VerificationMeta(
    'festivalId',
  );
  @override
  late final GeneratedColumn<int> festivalId = GeneratedColumn<int>(
    'festival_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _desiredIsLikedMeta = const VerificationMeta(
    'desiredIsLiked',
  );
  @override
  late final GeneratedColumn<bool> desiredIsLiked = GeneratedColumn<bool>(
    'desired_is_liked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("desired_is_liked" IN (0, 1))',
    ),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    setId,
    festivalId,
    desiredIsLiked,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_set_likes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingSetLike> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('set_id')) {
      context.handle(
        _setIdMeta,
        setId.isAcceptableOrUnknown(data['set_id']!, _setIdMeta),
      );
    }
    if (data.containsKey('festival_id')) {
      context.handle(
        _festivalIdMeta,
        festivalId.isAcceptableOrUnknown(data['festival_id']!, _festivalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_festivalIdMeta);
    }
    if (data.containsKey('desired_is_liked')) {
      context.handle(
        _desiredIsLikedMeta,
        desiredIsLiked.isAcceptableOrUnknown(
          data['desired_is_liked']!,
          _desiredIsLikedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_desiredIsLikedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {setId};
  @override
  PendingSetLike map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingSetLike(
      setId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_id'],
      )!,
      festivalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}festival_id'],
      )!,
      desiredIsLiked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}desired_is_liked'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingSetLikesTable createAlias(String alias) {
    return $PendingSetLikesTable(attachedDatabase, alias);
  }
}

class PendingSetLike extends DataClass implements Insertable<PendingSetLike> {
  final int setId;
  final int festivalId;
  final bool desiredIsLiked;
  final DateTime createdAt;
  const PendingSetLike({
    required this.setId,
    required this.festivalId,
    required this.desiredIsLiked,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['set_id'] = Variable<int>(setId);
    map['festival_id'] = Variable<int>(festivalId);
    map['desired_is_liked'] = Variable<bool>(desiredIsLiked);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingSetLikesCompanion toCompanion(bool nullToAbsent) {
    return PendingSetLikesCompanion(
      setId: Value(setId),
      festivalId: Value(festivalId),
      desiredIsLiked: Value(desiredIsLiked),
      createdAt: Value(createdAt),
    );
  }

  factory PendingSetLike.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingSetLike(
      setId: serializer.fromJson<int>(json['setId']),
      festivalId: serializer.fromJson<int>(json['festivalId']),
      desiredIsLiked: serializer.fromJson<bool>(json['desiredIsLiked']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'setId': serializer.toJson<int>(setId),
      'festivalId': serializer.toJson<int>(festivalId),
      'desiredIsLiked': serializer.toJson<bool>(desiredIsLiked),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingSetLike copyWith({
    int? setId,
    int? festivalId,
    bool? desiredIsLiked,
    DateTime? createdAt,
  }) => PendingSetLike(
    setId: setId ?? this.setId,
    festivalId: festivalId ?? this.festivalId,
    desiredIsLiked: desiredIsLiked ?? this.desiredIsLiked,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingSetLike copyWithCompanion(PendingSetLikesCompanion data) {
    return PendingSetLike(
      setId: data.setId.present ? data.setId.value : this.setId,
      festivalId: data.festivalId.present
          ? data.festivalId.value
          : this.festivalId,
      desiredIsLiked: data.desiredIsLiked.present
          ? data.desiredIsLiked.value
          : this.desiredIsLiked,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingSetLike(')
          ..write('setId: $setId, ')
          ..write('festivalId: $festivalId, ')
          ..write('desiredIsLiked: $desiredIsLiked, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(setId, festivalId, desiredIsLiked, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingSetLike &&
          other.setId == this.setId &&
          other.festivalId == this.festivalId &&
          other.desiredIsLiked == this.desiredIsLiked &&
          other.createdAt == this.createdAt);
}

class PendingSetLikesCompanion extends UpdateCompanion<PendingSetLike> {
  final Value<int> setId;
  final Value<int> festivalId;
  final Value<bool> desiredIsLiked;
  final Value<DateTime> createdAt;
  const PendingSetLikesCompanion({
    this.setId = const Value.absent(),
    this.festivalId = const Value.absent(),
    this.desiredIsLiked = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingSetLikesCompanion.insert({
    this.setId = const Value.absent(),
    required int festivalId,
    required bool desiredIsLiked,
    required DateTime createdAt,
  }) : festivalId = Value(festivalId),
       desiredIsLiked = Value(desiredIsLiked),
       createdAt = Value(createdAt);
  static Insertable<PendingSetLike> custom({
    Expression<int>? setId,
    Expression<int>? festivalId,
    Expression<bool>? desiredIsLiked,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (setId != null) 'set_id': setId,
      if (festivalId != null) 'festival_id': festivalId,
      if (desiredIsLiked != null) 'desired_is_liked': desiredIsLiked,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingSetLikesCompanion copyWith({
    Value<int>? setId,
    Value<int>? festivalId,
    Value<bool>? desiredIsLiked,
    Value<DateTime>? createdAt,
  }) {
    return PendingSetLikesCompanion(
      setId: setId ?? this.setId,
      festivalId: festivalId ?? this.festivalId,
      desiredIsLiked: desiredIsLiked ?? this.desiredIsLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (setId.present) {
      map['set_id'] = Variable<int>(setId.value);
    }
    if (festivalId.present) {
      map['festival_id'] = Variable<int>(festivalId.value);
    }
    if (desiredIsLiked.present) {
      map['desired_is_liked'] = Variable<bool>(desiredIsLiked.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingSetLikesCompanion(')
          ..write('setId: $setId, ')
          ..write('festivalId: $festivalId, ')
          ..write('desiredIsLiked: $desiredIsLiked, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedFestivalsTable cachedFestivals = $CachedFestivalsTable(
    this,
  );
  late final $CachedStagesTable cachedStages = $CachedStagesTable(this);
  late final $CachedFestivalSetsTable cachedFestivalSets =
      $CachedFestivalSetsTable(this);
  late final $PendingSetLikesTable pendingSetLikes = $PendingSetLikesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedFestivals,
    cachedStages,
    cachedFestivalSets,
    pendingSetLikes,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cached_festivals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cached_stages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cached_festivals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cached_festival_sets', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CachedFestivalsTableCreateCompanionBuilder =
    CachedFestivalsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> description,
      required DateTime startDate,
      required DateTime endDate,
      Value<String?> image,
      Value<String> organiserName,
      Value<String?> organiserProfilePicture,
      required DateTime syncedAt,
    });
typedef $$CachedFestivalsTableUpdateCompanionBuilder =
    CachedFestivalsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> description,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String?> image,
      Value<String> organiserName,
      Value<String?> organiserProfilePicture,
      Value<DateTime> syncedAt,
    });

final class $$CachedFestivalsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CachedFestivalsTable, CachedFestival> {
  $$CachedFestivalsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CachedStagesTable, List<CachedStage>>
  _cachedStagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cachedStages,
    aliasName: 'cached_festivals__id__cached_stages__festival_id',
  );

  $$CachedStagesTableProcessedTableManager get cachedStagesRefs {
    final manager = $$CachedStagesTableTableManager(
      $_db,
      $_db.cachedStages,
    ).filter((f) => f.festivalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cachedStagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CachedFestivalSetsTable, List<CachedFestivalSet>>
  _cachedFestivalSetsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cachedFestivalSets,
        aliasName: 'cached_festivals__id__cached_festival_sets__festival_id',
      );

  $$CachedFestivalSetsTableProcessedTableManager get cachedFestivalSetsRefs {
    final manager = $$CachedFestivalSetsTableTableManager(
      $_db,
      $_db.cachedFestivalSets,
    ).filter((f) => f.festivalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cachedFestivalSetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CachedFestivalsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedFestivalsTable> {
  $$CachedFestivalsTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organiserName => $composableBuilder(
    column: $table.organiserName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organiserProfilePicture => $composableBuilder(
    column: $table.organiserProfilePicture,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cachedStagesRefs(
    Expression<bool> Function($$CachedStagesTableFilterComposer f) f,
  ) {
    final $$CachedStagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cachedStages,
      getReferencedColumn: (t) => t.festivalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedStagesTableFilterComposer(
            $db: $db,
            $table: $db.cachedStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cachedFestivalSetsRefs(
    Expression<bool> Function($$CachedFestivalSetsTableFilterComposer f) f,
  ) {
    final $$CachedFestivalSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cachedFestivalSets,
      getReferencedColumn: (t) => t.festivalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFestivalSetsTableFilterComposer(
            $db: $db,
            $table: $db.cachedFestivalSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CachedFestivalsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedFestivalsTable> {
  $$CachedFestivalsTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organiserName => $composableBuilder(
    column: $table.organiserName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organiserProfilePicture => $composableBuilder(
    column: $table.organiserProfilePicture,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedFestivalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedFestivalsTable> {
  $$CachedFestivalsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get organiserName => $composableBuilder(
    column: $table.organiserName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get organiserProfilePicture => $composableBuilder(
    column: $table.organiserProfilePicture,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  Expression<T> cachedStagesRefs<T extends Object>(
    Expression<T> Function($$CachedStagesTableAnnotationComposer a) f,
  ) {
    final $$CachedStagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cachedStages,
      getReferencedColumn: (t) => t.festivalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedStagesTableAnnotationComposer(
            $db: $db,
            $table: $db.cachedStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cachedFestivalSetsRefs<T extends Object>(
    Expression<T> Function($$CachedFestivalSetsTableAnnotationComposer a) f,
  ) {
    final $$CachedFestivalSetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cachedFestivalSets,
          getReferencedColumn: (t) => t.festivalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CachedFestivalSetsTableAnnotationComposer(
                $db: $db,
                $table: $db.cachedFestivalSets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CachedFestivalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedFestivalsTable,
          CachedFestival,
          $$CachedFestivalsTableFilterComposer,
          $$CachedFestivalsTableOrderingComposer,
          $$CachedFestivalsTableAnnotationComposer,
          $$CachedFestivalsTableCreateCompanionBuilder,
          $$CachedFestivalsTableUpdateCompanionBuilder,
          (CachedFestival, $$CachedFestivalsTableReferences),
          CachedFestival,
          PrefetchHooks Function({
            bool cachedStagesRefs,
            bool cachedFestivalSetsRefs,
          })
        > {
  $$CachedFestivalsTableTableManager(
    _$AppDatabase db,
    $CachedFestivalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedFestivalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedFestivalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedFestivalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String> organiserName = const Value.absent(),
                Value<String?> organiserProfilePicture = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => CachedFestivalsCompanion(
                id: id,
                name: name,
                description: description,
                startDate: startDate,
                endDate: endDate,
                image: image,
                organiserName: organiserName,
                organiserProfilePicture: organiserProfilePicture,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> description = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                Value<String?> image = const Value.absent(),
                Value<String> organiserName = const Value.absent(),
                Value<String?> organiserProfilePicture = const Value.absent(),
                required DateTime syncedAt,
              }) => CachedFestivalsCompanion.insert(
                id: id,
                name: name,
                description: description,
                startDate: startDate,
                endDate: endDate,
                image: image,
                organiserName: organiserName,
                organiserProfilePicture: organiserProfilePicture,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CachedFestivalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cachedStagesRefs = false, cachedFestivalSetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cachedStagesRefs) db.cachedStages,
                    if (cachedFestivalSetsRefs) db.cachedFestivalSets,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cachedStagesRefs)
                        await $_getPrefetchedData<
                          CachedFestival,
                          $CachedFestivalsTable,
                          CachedStage
                        >(
                          currentTable: table,
                          referencedTable: $$CachedFestivalsTableReferences
                              ._cachedStagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CachedFestivalsTableReferences(
                                db,
                                table,
                                p0,
                              ).cachedStagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.festivalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cachedFestivalSetsRefs)
                        await $_getPrefetchedData<
                          CachedFestival,
                          $CachedFestivalsTable,
                          CachedFestivalSet
                        >(
                          currentTable: table,
                          referencedTable: $$CachedFestivalsTableReferences
                              ._cachedFestivalSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CachedFestivalsTableReferences(
                                db,
                                table,
                                p0,
                              ).cachedFestivalSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.festivalId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CachedFestivalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedFestivalsTable,
      CachedFestival,
      $$CachedFestivalsTableFilterComposer,
      $$CachedFestivalsTableOrderingComposer,
      $$CachedFestivalsTableAnnotationComposer,
      $$CachedFestivalsTableCreateCompanionBuilder,
      $$CachedFestivalsTableUpdateCompanionBuilder,
      (CachedFestival, $$CachedFestivalsTableReferences),
      CachedFestival,
      PrefetchHooks Function({
        bool cachedStagesRefs,
        bool cachedFestivalSetsRefs,
      })
    >;
typedef $$CachedStagesTableCreateCompanionBuilder =
    CachedStagesCompanion Function({
      Value<int> id,
      required int festivalId,
      required String name,
    });
typedef $$CachedStagesTableUpdateCompanionBuilder =
    CachedStagesCompanion Function({
      Value<int> id,
      Value<int> festivalId,
      Value<String> name,
    });

final class $$CachedStagesTableReferences
    extends BaseReferences<_$AppDatabase, $CachedStagesTable, CachedStage> {
  $$CachedStagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CachedFestivalsTable _festivalIdTable(_$AppDatabase db) => db
      .cachedFestivals
      .createAlias('cached_stages__festival_id__cached_festivals__id');

  $$CachedFestivalsTableProcessedTableManager get festivalId {
    final $_column = $_itemColumn<int>('festival_id')!;

    final manager = $$CachedFestivalsTableTableManager(
      $_db,
      $_db.cachedFestivals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_festivalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CachedStagesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedStagesTable> {
  $$CachedStagesTableFilterComposer({
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

  $$CachedFestivalsTableFilterComposer get festivalId {
    final $$CachedFestivalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.festivalId,
      referencedTable: $db.cachedFestivals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFestivalsTableFilterComposer(
            $db: $db,
            $table: $db.cachedFestivals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedStagesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedStagesTable> {
  $$CachedStagesTableOrderingComposer({
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

  $$CachedFestivalsTableOrderingComposer get festivalId {
    final $$CachedFestivalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.festivalId,
      referencedTable: $db.cachedFestivals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFestivalsTableOrderingComposer(
            $db: $db,
            $table: $db.cachedFestivals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedStagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedStagesTable> {
  $$CachedStagesTableAnnotationComposer({
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

  $$CachedFestivalsTableAnnotationComposer get festivalId {
    final $$CachedFestivalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.festivalId,
      referencedTable: $db.cachedFestivals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFestivalsTableAnnotationComposer(
            $db: $db,
            $table: $db.cachedFestivals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedStagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedStagesTable,
          CachedStage,
          $$CachedStagesTableFilterComposer,
          $$CachedStagesTableOrderingComposer,
          $$CachedStagesTableAnnotationComposer,
          $$CachedStagesTableCreateCompanionBuilder,
          $$CachedStagesTableUpdateCompanionBuilder,
          (CachedStage, $$CachedStagesTableReferences),
          CachedStage,
          PrefetchHooks Function({bool festivalId})
        > {
  $$CachedStagesTableTableManager(_$AppDatabase db, $CachedStagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedStagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedStagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedStagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> festivalId = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => CachedStagesCompanion(
                id: id,
                festivalId: festivalId,
                name: name,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int festivalId,
                required String name,
              }) => CachedStagesCompanion.insert(
                id: id,
                festivalId: festivalId,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CachedStagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({festivalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (festivalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.festivalId,
                                referencedTable: $$CachedStagesTableReferences
                                    ._festivalIdTable(db),
                                referencedColumn: $$CachedStagesTableReferences
                                    ._festivalIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CachedStagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedStagesTable,
      CachedStage,
      $$CachedStagesTableFilterComposer,
      $$CachedStagesTableOrderingComposer,
      $$CachedStagesTableAnnotationComposer,
      $$CachedStagesTableCreateCompanionBuilder,
      $$CachedStagesTableUpdateCompanionBuilder,
      (CachedStage, $$CachedStagesTableReferences),
      CachedStage,
      PrefetchHooks Function({bool festivalId})
    >;
typedef $$CachedFestivalSetsTableCreateCompanionBuilder =
    CachedFestivalSetsCompanion Function({
      Value<int> id,
      required int festivalId,
      required int stageId,
      required String stageName,
      required int artistId,
      required String artistName,
      required DateTime startTime,
      required DateTime endTime,
      Value<String?> image,
      Value<String?> displayImage,
      Value<bool> isLiked,
      Value<int> likeCount,
      required DateTime syncedAt,
    });
typedef $$CachedFestivalSetsTableUpdateCompanionBuilder =
    CachedFestivalSetsCompanion Function({
      Value<int> id,
      Value<int> festivalId,
      Value<int> stageId,
      Value<String> stageName,
      Value<int> artistId,
      Value<String> artistName,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<String?> image,
      Value<String?> displayImage,
      Value<bool> isLiked,
      Value<int> likeCount,
      Value<DateTime> syncedAt,
    });

final class $$CachedFestivalSetsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CachedFestivalSetsTable,
          CachedFestivalSet
        > {
  $$CachedFestivalSetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CachedFestivalsTable _festivalIdTable(_$AppDatabase db) => db
      .cachedFestivals
      .createAlias('cached_festival_sets__festival_id__cached_festivals__id');

  $$CachedFestivalsTableProcessedTableManager get festivalId {
    final $_column = $_itemColumn<int>('festival_id')!;

    final manager = $$CachedFestivalsTableTableManager(
      $_db,
      $_db.cachedFestivals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_festivalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CachedFestivalSetsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedFestivalSetsTable> {
  $$CachedFestivalSetsTableFilterComposer({
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

  ColumnFilters<int> get stageId => $composableBuilder(
    column: $table.stageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stageName => $composableBuilder(
    column: $table.stageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get artistId => $composableBuilder(
    column: $table.artistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayImage => $composableBuilder(
    column: $table.displayImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likeCount => $composableBuilder(
    column: $table.likeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CachedFestivalsTableFilterComposer get festivalId {
    final $$CachedFestivalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.festivalId,
      referencedTable: $db.cachedFestivals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFestivalsTableFilterComposer(
            $db: $db,
            $table: $db.cachedFestivals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedFestivalSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedFestivalSetsTable> {
  $$CachedFestivalSetsTableOrderingComposer({
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

  ColumnOrderings<int> get stageId => $composableBuilder(
    column: $table.stageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stageName => $composableBuilder(
    column: $table.stageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get artistId => $composableBuilder(
    column: $table.artistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayImage => $composableBuilder(
    column: $table.displayImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLiked => $composableBuilder(
    column: $table.isLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likeCount => $composableBuilder(
    column: $table.likeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CachedFestivalsTableOrderingComposer get festivalId {
    final $$CachedFestivalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.festivalId,
      referencedTable: $db.cachedFestivals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFestivalsTableOrderingComposer(
            $db: $db,
            $table: $db.cachedFestivals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedFestivalSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedFestivalSetsTable> {
  $$CachedFestivalSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stageId =>
      $composableBuilder(column: $table.stageId, builder: (column) => column);

  GeneratedColumn<String> get stageName =>
      $composableBuilder(column: $table.stageName, builder: (column) => column);

  GeneratedColumn<int> get artistId =>
      $composableBuilder(column: $table.artistId, builder: (column) => column);

  GeneratedColumn<String> get artistName => $composableBuilder(
    column: $table.artistName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get displayImage => $composableBuilder(
    column: $table.displayImage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLiked =>
      $composableBuilder(column: $table.isLiked, builder: (column) => column);

  GeneratedColumn<int> get likeCount =>
      $composableBuilder(column: $table.likeCount, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  $$CachedFestivalsTableAnnotationComposer get festivalId {
    final $$CachedFestivalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.festivalId,
      referencedTable: $db.cachedFestivals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedFestivalsTableAnnotationComposer(
            $db: $db,
            $table: $db.cachedFestivals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedFestivalSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedFestivalSetsTable,
          CachedFestivalSet,
          $$CachedFestivalSetsTableFilterComposer,
          $$CachedFestivalSetsTableOrderingComposer,
          $$CachedFestivalSetsTableAnnotationComposer,
          $$CachedFestivalSetsTableCreateCompanionBuilder,
          $$CachedFestivalSetsTableUpdateCompanionBuilder,
          (CachedFestivalSet, $$CachedFestivalSetsTableReferences),
          CachedFestivalSet,
          PrefetchHooks Function({bool festivalId})
        > {
  $$CachedFestivalSetsTableTableManager(
    _$AppDatabase db,
    $CachedFestivalSetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedFestivalSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedFestivalSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedFestivalSetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> festivalId = const Value.absent(),
                Value<int> stageId = const Value.absent(),
                Value<String> stageName = const Value.absent(),
                Value<int> artistId = const Value.absent(),
                Value<String> artistName = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<String?> displayImage = const Value.absent(),
                Value<bool> isLiked = const Value.absent(),
                Value<int> likeCount = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => CachedFestivalSetsCompanion(
                id: id,
                festivalId: festivalId,
                stageId: stageId,
                stageName: stageName,
                artistId: artistId,
                artistName: artistName,
                startTime: startTime,
                endTime: endTime,
                image: image,
                displayImage: displayImage,
                isLiked: isLiked,
                likeCount: likeCount,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int festivalId,
                required int stageId,
                required String stageName,
                required int artistId,
                required String artistName,
                required DateTime startTime,
                required DateTime endTime,
                Value<String?> image = const Value.absent(),
                Value<String?> displayImage = const Value.absent(),
                Value<bool> isLiked = const Value.absent(),
                Value<int> likeCount = const Value.absent(),
                required DateTime syncedAt,
              }) => CachedFestivalSetsCompanion.insert(
                id: id,
                festivalId: festivalId,
                stageId: stageId,
                stageName: stageName,
                artistId: artistId,
                artistName: artistName,
                startTime: startTime,
                endTime: endTime,
                image: image,
                displayImage: displayImage,
                isLiked: isLiked,
                likeCount: likeCount,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CachedFestivalSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({festivalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (festivalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.festivalId,
                                referencedTable:
                                    $$CachedFestivalSetsTableReferences
                                        ._festivalIdTable(db),
                                referencedColumn:
                                    $$CachedFestivalSetsTableReferences
                                        ._festivalIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CachedFestivalSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedFestivalSetsTable,
      CachedFestivalSet,
      $$CachedFestivalSetsTableFilterComposer,
      $$CachedFestivalSetsTableOrderingComposer,
      $$CachedFestivalSetsTableAnnotationComposer,
      $$CachedFestivalSetsTableCreateCompanionBuilder,
      $$CachedFestivalSetsTableUpdateCompanionBuilder,
      (CachedFestivalSet, $$CachedFestivalSetsTableReferences),
      CachedFestivalSet,
      PrefetchHooks Function({bool festivalId})
    >;
typedef $$PendingSetLikesTableCreateCompanionBuilder =
    PendingSetLikesCompanion Function({
      Value<int> setId,
      required int festivalId,
      required bool desiredIsLiked,
      required DateTime createdAt,
    });
typedef $$PendingSetLikesTableUpdateCompanionBuilder =
    PendingSetLikesCompanion Function({
      Value<int> setId,
      Value<int> festivalId,
      Value<bool> desiredIsLiked,
      Value<DateTime> createdAt,
    });

class $$PendingSetLikesTableFilterComposer
    extends Composer<_$AppDatabase, $PendingSetLikesTable> {
  $$PendingSetLikesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get setId => $composableBuilder(
    column: $table.setId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get festivalId => $composableBuilder(
    column: $table.festivalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get desiredIsLiked => $composableBuilder(
    column: $table.desiredIsLiked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingSetLikesTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingSetLikesTable> {
  $$PendingSetLikesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get setId => $composableBuilder(
    column: $table.setId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get festivalId => $composableBuilder(
    column: $table.festivalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get desiredIsLiked => $composableBuilder(
    column: $table.desiredIsLiked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingSetLikesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingSetLikesTable> {
  $$PendingSetLikesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get setId =>
      $composableBuilder(column: $table.setId, builder: (column) => column);

  GeneratedColumn<int> get festivalId => $composableBuilder(
    column: $table.festivalId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get desiredIsLiked => $composableBuilder(
    column: $table.desiredIsLiked,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingSetLikesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingSetLikesTable,
          PendingSetLike,
          $$PendingSetLikesTableFilterComposer,
          $$PendingSetLikesTableOrderingComposer,
          $$PendingSetLikesTableAnnotationComposer,
          $$PendingSetLikesTableCreateCompanionBuilder,
          $$PendingSetLikesTableUpdateCompanionBuilder,
          (
            PendingSetLike,
            BaseReferences<
              _$AppDatabase,
              $PendingSetLikesTable,
              PendingSetLike
            >,
          ),
          PendingSetLike,
          PrefetchHooks Function()
        > {
  $$PendingSetLikesTableTableManager(
    _$AppDatabase db,
    $PendingSetLikesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingSetLikesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingSetLikesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingSetLikesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> setId = const Value.absent(),
                Value<int> festivalId = const Value.absent(),
                Value<bool> desiredIsLiked = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingSetLikesCompanion(
                setId: setId,
                festivalId: festivalId,
                desiredIsLiked: desiredIsLiked,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> setId = const Value.absent(),
                required int festivalId,
                required bool desiredIsLiked,
                required DateTime createdAt,
              }) => PendingSetLikesCompanion.insert(
                setId: setId,
                festivalId: festivalId,
                desiredIsLiked: desiredIsLiked,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingSetLikesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingSetLikesTable,
      PendingSetLike,
      $$PendingSetLikesTableFilterComposer,
      $$PendingSetLikesTableOrderingComposer,
      $$PendingSetLikesTableAnnotationComposer,
      $$PendingSetLikesTableCreateCompanionBuilder,
      $$PendingSetLikesTableUpdateCompanionBuilder,
      (
        PendingSetLike,
        BaseReferences<_$AppDatabase, $PendingSetLikesTable, PendingSetLike>,
      ),
      PendingSetLike,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedFestivalsTableTableManager get cachedFestivals =>
      $$CachedFestivalsTableTableManager(_db, _db.cachedFestivals);
  $$CachedStagesTableTableManager get cachedStages =>
      $$CachedStagesTableTableManager(_db, _db.cachedStages);
  $$CachedFestivalSetsTableTableManager get cachedFestivalSets =>
      $$CachedFestivalSetsTableTableManager(_db, _db.cachedFestivalSets);
  $$PendingSetLikesTableTableManager get pendingSetLikes =>
      $$PendingSetLikesTableTableManager(_db, _db.pendingSetLikes);
}
