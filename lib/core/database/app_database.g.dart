// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MoviesTable extends Movies with TableInfo<$MoviesTable, MovieRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoviesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
    'tmdb_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalTitleMeta = const VerificationMeta(
    'originalTitle',
  );
  @override
  late final GeneratedColumn<String> originalTitle = GeneratedColumn<String>(
    'original_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseDateMeta = const VerificationMeta(
    'releaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
    'release_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseYearMeta = const VerificationMeta(
    'releaseYear',
  );
  @override
  late final GeneratedColumn<int> releaseYear = GeneratedColumn<int>(
    'release_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _runtimeMeta = const VerificationMeta(
    'runtime',
  );
  @override
  late final GeneratedColumn<int> runtime = GeneratedColumn<int>(
    'runtime',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backdropPathMeta = const VerificationMeta(
    'backdropPath',
  );
  @override
  late final GeneratedColumn<String> backdropPath = GeneratedColumn<String>(
    'backdrop_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _certificationMeta = const VerificationMeta(
    'certification',
  );
  @override
  late final GeneratedColumn<String> certification = GeneratedColumn<String>(
    'certification',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalLanguageMeta = const VerificationMeta(
    'originalLanguage',
  );
  @override
  late final GeneratedColumn<String> originalLanguage = GeneratedColumn<String>(
    'original_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tmdbCollectionIdMeta = const VerificationMeta(
    'tmdbCollectionId',
  );
  @override
  late final GeneratedColumn<int> tmdbCollectionId = GeneratedColumn<int>(
    'tmdb_collection_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CollectionStatus, String>
  userStatus = GeneratedColumn<String>(
    'user_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(CollectionStatus.owned.name),
  ).withConverter<CollectionStatus>($MoviesTable.$converteruserStatus);
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastMetadataSyncAtMeta =
      const VerificationMeta('lastMetadataSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastMetadataSyncAt =
      GeneratedColumn<DateTime>(
        'last_metadata_sync_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tmdbId,
    title,
    originalTitle,
    overview,
    releaseDate,
    releaseYear,
    runtime,
    posterPath,
    backdropPath,
    certification,
    originalLanguage,
    tmdbCollectionId,
    userStatus,
    createdAt,
    updatedAt,
    lastMetadataSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movies';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovieRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(
        _tmdbIdMeta,
        tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('original_title')) {
      context.handle(
        _originalTitleMeta,
        originalTitle.isAcceptableOrUnknown(
          data['original_title']!,
          _originalTitleMeta,
        ),
      );
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    }
    if (data.containsKey('release_date')) {
      context.handle(
        _releaseDateMeta,
        releaseDate.isAcceptableOrUnknown(
          data['release_date']!,
          _releaseDateMeta,
        ),
      );
    }
    if (data.containsKey('release_year')) {
      context.handle(
        _releaseYearMeta,
        releaseYear.isAcceptableOrUnknown(
          data['release_year']!,
          _releaseYearMeta,
        ),
      );
    }
    if (data.containsKey('runtime')) {
      context.handle(
        _runtimeMeta,
        runtime.isAcceptableOrUnknown(data['runtime']!, _runtimeMeta),
      );
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    }
    if (data.containsKey('backdrop_path')) {
      context.handle(
        _backdropPathMeta,
        backdropPath.isAcceptableOrUnknown(
          data['backdrop_path']!,
          _backdropPathMeta,
        ),
      );
    }
    if (data.containsKey('certification')) {
      context.handle(
        _certificationMeta,
        certification.isAcceptableOrUnknown(
          data['certification']!,
          _certificationMeta,
        ),
      );
    }
    if (data.containsKey('original_language')) {
      context.handle(
        _originalLanguageMeta,
        originalLanguage.isAcceptableOrUnknown(
          data['original_language']!,
          _originalLanguageMeta,
        ),
      );
    }
    if (data.containsKey('tmdb_collection_id')) {
      context.handle(
        _tmdbCollectionIdMeta,
        tmdbCollectionId.isAcceptableOrUnknown(
          data['tmdb_collection_id']!,
          _tmdbCollectionIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('last_metadata_sync_at')) {
      context.handle(
        _lastMetadataSyncAtMeta,
        lastMetadataSyncAt.isAcceptableOrUnknown(
          data['last_metadata_sync_at']!,
          _lastMetadataSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovieRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovieRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tmdbId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      originalTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_title'],
      ),
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      ),
      releaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}release_date'],
      ),
      releaseYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}release_year'],
      ),
      runtime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}runtime'],
      ),
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      ),
      backdropPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backdrop_path'],
      ),
      certification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}certification'],
      ),
      originalLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_language'],
      ),
      tmdbCollectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_collection_id'],
      ),
      userStatus: $MoviesTable.$converteruserStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}user_status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastMetadataSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_metadata_sync_at'],
      ),
    );
  }

  @override
  $MoviesTable createAlias(String alias) {
    return $MoviesTable(attachedDatabase, alias);
  }

  static TypeConverter<CollectionStatus, String> $converteruserStatus =
      const CollectionStatusConverter();
}

class MovieRow extends DataClass implements Insertable<MovieRow> {
  final int id;
  final int? tmdbId;
  final String title;
  final String? originalTitle;
  final String? overview;
  final DateTime? releaseDate;
  final int? releaseYear;
  final int? runtime;
  final String? posterPath;
  final String? backdropPath;
  final String? certification;
  final String? originalLanguage;
  final int? tmdbCollectionId;
  final CollectionStatus userStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastMetadataSyncAt;
  const MovieRow({
    required this.id,
    this.tmdbId,
    required this.title,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.releaseYear,
    this.runtime,
    this.posterPath,
    this.backdropPath,
    this.certification,
    this.originalLanguage,
    this.tmdbCollectionId,
    required this.userStatus,
    required this.createdAt,
    required this.updatedAt,
    this.lastMetadataSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || tmdbId != null) {
      map['tmdb_id'] = Variable<int>(tmdbId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || originalTitle != null) {
      map['original_title'] = Variable<String>(originalTitle);
    }
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<DateTime>(releaseDate);
    }
    if (!nullToAbsent || releaseYear != null) {
      map['release_year'] = Variable<int>(releaseYear);
    }
    if (!nullToAbsent || runtime != null) {
      map['runtime'] = Variable<int>(runtime);
    }
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || backdropPath != null) {
      map['backdrop_path'] = Variable<String>(backdropPath);
    }
    if (!nullToAbsent || certification != null) {
      map['certification'] = Variable<String>(certification);
    }
    if (!nullToAbsent || originalLanguage != null) {
      map['original_language'] = Variable<String>(originalLanguage);
    }
    if (!nullToAbsent || tmdbCollectionId != null) {
      map['tmdb_collection_id'] = Variable<int>(tmdbCollectionId);
    }
    {
      map['user_status'] = Variable<String>(
        $MoviesTable.$converteruserStatus.toSql(userStatus),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastMetadataSyncAt != null) {
      map['last_metadata_sync_at'] = Variable<DateTime>(lastMetadataSyncAt);
    }
    return map;
  }

  MoviesCompanion toCompanion(bool nullToAbsent) {
    return MoviesCompanion(
      id: Value(id),
      tmdbId: tmdbId == null && nullToAbsent
          ? const Value.absent()
          : Value(tmdbId),
      title: Value(title),
      originalTitle: originalTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(originalTitle),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      releaseYear: releaseYear == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseYear),
      runtime: runtime == null && nullToAbsent
          ? const Value.absent()
          : Value(runtime),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      backdropPath: backdropPath == null && nullToAbsent
          ? const Value.absent()
          : Value(backdropPath),
      certification: certification == null && nullToAbsent
          ? const Value.absent()
          : Value(certification),
      originalLanguage: originalLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLanguage),
      tmdbCollectionId: tmdbCollectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(tmdbCollectionId),
      userStatus: Value(userStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastMetadataSyncAt: lastMetadataSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMetadataSyncAt),
    );
  }

  factory MovieRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovieRow(
      id: serializer.fromJson<int>(json['id']),
      tmdbId: serializer.fromJson<int?>(json['tmdbId']),
      title: serializer.fromJson<String>(json['title']),
      originalTitle: serializer.fromJson<String?>(json['originalTitle']),
      overview: serializer.fromJson<String?>(json['overview']),
      releaseDate: serializer.fromJson<DateTime?>(json['releaseDate']),
      releaseYear: serializer.fromJson<int?>(json['releaseYear']),
      runtime: serializer.fromJson<int?>(json['runtime']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      backdropPath: serializer.fromJson<String?>(json['backdropPath']),
      certification: serializer.fromJson<String?>(json['certification']),
      originalLanguage: serializer.fromJson<String?>(json['originalLanguage']),
      tmdbCollectionId: serializer.fromJson<int?>(json['tmdbCollectionId']),
      userStatus: serializer.fromJson<CollectionStatus>(json['userStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastMetadataSyncAt: serializer.fromJson<DateTime?>(
        json['lastMetadataSyncAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tmdbId': serializer.toJson<int?>(tmdbId),
      'title': serializer.toJson<String>(title),
      'originalTitle': serializer.toJson<String?>(originalTitle),
      'overview': serializer.toJson<String?>(overview),
      'releaseDate': serializer.toJson<DateTime?>(releaseDate),
      'releaseYear': serializer.toJson<int?>(releaseYear),
      'runtime': serializer.toJson<int?>(runtime),
      'posterPath': serializer.toJson<String?>(posterPath),
      'backdropPath': serializer.toJson<String?>(backdropPath),
      'certification': serializer.toJson<String?>(certification),
      'originalLanguage': serializer.toJson<String?>(originalLanguage),
      'tmdbCollectionId': serializer.toJson<int?>(tmdbCollectionId),
      'userStatus': serializer.toJson<CollectionStatus>(userStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastMetadataSyncAt': serializer.toJson<DateTime?>(lastMetadataSyncAt),
    };
  }

  MovieRow copyWith({
    int? id,
    Value<int?> tmdbId = const Value.absent(),
    String? title,
    Value<String?> originalTitle = const Value.absent(),
    Value<String?> overview = const Value.absent(),
    Value<DateTime?> releaseDate = const Value.absent(),
    Value<int?> releaseYear = const Value.absent(),
    Value<int?> runtime = const Value.absent(),
    Value<String?> posterPath = const Value.absent(),
    Value<String?> backdropPath = const Value.absent(),
    Value<String?> certification = const Value.absent(),
    Value<String?> originalLanguage = const Value.absent(),
    Value<int?> tmdbCollectionId = const Value.absent(),
    CollectionStatus? userStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastMetadataSyncAt = const Value.absent(),
  }) => MovieRow(
    id: id ?? this.id,
    tmdbId: tmdbId.present ? tmdbId.value : this.tmdbId,
    title: title ?? this.title,
    originalTitle: originalTitle.present
        ? originalTitle.value
        : this.originalTitle,
    overview: overview.present ? overview.value : this.overview,
    releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
    releaseYear: releaseYear.present ? releaseYear.value : this.releaseYear,
    runtime: runtime.present ? runtime.value : this.runtime,
    posterPath: posterPath.present ? posterPath.value : this.posterPath,
    backdropPath: backdropPath.present ? backdropPath.value : this.backdropPath,
    certification: certification.present
        ? certification.value
        : this.certification,
    originalLanguage: originalLanguage.present
        ? originalLanguage.value
        : this.originalLanguage,
    tmdbCollectionId: tmdbCollectionId.present
        ? tmdbCollectionId.value
        : this.tmdbCollectionId,
    userStatus: userStatus ?? this.userStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastMetadataSyncAt: lastMetadataSyncAt.present
        ? lastMetadataSyncAt.value
        : this.lastMetadataSyncAt,
  );
  MovieRow copyWithCompanion(MoviesCompanion data) {
    return MovieRow(
      id: data.id.present ? data.id.value : this.id,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      title: data.title.present ? data.title.value : this.title,
      originalTitle: data.originalTitle.present
          ? data.originalTitle.value
          : this.originalTitle,
      overview: data.overview.present ? data.overview.value : this.overview,
      releaseDate: data.releaseDate.present
          ? data.releaseDate.value
          : this.releaseDate,
      releaseYear: data.releaseYear.present
          ? data.releaseYear.value
          : this.releaseYear,
      runtime: data.runtime.present ? data.runtime.value : this.runtime,
      posterPath: data.posterPath.present
          ? data.posterPath.value
          : this.posterPath,
      backdropPath: data.backdropPath.present
          ? data.backdropPath.value
          : this.backdropPath,
      certification: data.certification.present
          ? data.certification.value
          : this.certification,
      originalLanguage: data.originalLanguage.present
          ? data.originalLanguage.value
          : this.originalLanguage,
      tmdbCollectionId: data.tmdbCollectionId.present
          ? data.tmdbCollectionId.value
          : this.tmdbCollectionId,
      userStatus: data.userStatus.present
          ? data.userStatus.value
          : this.userStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastMetadataSyncAt: data.lastMetadataSyncAt.present
          ? data.lastMetadataSyncAt.value
          : this.lastMetadataSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovieRow(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('title: $title, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('overview: $overview, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('runtime: $runtime, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('certification: $certification, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('tmdbCollectionId: $tmdbCollectionId, ')
          ..write('userStatus: $userStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastMetadataSyncAt: $lastMetadataSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tmdbId,
    title,
    originalTitle,
    overview,
    releaseDate,
    releaseYear,
    runtime,
    posterPath,
    backdropPath,
    certification,
    originalLanguage,
    tmdbCollectionId,
    userStatus,
    createdAt,
    updatedAt,
    lastMetadataSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovieRow &&
          other.id == this.id &&
          other.tmdbId == this.tmdbId &&
          other.title == this.title &&
          other.originalTitle == this.originalTitle &&
          other.overview == this.overview &&
          other.releaseDate == this.releaseDate &&
          other.releaseYear == this.releaseYear &&
          other.runtime == this.runtime &&
          other.posterPath == this.posterPath &&
          other.backdropPath == this.backdropPath &&
          other.certification == this.certification &&
          other.originalLanguage == this.originalLanguage &&
          other.tmdbCollectionId == this.tmdbCollectionId &&
          other.userStatus == this.userStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastMetadataSyncAt == this.lastMetadataSyncAt);
}

class MoviesCompanion extends UpdateCompanion<MovieRow> {
  final Value<int> id;
  final Value<int?> tmdbId;
  final Value<String> title;
  final Value<String?> originalTitle;
  final Value<String?> overview;
  final Value<DateTime?> releaseDate;
  final Value<int?> releaseYear;
  final Value<int?> runtime;
  final Value<String?> posterPath;
  final Value<String?> backdropPath;
  final Value<String?> certification;
  final Value<String?> originalLanguage;
  final Value<int?> tmdbCollectionId;
  final Value<CollectionStatus> userStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastMetadataSyncAt;
  const MoviesCompanion({
    this.id = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.title = const Value.absent(),
    this.originalTitle = const Value.absent(),
    this.overview = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.runtime = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.certification = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.tmdbCollectionId = const Value.absent(),
    this.userStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastMetadataSyncAt = const Value.absent(),
  });
  MoviesCompanion.insert({
    this.id = const Value.absent(),
    this.tmdbId = const Value.absent(),
    required String title,
    this.originalTitle = const Value.absent(),
    this.overview = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.runtime = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.certification = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.tmdbCollectionId = const Value.absent(),
    this.userStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastMetadataSyncAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<MovieRow> custom({
    Expression<int>? id,
    Expression<int>? tmdbId,
    Expression<String>? title,
    Expression<String>? originalTitle,
    Expression<String>? overview,
    Expression<DateTime>? releaseDate,
    Expression<int>? releaseYear,
    Expression<int>? runtime,
    Expression<String>? posterPath,
    Expression<String>? backdropPath,
    Expression<String>? certification,
    Expression<String>? originalLanguage,
    Expression<int>? tmdbCollectionId,
    Expression<String>? userStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastMetadataSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (title != null) 'title': title,
      if (originalTitle != null) 'original_title': originalTitle,
      if (overview != null) 'overview': overview,
      if (releaseDate != null) 'release_date': releaseDate,
      if (releaseYear != null) 'release_year': releaseYear,
      if (runtime != null) 'runtime': runtime,
      if (posterPath != null) 'poster_path': posterPath,
      if (backdropPath != null) 'backdrop_path': backdropPath,
      if (certification != null) 'certification': certification,
      if (originalLanguage != null) 'original_language': originalLanguage,
      if (tmdbCollectionId != null) 'tmdb_collection_id': tmdbCollectionId,
      if (userStatus != null) 'user_status': userStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastMetadataSyncAt != null)
        'last_metadata_sync_at': lastMetadataSyncAt,
    });
  }

  MoviesCompanion copyWith({
    Value<int>? id,
    Value<int?>? tmdbId,
    Value<String>? title,
    Value<String?>? originalTitle,
    Value<String?>? overview,
    Value<DateTime?>? releaseDate,
    Value<int?>? releaseYear,
    Value<int?>? runtime,
    Value<String?>? posterPath,
    Value<String?>? backdropPath,
    Value<String?>? certification,
    Value<String?>? originalLanguage,
    Value<int?>? tmdbCollectionId,
    Value<CollectionStatus>? userStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastMetadataSyncAt,
  }) {
    return MoviesCompanion(
      id: id ?? this.id,
      tmdbId: tmdbId ?? this.tmdbId,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      releaseDate: releaseDate ?? this.releaseDate,
      releaseYear: releaseYear ?? this.releaseYear,
      runtime: runtime ?? this.runtime,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      certification: certification ?? this.certification,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      tmdbCollectionId: tmdbCollectionId ?? this.tmdbCollectionId,
      userStatus: userStatus ?? this.userStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMetadataSyncAt: lastMetadataSyncAt ?? this.lastMetadataSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (originalTitle.present) {
      map['original_title'] = Variable<String>(originalTitle.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (releaseYear.present) {
      map['release_year'] = Variable<int>(releaseYear.value);
    }
    if (runtime.present) {
      map['runtime'] = Variable<int>(runtime.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (backdropPath.present) {
      map['backdrop_path'] = Variable<String>(backdropPath.value);
    }
    if (certification.present) {
      map['certification'] = Variable<String>(certification.value);
    }
    if (originalLanguage.present) {
      map['original_language'] = Variable<String>(originalLanguage.value);
    }
    if (tmdbCollectionId.present) {
      map['tmdb_collection_id'] = Variable<int>(tmdbCollectionId.value);
    }
    if (userStatus.present) {
      map['user_status'] = Variable<String>(
        $MoviesTable.$converteruserStatus.toSql(userStatus.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastMetadataSyncAt.present) {
      map['last_metadata_sync_at'] = Variable<DateTime>(
        lastMetadataSyncAt.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoviesCompanion(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('title: $title, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('overview: $overview, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('runtime: $runtime, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('certification: $certification, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('tmdbCollectionId: $tmdbCollectionId, ')
          ..write('userStatus: $userStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastMetadataSyncAt: $lastMetadataSyncAt')
          ..write(')'))
        .toString();
  }
}

class $GenresTable extends Genres with TableInfo<$GenresTable, GenreRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GenresTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
    'tmdb_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  List<GeneratedColumn> get $columns => [id, tmdbId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'genres';
  @override
  VerificationContext validateIntegrity(
    Insertable<GenreRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(
        _tmdbIdMeta,
        tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
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
  GenreRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GenreRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tmdbId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $GenresTable createAlias(String alias) {
    return $GenresTable(attachedDatabase, alias);
  }
}

class GenreRow extends DataClass implements Insertable<GenreRow> {
  final int id;
  final int tmdbId;
  final String name;
  const GenreRow({required this.id, required this.tmdbId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['name'] = Variable<String>(name);
    return map;
  }

  GenresCompanion toCompanion(bool nullToAbsent) {
    return GenresCompanion(
      id: Value(id),
      tmdbId: Value(tmdbId),
      name: Value(name),
    );
  }

  factory GenreRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GenreRow(
      id: serializer.fromJson<int>(json['id']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'name': serializer.toJson<String>(name),
    };
  }

  GenreRow copyWith({int? id, int? tmdbId, String? name}) => GenreRow(
    id: id ?? this.id,
    tmdbId: tmdbId ?? this.tmdbId,
    name: name ?? this.name,
  );
  GenreRow copyWithCompanion(GenresCompanion data) {
    return GenreRow(
      id: data.id.present ? data.id.value : this.id,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GenreRow(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tmdbId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GenreRow &&
          other.id == this.id &&
          other.tmdbId == this.tmdbId &&
          other.name == this.name);
}

class GenresCompanion extends UpdateCompanion<GenreRow> {
  final Value<int> id;
  final Value<int> tmdbId;
  final Value<String> name;
  const GenresCompanion({
    this.id = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.name = const Value.absent(),
  });
  GenresCompanion.insert({
    this.id = const Value.absent(),
    required int tmdbId,
    required String name,
  }) : tmdbId = Value(tmdbId),
       name = Value(name);
  static Insertable<GenreRow> custom({
    Expression<int>? id,
    Expression<int>? tmdbId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (name != null) 'name': name,
    });
  }

  GenresCompanion copyWith({
    Value<int>? id,
    Value<int>? tmdbId,
    Value<String>? name,
  }) {
    return GenresCompanion(
      id: id ?? this.id,
      tmdbId: tmdbId ?? this.tmdbId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GenresCompanion(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $MovieGenresTable extends MovieGenres
    with TableInfo<$MovieGenresTable, MovieGenreRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovieGenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
    'movie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES movies (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _genreIdMeta = const VerificationMeta(
    'genreId',
  );
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
    'genre_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES genres (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [movieId, genreId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movie_genres';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovieGenreRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(
        _genreIdMeta,
        genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta),
      );
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movieId, genreId};
  @override
  MovieGenreRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovieGenreRow(
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      )!,
      genreId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}genre_id'],
      )!,
    );
  }

  @override
  $MovieGenresTable createAlias(String alias) {
    return $MovieGenresTable(attachedDatabase, alias);
  }
}

class MovieGenreRow extends DataClass implements Insertable<MovieGenreRow> {
  final int movieId;
  final int genreId;
  const MovieGenreRow({required this.movieId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['movie_id'] = Variable<int>(movieId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  MovieGenresCompanion toCompanion(bool nullToAbsent) {
    return MovieGenresCompanion(
      movieId: Value(movieId),
      genreId: Value(genreId),
    );
  }

  factory MovieGenreRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovieGenreRow(
      movieId: serializer.fromJson<int>(json['movieId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'movieId': serializer.toJson<int>(movieId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  MovieGenreRow copyWith({int? movieId, int? genreId}) => MovieGenreRow(
    movieId: movieId ?? this.movieId,
    genreId: genreId ?? this.genreId,
  );
  MovieGenreRow copyWithCompanion(MovieGenresCompanion data) {
    return MovieGenreRow(
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      genreId: data.genreId.present ? data.genreId.value : this.genreId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovieGenreRow(')
          ..write('movieId: $movieId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(movieId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovieGenreRow &&
          other.movieId == this.movieId &&
          other.genreId == this.genreId);
}

class MovieGenresCompanion extends UpdateCompanion<MovieGenreRow> {
  final Value<int> movieId;
  final Value<int> genreId;
  final Value<int> rowid;
  const MovieGenresCompanion({
    this.movieId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MovieGenresCompanion.insert({
    required int movieId,
    required int genreId,
    this.rowid = const Value.absent(),
  }) : movieId = Value(movieId),
       genreId = Value(genreId);
  static Insertable<MovieGenreRow> custom({
    Expression<int>? movieId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (movieId != null) 'movie_id': movieId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MovieGenresCompanion copyWith({
    Value<int>? movieId,
    Value<int>? genreId,
    Value<int>? rowid,
  }) {
    return MovieGenresCompanion(
      movieId: movieId ?? this.movieId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovieGenresCompanion(')
          ..write('movieId: $movieId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhysicalEditionsTable extends PhysicalEditions
    with TableInfo<$PhysicalEditionsTable, PhysicalEditionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhysicalEditionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _productTitleMeta = const VerificationMeta(
    'productTitle',
  );
  @override
  late final GeneratedColumn<String> productTitle = GeneratedColumn<String>(
    'product_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editionNameMeta = const VerificationMeta(
    'editionName',
  );
  @override
  late final GeneratedColumn<String> editionName = GeneratedColumn<String>(
    'edition_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaKindMeta = const VerificationMeta(
    'mediaKind',
  );
  @override
  late final GeneratedColumn<String> mediaKind = GeneratedColumn<String>(
    'media_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tmdbCollectionIdMeta = const VerificationMeta(
    'tmdbCollectionId',
  );
  @override
  late final GeneratedColumn<int> tmdbCollectionId = GeneratedColumn<int>(
    'tmdb_collection_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tmdbTvSeriesIdMeta = const VerificationMeta(
    'tmdbTvSeriesId',
  );
  @override
  late final GeneratedColumn<int> tmdbTvSeriesId = GeneratedColumn<int>(
    'tmdb_tv_series_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    productTitle,
    editionName,
    mediaKind,
    tmdbCollectionId,
    tmdbTvSeriesId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'physical_editions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PhysicalEditionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_title')) {
      context.handle(
        _productTitleMeta,
        productTitle.isAcceptableOrUnknown(
          data['product_title']!,
          _productTitleMeta,
        ),
      );
    }
    if (data.containsKey('edition_name')) {
      context.handle(
        _editionNameMeta,
        editionName.isAcceptableOrUnknown(
          data['edition_name']!,
          _editionNameMeta,
        ),
      );
    }
    if (data.containsKey('media_kind')) {
      context.handle(
        _mediaKindMeta,
        mediaKind.isAcceptableOrUnknown(data['media_kind']!, _mediaKindMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaKindMeta);
    }
    if (data.containsKey('tmdb_collection_id')) {
      context.handle(
        _tmdbCollectionIdMeta,
        tmdbCollectionId.isAcceptableOrUnknown(
          data['tmdb_collection_id']!,
          _tmdbCollectionIdMeta,
        ),
      );
    }
    if (data.containsKey('tmdb_tv_series_id')) {
      context.handle(
        _tmdbTvSeriesIdMeta,
        tmdbTvSeriesId.isAcceptableOrUnknown(
          data['tmdb_tv_series_id']!,
          _tmdbTvSeriesIdMeta,
        ),
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
  PhysicalEditionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhysicalEditionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_title'],
      ),
      editionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_name'],
      ),
      mediaKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_kind'],
      )!,
      tmdbCollectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_collection_id'],
      ),
      tmdbTvSeriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_tv_series_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PhysicalEditionsTable createAlias(String alias) {
    return $PhysicalEditionsTable(attachedDatabase, alias);
  }
}

class PhysicalEditionRow extends DataClass
    implements Insertable<PhysicalEditionRow> {
  final int id;
  final String? productTitle;
  final String? editionName;
  final String mediaKind;
  final int? tmdbCollectionId;
  final int? tmdbTvSeriesId;
  final DateTime createdAt;
  const PhysicalEditionRow({
    required this.id,
    this.productTitle,
    this.editionName,
    required this.mediaKind,
    this.tmdbCollectionId,
    this.tmdbTvSeriesId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || productTitle != null) {
      map['product_title'] = Variable<String>(productTitle);
    }
    if (!nullToAbsent || editionName != null) {
      map['edition_name'] = Variable<String>(editionName);
    }
    map['media_kind'] = Variable<String>(mediaKind);
    if (!nullToAbsent || tmdbCollectionId != null) {
      map['tmdb_collection_id'] = Variable<int>(tmdbCollectionId);
    }
    if (!nullToAbsent || tmdbTvSeriesId != null) {
      map['tmdb_tv_series_id'] = Variable<int>(tmdbTvSeriesId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PhysicalEditionsCompanion toCompanion(bool nullToAbsent) {
    return PhysicalEditionsCompanion(
      id: Value(id),
      productTitle: productTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(productTitle),
      editionName: editionName == null && nullToAbsent
          ? const Value.absent()
          : Value(editionName),
      mediaKind: Value(mediaKind),
      tmdbCollectionId: tmdbCollectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(tmdbCollectionId),
      tmdbTvSeriesId: tmdbTvSeriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(tmdbTvSeriesId),
      createdAt: Value(createdAt),
    );
  }

  factory PhysicalEditionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhysicalEditionRow(
      id: serializer.fromJson<int>(json['id']),
      productTitle: serializer.fromJson<String?>(json['productTitle']),
      editionName: serializer.fromJson<String?>(json['editionName']),
      mediaKind: serializer.fromJson<String>(json['mediaKind']),
      tmdbCollectionId: serializer.fromJson<int?>(json['tmdbCollectionId']),
      tmdbTvSeriesId: serializer.fromJson<int?>(json['tmdbTvSeriesId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productTitle': serializer.toJson<String?>(productTitle),
      'editionName': serializer.toJson<String?>(editionName),
      'mediaKind': serializer.toJson<String>(mediaKind),
      'tmdbCollectionId': serializer.toJson<int?>(tmdbCollectionId),
      'tmdbTvSeriesId': serializer.toJson<int?>(tmdbTvSeriesId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PhysicalEditionRow copyWith({
    int? id,
    Value<String?> productTitle = const Value.absent(),
    Value<String?> editionName = const Value.absent(),
    String? mediaKind,
    Value<int?> tmdbCollectionId = const Value.absent(),
    Value<int?> tmdbTvSeriesId = const Value.absent(),
    DateTime? createdAt,
  }) => PhysicalEditionRow(
    id: id ?? this.id,
    productTitle: productTitle.present ? productTitle.value : this.productTitle,
    editionName: editionName.present ? editionName.value : this.editionName,
    mediaKind: mediaKind ?? this.mediaKind,
    tmdbCollectionId: tmdbCollectionId.present
        ? tmdbCollectionId.value
        : this.tmdbCollectionId,
    tmdbTvSeriesId: tmdbTvSeriesId.present
        ? tmdbTvSeriesId.value
        : this.tmdbTvSeriesId,
    createdAt: createdAt ?? this.createdAt,
  );
  PhysicalEditionRow copyWithCompanion(PhysicalEditionsCompanion data) {
    return PhysicalEditionRow(
      id: data.id.present ? data.id.value : this.id,
      productTitle: data.productTitle.present
          ? data.productTitle.value
          : this.productTitle,
      editionName: data.editionName.present
          ? data.editionName.value
          : this.editionName,
      mediaKind: data.mediaKind.present ? data.mediaKind.value : this.mediaKind,
      tmdbCollectionId: data.tmdbCollectionId.present
          ? data.tmdbCollectionId.value
          : this.tmdbCollectionId,
      tmdbTvSeriesId: data.tmdbTvSeriesId.present
          ? data.tmdbTvSeriesId.value
          : this.tmdbTvSeriesId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhysicalEditionRow(')
          ..write('id: $id, ')
          ..write('productTitle: $productTitle, ')
          ..write('editionName: $editionName, ')
          ..write('mediaKind: $mediaKind, ')
          ..write('tmdbCollectionId: $tmdbCollectionId, ')
          ..write('tmdbTvSeriesId: $tmdbTvSeriesId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productTitle,
    editionName,
    mediaKind,
    tmdbCollectionId,
    tmdbTvSeriesId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhysicalEditionRow &&
          other.id == this.id &&
          other.productTitle == this.productTitle &&
          other.editionName == this.editionName &&
          other.mediaKind == this.mediaKind &&
          other.tmdbCollectionId == this.tmdbCollectionId &&
          other.tmdbTvSeriesId == this.tmdbTvSeriesId &&
          other.createdAt == this.createdAt);
}

class PhysicalEditionsCompanion extends UpdateCompanion<PhysicalEditionRow> {
  final Value<int> id;
  final Value<String?> productTitle;
  final Value<String?> editionName;
  final Value<String> mediaKind;
  final Value<int?> tmdbCollectionId;
  final Value<int?> tmdbTvSeriesId;
  final Value<DateTime> createdAt;
  const PhysicalEditionsCompanion({
    this.id = const Value.absent(),
    this.productTitle = const Value.absent(),
    this.editionName = const Value.absent(),
    this.mediaKind = const Value.absent(),
    this.tmdbCollectionId = const Value.absent(),
    this.tmdbTvSeriesId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PhysicalEditionsCompanion.insert({
    this.id = const Value.absent(),
    this.productTitle = const Value.absent(),
    this.editionName = const Value.absent(),
    required String mediaKind,
    this.tmdbCollectionId = const Value.absent(),
    this.tmdbTvSeriesId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : mediaKind = Value(mediaKind);
  static Insertable<PhysicalEditionRow> custom({
    Expression<int>? id,
    Expression<String>? productTitle,
    Expression<String>? editionName,
    Expression<String>? mediaKind,
    Expression<int>? tmdbCollectionId,
    Expression<int>? tmdbTvSeriesId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productTitle != null) 'product_title': productTitle,
      if (editionName != null) 'edition_name': editionName,
      if (mediaKind != null) 'media_kind': mediaKind,
      if (tmdbCollectionId != null) 'tmdb_collection_id': tmdbCollectionId,
      if (tmdbTvSeriesId != null) 'tmdb_tv_series_id': tmdbTvSeriesId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PhysicalEditionsCompanion copyWith({
    Value<int>? id,
    Value<String?>? productTitle,
    Value<String?>? editionName,
    Value<String>? mediaKind,
    Value<int?>? tmdbCollectionId,
    Value<int?>? tmdbTvSeriesId,
    Value<DateTime>? createdAt,
  }) {
    return PhysicalEditionsCompanion(
      id: id ?? this.id,
      productTitle: productTitle ?? this.productTitle,
      editionName: editionName ?? this.editionName,
      mediaKind: mediaKind ?? this.mediaKind,
      tmdbCollectionId: tmdbCollectionId ?? this.tmdbCollectionId,
      tmdbTvSeriesId: tmdbTvSeriesId ?? this.tmdbTvSeriesId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productTitle.present) {
      map['product_title'] = Variable<String>(productTitle.value);
    }
    if (editionName.present) {
      map['edition_name'] = Variable<String>(editionName.value);
    }
    if (mediaKind.present) {
      map['media_kind'] = Variable<String>(mediaKind.value);
    }
    if (tmdbCollectionId.present) {
      map['tmdb_collection_id'] = Variable<int>(tmdbCollectionId.value);
    }
    if (tmdbTvSeriesId.present) {
      map['tmdb_tv_series_id'] = Variable<int>(tmdbTvSeriesId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhysicalEditionsCompanion(')
          ..write('id: $id, ')
          ..write('productTitle: $productTitle, ')
          ..write('editionName: $editionName, ')
          ..write('mediaKind: $mediaKind, ')
          ..write('tmdbCollectionId: $tmdbCollectionId, ')
          ..write('tmdbTvSeriesId: $tmdbTvSeriesId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BarcodesTable extends Barcodes
    with TableInfo<$BarcodesTable, BarcodeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BarcodesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
    'movie_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES movies (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _physicalEditionIdMeta = const VerificationMeta(
    'physicalEditionId',
  );
  @override
  late final GeneratedColumn<int> physicalEditionId = GeneratedColumn<int>(
    'physical_edition_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES physical_editions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _barcodeTypeMeta = const VerificationMeta(
    'barcodeType',
  );
  @override
  late final GeneratedColumn<String> barcodeType = GeneratedColumn<String>(
    'barcode_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productTitleMeta = const VerificationMeta(
    'productTitle',
  );
  @override
  late final GeneratedColumn<String> productTitle = GeneratedColumn<String>(
    'product_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editionNameMeta = const VerificationMeta(
    'editionName',
  );
  @override
  late final GeneratedColumn<String> editionName = GeneratedColumn<String>(
    'edition_name',
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
    movieId,
    physicalEditionId,
    barcode,
    barcodeType,
    productTitle,
    editionName,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'barcodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<BarcodeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    }
    if (data.containsKey('physical_edition_id')) {
      context.handle(
        _physicalEditionIdMeta,
        physicalEditionId.isAcceptableOrUnknown(
          data['physical_edition_id']!,
          _physicalEditionIdMeta,
        ),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('barcode_type')) {
      context.handle(
        _barcodeTypeMeta,
        barcodeType.isAcceptableOrUnknown(
          data['barcode_type']!,
          _barcodeTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_barcodeTypeMeta);
    }
    if (data.containsKey('product_title')) {
      context.handle(
        _productTitleMeta,
        productTitle.isAcceptableOrUnknown(
          data['product_title']!,
          _productTitleMeta,
        ),
      );
    }
    if (data.containsKey('edition_name')) {
      context.handle(
        _editionNameMeta,
        editionName.isAcceptableOrUnknown(
          data['edition_name']!,
          _editionNameMeta,
        ),
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
  BarcodeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BarcodeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      ),
      physicalEditionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}physical_edition_id'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      barcodeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode_type'],
      )!,
      productTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_title'],
      ),
      editionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BarcodesTable createAlias(String alias) {
    return $BarcodesTable(attachedDatabase, alias);
  }
}

class BarcodeRow extends DataClass implements Insertable<BarcodeRow> {
  final int id;
  final int? movieId;
  final int? physicalEditionId;
  final String barcode;
  final String barcodeType;
  final String? productTitle;
  final String? editionName;
  final DateTime createdAt;
  const BarcodeRow({
    required this.id,
    this.movieId,
    this.physicalEditionId,
    required this.barcode,
    required this.barcodeType,
    this.productTitle,
    this.editionName,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || movieId != null) {
      map['movie_id'] = Variable<int>(movieId);
    }
    if (!nullToAbsent || physicalEditionId != null) {
      map['physical_edition_id'] = Variable<int>(physicalEditionId);
    }
    map['barcode'] = Variable<String>(barcode);
    map['barcode_type'] = Variable<String>(barcodeType);
    if (!nullToAbsent || productTitle != null) {
      map['product_title'] = Variable<String>(productTitle);
    }
    if (!nullToAbsent || editionName != null) {
      map['edition_name'] = Variable<String>(editionName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BarcodesCompanion toCompanion(bool nullToAbsent) {
    return BarcodesCompanion(
      id: Value(id),
      movieId: movieId == null && nullToAbsent
          ? const Value.absent()
          : Value(movieId),
      physicalEditionId: physicalEditionId == null && nullToAbsent
          ? const Value.absent()
          : Value(physicalEditionId),
      barcode: Value(barcode),
      barcodeType: Value(barcodeType),
      productTitle: productTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(productTitle),
      editionName: editionName == null && nullToAbsent
          ? const Value.absent()
          : Value(editionName),
      createdAt: Value(createdAt),
    );
  }

  factory BarcodeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BarcodeRow(
      id: serializer.fromJson<int>(json['id']),
      movieId: serializer.fromJson<int?>(json['movieId']),
      physicalEditionId: serializer.fromJson<int?>(json['physicalEditionId']),
      barcode: serializer.fromJson<String>(json['barcode']),
      barcodeType: serializer.fromJson<String>(json['barcodeType']),
      productTitle: serializer.fromJson<String?>(json['productTitle']),
      editionName: serializer.fromJson<String?>(json['editionName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'movieId': serializer.toJson<int?>(movieId),
      'physicalEditionId': serializer.toJson<int?>(physicalEditionId),
      'barcode': serializer.toJson<String>(barcode),
      'barcodeType': serializer.toJson<String>(barcodeType),
      'productTitle': serializer.toJson<String?>(productTitle),
      'editionName': serializer.toJson<String?>(editionName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BarcodeRow copyWith({
    int? id,
    Value<int?> movieId = const Value.absent(),
    Value<int?> physicalEditionId = const Value.absent(),
    String? barcode,
    String? barcodeType,
    Value<String?> productTitle = const Value.absent(),
    Value<String?> editionName = const Value.absent(),
    DateTime? createdAt,
  }) => BarcodeRow(
    id: id ?? this.id,
    movieId: movieId.present ? movieId.value : this.movieId,
    physicalEditionId: physicalEditionId.present
        ? physicalEditionId.value
        : this.physicalEditionId,
    barcode: barcode ?? this.barcode,
    barcodeType: barcodeType ?? this.barcodeType,
    productTitle: productTitle.present ? productTitle.value : this.productTitle,
    editionName: editionName.present ? editionName.value : this.editionName,
    createdAt: createdAt ?? this.createdAt,
  );
  BarcodeRow copyWithCompanion(BarcodesCompanion data) {
    return BarcodeRow(
      id: data.id.present ? data.id.value : this.id,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      physicalEditionId: data.physicalEditionId.present
          ? data.physicalEditionId.value
          : this.physicalEditionId,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      barcodeType: data.barcodeType.present
          ? data.barcodeType.value
          : this.barcodeType,
      productTitle: data.productTitle.present
          ? data.productTitle.value
          : this.productTitle,
      editionName: data.editionName.present
          ? data.editionName.value
          : this.editionName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeRow(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('physicalEditionId: $physicalEditionId, ')
          ..write('barcode: $barcode, ')
          ..write('barcodeType: $barcodeType, ')
          ..write('productTitle: $productTitle, ')
          ..write('editionName: $editionName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    movieId,
    physicalEditionId,
    barcode,
    barcodeType,
    productTitle,
    editionName,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BarcodeRow &&
          other.id == this.id &&
          other.movieId == this.movieId &&
          other.physicalEditionId == this.physicalEditionId &&
          other.barcode == this.barcode &&
          other.barcodeType == this.barcodeType &&
          other.productTitle == this.productTitle &&
          other.editionName == this.editionName &&
          other.createdAt == this.createdAt);
}

class BarcodesCompanion extends UpdateCompanion<BarcodeRow> {
  final Value<int> id;
  final Value<int?> movieId;
  final Value<int?> physicalEditionId;
  final Value<String> barcode;
  final Value<String> barcodeType;
  final Value<String?> productTitle;
  final Value<String?> editionName;
  final Value<DateTime> createdAt;
  const BarcodesCompanion({
    this.id = const Value.absent(),
    this.movieId = const Value.absent(),
    this.physicalEditionId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.barcodeType = const Value.absent(),
    this.productTitle = const Value.absent(),
    this.editionName = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BarcodesCompanion.insert({
    this.id = const Value.absent(),
    this.movieId = const Value.absent(),
    this.physicalEditionId = const Value.absent(),
    required String barcode,
    required String barcodeType,
    this.productTitle = const Value.absent(),
    this.editionName = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : barcode = Value(barcode),
       barcodeType = Value(barcodeType);
  static Insertable<BarcodeRow> custom({
    Expression<int>? id,
    Expression<int>? movieId,
    Expression<int>? physicalEditionId,
    Expression<String>? barcode,
    Expression<String>? barcodeType,
    Expression<String>? productTitle,
    Expression<String>? editionName,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (movieId != null) 'movie_id': movieId,
      if (physicalEditionId != null) 'physical_edition_id': physicalEditionId,
      if (barcode != null) 'barcode': barcode,
      if (barcodeType != null) 'barcode_type': barcodeType,
      if (productTitle != null) 'product_title': productTitle,
      if (editionName != null) 'edition_name': editionName,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BarcodesCompanion copyWith({
    Value<int>? id,
    Value<int?>? movieId,
    Value<int?>? physicalEditionId,
    Value<String>? barcode,
    Value<String>? barcodeType,
    Value<String?>? productTitle,
    Value<String?>? editionName,
    Value<DateTime>? createdAt,
  }) {
    return BarcodesCompanion(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      physicalEditionId: physicalEditionId ?? this.physicalEditionId,
      barcode: barcode ?? this.barcode,
      barcodeType: barcodeType ?? this.barcodeType,
      productTitle: productTitle ?? this.productTitle,
      editionName: editionName ?? this.editionName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (physicalEditionId.present) {
      map['physical_edition_id'] = Variable<int>(physicalEditionId.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (barcodeType.present) {
      map['barcode_type'] = Variable<String>(barcodeType.value);
    }
    if (productTitle.present) {
      map['product_title'] = Variable<String>(productTitle.value);
    }
    if (editionName.present) {
      map['edition_name'] = Variable<String>(editionName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BarcodesCompanion(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('physicalEditionId: $physicalEditionId, ')
          ..write('barcode: $barcode, ')
          ..write('barcodeType: $barcodeType, ')
          ..write('productTitle: $productTitle, ')
          ..write('editionName: $editionName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, CollectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tmdbCollectionIdMeta = const VerificationMeta(
    'tmdbCollectionId',
  );
  @override
  late final GeneratedColumn<int> tmdbCollectionId = GeneratedColumn<int>(
    'tmdb_collection_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backdropPathMeta = const VerificationMeta(
    'backdropPath',
  );
  @override
  late final GeneratedColumn<String> backdropPath = GeneratedColumn<String>(
    'backdrop_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tmdbCollectionId,
    name,
    overview,
    posterPath,
    backdropPath,
    isCustom,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tmdb_collection_id')) {
      context.handle(
        _tmdbCollectionIdMeta,
        tmdbCollectionId.isAcceptableOrUnknown(
          data['tmdb_collection_id']!,
          _tmdbCollectionIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    }
    if (data.containsKey('backdrop_path')) {
      context.handle(
        _backdropPathMeta,
        backdropPath.isAcceptableOrUnknown(
          data['backdrop_path']!,
          _backdropPathMeta,
        ),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CollectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tmdbCollectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_collection_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      ),
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      ),
      backdropPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backdrop_path'],
      ),
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(attachedDatabase, alias);
  }
}

class CollectionRow extends DataClass implements Insertable<CollectionRow> {
  final int id;
  final int? tmdbCollectionId;
  final String name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final bool isCustom;
  final DateTime? lastSyncedAt;
  const CollectionRow({
    required this.id,
    this.tmdbCollectionId,
    required this.name,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.isCustom,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || tmdbCollectionId != null) {
      map['tmdb_collection_id'] = Variable<int>(tmdbCollectionId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || backdropPath != null) {
      map['backdrop_path'] = Variable<String>(backdropPath);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  CollectionsCompanion toCompanion(bool nullToAbsent) {
    return CollectionsCompanion(
      id: Value(id),
      tmdbCollectionId: tmdbCollectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(tmdbCollectionId),
      name: Value(name),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      backdropPath: backdropPath == null && nullToAbsent
          ? const Value.absent()
          : Value(backdropPath),
      isCustom: Value(isCustom),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory CollectionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionRow(
      id: serializer.fromJson<int>(json['id']),
      tmdbCollectionId: serializer.fromJson<int?>(json['tmdbCollectionId']),
      name: serializer.fromJson<String>(json['name']),
      overview: serializer.fromJson<String?>(json['overview']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      backdropPath: serializer.fromJson<String?>(json['backdropPath']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tmdbCollectionId': serializer.toJson<int?>(tmdbCollectionId),
      'name': serializer.toJson<String>(name),
      'overview': serializer.toJson<String?>(overview),
      'posterPath': serializer.toJson<String?>(posterPath),
      'backdropPath': serializer.toJson<String?>(backdropPath),
      'isCustom': serializer.toJson<bool>(isCustom),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  CollectionRow copyWith({
    int? id,
    Value<int?> tmdbCollectionId = const Value.absent(),
    String? name,
    Value<String?> overview = const Value.absent(),
    Value<String?> posterPath = const Value.absent(),
    Value<String?> backdropPath = const Value.absent(),
    bool? isCustom,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => CollectionRow(
    id: id ?? this.id,
    tmdbCollectionId: tmdbCollectionId.present
        ? tmdbCollectionId.value
        : this.tmdbCollectionId,
    name: name ?? this.name,
    overview: overview.present ? overview.value : this.overview,
    posterPath: posterPath.present ? posterPath.value : this.posterPath,
    backdropPath: backdropPath.present ? backdropPath.value : this.backdropPath,
    isCustom: isCustom ?? this.isCustom,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  CollectionRow copyWithCompanion(CollectionsCompanion data) {
    return CollectionRow(
      id: data.id.present ? data.id.value : this.id,
      tmdbCollectionId: data.tmdbCollectionId.present
          ? data.tmdbCollectionId.value
          : this.tmdbCollectionId,
      name: data.name.present ? data.name.value : this.name,
      overview: data.overview.present ? data.overview.value : this.overview,
      posterPath: data.posterPath.present
          ? data.posterPath.value
          : this.posterPath,
      backdropPath: data.backdropPath.present
          ? data.backdropPath.value
          : this.backdropPath,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionRow(')
          ..write('id: $id, ')
          ..write('tmdbCollectionId: $tmdbCollectionId, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('isCustom: $isCustom, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tmdbCollectionId,
    name,
    overview,
    posterPath,
    backdropPath,
    isCustom,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionRow &&
          other.id == this.id &&
          other.tmdbCollectionId == this.tmdbCollectionId &&
          other.name == this.name &&
          other.overview == this.overview &&
          other.posterPath == this.posterPath &&
          other.backdropPath == this.backdropPath &&
          other.isCustom == this.isCustom &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class CollectionsCompanion extends UpdateCompanion<CollectionRow> {
  final Value<int> id;
  final Value<int?> tmdbCollectionId;
  final Value<String> name;
  final Value<String?> overview;
  final Value<String?> posterPath;
  final Value<String?> backdropPath;
  final Value<bool> isCustom;
  final Value<DateTime?> lastSyncedAt;
  const CollectionsCompanion({
    this.id = const Value.absent(),
    this.tmdbCollectionId = const Value.absent(),
    this.name = const Value.absent(),
    this.overview = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  CollectionsCompanion.insert({
    this.id = const Value.absent(),
    this.tmdbCollectionId = const Value.absent(),
    required String name,
    this.overview = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CollectionRow> custom({
    Expression<int>? id,
    Expression<int>? tmdbCollectionId,
    Expression<String>? name,
    Expression<String>? overview,
    Expression<String>? posterPath,
    Expression<String>? backdropPath,
    Expression<bool>? isCustom,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tmdbCollectionId != null) 'tmdb_collection_id': tmdbCollectionId,
      if (name != null) 'name': name,
      if (overview != null) 'overview': overview,
      if (posterPath != null) 'poster_path': posterPath,
      if (backdropPath != null) 'backdrop_path': backdropPath,
      if (isCustom != null) 'is_custom': isCustom,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  CollectionsCompanion copyWith({
    Value<int>? id,
    Value<int?>? tmdbCollectionId,
    Value<String>? name,
    Value<String?>? overview,
    Value<String?>? posterPath,
    Value<String?>? backdropPath,
    Value<bool>? isCustom,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return CollectionsCompanion(
      id: id ?? this.id,
      tmdbCollectionId: tmdbCollectionId ?? this.tmdbCollectionId,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      isCustom: isCustom ?? this.isCustom,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tmdbCollectionId.present) {
      map['tmdb_collection_id'] = Variable<int>(tmdbCollectionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (backdropPath.present) {
      map['backdrop_path'] = Variable<String>(backdropPath.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('id: $id, ')
          ..write('tmdbCollectionId: $tmdbCollectionId, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('isCustom: $isCustom, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $CollectionMoviesTable extends CollectionMovies
    with TableInfo<$CollectionMoviesTable, CollectionMovieRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionMoviesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tmdbMovieIdMeta = const VerificationMeta(
    'tmdbMovieId',
  );
  @override
  late final GeneratedColumn<int> tmdbMovieId = GeneratedColumn<int>(
    'tmdb_movie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalTitleMeta = const VerificationMeta(
    'originalTitle',
  );
  @override
  late final GeneratedColumn<String> originalTitle = GeneratedColumn<String>(
    'original_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseDateMeta = const VerificationMeta(
    'releaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
    'release_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    collectionId,
    tmdbMovieId,
    title,
    originalTitle,
    posterPath,
    releaseDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_movies';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectionMovieRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('tmdb_movie_id')) {
      context.handle(
        _tmdbMovieIdMeta,
        tmdbMovieId.isAcceptableOrUnknown(
          data['tmdb_movie_id']!,
          _tmdbMovieIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tmdbMovieIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('original_title')) {
      context.handle(
        _originalTitleMeta,
        originalTitle.isAcceptableOrUnknown(
          data['original_title']!,
          _originalTitleMeta,
        ),
      );
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    }
    if (data.containsKey('release_date')) {
      context.handle(
        _releaseDateMeta,
        releaseDate.isAcceptableOrUnknown(
          data['release_date']!,
          _releaseDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {collectionId, tmdbMovieId},
  ];
  @override
  CollectionMovieRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionMovieRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
      tmdbMovieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_movie_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      originalTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_title'],
      ),
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      ),
      releaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}release_date'],
      ),
    );
  }

  @override
  $CollectionMoviesTable createAlias(String alias) {
    return $CollectionMoviesTable(attachedDatabase, alias);
  }
}

class CollectionMovieRow extends DataClass
    implements Insertable<CollectionMovieRow> {
  final int id;
  final int collectionId;
  final int tmdbMovieId;
  final String title;
  final String? originalTitle;
  final String? posterPath;
  final DateTime? releaseDate;
  const CollectionMovieRow({
    required this.id,
    required this.collectionId,
    required this.tmdbMovieId,
    required this.title,
    this.originalTitle,
    this.posterPath,
    this.releaseDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['collection_id'] = Variable<int>(collectionId);
    map['tmdb_movie_id'] = Variable<int>(tmdbMovieId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || originalTitle != null) {
      map['original_title'] = Variable<String>(originalTitle);
    }
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<DateTime>(releaseDate);
    }
    return map;
  }

  CollectionMoviesCompanion toCompanion(bool nullToAbsent) {
    return CollectionMoviesCompanion(
      id: Value(id),
      collectionId: Value(collectionId),
      tmdbMovieId: Value(tmdbMovieId),
      title: Value(title),
      originalTitle: originalTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(originalTitle),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
    );
  }

  factory CollectionMovieRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionMovieRow(
      id: serializer.fromJson<int>(json['id']),
      collectionId: serializer.fromJson<int>(json['collectionId']),
      tmdbMovieId: serializer.fromJson<int>(json['tmdbMovieId']),
      title: serializer.fromJson<String>(json['title']),
      originalTitle: serializer.fromJson<String?>(json['originalTitle']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      releaseDate: serializer.fromJson<DateTime?>(json['releaseDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'collectionId': serializer.toJson<int>(collectionId),
      'tmdbMovieId': serializer.toJson<int>(tmdbMovieId),
      'title': serializer.toJson<String>(title),
      'originalTitle': serializer.toJson<String?>(originalTitle),
      'posterPath': serializer.toJson<String?>(posterPath),
      'releaseDate': serializer.toJson<DateTime?>(releaseDate),
    };
  }

  CollectionMovieRow copyWith({
    int? id,
    int? collectionId,
    int? tmdbMovieId,
    String? title,
    Value<String?> originalTitle = const Value.absent(),
    Value<String?> posterPath = const Value.absent(),
    Value<DateTime?> releaseDate = const Value.absent(),
  }) => CollectionMovieRow(
    id: id ?? this.id,
    collectionId: collectionId ?? this.collectionId,
    tmdbMovieId: tmdbMovieId ?? this.tmdbMovieId,
    title: title ?? this.title,
    originalTitle: originalTitle.present
        ? originalTitle.value
        : this.originalTitle,
    posterPath: posterPath.present ? posterPath.value : this.posterPath,
    releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
  );
  CollectionMovieRow copyWithCompanion(CollectionMoviesCompanion data) {
    return CollectionMovieRow(
      id: data.id.present ? data.id.value : this.id,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      tmdbMovieId: data.tmdbMovieId.present
          ? data.tmdbMovieId.value
          : this.tmdbMovieId,
      title: data.title.present ? data.title.value : this.title,
      originalTitle: data.originalTitle.present
          ? data.originalTitle.value
          : this.originalTitle,
      posterPath: data.posterPath.present
          ? data.posterPath.value
          : this.posterPath,
      releaseDate: data.releaseDate.present
          ? data.releaseDate.value
          : this.releaseDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionMovieRow(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('tmdbMovieId: $tmdbMovieId, ')
          ..write('title: $title, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('posterPath: $posterPath, ')
          ..write('releaseDate: $releaseDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    collectionId,
    tmdbMovieId,
    title,
    originalTitle,
    posterPath,
    releaseDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionMovieRow &&
          other.id == this.id &&
          other.collectionId == this.collectionId &&
          other.tmdbMovieId == this.tmdbMovieId &&
          other.title == this.title &&
          other.originalTitle == this.originalTitle &&
          other.posterPath == this.posterPath &&
          other.releaseDate == this.releaseDate);
}

class CollectionMoviesCompanion extends UpdateCompanion<CollectionMovieRow> {
  final Value<int> id;
  final Value<int> collectionId;
  final Value<int> tmdbMovieId;
  final Value<String> title;
  final Value<String?> originalTitle;
  final Value<String?> posterPath;
  final Value<DateTime?> releaseDate;
  const CollectionMoviesCompanion({
    this.id = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.tmdbMovieId = const Value.absent(),
    this.title = const Value.absent(),
    this.originalTitle = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.releaseDate = const Value.absent(),
  });
  CollectionMoviesCompanion.insert({
    this.id = const Value.absent(),
    required int collectionId,
    required int tmdbMovieId,
    required String title,
    this.originalTitle = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.releaseDate = const Value.absent(),
  }) : collectionId = Value(collectionId),
       tmdbMovieId = Value(tmdbMovieId),
       title = Value(title);
  static Insertable<CollectionMovieRow> custom({
    Expression<int>? id,
    Expression<int>? collectionId,
    Expression<int>? tmdbMovieId,
    Expression<String>? title,
    Expression<String>? originalTitle,
    Expression<String>? posterPath,
    Expression<DateTime>? releaseDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionId != null) 'collection_id': collectionId,
      if (tmdbMovieId != null) 'tmdb_movie_id': tmdbMovieId,
      if (title != null) 'title': title,
      if (originalTitle != null) 'original_title': originalTitle,
      if (posterPath != null) 'poster_path': posterPath,
      if (releaseDate != null) 'release_date': releaseDate,
    });
  }

  CollectionMoviesCompanion copyWith({
    Value<int>? id,
    Value<int>? collectionId,
    Value<int>? tmdbMovieId,
    Value<String>? title,
    Value<String?>? originalTitle,
    Value<String?>? posterPath,
    Value<DateTime?>? releaseDate,
  }) {
    return CollectionMoviesCompanion(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      tmdbMovieId: tmdbMovieId ?? this.tmdbMovieId,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      posterPath: posterPath ?? this.posterPath,
      releaseDate: releaseDate ?? this.releaseDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (tmdbMovieId.present) {
      map['tmdb_movie_id'] = Variable<int>(tmdbMovieId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (originalTitle.present) {
      map['original_title'] = Variable<String>(originalTitle.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionMoviesCompanion(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('tmdbMovieId: $tmdbMovieId, ')
          ..write('title: $title, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('posterPath: $posterPath, ')
          ..write('releaseDate: $releaseDate')
          ..write(')'))
        .toString();
  }
}

class $TvSeriesTableTable extends TvSeriesTable
    with TableInfo<$TvSeriesTableTable, TvSeriesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TvSeriesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
    'tmdb_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _originalNameMeta = const VerificationMeta(
    'originalName',
  );
  @override
  late final GeneratedColumn<String> originalName = GeneratedColumn<String>(
    'original_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backdropPathMeta = const VerificationMeta(
    'backdropPath',
  );
  @override
  late final GeneratedColumn<String> backdropPath = GeneratedColumn<String>(
    'backdrop_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstAirDateMeta = const VerificationMeta(
    'firstAirDate',
  );
  @override
  late final GeneratedColumn<DateTime> firstAirDate = GeneratedColumn<DateTime>(
    'first_air_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastAirDateMeta = const VerificationMeta(
    'lastAirDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastAirDate = GeneratedColumn<DateTime>(
    'last_air_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numberOfSeasonsMeta = const VerificationMeta(
    'numberOfSeasons',
  );
  @override
  late final GeneratedColumn<int> numberOfSeasons = GeneratedColumn<int>(
    'number_of_seasons',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seriesStatusMeta = const VerificationMeta(
    'seriesStatus',
  );
  @override
  late final GeneratedColumn<String> seriesStatus = GeneratedColumn<String>(
    'series_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalLanguageMeta = const VerificationMeta(
    'originalLanguage',
  );
  @override
  late final GeneratedColumn<String> originalLanguage = GeneratedColumn<String>(
    'original_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentRatingMeta = const VerificationMeta(
    'contentRating',
  );
  @override
  late final GeneratedColumn<String> contentRating = GeneratedColumn<String>(
    'content_rating',
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastMetadataSyncAtMeta =
      const VerificationMeta('lastMetadataSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastMetadataSyncAt =
      GeneratedColumn<DateTime>(
        'last_metadata_sync_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tmdbId,
    name,
    originalName,
    overview,
    posterPath,
    backdropPath,
    firstAirDate,
    lastAirDate,
    numberOfSeasons,
    seriesStatus,
    originalLanguage,
    contentRating,
    createdAt,
    updatedAt,
    lastMetadataSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tv_series';
  @override
  VerificationContext validateIntegrity(
    Insertable<TvSeriesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(
        _tmdbIdMeta,
        tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('original_name')) {
      context.handle(
        _originalNameMeta,
        originalName.isAcceptableOrUnknown(
          data['original_name']!,
          _originalNameMeta,
        ),
      );
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    }
    if (data.containsKey('backdrop_path')) {
      context.handle(
        _backdropPathMeta,
        backdropPath.isAcceptableOrUnknown(
          data['backdrop_path']!,
          _backdropPathMeta,
        ),
      );
    }
    if (data.containsKey('first_air_date')) {
      context.handle(
        _firstAirDateMeta,
        firstAirDate.isAcceptableOrUnknown(
          data['first_air_date']!,
          _firstAirDateMeta,
        ),
      );
    }
    if (data.containsKey('last_air_date')) {
      context.handle(
        _lastAirDateMeta,
        lastAirDate.isAcceptableOrUnknown(
          data['last_air_date']!,
          _lastAirDateMeta,
        ),
      );
    }
    if (data.containsKey('number_of_seasons')) {
      context.handle(
        _numberOfSeasonsMeta,
        numberOfSeasons.isAcceptableOrUnknown(
          data['number_of_seasons']!,
          _numberOfSeasonsMeta,
        ),
      );
    }
    if (data.containsKey('series_status')) {
      context.handle(
        _seriesStatusMeta,
        seriesStatus.isAcceptableOrUnknown(
          data['series_status']!,
          _seriesStatusMeta,
        ),
      );
    }
    if (data.containsKey('original_language')) {
      context.handle(
        _originalLanguageMeta,
        originalLanguage.isAcceptableOrUnknown(
          data['original_language']!,
          _originalLanguageMeta,
        ),
      );
    }
    if (data.containsKey('content_rating')) {
      context.handle(
        _contentRatingMeta,
        contentRating.isAcceptableOrUnknown(
          data['content_rating']!,
          _contentRatingMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('last_metadata_sync_at')) {
      context.handle(
        _lastMetadataSyncAtMeta,
        lastMetadataSyncAt.isAcceptableOrUnknown(
          data['last_metadata_sync_at']!,
          _lastMetadataSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TvSeriesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TvSeriesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tmdbId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      originalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_name'],
      ),
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      ),
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      ),
      backdropPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backdrop_path'],
      ),
      firstAirDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_air_date'],
      ),
      lastAirDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_air_date'],
      ),
      numberOfSeasons: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number_of_seasons'],
      ),
      seriesStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_status'],
      ),
      originalLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_language'],
      ),
      contentRating: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_rating'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastMetadataSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_metadata_sync_at'],
      ),
    );
  }

  @override
  $TvSeriesTableTable createAlias(String alias) {
    return $TvSeriesTableTable(attachedDatabase, alias);
  }
}

class TvSeriesRow extends DataClass implements Insertable<TvSeriesRow> {
  final int id;
  final int tmdbId;
  final String name;
  final String? originalName;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? firstAirDate;
  final DateTime? lastAirDate;
  final int? numberOfSeasons;
  final String? seriesStatus;
  final String? originalLanguage;
  final String? contentRating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastMetadataSyncAt;
  const TvSeriesRow({
    required this.id,
    required this.tmdbId,
    required this.name,
    this.originalName,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.firstAirDate,
    this.lastAirDate,
    this.numberOfSeasons,
    this.seriesStatus,
    this.originalLanguage,
    this.contentRating,
    required this.createdAt,
    required this.updatedAt,
    this.lastMetadataSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || originalName != null) {
      map['original_name'] = Variable<String>(originalName);
    }
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || backdropPath != null) {
      map['backdrop_path'] = Variable<String>(backdropPath);
    }
    if (!nullToAbsent || firstAirDate != null) {
      map['first_air_date'] = Variable<DateTime>(firstAirDate);
    }
    if (!nullToAbsent || lastAirDate != null) {
      map['last_air_date'] = Variable<DateTime>(lastAirDate);
    }
    if (!nullToAbsent || numberOfSeasons != null) {
      map['number_of_seasons'] = Variable<int>(numberOfSeasons);
    }
    if (!nullToAbsent || seriesStatus != null) {
      map['series_status'] = Variable<String>(seriesStatus);
    }
    if (!nullToAbsent || originalLanguage != null) {
      map['original_language'] = Variable<String>(originalLanguage);
    }
    if (!nullToAbsent || contentRating != null) {
      map['content_rating'] = Variable<String>(contentRating);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastMetadataSyncAt != null) {
      map['last_metadata_sync_at'] = Variable<DateTime>(lastMetadataSyncAt);
    }
    return map;
  }

  TvSeriesTableCompanion toCompanion(bool nullToAbsent) {
    return TvSeriesTableCompanion(
      id: Value(id),
      tmdbId: Value(tmdbId),
      name: Value(name),
      originalName: originalName == null && nullToAbsent
          ? const Value.absent()
          : Value(originalName),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      backdropPath: backdropPath == null && nullToAbsent
          ? const Value.absent()
          : Value(backdropPath),
      firstAirDate: firstAirDate == null && nullToAbsent
          ? const Value.absent()
          : Value(firstAirDate),
      lastAirDate: lastAirDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAirDate),
      numberOfSeasons: numberOfSeasons == null && nullToAbsent
          ? const Value.absent()
          : Value(numberOfSeasons),
      seriesStatus: seriesStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesStatus),
      originalLanguage: originalLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(originalLanguage),
      contentRating: contentRating == null && nullToAbsent
          ? const Value.absent()
          : Value(contentRating),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastMetadataSyncAt: lastMetadataSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMetadataSyncAt),
    );
  }

  factory TvSeriesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TvSeriesRow(
      id: serializer.fromJson<int>(json['id']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      name: serializer.fromJson<String>(json['name']),
      originalName: serializer.fromJson<String?>(json['originalName']),
      overview: serializer.fromJson<String?>(json['overview']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      backdropPath: serializer.fromJson<String?>(json['backdropPath']),
      firstAirDate: serializer.fromJson<DateTime?>(json['firstAirDate']),
      lastAirDate: serializer.fromJson<DateTime?>(json['lastAirDate']),
      numberOfSeasons: serializer.fromJson<int?>(json['numberOfSeasons']),
      seriesStatus: serializer.fromJson<String?>(json['seriesStatus']),
      originalLanguage: serializer.fromJson<String?>(json['originalLanguage']),
      contentRating: serializer.fromJson<String?>(json['contentRating']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastMetadataSyncAt: serializer.fromJson<DateTime?>(
        json['lastMetadataSyncAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'name': serializer.toJson<String>(name),
      'originalName': serializer.toJson<String?>(originalName),
      'overview': serializer.toJson<String?>(overview),
      'posterPath': serializer.toJson<String?>(posterPath),
      'backdropPath': serializer.toJson<String?>(backdropPath),
      'firstAirDate': serializer.toJson<DateTime?>(firstAirDate),
      'lastAirDate': serializer.toJson<DateTime?>(lastAirDate),
      'numberOfSeasons': serializer.toJson<int?>(numberOfSeasons),
      'seriesStatus': serializer.toJson<String?>(seriesStatus),
      'originalLanguage': serializer.toJson<String?>(originalLanguage),
      'contentRating': serializer.toJson<String?>(contentRating),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastMetadataSyncAt': serializer.toJson<DateTime?>(lastMetadataSyncAt),
    };
  }

  TvSeriesRow copyWith({
    int? id,
    int? tmdbId,
    String? name,
    Value<String?> originalName = const Value.absent(),
    Value<String?> overview = const Value.absent(),
    Value<String?> posterPath = const Value.absent(),
    Value<String?> backdropPath = const Value.absent(),
    Value<DateTime?> firstAirDate = const Value.absent(),
    Value<DateTime?> lastAirDate = const Value.absent(),
    Value<int?> numberOfSeasons = const Value.absent(),
    Value<String?> seriesStatus = const Value.absent(),
    Value<String?> originalLanguage = const Value.absent(),
    Value<String?> contentRating = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastMetadataSyncAt = const Value.absent(),
  }) => TvSeriesRow(
    id: id ?? this.id,
    tmdbId: tmdbId ?? this.tmdbId,
    name: name ?? this.name,
    originalName: originalName.present ? originalName.value : this.originalName,
    overview: overview.present ? overview.value : this.overview,
    posterPath: posterPath.present ? posterPath.value : this.posterPath,
    backdropPath: backdropPath.present ? backdropPath.value : this.backdropPath,
    firstAirDate: firstAirDate.present ? firstAirDate.value : this.firstAirDate,
    lastAirDate: lastAirDate.present ? lastAirDate.value : this.lastAirDate,
    numberOfSeasons: numberOfSeasons.present
        ? numberOfSeasons.value
        : this.numberOfSeasons,
    seriesStatus: seriesStatus.present ? seriesStatus.value : this.seriesStatus,
    originalLanguage: originalLanguage.present
        ? originalLanguage.value
        : this.originalLanguage,
    contentRating: contentRating.present
        ? contentRating.value
        : this.contentRating,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastMetadataSyncAt: lastMetadataSyncAt.present
        ? lastMetadataSyncAt.value
        : this.lastMetadataSyncAt,
  );
  TvSeriesRow copyWithCompanion(TvSeriesTableCompanion data) {
    return TvSeriesRow(
      id: data.id.present ? data.id.value : this.id,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      name: data.name.present ? data.name.value : this.name,
      originalName: data.originalName.present
          ? data.originalName.value
          : this.originalName,
      overview: data.overview.present ? data.overview.value : this.overview,
      posterPath: data.posterPath.present
          ? data.posterPath.value
          : this.posterPath,
      backdropPath: data.backdropPath.present
          ? data.backdropPath.value
          : this.backdropPath,
      firstAirDate: data.firstAirDate.present
          ? data.firstAirDate.value
          : this.firstAirDate,
      lastAirDate: data.lastAirDate.present
          ? data.lastAirDate.value
          : this.lastAirDate,
      numberOfSeasons: data.numberOfSeasons.present
          ? data.numberOfSeasons.value
          : this.numberOfSeasons,
      seriesStatus: data.seriesStatus.present
          ? data.seriesStatus.value
          : this.seriesStatus,
      originalLanguage: data.originalLanguage.present
          ? data.originalLanguage.value
          : this.originalLanguage,
      contentRating: data.contentRating.present
          ? data.contentRating.value
          : this.contentRating,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastMetadataSyncAt: data.lastMetadataSyncAt.present
          ? data.lastMetadataSyncAt.value
          : this.lastMetadataSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TvSeriesRow(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('name: $name, ')
          ..write('originalName: $originalName, ')
          ..write('overview: $overview, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('firstAirDate: $firstAirDate, ')
          ..write('lastAirDate: $lastAirDate, ')
          ..write('numberOfSeasons: $numberOfSeasons, ')
          ..write('seriesStatus: $seriesStatus, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('contentRating: $contentRating, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastMetadataSyncAt: $lastMetadataSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tmdbId,
    name,
    originalName,
    overview,
    posterPath,
    backdropPath,
    firstAirDate,
    lastAirDate,
    numberOfSeasons,
    seriesStatus,
    originalLanguage,
    contentRating,
    createdAt,
    updatedAt,
    lastMetadataSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TvSeriesRow &&
          other.id == this.id &&
          other.tmdbId == this.tmdbId &&
          other.name == this.name &&
          other.originalName == this.originalName &&
          other.overview == this.overview &&
          other.posterPath == this.posterPath &&
          other.backdropPath == this.backdropPath &&
          other.firstAirDate == this.firstAirDate &&
          other.lastAirDate == this.lastAirDate &&
          other.numberOfSeasons == this.numberOfSeasons &&
          other.seriesStatus == this.seriesStatus &&
          other.originalLanguage == this.originalLanguage &&
          other.contentRating == this.contentRating &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastMetadataSyncAt == this.lastMetadataSyncAt);
}

class TvSeriesTableCompanion extends UpdateCompanion<TvSeriesRow> {
  final Value<int> id;
  final Value<int> tmdbId;
  final Value<String> name;
  final Value<String?> originalName;
  final Value<String?> overview;
  final Value<String?> posterPath;
  final Value<String?> backdropPath;
  final Value<DateTime?> firstAirDate;
  final Value<DateTime?> lastAirDate;
  final Value<int?> numberOfSeasons;
  final Value<String?> seriesStatus;
  final Value<String?> originalLanguage;
  final Value<String?> contentRating;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastMetadataSyncAt;
  const TvSeriesTableCompanion({
    this.id = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.name = const Value.absent(),
    this.originalName = const Value.absent(),
    this.overview = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.firstAirDate = const Value.absent(),
    this.lastAirDate = const Value.absent(),
    this.numberOfSeasons = const Value.absent(),
    this.seriesStatus = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.contentRating = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastMetadataSyncAt = const Value.absent(),
  });
  TvSeriesTableCompanion.insert({
    this.id = const Value.absent(),
    required int tmdbId,
    required String name,
    this.originalName = const Value.absent(),
    this.overview = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.firstAirDate = const Value.absent(),
    this.lastAirDate = const Value.absent(),
    this.numberOfSeasons = const Value.absent(),
    this.seriesStatus = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.contentRating = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastMetadataSyncAt = const Value.absent(),
  }) : tmdbId = Value(tmdbId),
       name = Value(name);
  static Insertable<TvSeriesRow> custom({
    Expression<int>? id,
    Expression<int>? tmdbId,
    Expression<String>? name,
    Expression<String>? originalName,
    Expression<String>? overview,
    Expression<String>? posterPath,
    Expression<String>? backdropPath,
    Expression<DateTime>? firstAirDate,
    Expression<DateTime>? lastAirDate,
    Expression<int>? numberOfSeasons,
    Expression<String>? seriesStatus,
    Expression<String>? originalLanguage,
    Expression<String>? contentRating,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastMetadataSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (name != null) 'name': name,
      if (originalName != null) 'original_name': originalName,
      if (overview != null) 'overview': overview,
      if (posterPath != null) 'poster_path': posterPath,
      if (backdropPath != null) 'backdrop_path': backdropPath,
      if (firstAirDate != null) 'first_air_date': firstAirDate,
      if (lastAirDate != null) 'last_air_date': lastAirDate,
      if (numberOfSeasons != null) 'number_of_seasons': numberOfSeasons,
      if (seriesStatus != null) 'series_status': seriesStatus,
      if (originalLanguage != null) 'original_language': originalLanguage,
      if (contentRating != null) 'content_rating': contentRating,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastMetadataSyncAt != null)
        'last_metadata_sync_at': lastMetadataSyncAt,
    });
  }

  TvSeriesTableCompanion copyWith({
    Value<int>? id,
    Value<int>? tmdbId,
    Value<String>? name,
    Value<String?>? originalName,
    Value<String?>? overview,
    Value<String?>? posterPath,
    Value<String?>? backdropPath,
    Value<DateTime?>? firstAirDate,
    Value<DateTime?>? lastAirDate,
    Value<int?>? numberOfSeasons,
    Value<String?>? seriesStatus,
    Value<String?>? originalLanguage,
    Value<String?>? contentRating,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastMetadataSyncAt,
  }) {
    return TvSeriesTableCompanion(
      id: id ?? this.id,
      tmdbId: tmdbId ?? this.tmdbId,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      firstAirDate: firstAirDate ?? this.firstAirDate,
      lastAirDate: lastAirDate ?? this.lastAirDate,
      numberOfSeasons: numberOfSeasons ?? this.numberOfSeasons,
      seriesStatus: seriesStatus ?? this.seriesStatus,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      contentRating: contentRating ?? this.contentRating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMetadataSyncAt: lastMetadataSyncAt ?? this.lastMetadataSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (originalName.present) {
      map['original_name'] = Variable<String>(originalName.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (backdropPath.present) {
      map['backdrop_path'] = Variable<String>(backdropPath.value);
    }
    if (firstAirDate.present) {
      map['first_air_date'] = Variable<DateTime>(firstAirDate.value);
    }
    if (lastAirDate.present) {
      map['last_air_date'] = Variable<DateTime>(lastAirDate.value);
    }
    if (numberOfSeasons.present) {
      map['number_of_seasons'] = Variable<int>(numberOfSeasons.value);
    }
    if (seriesStatus.present) {
      map['series_status'] = Variable<String>(seriesStatus.value);
    }
    if (originalLanguage.present) {
      map['original_language'] = Variable<String>(originalLanguage.value);
    }
    if (contentRating.present) {
      map['content_rating'] = Variable<String>(contentRating.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastMetadataSyncAt.present) {
      map['last_metadata_sync_at'] = Variable<DateTime>(
        lastMetadataSyncAt.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TvSeriesTableCompanion(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('name: $name, ')
          ..write('originalName: $originalName, ')
          ..write('overview: $overview, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('firstAirDate: $firstAirDate, ')
          ..write('lastAirDate: $lastAirDate, ')
          ..write('numberOfSeasons: $numberOfSeasons, ')
          ..write('seriesStatus: $seriesStatus, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('contentRating: $contentRating, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastMetadataSyncAt: $lastMetadataSyncAt')
          ..write(')'))
        .toString();
  }
}

class $TvSeasonsTableTable extends TvSeasonsTable
    with TableInfo<$TvSeasonsTableTable, TvSeasonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TvSeasonsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<int> seriesId = GeneratedColumn<int>(
    'series_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tv_series (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tmdbSeasonIdMeta = const VerificationMeta(
    'tmdbSeasonId',
  );
  @override
  late final GeneratedColumn<int> tmdbSeasonId = GeneratedColumn<int>(
    'tmdb_season_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seasonNumberMeta = const VerificationMeta(
    'seasonNumber',
  );
  @override
  late final GeneratedColumn<int> seasonNumber = GeneratedColumn<int>(
    'season_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _airDateMeta = const VerificationMeta(
    'airDate',
  );
  @override
  late final GeneratedColumn<DateTime> airDate = GeneratedColumn<DateTime>(
    'air_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _episodeCountMeta = const VerificationMeta(
    'episodeCount',
  );
  @override
  late final GeneratedColumn<int> episodeCount = GeneratedColumn<int>(
    'episode_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CollectionStatus?, String>
  userStatus =
      GeneratedColumn<String>(
        'user_status',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<CollectionStatus?>(
        $TvSeasonsTableTable.$converteruserStatusn,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seriesId,
    tmdbSeasonId,
    seasonNumber,
    name,
    overview,
    posterPath,
    airDate,
    episodeCount,
    userStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tv_seasons';
  @override
  VerificationContext validateIntegrity(
    Insertable<TvSeasonRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesIdMeta);
    }
    if (data.containsKey('tmdb_season_id')) {
      context.handle(
        _tmdbSeasonIdMeta,
        tmdbSeasonId.isAcceptableOrUnknown(
          data['tmdb_season_id']!,
          _tmdbSeasonIdMeta,
        ),
      );
    }
    if (data.containsKey('season_number')) {
      context.handle(
        _seasonNumberMeta,
        seasonNumber.isAcceptableOrUnknown(
          data['season_number']!,
          _seasonNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_seasonNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    }
    if (data.containsKey('air_date')) {
      context.handle(
        _airDateMeta,
        airDate.isAcceptableOrUnknown(data['air_date']!, _airDateMeta),
      );
    }
    if (data.containsKey('episode_count')) {
      context.handle(
        _episodeCountMeta,
        episodeCount.isAcceptableOrUnknown(
          data['episode_count']!,
          _episodeCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {seriesId, seasonNumber},
  ];
  @override
  TvSeasonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TvSeasonRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series_id'],
      )!,
      tmdbSeasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_season_id'],
      ),
      seasonNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_number'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      ),
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      ),
      airDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}air_date'],
      ),
      episodeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_count'],
      ),
      userStatus: $TvSeasonsTableTable.$converteruserStatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}user_status'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TvSeasonsTableTable createAlias(String alias) {
    return $TvSeasonsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<CollectionStatus, String> $converteruserStatus =
      const CollectionStatusConverter();
  static TypeConverter<CollectionStatus?, String?> $converteruserStatusn =
      NullAwareTypeConverter.wrap($converteruserStatus);
}

class TvSeasonRow extends DataClass implements Insertable<TvSeasonRow> {
  final int id;
  final int seriesId;
  final int? tmdbSeasonId;
  final int seasonNumber;
  final String name;
  final String? overview;
  final String? posterPath;
  final DateTime? airDate;
  final int? episodeCount;
  final CollectionStatus? userStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TvSeasonRow({
    required this.id,
    required this.seriesId,
    this.tmdbSeasonId,
    required this.seasonNumber,
    required this.name,
    this.overview,
    this.posterPath,
    this.airDate,
    this.episodeCount,
    this.userStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['series_id'] = Variable<int>(seriesId);
    if (!nullToAbsent || tmdbSeasonId != null) {
      map['tmdb_season_id'] = Variable<int>(tmdbSeasonId);
    }
    map['season_number'] = Variable<int>(seasonNumber);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || airDate != null) {
      map['air_date'] = Variable<DateTime>(airDate);
    }
    if (!nullToAbsent || episodeCount != null) {
      map['episode_count'] = Variable<int>(episodeCount);
    }
    if (!nullToAbsent || userStatus != null) {
      map['user_status'] = Variable<String>(
        $TvSeasonsTableTable.$converteruserStatusn.toSql(userStatus),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TvSeasonsTableCompanion toCompanion(bool nullToAbsent) {
    return TvSeasonsTableCompanion(
      id: Value(id),
      seriesId: Value(seriesId),
      tmdbSeasonId: tmdbSeasonId == null && nullToAbsent
          ? const Value.absent()
          : Value(tmdbSeasonId),
      seasonNumber: Value(seasonNumber),
      name: Value(name),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      airDate: airDate == null && nullToAbsent
          ? const Value.absent()
          : Value(airDate),
      episodeCount: episodeCount == null && nullToAbsent
          ? const Value.absent()
          : Value(episodeCount),
      userStatus: userStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(userStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TvSeasonRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TvSeasonRow(
      id: serializer.fromJson<int>(json['id']),
      seriesId: serializer.fromJson<int>(json['seriesId']),
      tmdbSeasonId: serializer.fromJson<int?>(json['tmdbSeasonId']),
      seasonNumber: serializer.fromJson<int>(json['seasonNumber']),
      name: serializer.fromJson<String>(json['name']),
      overview: serializer.fromJson<String?>(json['overview']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      airDate: serializer.fromJson<DateTime?>(json['airDate']),
      episodeCount: serializer.fromJson<int?>(json['episodeCount']),
      userStatus: serializer.fromJson<CollectionStatus?>(json['userStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seriesId': serializer.toJson<int>(seriesId),
      'tmdbSeasonId': serializer.toJson<int?>(tmdbSeasonId),
      'seasonNumber': serializer.toJson<int>(seasonNumber),
      'name': serializer.toJson<String>(name),
      'overview': serializer.toJson<String?>(overview),
      'posterPath': serializer.toJson<String?>(posterPath),
      'airDate': serializer.toJson<DateTime?>(airDate),
      'episodeCount': serializer.toJson<int?>(episodeCount),
      'userStatus': serializer.toJson<CollectionStatus?>(userStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TvSeasonRow copyWith({
    int? id,
    int? seriesId,
    Value<int?> tmdbSeasonId = const Value.absent(),
    int? seasonNumber,
    String? name,
    Value<String?> overview = const Value.absent(),
    Value<String?> posterPath = const Value.absent(),
    Value<DateTime?> airDate = const Value.absent(),
    Value<int?> episodeCount = const Value.absent(),
    Value<CollectionStatus?> userStatus = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TvSeasonRow(
    id: id ?? this.id,
    seriesId: seriesId ?? this.seriesId,
    tmdbSeasonId: tmdbSeasonId.present ? tmdbSeasonId.value : this.tmdbSeasonId,
    seasonNumber: seasonNumber ?? this.seasonNumber,
    name: name ?? this.name,
    overview: overview.present ? overview.value : this.overview,
    posterPath: posterPath.present ? posterPath.value : this.posterPath,
    airDate: airDate.present ? airDate.value : this.airDate,
    episodeCount: episodeCount.present ? episodeCount.value : this.episodeCount,
    userStatus: userStatus.present ? userStatus.value : this.userStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TvSeasonRow copyWithCompanion(TvSeasonsTableCompanion data) {
    return TvSeasonRow(
      id: data.id.present ? data.id.value : this.id,
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      tmdbSeasonId: data.tmdbSeasonId.present
          ? data.tmdbSeasonId.value
          : this.tmdbSeasonId,
      seasonNumber: data.seasonNumber.present
          ? data.seasonNumber.value
          : this.seasonNumber,
      name: data.name.present ? data.name.value : this.name,
      overview: data.overview.present ? data.overview.value : this.overview,
      posterPath: data.posterPath.present
          ? data.posterPath.value
          : this.posterPath,
      airDate: data.airDate.present ? data.airDate.value : this.airDate,
      episodeCount: data.episodeCount.present
          ? data.episodeCount.value
          : this.episodeCount,
      userStatus: data.userStatus.present
          ? data.userStatus.value
          : this.userStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TvSeasonRow(')
          ..write('id: $id, ')
          ..write('seriesId: $seriesId, ')
          ..write('tmdbSeasonId: $tmdbSeasonId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('posterPath: $posterPath, ')
          ..write('airDate: $airDate, ')
          ..write('episodeCount: $episodeCount, ')
          ..write('userStatus: $userStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    seriesId,
    tmdbSeasonId,
    seasonNumber,
    name,
    overview,
    posterPath,
    airDate,
    episodeCount,
    userStatus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TvSeasonRow &&
          other.id == this.id &&
          other.seriesId == this.seriesId &&
          other.tmdbSeasonId == this.tmdbSeasonId &&
          other.seasonNumber == this.seasonNumber &&
          other.name == this.name &&
          other.overview == this.overview &&
          other.posterPath == this.posterPath &&
          other.airDate == this.airDate &&
          other.episodeCount == this.episodeCount &&
          other.userStatus == this.userStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TvSeasonsTableCompanion extends UpdateCompanion<TvSeasonRow> {
  final Value<int> id;
  final Value<int> seriesId;
  final Value<int?> tmdbSeasonId;
  final Value<int> seasonNumber;
  final Value<String> name;
  final Value<String?> overview;
  final Value<String?> posterPath;
  final Value<DateTime?> airDate;
  final Value<int?> episodeCount;
  final Value<CollectionStatus?> userStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TvSeasonsTableCompanion({
    this.id = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.tmdbSeasonId = const Value.absent(),
    this.seasonNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.overview = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.airDate = const Value.absent(),
    this.episodeCount = const Value.absent(),
    this.userStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TvSeasonsTableCompanion.insert({
    this.id = const Value.absent(),
    required int seriesId,
    this.tmdbSeasonId = const Value.absent(),
    required int seasonNumber,
    required String name,
    this.overview = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.airDate = const Value.absent(),
    this.episodeCount = const Value.absent(),
    this.userStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : seriesId = Value(seriesId),
       seasonNumber = Value(seasonNumber),
       name = Value(name);
  static Insertable<TvSeasonRow> custom({
    Expression<int>? id,
    Expression<int>? seriesId,
    Expression<int>? tmdbSeasonId,
    Expression<int>? seasonNumber,
    Expression<String>? name,
    Expression<String>? overview,
    Expression<String>? posterPath,
    Expression<DateTime>? airDate,
    Expression<int>? episodeCount,
    Expression<String>? userStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seriesId != null) 'series_id': seriesId,
      if (tmdbSeasonId != null) 'tmdb_season_id': tmdbSeasonId,
      if (seasonNumber != null) 'season_number': seasonNumber,
      if (name != null) 'name': name,
      if (overview != null) 'overview': overview,
      if (posterPath != null) 'poster_path': posterPath,
      if (airDate != null) 'air_date': airDate,
      if (episodeCount != null) 'episode_count': episodeCount,
      if (userStatus != null) 'user_status': userStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TvSeasonsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? seriesId,
    Value<int?>? tmdbSeasonId,
    Value<int>? seasonNumber,
    Value<String>? name,
    Value<String?>? overview,
    Value<String?>? posterPath,
    Value<DateTime?>? airDate,
    Value<int?>? episodeCount,
    Value<CollectionStatus?>? userStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TvSeasonsTableCompanion(
      id: id ?? this.id,
      seriesId: seriesId ?? this.seriesId,
      tmdbSeasonId: tmdbSeasonId ?? this.tmdbSeasonId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      airDate: airDate ?? this.airDate,
      episodeCount: episodeCount ?? this.episodeCount,
      userStatus: userStatus ?? this.userStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seriesId.present) {
      map['series_id'] = Variable<int>(seriesId.value);
    }
    if (tmdbSeasonId.present) {
      map['tmdb_season_id'] = Variable<int>(tmdbSeasonId.value);
    }
    if (seasonNumber.present) {
      map['season_number'] = Variable<int>(seasonNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (airDate.present) {
      map['air_date'] = Variable<DateTime>(airDate.value);
    }
    if (episodeCount.present) {
      map['episode_count'] = Variable<int>(episodeCount.value);
    }
    if (userStatus.present) {
      map['user_status'] = Variable<String>(
        $TvSeasonsTableTable.$converteruserStatusn.toSql(userStatus.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TvSeasonsTableCompanion(')
          ..write('id: $id, ')
          ..write('seriesId: $seriesId, ')
          ..write('tmdbSeasonId: $tmdbSeasonId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('posterPath: $posterPath, ')
          ..write('airDate: $airDate, ')
          ..write('episodeCount: $episodeCount, ')
          ..write('userStatus: $userStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TvSeriesGenresTable extends TvSeriesGenres
    with TableInfo<$TvSeriesGenresTable, TvSeriesGenreRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TvSeriesGenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<int> seriesId = GeneratedColumn<int>(
    'series_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tv_series (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _genreIdMeta = const VerificationMeta(
    'genreId',
  );
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
    'genre_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES genres (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [seriesId, genreId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tv_series_genres';
  @override
  VerificationContext validateIntegrity(
    Insertable<TvSeriesGenreRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(
        _genreIdMeta,
        genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta),
      );
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seriesId, genreId};
  @override
  TvSeriesGenreRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TvSeriesGenreRow(
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series_id'],
      )!,
      genreId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}genre_id'],
      )!,
    );
  }

  @override
  $TvSeriesGenresTable createAlias(String alias) {
    return $TvSeriesGenresTable(attachedDatabase, alias);
  }
}

class TvSeriesGenreRow extends DataClass
    implements Insertable<TvSeriesGenreRow> {
  final int seriesId;
  final int genreId;
  const TvSeriesGenreRow({required this.seriesId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['series_id'] = Variable<int>(seriesId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  TvSeriesGenresCompanion toCompanion(bool nullToAbsent) {
    return TvSeriesGenresCompanion(
      seriesId: Value(seriesId),
      genreId: Value(genreId),
    );
  }

  factory TvSeriesGenreRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TvSeriesGenreRow(
      seriesId: serializer.fromJson<int>(json['seriesId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seriesId': serializer.toJson<int>(seriesId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  TvSeriesGenreRow copyWith({int? seriesId, int? genreId}) => TvSeriesGenreRow(
    seriesId: seriesId ?? this.seriesId,
    genreId: genreId ?? this.genreId,
  );
  TvSeriesGenreRow copyWithCompanion(TvSeriesGenresCompanion data) {
    return TvSeriesGenreRow(
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      genreId: data.genreId.present ? data.genreId.value : this.genreId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TvSeriesGenreRow(')
          ..write('seriesId: $seriesId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(seriesId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TvSeriesGenreRow &&
          other.seriesId == this.seriesId &&
          other.genreId == this.genreId);
}

class TvSeriesGenresCompanion extends UpdateCompanion<TvSeriesGenreRow> {
  final Value<int> seriesId;
  final Value<int> genreId;
  final Value<int> rowid;
  const TvSeriesGenresCompanion({
    this.seriesId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TvSeriesGenresCompanion.insert({
    required int seriesId,
    required int genreId,
    this.rowid = const Value.absent(),
  }) : seriesId = Value(seriesId),
       genreId = Value(genreId);
  static Insertable<TvSeriesGenreRow> custom({
    Expression<int>? seriesId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (seriesId != null) 'series_id': seriesId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TvSeriesGenresCompanion copyWith({
    Value<int>? seriesId,
    Value<int>? genreId,
    Value<int>? rowid,
  }) {
    return TvSeriesGenresCompanion(
      seriesId: seriesId ?? this.seriesId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seriesId.present) {
      map['series_id'] = Variable<int>(seriesId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TvSeriesGenresCompanion(')
          ..write('seriesId: $seriesId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhysicalEditionMoviesTable extends PhysicalEditionMovies
    with TableInfo<$PhysicalEditionMoviesTable, PhysicalEditionMovieRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhysicalEditionMoviesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _editionIdMeta = const VerificationMeta(
    'editionId',
  );
  @override
  late final GeneratedColumn<int> editionId = GeneratedColumn<int>(
    'edition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES physical_editions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
    'movie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES movies (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [editionId, movieId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'physical_edition_movies';
  @override
  VerificationContext validateIntegrity(
    Insertable<PhysicalEditionMovieRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_editionIdMeta);
    }
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {editionId, movieId};
  @override
  PhysicalEditionMovieRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhysicalEditionMovieRow(
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}edition_id'],
      )!,
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      )!,
    );
  }

  @override
  $PhysicalEditionMoviesTable createAlias(String alias) {
    return $PhysicalEditionMoviesTable(attachedDatabase, alias);
  }
}

class PhysicalEditionMovieRow extends DataClass
    implements Insertable<PhysicalEditionMovieRow> {
  final int editionId;
  final int movieId;
  const PhysicalEditionMovieRow({
    required this.editionId,
    required this.movieId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['edition_id'] = Variable<int>(editionId);
    map['movie_id'] = Variable<int>(movieId);
    return map;
  }

  PhysicalEditionMoviesCompanion toCompanion(bool nullToAbsent) {
    return PhysicalEditionMoviesCompanion(
      editionId: Value(editionId),
      movieId: Value(movieId),
    );
  }

  factory PhysicalEditionMovieRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhysicalEditionMovieRow(
      editionId: serializer.fromJson<int>(json['editionId']),
      movieId: serializer.fromJson<int>(json['movieId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'editionId': serializer.toJson<int>(editionId),
      'movieId': serializer.toJson<int>(movieId),
    };
  }

  PhysicalEditionMovieRow copyWith({int? editionId, int? movieId}) =>
      PhysicalEditionMovieRow(
        editionId: editionId ?? this.editionId,
        movieId: movieId ?? this.movieId,
      );
  PhysicalEditionMovieRow copyWithCompanion(
    PhysicalEditionMoviesCompanion data,
  ) {
    return PhysicalEditionMovieRow(
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhysicalEditionMovieRow(')
          ..write('editionId: $editionId, ')
          ..write('movieId: $movieId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(editionId, movieId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhysicalEditionMovieRow &&
          other.editionId == this.editionId &&
          other.movieId == this.movieId);
}

class PhysicalEditionMoviesCompanion
    extends UpdateCompanion<PhysicalEditionMovieRow> {
  final Value<int> editionId;
  final Value<int> movieId;
  final Value<int> rowid;
  const PhysicalEditionMoviesCompanion({
    this.editionId = const Value.absent(),
    this.movieId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhysicalEditionMoviesCompanion.insert({
    required int editionId,
    required int movieId,
    this.rowid = const Value.absent(),
  }) : editionId = Value(editionId),
       movieId = Value(movieId);
  static Insertable<PhysicalEditionMovieRow> custom({
    Expression<int>? editionId,
    Expression<int>? movieId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (editionId != null) 'edition_id': editionId,
      if (movieId != null) 'movie_id': movieId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhysicalEditionMoviesCompanion copyWith({
    Value<int>? editionId,
    Value<int>? movieId,
    Value<int>? rowid,
  }) {
    return PhysicalEditionMoviesCompanion(
      editionId: editionId ?? this.editionId,
      movieId: movieId ?? this.movieId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (editionId.present) {
      map['edition_id'] = Variable<int>(editionId.value);
    }
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhysicalEditionMoviesCompanion(')
          ..write('editionId: $editionId, ')
          ..write('movieId: $movieId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhysicalEditionTvSeasonsTable extends PhysicalEditionTvSeasons
    with TableInfo<$PhysicalEditionTvSeasonsTable, PhysicalEditionTvSeasonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhysicalEditionTvSeasonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _editionIdMeta = const VerificationMeta(
    'editionId',
  );
  @override
  late final GeneratedColumn<int> editionId = GeneratedColumn<int>(
    'edition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES physical_editions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
    'season_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tv_seasons (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [editionId, seasonId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'physical_edition_tv_seasons';
  @override
  VerificationContext validateIntegrity(
    Insertable<PhysicalEditionTvSeasonRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_editionIdMeta);
    }
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seasonIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {editionId, seasonId};
  @override
  PhysicalEditionTvSeasonRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhysicalEditionTvSeasonRow(
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}edition_id'],
      )!,
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_id'],
      )!,
    );
  }

  @override
  $PhysicalEditionTvSeasonsTable createAlias(String alias) {
    return $PhysicalEditionTvSeasonsTable(attachedDatabase, alias);
  }
}

class PhysicalEditionTvSeasonRow extends DataClass
    implements Insertable<PhysicalEditionTvSeasonRow> {
  final int editionId;
  final int seasonId;
  const PhysicalEditionTvSeasonRow({
    required this.editionId,
    required this.seasonId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['edition_id'] = Variable<int>(editionId);
    map['season_id'] = Variable<int>(seasonId);
    return map;
  }

  PhysicalEditionTvSeasonsCompanion toCompanion(bool nullToAbsent) {
    return PhysicalEditionTvSeasonsCompanion(
      editionId: Value(editionId),
      seasonId: Value(seasonId),
    );
  }

  factory PhysicalEditionTvSeasonRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhysicalEditionTvSeasonRow(
      editionId: serializer.fromJson<int>(json['editionId']),
      seasonId: serializer.fromJson<int>(json['seasonId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'editionId': serializer.toJson<int>(editionId),
      'seasonId': serializer.toJson<int>(seasonId),
    };
  }

  PhysicalEditionTvSeasonRow copyWith({int? editionId, int? seasonId}) =>
      PhysicalEditionTvSeasonRow(
        editionId: editionId ?? this.editionId,
        seasonId: seasonId ?? this.seasonId,
      );
  PhysicalEditionTvSeasonRow copyWithCompanion(
    PhysicalEditionTvSeasonsCompanion data,
  ) {
    return PhysicalEditionTvSeasonRow(
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhysicalEditionTvSeasonRow(')
          ..write('editionId: $editionId, ')
          ..write('seasonId: $seasonId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(editionId, seasonId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhysicalEditionTvSeasonRow &&
          other.editionId == this.editionId &&
          other.seasonId == this.seasonId);
}

class PhysicalEditionTvSeasonsCompanion
    extends UpdateCompanion<PhysicalEditionTvSeasonRow> {
  final Value<int> editionId;
  final Value<int> seasonId;
  final Value<int> rowid;
  const PhysicalEditionTvSeasonsCompanion({
    this.editionId = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhysicalEditionTvSeasonsCompanion.insert({
    required int editionId,
    required int seasonId,
    this.rowid = const Value.absent(),
  }) : editionId = Value(editionId),
       seasonId = Value(seasonId);
  static Insertable<PhysicalEditionTvSeasonRow> custom({
    Expression<int>? editionId,
    Expression<int>? seasonId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (editionId != null) 'edition_id': editionId,
      if (seasonId != null) 'season_id': seasonId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhysicalEditionTvSeasonsCompanion copyWith({
    Value<int>? editionId,
    Value<int>? seasonId,
    Value<int>? rowid,
  }) {
    return PhysicalEditionTvSeasonsCompanion(
      editionId: editionId ?? this.editionId,
      seasonId: seasonId ?? this.seasonId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (editionId.present) {
      map['edition_id'] = Variable<int>(editionId.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhysicalEditionTvSeasonsCompanion(')
          ..write('editionId: $editionId, ')
          ..write('seasonId: $seasonId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MoviesTable movies = $MoviesTable(this);
  late final $GenresTable genres = $GenresTable(this);
  late final $MovieGenresTable movieGenres = $MovieGenresTable(this);
  late final $PhysicalEditionsTable physicalEditions = $PhysicalEditionsTable(
    this,
  );
  late final $BarcodesTable barcodes = $BarcodesTable(this);
  late final $CollectionsTable collections = $CollectionsTable(this);
  late final $CollectionMoviesTable collectionMovies = $CollectionMoviesTable(
    this,
  );
  late final $TvSeriesTableTable tvSeriesTable = $TvSeriesTableTable(this);
  late final $TvSeasonsTableTable tvSeasonsTable = $TvSeasonsTableTable(this);
  late final $TvSeriesGenresTable tvSeriesGenres = $TvSeriesGenresTable(this);
  late final $PhysicalEditionMoviesTable physicalEditionMovies =
      $PhysicalEditionMoviesTable(this);
  late final $PhysicalEditionTvSeasonsTable physicalEditionTvSeasons =
      $PhysicalEditionTvSeasonsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    movies,
    genres,
    movieGenres,
    physicalEditions,
    barcodes,
    collections,
    collectionMovies,
    tvSeriesTable,
    tvSeasonsTable,
    tvSeriesGenres,
    physicalEditionMovies,
    physicalEditionTvSeasons,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movie_genres', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'genres',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movie_genres', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('barcodes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'physical_editions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('barcodes', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('collection_movies', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tv_series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tv_seasons', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tv_series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tv_series_genres', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'genres',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tv_series_genres', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'physical_editions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('physical_edition_movies', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('physical_edition_movies', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'physical_editions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('physical_edition_tv_seasons', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tv_seasons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('physical_edition_tv_seasons', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$MoviesTableCreateCompanionBuilder =
    MoviesCompanion Function({
      Value<int> id,
      Value<int?> tmdbId,
      required String title,
      Value<String?> originalTitle,
      Value<String?> overview,
      Value<DateTime?> releaseDate,
      Value<int?> releaseYear,
      Value<int?> runtime,
      Value<String?> posterPath,
      Value<String?> backdropPath,
      Value<String?> certification,
      Value<String?> originalLanguage,
      Value<int?> tmdbCollectionId,
      Value<CollectionStatus> userStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastMetadataSyncAt,
    });
typedef $$MoviesTableUpdateCompanionBuilder =
    MoviesCompanion Function({
      Value<int> id,
      Value<int?> tmdbId,
      Value<String> title,
      Value<String?> originalTitle,
      Value<String?> overview,
      Value<DateTime?> releaseDate,
      Value<int?> releaseYear,
      Value<int?> runtime,
      Value<String?> posterPath,
      Value<String?> backdropPath,
      Value<String?> certification,
      Value<String?> originalLanguage,
      Value<int?> tmdbCollectionId,
      Value<CollectionStatus> userStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastMetadataSyncAt,
    });

final class $$MoviesTableReferences
    extends BaseReferences<_$AppDatabase, $MoviesTable, MovieRow> {
  $$MoviesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovieGenresTable, List<MovieGenreRow>>
  _movieGenresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movieGenres,
    aliasName: $_aliasNameGenerator(db.movies.id, db.movieGenres.movieId),
  );

  $$MovieGenresTableProcessedTableManager get movieGenresRefs {
    final manager = $$MovieGenresTableTableManager(
      $_db,
      $_db.movieGenres,
    ).filter((f) => f.movieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movieGenresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BarcodesTable, List<BarcodeRow>>
  _barcodesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.barcodes,
    aliasName: $_aliasNameGenerator(db.movies.id, db.barcodes.movieId),
  );

  $$BarcodesTableProcessedTableManager get barcodesRefs {
    final manager = $$BarcodesTableTableManager(
      $_db,
      $_db.barcodes,
    ).filter((f) => f.movieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_barcodesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PhysicalEditionMoviesTable,
    List<PhysicalEditionMovieRow>
  >
  _physicalEditionMoviesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.physicalEditionMovies,
        aliasName: $_aliasNameGenerator(
          db.movies.id,
          db.physicalEditionMovies.movieId,
        ),
      );

  $$PhysicalEditionMoviesTableProcessedTableManager
  get physicalEditionMoviesRefs {
    final manager = $$PhysicalEditionMoviesTableTableManager(
      $_db,
      $_db.physicalEditionMovies,
    ).filter((f) => f.movieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _physicalEditionMoviesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MoviesTableFilterComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableFilterComposer({
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

  ColumnFilters<int> get tmdbId => $composableBuilder(
    column: $table.tmdbId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get runtime => $composableBuilder(
    column: $table.runtime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get certification => $composableBuilder(
    column: $table.certification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tmdbCollectionId => $composableBuilder(
    column: $table.tmdbCollectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CollectionStatus, CollectionStatus, String>
  get userStatus => $composableBuilder(
    column: $table.userStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMetadataSyncAt => $composableBuilder(
    column: $table.lastMetadataSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> movieGenresRefs(
    Expression<bool> Function($$MovieGenresTableFilterComposer f) f,
  ) {
    final $$MovieGenresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movieGenres,
      getReferencedColumn: (t) => t.movieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovieGenresTableFilterComposer(
            $db: $db,
            $table: $db.movieGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> barcodesRefs(
    Expression<bool> Function($$BarcodesTableFilterComposer f) f,
  ) {
    final $$BarcodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.barcodes,
      getReferencedColumn: (t) => t.movieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BarcodesTableFilterComposer(
            $db: $db,
            $table: $db.barcodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> physicalEditionMoviesRefs(
    Expression<bool> Function($$PhysicalEditionMoviesTableFilterComposer f) f,
  ) {
    final $$PhysicalEditionMoviesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.physicalEditionMovies,
          getReferencedColumn: (t) => t.movieId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PhysicalEditionMoviesTableFilterComposer(
                $db: $db,
                $table: $db.physicalEditionMovies,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MoviesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableOrderingComposer({
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

  ColumnOrderings<int> get tmdbId => $composableBuilder(
    column: $table.tmdbId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get runtime => $composableBuilder(
    column: $table.runtime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get certification => $composableBuilder(
    column: $table.certification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tmdbCollectionId => $composableBuilder(
    column: $table.tmdbCollectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userStatus => $composableBuilder(
    column: $table.userStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMetadataSyncAt => $composableBuilder(
    column: $table.lastMetadataSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoviesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => column,
  );

  GeneratedColumn<int> get runtime =>
      $composableBuilder(column: $table.runtime, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get certification => $composableBuilder(
    column: $table.certification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tmdbCollectionId => $composableBuilder(
    column: $table.tmdbCollectionId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CollectionStatus, String> get userStatus =>
      $composableBuilder(
        column: $table.userStatus,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMetadataSyncAt => $composableBuilder(
    column: $table.lastMetadataSyncAt,
    builder: (column) => column,
  );

  Expression<T> movieGenresRefs<T extends Object>(
    Expression<T> Function($$MovieGenresTableAnnotationComposer a) f,
  ) {
    final $$MovieGenresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movieGenres,
      getReferencedColumn: (t) => t.movieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovieGenresTableAnnotationComposer(
            $db: $db,
            $table: $db.movieGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> barcodesRefs<T extends Object>(
    Expression<T> Function($$BarcodesTableAnnotationComposer a) f,
  ) {
    final $$BarcodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.barcodes,
      getReferencedColumn: (t) => t.movieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BarcodesTableAnnotationComposer(
            $db: $db,
            $table: $db.barcodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> physicalEditionMoviesRefs<T extends Object>(
    Expression<T> Function($$PhysicalEditionMoviesTableAnnotationComposer a) f,
  ) {
    final $$PhysicalEditionMoviesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.physicalEditionMovies,
          getReferencedColumn: (t) => t.movieId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PhysicalEditionMoviesTableAnnotationComposer(
                $db: $db,
                $table: $db.physicalEditionMovies,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MoviesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoviesTable,
          MovieRow,
          $$MoviesTableFilterComposer,
          $$MoviesTableOrderingComposer,
          $$MoviesTableAnnotationComposer,
          $$MoviesTableCreateCompanionBuilder,
          $$MoviesTableUpdateCompanionBuilder,
          (MovieRow, $$MoviesTableReferences),
          MovieRow,
          PrefetchHooks Function({
            bool movieGenresRefs,
            bool barcodesRefs,
            bool physicalEditionMoviesRefs,
          })
        > {
  $$MoviesTableTableManager(_$AppDatabase db, $MoviesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoviesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoviesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoviesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> tmdbId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> originalTitle = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<int?> runtime = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<String?> backdropPath = const Value.absent(),
                Value<String?> certification = const Value.absent(),
                Value<String?> originalLanguage = const Value.absent(),
                Value<int?> tmdbCollectionId = const Value.absent(),
                Value<CollectionStatus> userStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastMetadataSyncAt = const Value.absent(),
              }) => MoviesCompanion(
                id: id,
                tmdbId: tmdbId,
                title: title,
                originalTitle: originalTitle,
                overview: overview,
                releaseDate: releaseDate,
                releaseYear: releaseYear,
                runtime: runtime,
                posterPath: posterPath,
                backdropPath: backdropPath,
                certification: certification,
                originalLanguage: originalLanguage,
                tmdbCollectionId: tmdbCollectionId,
                userStatus: userStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastMetadataSyncAt: lastMetadataSyncAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> tmdbId = const Value.absent(),
                required String title,
                Value<String?> originalTitle = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<int?> runtime = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<String?> backdropPath = const Value.absent(),
                Value<String?> certification = const Value.absent(),
                Value<String?> originalLanguage = const Value.absent(),
                Value<int?> tmdbCollectionId = const Value.absent(),
                Value<CollectionStatus> userStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastMetadataSyncAt = const Value.absent(),
              }) => MoviesCompanion.insert(
                id: id,
                tmdbId: tmdbId,
                title: title,
                originalTitle: originalTitle,
                overview: overview,
                releaseDate: releaseDate,
                releaseYear: releaseYear,
                runtime: runtime,
                posterPath: posterPath,
                backdropPath: backdropPath,
                certification: certification,
                originalLanguage: originalLanguage,
                tmdbCollectionId: tmdbCollectionId,
                userStatus: userStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastMetadataSyncAt: lastMetadataSyncAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MoviesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                movieGenresRefs = false,
                barcodesRefs = false,
                physicalEditionMoviesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movieGenresRefs) db.movieGenres,
                    if (barcodesRefs) db.barcodes,
                    if (physicalEditionMoviesRefs) db.physicalEditionMovies,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movieGenresRefs)
                        await $_getPrefetchedData<
                          MovieRow,
                          $MoviesTable,
                          MovieGenreRow
                        >(
                          currentTable: table,
                          referencedTable: $$MoviesTableReferences
                              ._movieGenresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MoviesTableReferences(
                                db,
                                table,
                                p0,
                              ).movieGenresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.movieId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (barcodesRefs)
                        await $_getPrefetchedData<
                          MovieRow,
                          $MoviesTable,
                          BarcodeRow
                        >(
                          currentTable: table,
                          referencedTable: $$MoviesTableReferences
                              ._barcodesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MoviesTableReferences(
                                db,
                                table,
                                p0,
                              ).barcodesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.movieId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (physicalEditionMoviesRefs)
                        await $_getPrefetchedData<
                          MovieRow,
                          $MoviesTable,
                          PhysicalEditionMovieRow
                        >(
                          currentTable: table,
                          referencedTable: $$MoviesTableReferences
                              ._physicalEditionMoviesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MoviesTableReferences(
                                db,
                                table,
                                p0,
                              ).physicalEditionMoviesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.movieId == item.id,
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

typedef $$MoviesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoviesTable,
      MovieRow,
      $$MoviesTableFilterComposer,
      $$MoviesTableOrderingComposer,
      $$MoviesTableAnnotationComposer,
      $$MoviesTableCreateCompanionBuilder,
      $$MoviesTableUpdateCompanionBuilder,
      (MovieRow, $$MoviesTableReferences),
      MovieRow,
      PrefetchHooks Function({
        bool movieGenresRefs,
        bool barcodesRefs,
        bool physicalEditionMoviesRefs,
      })
    >;
typedef $$GenresTableCreateCompanionBuilder =
    GenresCompanion Function({
      Value<int> id,
      required int tmdbId,
      required String name,
    });
typedef $$GenresTableUpdateCompanionBuilder =
    GenresCompanion Function({
      Value<int> id,
      Value<int> tmdbId,
      Value<String> name,
    });

final class $$GenresTableReferences
    extends BaseReferences<_$AppDatabase, $GenresTable, GenreRow> {
  $$GenresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovieGenresTable, List<MovieGenreRow>>
  _movieGenresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movieGenres,
    aliasName: $_aliasNameGenerator(db.genres.id, db.movieGenres.genreId),
  );

  $$MovieGenresTableProcessedTableManager get movieGenresRefs {
    final manager = $$MovieGenresTableTableManager(
      $_db,
      $_db.movieGenres,
    ).filter((f) => f.genreId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movieGenresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TvSeriesGenresTable, List<TvSeriesGenreRow>>
  _tvSeriesGenresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tvSeriesGenres,
    aliasName: $_aliasNameGenerator(db.genres.id, db.tvSeriesGenres.genreId),
  );

  $$TvSeriesGenresTableProcessedTableManager get tvSeriesGenresRefs {
    final manager = $$TvSeriesGenresTableTableManager(
      $_db,
      $_db.tvSeriesGenres,
    ).filter((f) => f.genreId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tvSeriesGenresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GenresTableFilterComposer
    extends Composer<_$AppDatabase, $GenresTable> {
  $$GenresTableFilterComposer({
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

  ColumnFilters<int> get tmdbId => $composableBuilder(
    column: $table.tmdbId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> movieGenresRefs(
    Expression<bool> Function($$MovieGenresTableFilterComposer f) f,
  ) {
    final $$MovieGenresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movieGenres,
      getReferencedColumn: (t) => t.genreId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovieGenresTableFilterComposer(
            $db: $db,
            $table: $db.movieGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tvSeriesGenresRefs(
    Expression<bool> Function($$TvSeriesGenresTableFilterComposer f) f,
  ) {
    final $$TvSeriesGenresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tvSeriesGenres,
      getReferencedColumn: (t) => t.genreId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeriesGenresTableFilterComposer(
            $db: $db,
            $table: $db.tvSeriesGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GenresTableOrderingComposer
    extends Composer<_$AppDatabase, $GenresTable> {
  $$GenresTableOrderingComposer({
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

  ColumnOrderings<int> get tmdbId => $composableBuilder(
    column: $table.tmdbId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GenresTableAnnotationComposer
    extends Composer<_$AppDatabase, $GenresTable> {
  $$GenresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> movieGenresRefs<T extends Object>(
    Expression<T> Function($$MovieGenresTableAnnotationComposer a) f,
  ) {
    final $$MovieGenresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movieGenres,
      getReferencedColumn: (t) => t.genreId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovieGenresTableAnnotationComposer(
            $db: $db,
            $table: $db.movieGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tvSeriesGenresRefs<T extends Object>(
    Expression<T> Function($$TvSeriesGenresTableAnnotationComposer a) f,
  ) {
    final $$TvSeriesGenresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tvSeriesGenres,
      getReferencedColumn: (t) => t.genreId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeriesGenresTableAnnotationComposer(
            $db: $db,
            $table: $db.tvSeriesGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GenresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GenresTable,
          GenreRow,
          $$GenresTableFilterComposer,
          $$GenresTableOrderingComposer,
          $$GenresTableAnnotationComposer,
          $$GenresTableCreateCompanionBuilder,
          $$GenresTableUpdateCompanionBuilder,
          (GenreRow, $$GenresTableReferences),
          GenreRow,
          PrefetchHooks Function({
            bool movieGenresRefs,
            bool tvSeriesGenresRefs,
          })
        > {
  $$GenresTableTableManager(_$AppDatabase db, $GenresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GenresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GenresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GenresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tmdbId = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => GenresCompanion(id: id, tmdbId: tmdbId, name: name),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tmdbId,
                required String name,
              }) => GenresCompanion.insert(id: id, tmdbId: tmdbId, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GenresTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({movieGenresRefs = false, tvSeriesGenresRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movieGenresRefs) db.movieGenres,
                    if (tvSeriesGenresRefs) db.tvSeriesGenres,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movieGenresRefs)
                        await $_getPrefetchedData<
                          GenreRow,
                          $GenresTable,
                          MovieGenreRow
                        >(
                          currentTable: table,
                          referencedTable: $$GenresTableReferences
                              ._movieGenresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GenresTableReferences(
                                db,
                                table,
                                p0,
                              ).movieGenresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.genreId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tvSeriesGenresRefs)
                        await $_getPrefetchedData<
                          GenreRow,
                          $GenresTable,
                          TvSeriesGenreRow
                        >(
                          currentTable: table,
                          referencedTable: $$GenresTableReferences
                              ._tvSeriesGenresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GenresTableReferences(
                                db,
                                table,
                                p0,
                              ).tvSeriesGenresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.genreId == item.id,
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

typedef $$GenresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GenresTable,
      GenreRow,
      $$GenresTableFilterComposer,
      $$GenresTableOrderingComposer,
      $$GenresTableAnnotationComposer,
      $$GenresTableCreateCompanionBuilder,
      $$GenresTableUpdateCompanionBuilder,
      (GenreRow, $$GenresTableReferences),
      GenreRow,
      PrefetchHooks Function({bool movieGenresRefs, bool tvSeriesGenresRefs})
    >;
typedef $$MovieGenresTableCreateCompanionBuilder =
    MovieGenresCompanion Function({
      required int movieId,
      required int genreId,
      Value<int> rowid,
    });
typedef $$MovieGenresTableUpdateCompanionBuilder =
    MovieGenresCompanion Function({
      Value<int> movieId,
      Value<int> genreId,
      Value<int> rowid,
    });

final class $$MovieGenresTableReferences
    extends BaseReferences<_$AppDatabase, $MovieGenresTable, MovieGenreRow> {
  $$MovieGenresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MoviesTable _movieIdTable(_$AppDatabase db) => db.movies.createAlias(
    $_aliasNameGenerator(db.movieGenres.movieId, db.movies.id),
  );

  $$MoviesTableProcessedTableManager get movieId {
    final $_column = $_itemColumn<int>('movie_id')!;

    final manager = $$MoviesTableTableManager(
      $_db,
      $_db.movies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GenresTable _genreIdTable(_$AppDatabase db) => db.genres.createAlias(
    $_aliasNameGenerator(db.movieGenres.genreId, db.genres.id),
  );

  $$GenresTableProcessedTableManager get genreId {
    final $_column = $_itemColumn<int>('genre_id')!;

    final manager = $$GenresTableTableManager(
      $_db,
      $_db.genres,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_genreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovieGenresTableFilterComposer
    extends Composer<_$AppDatabase, $MovieGenresTable> {
  $$MovieGenresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoviesTableFilterComposer get movieId {
    final $$MoviesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoviesTableFilterComposer(
            $db: $db,
            $table: $db.movies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GenresTableFilterComposer get genreId {
    final $$GenresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.genreId,
      referencedTable: $db.genres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GenresTableFilterComposer(
            $db: $db,
            $table: $db.genres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovieGenresTableOrderingComposer
    extends Composer<_$AppDatabase, $MovieGenresTable> {
  $$MovieGenresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoviesTableOrderingComposer get movieId {
    final $$MoviesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoviesTableOrderingComposer(
            $db: $db,
            $table: $db.movies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GenresTableOrderingComposer get genreId {
    final $$GenresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.genreId,
      referencedTable: $db.genres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GenresTableOrderingComposer(
            $db: $db,
            $table: $db.genres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovieGenresTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovieGenresTable> {
  $$MovieGenresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoviesTableAnnotationComposer get movieId {
    final $$MoviesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoviesTableAnnotationComposer(
            $db: $db,
            $table: $db.movies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GenresTableAnnotationComposer get genreId {
    final $$GenresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.genreId,
      referencedTable: $db.genres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GenresTableAnnotationComposer(
            $db: $db,
            $table: $db.genres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovieGenresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovieGenresTable,
          MovieGenreRow,
          $$MovieGenresTableFilterComposer,
          $$MovieGenresTableOrderingComposer,
          $$MovieGenresTableAnnotationComposer,
          $$MovieGenresTableCreateCompanionBuilder,
          $$MovieGenresTableUpdateCompanionBuilder,
          (MovieGenreRow, $$MovieGenresTableReferences),
          MovieGenreRow,
          PrefetchHooks Function({bool movieId, bool genreId})
        > {
  $$MovieGenresTableTableManager(_$AppDatabase db, $MovieGenresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovieGenresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovieGenresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovieGenresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> movieId = const Value.absent(),
                Value<int> genreId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MovieGenresCompanion(
                movieId: movieId,
                genreId: genreId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int movieId,
                required int genreId,
                Value<int> rowid = const Value.absent(),
              }) => MovieGenresCompanion.insert(
                movieId: movieId,
                genreId: genreId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MovieGenresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({movieId = false, genreId = false}) {
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
                    if (movieId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.movieId,
                                referencedTable: $$MovieGenresTableReferences
                                    ._movieIdTable(db),
                                referencedColumn: $$MovieGenresTableReferences
                                    ._movieIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (genreId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.genreId,
                                referencedTable: $$MovieGenresTableReferences
                                    ._genreIdTable(db),
                                referencedColumn: $$MovieGenresTableReferences
                                    ._genreIdTable(db)
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

typedef $$MovieGenresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovieGenresTable,
      MovieGenreRow,
      $$MovieGenresTableFilterComposer,
      $$MovieGenresTableOrderingComposer,
      $$MovieGenresTableAnnotationComposer,
      $$MovieGenresTableCreateCompanionBuilder,
      $$MovieGenresTableUpdateCompanionBuilder,
      (MovieGenreRow, $$MovieGenresTableReferences),
      MovieGenreRow,
      PrefetchHooks Function({bool movieId, bool genreId})
    >;
typedef $$PhysicalEditionsTableCreateCompanionBuilder =
    PhysicalEditionsCompanion Function({
      Value<int> id,
      Value<String?> productTitle,
      Value<String?> editionName,
      required String mediaKind,
      Value<int?> tmdbCollectionId,
      Value<int?> tmdbTvSeriesId,
      Value<DateTime> createdAt,
    });
typedef $$PhysicalEditionsTableUpdateCompanionBuilder =
    PhysicalEditionsCompanion Function({
      Value<int> id,
      Value<String?> productTitle,
      Value<String?> editionName,
      Value<String> mediaKind,
      Value<int?> tmdbCollectionId,
      Value<int?> tmdbTvSeriesId,
      Value<DateTime> createdAt,
    });

final class $$PhysicalEditionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PhysicalEditionsTable,
          PhysicalEditionRow
        > {
  $$PhysicalEditionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$BarcodesTable, List<BarcodeRow>>
  _barcodesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.barcodes,
    aliasName: $_aliasNameGenerator(
      db.physicalEditions.id,
      db.barcodes.physicalEditionId,
    ),
  );

  $$BarcodesTableProcessedTableManager get barcodesRefs {
    final manager = $$BarcodesTableTableManager(
      $_db,
      $_db.barcodes,
    ).filter((f) => f.physicalEditionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_barcodesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PhysicalEditionMoviesTable,
    List<PhysicalEditionMovieRow>
  >
  _physicalEditionMoviesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.physicalEditionMovies,
        aliasName: $_aliasNameGenerator(
          db.physicalEditions.id,
          db.physicalEditionMovies.editionId,
        ),
      );

  $$PhysicalEditionMoviesTableProcessedTableManager
  get physicalEditionMoviesRefs {
    final manager = $$PhysicalEditionMoviesTableTableManager(
      $_db,
      $_db.physicalEditionMovies,
    ).filter((f) => f.editionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _physicalEditionMoviesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PhysicalEditionTvSeasonsTable,
    List<PhysicalEditionTvSeasonRow>
  >
  _physicalEditionTvSeasonsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.physicalEditionTvSeasons,
        aliasName: $_aliasNameGenerator(
          db.physicalEditions.id,
          db.physicalEditionTvSeasons.editionId,
        ),
      );

  $$PhysicalEditionTvSeasonsTableProcessedTableManager
  get physicalEditionTvSeasonsRefs {
    final manager = $$PhysicalEditionTvSeasonsTableTableManager(
      $_db,
      $_db.physicalEditionTvSeasons,
    ).filter((f) => f.editionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _physicalEditionTvSeasonsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PhysicalEditionsTableFilterComposer
    extends Composer<_$AppDatabase, $PhysicalEditionsTable> {
  $$PhysicalEditionsTableFilterComposer({
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

  ColumnFilters<String> get productTitle => $composableBuilder(
    column: $table.productTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaKind => $composableBuilder(
    column: $table.mediaKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tmdbCollectionId => $composableBuilder(
    column: $table.tmdbCollectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tmdbTvSeriesId => $composableBuilder(
    column: $table.tmdbTvSeriesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> barcodesRefs(
    Expression<bool> Function($$BarcodesTableFilterComposer f) f,
  ) {
    final $$BarcodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.barcodes,
      getReferencedColumn: (t) => t.physicalEditionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BarcodesTableFilterComposer(
            $db: $db,
            $table: $db.barcodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> physicalEditionMoviesRefs(
    Expression<bool> Function($$PhysicalEditionMoviesTableFilterComposer f) f,
  ) {
    final $$PhysicalEditionMoviesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.physicalEditionMovies,
          getReferencedColumn: (t) => t.editionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PhysicalEditionMoviesTableFilterComposer(
                $db: $db,
                $table: $db.physicalEditionMovies,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> physicalEditionTvSeasonsRefs(
    Expression<bool> Function($$PhysicalEditionTvSeasonsTableFilterComposer f)
    f,
  ) {
    final $$PhysicalEditionTvSeasonsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.physicalEditionTvSeasons,
          getReferencedColumn: (t) => t.editionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PhysicalEditionTvSeasonsTableFilterComposer(
                $db: $db,
                $table: $db.physicalEditionTvSeasons,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PhysicalEditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PhysicalEditionsTable> {
  $$PhysicalEditionsTableOrderingComposer({
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

  ColumnOrderings<String> get productTitle => $composableBuilder(
    column: $table.productTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaKind => $composableBuilder(
    column: $table.mediaKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tmdbCollectionId => $composableBuilder(
    column: $table.tmdbCollectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tmdbTvSeriesId => $composableBuilder(
    column: $table.tmdbTvSeriesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PhysicalEditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhysicalEditionsTable> {
  $$PhysicalEditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productTitle => $composableBuilder(
    column: $table.productTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaKind =>
      $composableBuilder(column: $table.mediaKind, builder: (column) => column);

  GeneratedColumn<int> get tmdbCollectionId => $composableBuilder(
    column: $table.tmdbCollectionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tmdbTvSeriesId => $composableBuilder(
    column: $table.tmdbTvSeriesId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> barcodesRefs<T extends Object>(
    Expression<T> Function($$BarcodesTableAnnotationComposer a) f,
  ) {
    final $$BarcodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.barcodes,
      getReferencedColumn: (t) => t.physicalEditionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BarcodesTableAnnotationComposer(
            $db: $db,
            $table: $db.barcodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> physicalEditionMoviesRefs<T extends Object>(
    Expression<T> Function($$PhysicalEditionMoviesTableAnnotationComposer a) f,
  ) {
    final $$PhysicalEditionMoviesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.physicalEditionMovies,
          getReferencedColumn: (t) => t.editionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PhysicalEditionMoviesTableAnnotationComposer(
                $db: $db,
                $table: $db.physicalEditionMovies,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> physicalEditionTvSeasonsRefs<T extends Object>(
    Expression<T> Function($$PhysicalEditionTvSeasonsTableAnnotationComposer a)
    f,
  ) {
    final $$PhysicalEditionTvSeasonsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.physicalEditionTvSeasons,
          getReferencedColumn: (t) => t.editionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PhysicalEditionTvSeasonsTableAnnotationComposer(
                $db: $db,
                $table: $db.physicalEditionTvSeasons,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PhysicalEditionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhysicalEditionsTable,
          PhysicalEditionRow,
          $$PhysicalEditionsTableFilterComposer,
          $$PhysicalEditionsTableOrderingComposer,
          $$PhysicalEditionsTableAnnotationComposer,
          $$PhysicalEditionsTableCreateCompanionBuilder,
          $$PhysicalEditionsTableUpdateCompanionBuilder,
          (PhysicalEditionRow, $$PhysicalEditionsTableReferences),
          PhysicalEditionRow,
          PrefetchHooks Function({
            bool barcodesRefs,
            bool physicalEditionMoviesRefs,
            bool physicalEditionTvSeasonsRefs,
          })
        > {
  $$PhysicalEditionsTableTableManager(
    _$AppDatabase db,
    $PhysicalEditionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhysicalEditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhysicalEditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhysicalEditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> productTitle = const Value.absent(),
                Value<String?> editionName = const Value.absent(),
                Value<String> mediaKind = const Value.absent(),
                Value<int?> tmdbCollectionId = const Value.absent(),
                Value<int?> tmdbTvSeriesId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PhysicalEditionsCompanion(
                id: id,
                productTitle: productTitle,
                editionName: editionName,
                mediaKind: mediaKind,
                tmdbCollectionId: tmdbCollectionId,
                tmdbTvSeriesId: tmdbTvSeriesId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> productTitle = const Value.absent(),
                Value<String?> editionName = const Value.absent(),
                required String mediaKind,
                Value<int?> tmdbCollectionId = const Value.absent(),
                Value<int?> tmdbTvSeriesId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PhysicalEditionsCompanion.insert(
                id: id,
                productTitle: productTitle,
                editionName: editionName,
                mediaKind: mediaKind,
                tmdbCollectionId: tmdbCollectionId,
                tmdbTvSeriesId: tmdbTvSeriesId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PhysicalEditionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                barcodesRefs = false,
                physicalEditionMoviesRefs = false,
                physicalEditionTvSeasonsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (barcodesRefs) db.barcodes,
                    if (physicalEditionMoviesRefs) db.physicalEditionMovies,
                    if (physicalEditionTvSeasonsRefs)
                      db.physicalEditionTvSeasons,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (barcodesRefs)
                        await $_getPrefetchedData<
                          PhysicalEditionRow,
                          $PhysicalEditionsTable,
                          BarcodeRow
                        >(
                          currentTable: table,
                          referencedTable: $$PhysicalEditionsTableReferences
                              ._barcodesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PhysicalEditionsTableReferences(
                                db,
                                table,
                                p0,
                              ).barcodesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.physicalEditionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (physicalEditionMoviesRefs)
                        await $_getPrefetchedData<
                          PhysicalEditionRow,
                          $PhysicalEditionsTable,
                          PhysicalEditionMovieRow
                        >(
                          currentTable: table,
                          referencedTable: $$PhysicalEditionsTableReferences
                              ._physicalEditionMoviesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PhysicalEditionsTableReferences(
                                db,
                                table,
                                p0,
                              ).physicalEditionMoviesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.editionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (physicalEditionTvSeasonsRefs)
                        await $_getPrefetchedData<
                          PhysicalEditionRow,
                          $PhysicalEditionsTable,
                          PhysicalEditionTvSeasonRow
                        >(
                          currentTable: table,
                          referencedTable: $$PhysicalEditionsTableReferences
                              ._physicalEditionTvSeasonsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PhysicalEditionsTableReferences(
                                db,
                                table,
                                p0,
                              ).physicalEditionTvSeasonsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.editionId == item.id,
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

typedef $$PhysicalEditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhysicalEditionsTable,
      PhysicalEditionRow,
      $$PhysicalEditionsTableFilterComposer,
      $$PhysicalEditionsTableOrderingComposer,
      $$PhysicalEditionsTableAnnotationComposer,
      $$PhysicalEditionsTableCreateCompanionBuilder,
      $$PhysicalEditionsTableUpdateCompanionBuilder,
      (PhysicalEditionRow, $$PhysicalEditionsTableReferences),
      PhysicalEditionRow,
      PrefetchHooks Function({
        bool barcodesRefs,
        bool physicalEditionMoviesRefs,
        bool physicalEditionTvSeasonsRefs,
      })
    >;
typedef $$BarcodesTableCreateCompanionBuilder =
    BarcodesCompanion Function({
      Value<int> id,
      Value<int?> movieId,
      Value<int?> physicalEditionId,
      required String barcode,
      required String barcodeType,
      Value<String?> productTitle,
      Value<String?> editionName,
      Value<DateTime> createdAt,
    });
typedef $$BarcodesTableUpdateCompanionBuilder =
    BarcodesCompanion Function({
      Value<int> id,
      Value<int?> movieId,
      Value<int?> physicalEditionId,
      Value<String> barcode,
      Value<String> barcodeType,
      Value<String?> productTitle,
      Value<String?> editionName,
      Value<DateTime> createdAt,
    });

final class $$BarcodesTableReferences
    extends BaseReferences<_$AppDatabase, $BarcodesTable, BarcodeRow> {
  $$BarcodesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MoviesTable _movieIdTable(_$AppDatabase db) => db.movies.createAlias(
    $_aliasNameGenerator(db.barcodes.movieId, db.movies.id),
  );

  $$MoviesTableProcessedTableManager? get movieId {
    final $_column = $_itemColumn<int>('movie_id');
    if ($_column == null) return null;
    final manager = $$MoviesTableTableManager(
      $_db,
      $_db.movies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PhysicalEditionsTable _physicalEditionIdTable(_$AppDatabase db) =>
      db.physicalEditions.createAlias(
        $_aliasNameGenerator(
          db.barcodes.physicalEditionId,
          db.physicalEditions.id,
        ),
      );

  $$PhysicalEditionsTableProcessedTableManager? get physicalEditionId {
    final $_column = $_itemColumn<int>('physical_edition_id');
    if ($_column == null) return null;
    final manager = $$PhysicalEditionsTableTableManager(
      $_db,
      $_db.physicalEditions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_physicalEditionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BarcodesTableFilterComposer
    extends Composer<_$AppDatabase, $BarcodesTable> {
  $$BarcodesTableFilterComposer({
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

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcodeType => $composableBuilder(
    column: $table.barcodeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productTitle => $composableBuilder(
    column: $table.productTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MoviesTableFilterComposer get movieId {
    final $$MoviesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoviesTableFilterComposer(
            $db: $db,
            $table: $db.movies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhysicalEditionsTableFilterComposer get physicalEditionId {
    final $$PhysicalEditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.physicalEditionId,
      referencedTable: $db.physicalEditions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhysicalEditionsTableFilterComposer(
            $db: $db,
            $table: $db.physicalEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BarcodesTableOrderingComposer
    extends Composer<_$AppDatabase, $BarcodesTable> {
  $$BarcodesTableOrderingComposer({
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

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcodeType => $composableBuilder(
    column: $table.barcodeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productTitle => $composableBuilder(
    column: $table.productTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MoviesTableOrderingComposer get movieId {
    final $$MoviesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoviesTableOrderingComposer(
            $db: $db,
            $table: $db.movies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhysicalEditionsTableOrderingComposer get physicalEditionId {
    final $$PhysicalEditionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.physicalEditionId,
      referencedTable: $db.physicalEditions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhysicalEditionsTableOrderingComposer(
            $db: $db,
            $table: $db.physicalEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BarcodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BarcodesTable> {
  $$BarcodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get barcodeType => $composableBuilder(
    column: $table.barcodeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productTitle => $composableBuilder(
    column: $table.productTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MoviesTableAnnotationComposer get movieId {
    final $$MoviesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoviesTableAnnotationComposer(
            $db: $db,
            $table: $db.movies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PhysicalEditionsTableAnnotationComposer get physicalEditionId {
    final $$PhysicalEditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.physicalEditionId,
      referencedTable: $db.physicalEditions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhysicalEditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.physicalEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BarcodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BarcodesTable,
          BarcodeRow,
          $$BarcodesTableFilterComposer,
          $$BarcodesTableOrderingComposer,
          $$BarcodesTableAnnotationComposer,
          $$BarcodesTableCreateCompanionBuilder,
          $$BarcodesTableUpdateCompanionBuilder,
          (BarcodeRow, $$BarcodesTableReferences),
          BarcodeRow,
          PrefetchHooks Function({bool movieId, bool physicalEditionId})
        > {
  $$BarcodesTableTableManager(_$AppDatabase db, $BarcodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BarcodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BarcodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BarcodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> movieId = const Value.absent(),
                Value<int?> physicalEditionId = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String> barcodeType = const Value.absent(),
                Value<String?> productTitle = const Value.absent(),
                Value<String?> editionName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BarcodesCompanion(
                id: id,
                movieId: movieId,
                physicalEditionId: physicalEditionId,
                barcode: barcode,
                barcodeType: barcodeType,
                productTitle: productTitle,
                editionName: editionName,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> movieId = const Value.absent(),
                Value<int?> physicalEditionId = const Value.absent(),
                required String barcode,
                required String barcodeType,
                Value<String?> productTitle = const Value.absent(),
                Value<String?> editionName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BarcodesCompanion.insert(
                id: id,
                movieId: movieId,
                physicalEditionId: physicalEditionId,
                barcode: barcode,
                barcodeType: barcodeType,
                productTitle: productTitle,
                editionName: editionName,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BarcodesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({movieId = false, physicalEditionId = false}) {
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
                        if (movieId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.movieId,
                                    referencedTable: $$BarcodesTableReferences
                                        ._movieIdTable(db),
                                    referencedColumn: $$BarcodesTableReferences
                                        ._movieIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (physicalEditionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.physicalEditionId,
                                    referencedTable: $$BarcodesTableReferences
                                        ._physicalEditionIdTable(db),
                                    referencedColumn: $$BarcodesTableReferences
                                        ._physicalEditionIdTable(db)
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

typedef $$BarcodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BarcodesTable,
      BarcodeRow,
      $$BarcodesTableFilterComposer,
      $$BarcodesTableOrderingComposer,
      $$BarcodesTableAnnotationComposer,
      $$BarcodesTableCreateCompanionBuilder,
      $$BarcodesTableUpdateCompanionBuilder,
      (BarcodeRow, $$BarcodesTableReferences),
      BarcodeRow,
      PrefetchHooks Function({bool movieId, bool physicalEditionId})
    >;
typedef $$CollectionsTableCreateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      Value<int?> tmdbCollectionId,
      required String name,
      Value<String?> overview,
      Value<String?> posterPath,
      Value<String?> backdropPath,
      Value<bool> isCustom,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$CollectionsTableUpdateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      Value<int?> tmdbCollectionId,
      Value<String> name,
      Value<String?> overview,
      Value<String?> posterPath,
      Value<String?> backdropPath,
      Value<bool> isCustom,
      Value<DateTime?> lastSyncedAt,
    });

final class $$CollectionsTableReferences
    extends BaseReferences<_$AppDatabase, $CollectionsTable, CollectionRow> {
  $$CollectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CollectionMoviesTable, List<CollectionMovieRow>>
  _collectionMoviesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.collectionMovies,
    aliasName: $_aliasNameGenerator(
      db.collections.id,
      db.collectionMovies.collectionId,
    ),
  );

  $$CollectionMoviesTableProcessedTableManager get collectionMoviesRefs {
    final manager = $$CollectionMoviesTableTableManager(
      $_db,
      $_db.collectionMovies,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _collectionMoviesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableFilterComposer({
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

  ColumnFilters<int> get tmdbCollectionId => $composableBuilder(
    column: $table.tmdbCollectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> collectionMoviesRefs(
    Expression<bool> Function($$CollectionMoviesTableFilterComposer f) f,
  ) {
    final $$CollectionMoviesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionMovies,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionMoviesTableFilterComposer(
            $db: $db,
            $table: $db.collectionMovies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableOrderingComposer({
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

  ColumnOrderings<int> get tmdbCollectionId => $composableBuilder(
    column: $table.tmdbCollectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbCollectionId => $composableBuilder(
    column: $table.tmdbCollectionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  Expression<T> collectionMoviesRefs<T extends Object>(
    Expression<T> Function($$CollectionMoviesTableAnnotationComposer a) f,
  ) {
    final $$CollectionMoviesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionMovies,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionMoviesTableAnnotationComposer(
            $db: $db,
            $table: $db.collectionMovies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionsTable,
          CollectionRow,
          $$CollectionsTableFilterComposer,
          $$CollectionsTableOrderingComposer,
          $$CollectionsTableAnnotationComposer,
          $$CollectionsTableCreateCompanionBuilder,
          $$CollectionsTableUpdateCompanionBuilder,
          (CollectionRow, $$CollectionsTableReferences),
          CollectionRow,
          PrefetchHooks Function({bool collectionMoviesRefs})
        > {
  $$CollectionsTableTableManager(_$AppDatabase db, $CollectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> tmdbCollectionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<String?> backdropPath = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => CollectionsCompanion(
                id: id,
                tmdbCollectionId: tmdbCollectionId,
                name: name,
                overview: overview,
                posterPath: posterPath,
                backdropPath: backdropPath,
                isCustom: isCustom,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> tmdbCollectionId = const Value.absent(),
                required String name,
                Value<String?> overview = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<String?> backdropPath = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => CollectionsCompanion.insert(
                id: id,
                tmdbCollectionId: tmdbCollectionId,
                name: name,
                overview: overview,
                posterPath: posterPath,
                backdropPath: backdropPath,
                isCustom: isCustom,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({collectionMoviesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (collectionMoviesRefs) db.collectionMovies,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (collectionMoviesRefs)
                    await $_getPrefetchedData<
                      CollectionRow,
                      $CollectionsTable,
                      CollectionMovieRow
                    >(
                      currentTable: table,
                      referencedTable: $$CollectionsTableReferences
                          ._collectionMoviesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CollectionsTableReferences(
                            db,
                            table,
                            p0,
                          ).collectionMoviesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.collectionId == item.id,
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

typedef $$CollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionsTable,
      CollectionRow,
      $$CollectionsTableFilterComposer,
      $$CollectionsTableOrderingComposer,
      $$CollectionsTableAnnotationComposer,
      $$CollectionsTableCreateCompanionBuilder,
      $$CollectionsTableUpdateCompanionBuilder,
      (CollectionRow, $$CollectionsTableReferences),
      CollectionRow,
      PrefetchHooks Function({bool collectionMoviesRefs})
    >;
typedef $$CollectionMoviesTableCreateCompanionBuilder =
    CollectionMoviesCompanion Function({
      Value<int> id,
      required int collectionId,
      required int tmdbMovieId,
      required String title,
      Value<String?> originalTitle,
      Value<String?> posterPath,
      Value<DateTime?> releaseDate,
    });
typedef $$CollectionMoviesTableUpdateCompanionBuilder =
    CollectionMoviesCompanion Function({
      Value<int> id,
      Value<int> collectionId,
      Value<int> tmdbMovieId,
      Value<String> title,
      Value<String?> originalTitle,
      Value<String?> posterPath,
      Value<DateTime?> releaseDate,
    });

final class $$CollectionMoviesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CollectionMoviesTable,
          CollectionMovieRow
        > {
  $$CollectionMoviesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CollectionsTable _collectionIdTable(_$AppDatabase db) =>
      db.collections.createAlias(
        $_aliasNameGenerator(
          db.collectionMovies.collectionId,
          db.collections.id,
        ),
      );

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<int>('collection_id')!;

    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CollectionMoviesTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionMoviesTable> {
  $$CollectionMoviesTableFilterComposer({
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

  ColumnFilters<int> get tmdbMovieId => $composableBuilder(
    column: $table.tmdbMovieId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnFilters(column),
  );

  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionMoviesTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionMoviesTable> {
  $$CollectionMoviesTableOrderingComposer({
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

  ColumnOrderings<int> get tmdbMovieId => $composableBuilder(
    column: $table.tmdbMovieId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionMoviesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionMoviesTable> {
  $$CollectionMoviesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbMovieId => $composableBuilder(
    column: $table.tmdbMovieId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => column,
  );

  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionMoviesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionMoviesTable,
          CollectionMovieRow,
          $$CollectionMoviesTableFilterComposer,
          $$CollectionMoviesTableOrderingComposer,
          $$CollectionMoviesTableAnnotationComposer,
          $$CollectionMoviesTableCreateCompanionBuilder,
          $$CollectionMoviesTableUpdateCompanionBuilder,
          (CollectionMovieRow, $$CollectionMoviesTableReferences),
          CollectionMovieRow,
          PrefetchHooks Function({bool collectionId})
        > {
  $$CollectionMoviesTableTableManager(
    _$AppDatabase db,
    $CollectionMoviesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionMoviesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionMoviesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionMoviesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> collectionId = const Value.absent(),
                Value<int> tmdbMovieId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> originalTitle = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
              }) => CollectionMoviesCompanion(
                id: id,
                collectionId: collectionId,
                tmdbMovieId: tmdbMovieId,
                title: title,
                originalTitle: originalTitle,
                posterPath: posterPath,
                releaseDate: releaseDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int collectionId,
                required int tmdbMovieId,
                required String title,
                Value<String?> originalTitle = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<DateTime?> releaseDate = const Value.absent(),
              }) => CollectionMoviesCompanion.insert(
                id: id,
                collectionId: collectionId,
                tmdbMovieId: tmdbMovieId,
                title: title,
                originalTitle: originalTitle,
                posterPath: posterPath,
                releaseDate: releaseDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CollectionMoviesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({collectionId = false}) {
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
                    if (collectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.collectionId,
                                referencedTable:
                                    $$CollectionMoviesTableReferences
                                        ._collectionIdTable(db),
                                referencedColumn:
                                    $$CollectionMoviesTableReferences
                                        ._collectionIdTable(db)
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

typedef $$CollectionMoviesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionMoviesTable,
      CollectionMovieRow,
      $$CollectionMoviesTableFilterComposer,
      $$CollectionMoviesTableOrderingComposer,
      $$CollectionMoviesTableAnnotationComposer,
      $$CollectionMoviesTableCreateCompanionBuilder,
      $$CollectionMoviesTableUpdateCompanionBuilder,
      (CollectionMovieRow, $$CollectionMoviesTableReferences),
      CollectionMovieRow,
      PrefetchHooks Function({bool collectionId})
    >;
typedef $$TvSeriesTableTableCreateCompanionBuilder =
    TvSeriesTableCompanion Function({
      Value<int> id,
      required int tmdbId,
      required String name,
      Value<String?> originalName,
      Value<String?> overview,
      Value<String?> posterPath,
      Value<String?> backdropPath,
      Value<DateTime?> firstAirDate,
      Value<DateTime?> lastAirDate,
      Value<int?> numberOfSeasons,
      Value<String?> seriesStatus,
      Value<String?> originalLanguage,
      Value<String?> contentRating,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastMetadataSyncAt,
    });
typedef $$TvSeriesTableTableUpdateCompanionBuilder =
    TvSeriesTableCompanion Function({
      Value<int> id,
      Value<int> tmdbId,
      Value<String> name,
      Value<String?> originalName,
      Value<String?> overview,
      Value<String?> posterPath,
      Value<String?> backdropPath,
      Value<DateTime?> firstAirDate,
      Value<DateTime?> lastAirDate,
      Value<int?> numberOfSeasons,
      Value<String?> seriesStatus,
      Value<String?> originalLanguage,
      Value<String?> contentRating,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastMetadataSyncAt,
    });

final class $$TvSeriesTableTableReferences
    extends BaseReferences<_$AppDatabase, $TvSeriesTableTable, TvSeriesRow> {
  $$TvSeriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TvSeasonsTableTable, List<TvSeasonRow>>
  _tvSeasonsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tvSeasonsTable,
    aliasName: $_aliasNameGenerator(
      db.tvSeriesTable.id,
      db.tvSeasonsTable.seriesId,
    ),
  );

  $$TvSeasonsTableTableProcessedTableManager get tvSeasonsTableRefs {
    final manager = $$TvSeasonsTableTableTableManager(
      $_db,
      $_db.tvSeasonsTable,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tvSeasonsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TvSeriesGenresTable, List<TvSeriesGenreRow>>
  _tvSeriesGenresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tvSeriesGenres,
    aliasName: $_aliasNameGenerator(
      db.tvSeriesTable.id,
      db.tvSeriesGenres.seriesId,
    ),
  );

  $$TvSeriesGenresTableProcessedTableManager get tvSeriesGenresRefs {
    final manager = $$TvSeriesGenresTableTableManager(
      $_db,
      $_db.tvSeriesGenres,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tvSeriesGenresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TvSeriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $TvSeriesTableTable> {
  $$TvSeriesTableTableFilterComposer({
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

  ColumnFilters<int> get tmdbId => $composableBuilder(
    column: $table.tmdbId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstAirDate => $composableBuilder(
    column: $table.firstAirDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAirDate => $composableBuilder(
    column: $table.lastAirDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numberOfSeasons => $composableBuilder(
    column: $table.numberOfSeasons,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seriesStatus => $composableBuilder(
    column: $table.seriesStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentRating => $composableBuilder(
    column: $table.contentRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMetadataSyncAt => $composableBuilder(
    column: $table.lastMetadataSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tvSeasonsTableRefs(
    Expression<bool> Function($$TvSeasonsTableTableFilterComposer f) f,
  ) {
    final $$TvSeasonsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tvSeasonsTable,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeasonsTableTableFilterComposer(
            $db: $db,
            $table: $db.tvSeasonsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tvSeriesGenresRefs(
    Expression<bool> Function($$TvSeriesGenresTableFilterComposer f) f,
  ) {
    final $$TvSeriesGenresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tvSeriesGenres,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeriesGenresTableFilterComposer(
            $db: $db,
            $table: $db.tvSeriesGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TvSeriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TvSeriesTableTable> {
  $$TvSeriesTableTableOrderingComposer({
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

  ColumnOrderings<int> get tmdbId => $composableBuilder(
    column: $table.tmdbId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstAirDate => $composableBuilder(
    column: $table.firstAirDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAirDate => $composableBuilder(
    column: $table.lastAirDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numberOfSeasons => $composableBuilder(
    column: $table.numberOfSeasons,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seriesStatus => $composableBuilder(
    column: $table.seriesStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentRating => $composableBuilder(
    column: $table.contentRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMetadataSyncAt => $composableBuilder(
    column: $table.lastMetadataSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TvSeriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TvSeriesTableTable> {
  $$TvSeriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firstAirDate => $composableBuilder(
    column: $table.firstAirDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAirDate => $composableBuilder(
    column: $table.lastAirDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numberOfSeasons => $composableBuilder(
    column: $table.numberOfSeasons,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seriesStatus => $composableBuilder(
    column: $table.seriesStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalLanguage => $composableBuilder(
    column: $table.originalLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentRating => $composableBuilder(
    column: $table.contentRating,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMetadataSyncAt => $composableBuilder(
    column: $table.lastMetadataSyncAt,
    builder: (column) => column,
  );

  Expression<T> tvSeasonsTableRefs<T extends Object>(
    Expression<T> Function($$TvSeasonsTableTableAnnotationComposer a) f,
  ) {
    final $$TvSeasonsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tvSeasonsTable,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeasonsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tvSeasonsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tvSeriesGenresRefs<T extends Object>(
    Expression<T> Function($$TvSeriesGenresTableAnnotationComposer a) f,
  ) {
    final $$TvSeriesGenresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tvSeriesGenres,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeriesGenresTableAnnotationComposer(
            $db: $db,
            $table: $db.tvSeriesGenres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TvSeriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TvSeriesTableTable,
          TvSeriesRow,
          $$TvSeriesTableTableFilterComposer,
          $$TvSeriesTableTableOrderingComposer,
          $$TvSeriesTableTableAnnotationComposer,
          $$TvSeriesTableTableCreateCompanionBuilder,
          $$TvSeriesTableTableUpdateCompanionBuilder,
          (TvSeriesRow, $$TvSeriesTableTableReferences),
          TvSeriesRow,
          PrefetchHooks Function({
            bool tvSeasonsTableRefs,
            bool tvSeriesGenresRefs,
          })
        > {
  $$TvSeriesTableTableTableManager(_$AppDatabase db, $TvSeriesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TvSeriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TvSeriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TvSeriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tmdbId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> originalName = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<String?> backdropPath = const Value.absent(),
                Value<DateTime?> firstAirDate = const Value.absent(),
                Value<DateTime?> lastAirDate = const Value.absent(),
                Value<int?> numberOfSeasons = const Value.absent(),
                Value<String?> seriesStatus = const Value.absent(),
                Value<String?> originalLanguage = const Value.absent(),
                Value<String?> contentRating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastMetadataSyncAt = const Value.absent(),
              }) => TvSeriesTableCompanion(
                id: id,
                tmdbId: tmdbId,
                name: name,
                originalName: originalName,
                overview: overview,
                posterPath: posterPath,
                backdropPath: backdropPath,
                firstAirDate: firstAirDate,
                lastAirDate: lastAirDate,
                numberOfSeasons: numberOfSeasons,
                seriesStatus: seriesStatus,
                originalLanguage: originalLanguage,
                contentRating: contentRating,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastMetadataSyncAt: lastMetadataSyncAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tmdbId,
                required String name,
                Value<String?> originalName = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<String?> backdropPath = const Value.absent(),
                Value<DateTime?> firstAirDate = const Value.absent(),
                Value<DateTime?> lastAirDate = const Value.absent(),
                Value<int?> numberOfSeasons = const Value.absent(),
                Value<String?> seriesStatus = const Value.absent(),
                Value<String?> originalLanguage = const Value.absent(),
                Value<String?> contentRating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastMetadataSyncAt = const Value.absent(),
              }) => TvSeriesTableCompanion.insert(
                id: id,
                tmdbId: tmdbId,
                name: name,
                originalName: originalName,
                overview: overview,
                posterPath: posterPath,
                backdropPath: backdropPath,
                firstAirDate: firstAirDate,
                lastAirDate: lastAirDate,
                numberOfSeasons: numberOfSeasons,
                seriesStatus: seriesStatus,
                originalLanguage: originalLanguage,
                contentRating: contentRating,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastMetadataSyncAt: lastMetadataSyncAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TvSeriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({tvSeasonsTableRefs = false, tvSeriesGenresRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tvSeasonsTableRefs) db.tvSeasonsTable,
                    if (tvSeriesGenresRefs) db.tvSeriesGenres,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tvSeasonsTableRefs)
                        await $_getPrefetchedData<
                          TvSeriesRow,
                          $TvSeriesTableTable,
                          TvSeasonRow
                        >(
                          currentTable: table,
                          referencedTable: $$TvSeriesTableTableReferences
                              ._tvSeasonsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TvSeriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).tvSeasonsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seriesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tvSeriesGenresRefs)
                        await $_getPrefetchedData<
                          TvSeriesRow,
                          $TvSeriesTableTable,
                          TvSeriesGenreRow
                        >(
                          currentTable: table,
                          referencedTable: $$TvSeriesTableTableReferences
                              ._tvSeriesGenresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TvSeriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).tvSeriesGenresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seriesId == item.id,
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

typedef $$TvSeriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TvSeriesTableTable,
      TvSeriesRow,
      $$TvSeriesTableTableFilterComposer,
      $$TvSeriesTableTableOrderingComposer,
      $$TvSeriesTableTableAnnotationComposer,
      $$TvSeriesTableTableCreateCompanionBuilder,
      $$TvSeriesTableTableUpdateCompanionBuilder,
      (TvSeriesRow, $$TvSeriesTableTableReferences),
      TvSeriesRow,
      PrefetchHooks Function({bool tvSeasonsTableRefs, bool tvSeriesGenresRefs})
    >;
typedef $$TvSeasonsTableTableCreateCompanionBuilder =
    TvSeasonsTableCompanion Function({
      Value<int> id,
      required int seriesId,
      Value<int?> tmdbSeasonId,
      required int seasonNumber,
      required String name,
      Value<String?> overview,
      Value<String?> posterPath,
      Value<DateTime?> airDate,
      Value<int?> episodeCount,
      Value<CollectionStatus?> userStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TvSeasonsTableTableUpdateCompanionBuilder =
    TvSeasonsTableCompanion Function({
      Value<int> id,
      Value<int> seriesId,
      Value<int?> tmdbSeasonId,
      Value<int> seasonNumber,
      Value<String> name,
      Value<String?> overview,
      Value<String?> posterPath,
      Value<DateTime?> airDate,
      Value<int?> episodeCount,
      Value<CollectionStatus?> userStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TvSeasonsTableTableReferences
    extends BaseReferences<_$AppDatabase, $TvSeasonsTableTable, TvSeasonRow> {
  $$TvSeasonsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TvSeriesTableTable _seriesIdTable(_$AppDatabase db) =>
      db.tvSeriesTable.createAlias(
        $_aliasNameGenerator(db.tvSeasonsTable.seriesId, db.tvSeriesTable.id),
      );

  $$TvSeriesTableTableProcessedTableManager get seriesId {
    final $_column = $_itemColumn<int>('series_id')!;

    final manager = $$TvSeriesTableTableTableManager(
      $_db,
      $_db.tvSeriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $PhysicalEditionTvSeasonsTable,
    List<PhysicalEditionTvSeasonRow>
  >
  _physicalEditionTvSeasonsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.physicalEditionTvSeasons,
        aliasName: $_aliasNameGenerator(
          db.tvSeasonsTable.id,
          db.physicalEditionTvSeasons.seasonId,
        ),
      );

  $$PhysicalEditionTvSeasonsTableProcessedTableManager
  get physicalEditionTvSeasonsRefs {
    final manager = $$PhysicalEditionTvSeasonsTableTableManager(
      $_db,
      $_db.physicalEditionTvSeasons,
    ).filter((f) => f.seasonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _physicalEditionTvSeasonsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TvSeasonsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TvSeasonsTableTable> {
  $$TvSeasonsTableTableFilterComposer({
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

  ColumnFilters<int> get tmdbSeasonId => $composableBuilder(
    column: $table.tmdbSeasonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get airDate => $composableBuilder(
    column: $table.airDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episodeCount => $composableBuilder(
    column: $table.episodeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CollectionStatus?, CollectionStatus, String>
  get userStatus => $composableBuilder(
    column: $table.userStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TvSeriesTableTableFilterComposer get seriesId {
    final $$TvSeriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.tvSeriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeriesTableTableFilterComposer(
            $db: $db,
            $table: $db.tvSeriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> physicalEditionTvSeasonsRefs(
    Expression<bool> Function($$PhysicalEditionTvSeasonsTableFilterComposer f)
    f,
  ) {
    final $$PhysicalEditionTvSeasonsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.physicalEditionTvSeasons,
          getReferencedColumn: (t) => t.seasonId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PhysicalEditionTvSeasonsTableFilterComposer(
                $db: $db,
                $table: $db.physicalEditionTvSeasons,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TvSeasonsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TvSeasonsTableTable> {
  $$TvSeasonsTableTableOrderingComposer({
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

  ColumnOrderings<int> get tmdbSeasonId => $composableBuilder(
    column: $table.tmdbSeasonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get airDate => $composableBuilder(
    column: $table.airDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episodeCount => $composableBuilder(
    column: $table.episodeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userStatus => $composableBuilder(
    column: $table.userStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TvSeriesTableTableOrderingComposer get seriesId {
    final $$TvSeriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.tvSeriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.tvSeriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TvSeasonsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TvSeasonsTableTable> {
  $$TvSeasonsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbSeasonId => $composableBuilder(
    column: $table.tmdbSeasonId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get airDate =>
      $composableBuilder(column: $table.airDate, builder: (column) => column);

  GeneratedColumn<int> get episodeCount => $composableBuilder(
    column: $table.episodeCount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CollectionStatus?, String> get userStatus =>
      $composableBuilder(
        column: $table.userStatus,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TvSeriesTableTableAnnotationComposer get seriesId {
    final $$TvSeriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.tvSeriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tvSeriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> physicalEditionTvSeasonsRefs<T extends Object>(
    Expression<T> Function($$PhysicalEditionTvSeasonsTableAnnotationComposer a)
    f,
  ) {
    final $$PhysicalEditionTvSeasonsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.physicalEditionTvSeasons,
          getReferencedColumn: (t) => t.seasonId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PhysicalEditionTvSeasonsTableAnnotationComposer(
                $db: $db,
                $table: $db.physicalEditionTvSeasons,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TvSeasonsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TvSeasonsTableTable,
          TvSeasonRow,
          $$TvSeasonsTableTableFilterComposer,
          $$TvSeasonsTableTableOrderingComposer,
          $$TvSeasonsTableTableAnnotationComposer,
          $$TvSeasonsTableTableCreateCompanionBuilder,
          $$TvSeasonsTableTableUpdateCompanionBuilder,
          (TvSeasonRow, $$TvSeasonsTableTableReferences),
          TvSeasonRow,
          PrefetchHooks Function({
            bool seriesId,
            bool physicalEditionTvSeasonsRefs,
          })
        > {
  $$TvSeasonsTableTableTableManager(
    _$AppDatabase db,
    $TvSeasonsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TvSeasonsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TvSeasonsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TvSeasonsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> seriesId = const Value.absent(),
                Value<int?> tmdbSeasonId = const Value.absent(),
                Value<int> seasonNumber = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<DateTime?> airDate = const Value.absent(),
                Value<int?> episodeCount = const Value.absent(),
                Value<CollectionStatus?> userStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TvSeasonsTableCompanion(
                id: id,
                seriesId: seriesId,
                tmdbSeasonId: tmdbSeasonId,
                seasonNumber: seasonNumber,
                name: name,
                overview: overview,
                posterPath: posterPath,
                airDate: airDate,
                episodeCount: episodeCount,
                userStatus: userStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int seriesId,
                Value<int?> tmdbSeasonId = const Value.absent(),
                required int seasonNumber,
                required String name,
                Value<String?> overview = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<DateTime?> airDate = const Value.absent(),
                Value<int?> episodeCount = const Value.absent(),
                Value<CollectionStatus?> userStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TvSeasonsTableCompanion.insert(
                id: id,
                seriesId: seriesId,
                tmdbSeasonId: tmdbSeasonId,
                seasonNumber: seasonNumber,
                name: name,
                overview: overview,
                posterPath: posterPath,
                airDate: airDate,
                episodeCount: episodeCount,
                userStatus: userStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TvSeasonsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({seriesId = false, physicalEditionTvSeasonsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (physicalEditionTvSeasonsRefs)
                      db.physicalEditionTvSeasons,
                  ],
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
                        if (seriesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.seriesId,
                                    referencedTable:
                                        $$TvSeasonsTableTableReferences
                                            ._seriesIdTable(db),
                                    referencedColumn:
                                        $$TvSeasonsTableTableReferences
                                            ._seriesIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (physicalEditionTvSeasonsRefs)
                        await $_getPrefetchedData<
                          TvSeasonRow,
                          $TvSeasonsTableTable,
                          PhysicalEditionTvSeasonRow
                        >(
                          currentTable: table,
                          referencedTable: $$TvSeasonsTableTableReferences
                              ._physicalEditionTvSeasonsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TvSeasonsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).physicalEditionTvSeasonsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.seasonId == item.id,
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

typedef $$TvSeasonsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TvSeasonsTableTable,
      TvSeasonRow,
      $$TvSeasonsTableTableFilterComposer,
      $$TvSeasonsTableTableOrderingComposer,
      $$TvSeasonsTableTableAnnotationComposer,
      $$TvSeasonsTableTableCreateCompanionBuilder,
      $$TvSeasonsTableTableUpdateCompanionBuilder,
      (TvSeasonRow, $$TvSeasonsTableTableReferences),
      TvSeasonRow,
      PrefetchHooks Function({bool seriesId, bool physicalEditionTvSeasonsRefs})
    >;
typedef $$TvSeriesGenresTableCreateCompanionBuilder =
    TvSeriesGenresCompanion Function({
      required int seriesId,
      required int genreId,
      Value<int> rowid,
    });
typedef $$TvSeriesGenresTableUpdateCompanionBuilder =
    TvSeriesGenresCompanion Function({
      Value<int> seriesId,
      Value<int> genreId,
      Value<int> rowid,
    });

final class $$TvSeriesGenresTableReferences
    extends
        BaseReferences<_$AppDatabase, $TvSeriesGenresTable, TvSeriesGenreRow> {
  $$TvSeriesGenresTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TvSeriesTableTable _seriesIdTable(_$AppDatabase db) =>
      db.tvSeriesTable.createAlias(
        $_aliasNameGenerator(db.tvSeriesGenres.seriesId, db.tvSeriesTable.id),
      );

  $$TvSeriesTableTableProcessedTableManager get seriesId {
    final $_column = $_itemColumn<int>('series_id')!;

    final manager = $$TvSeriesTableTableTableManager(
      $_db,
      $_db.tvSeriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GenresTable _genreIdTable(_$AppDatabase db) => db.genres.createAlias(
    $_aliasNameGenerator(db.tvSeriesGenres.genreId, db.genres.id),
  );

  $$GenresTableProcessedTableManager get genreId {
    final $_column = $_itemColumn<int>('genre_id')!;

    final manager = $$GenresTableTableManager(
      $_db,
      $_db.genres,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_genreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TvSeriesGenresTableFilterComposer
    extends Composer<_$AppDatabase, $TvSeriesGenresTable> {
  $$TvSeriesGenresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TvSeriesTableTableFilterComposer get seriesId {
    final $$TvSeriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.tvSeriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeriesTableTableFilterComposer(
            $db: $db,
            $table: $db.tvSeriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GenresTableFilterComposer get genreId {
    final $$GenresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.genreId,
      referencedTable: $db.genres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GenresTableFilterComposer(
            $db: $db,
            $table: $db.genres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TvSeriesGenresTableOrderingComposer
    extends Composer<_$AppDatabase, $TvSeriesGenresTable> {
  $$TvSeriesGenresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TvSeriesTableTableOrderingComposer get seriesId {
    final $$TvSeriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.tvSeriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.tvSeriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GenresTableOrderingComposer get genreId {
    final $$GenresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.genreId,
      referencedTable: $db.genres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GenresTableOrderingComposer(
            $db: $db,
            $table: $db.genres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TvSeriesGenresTableAnnotationComposer
    extends Composer<_$AppDatabase, $TvSeriesGenresTable> {
  $$TvSeriesGenresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TvSeriesTableTableAnnotationComposer get seriesId {
    final $$TvSeriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.tvSeriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tvSeriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GenresTableAnnotationComposer get genreId {
    final $$GenresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.genreId,
      referencedTable: $db.genres,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GenresTableAnnotationComposer(
            $db: $db,
            $table: $db.genres,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TvSeriesGenresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TvSeriesGenresTable,
          TvSeriesGenreRow,
          $$TvSeriesGenresTableFilterComposer,
          $$TvSeriesGenresTableOrderingComposer,
          $$TvSeriesGenresTableAnnotationComposer,
          $$TvSeriesGenresTableCreateCompanionBuilder,
          $$TvSeriesGenresTableUpdateCompanionBuilder,
          (TvSeriesGenreRow, $$TvSeriesGenresTableReferences),
          TvSeriesGenreRow,
          PrefetchHooks Function({bool seriesId, bool genreId})
        > {
  $$TvSeriesGenresTableTableManager(
    _$AppDatabase db,
    $TvSeriesGenresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TvSeriesGenresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TvSeriesGenresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TvSeriesGenresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seriesId = const Value.absent(),
                Value<int> genreId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TvSeriesGenresCompanion(
                seriesId: seriesId,
                genreId: genreId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int seriesId,
                required int genreId,
                Value<int> rowid = const Value.absent(),
              }) => TvSeriesGenresCompanion.insert(
                seriesId: seriesId,
                genreId: genreId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TvSeriesGenresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({seriesId = false, genreId = false}) {
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
                    if (seriesId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.seriesId,
                                referencedTable: $$TvSeriesGenresTableReferences
                                    ._seriesIdTable(db),
                                referencedColumn:
                                    $$TvSeriesGenresTableReferences
                                        ._seriesIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (genreId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.genreId,
                                referencedTable: $$TvSeriesGenresTableReferences
                                    ._genreIdTable(db),
                                referencedColumn:
                                    $$TvSeriesGenresTableReferences
                                        ._genreIdTable(db)
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

typedef $$TvSeriesGenresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TvSeriesGenresTable,
      TvSeriesGenreRow,
      $$TvSeriesGenresTableFilterComposer,
      $$TvSeriesGenresTableOrderingComposer,
      $$TvSeriesGenresTableAnnotationComposer,
      $$TvSeriesGenresTableCreateCompanionBuilder,
      $$TvSeriesGenresTableUpdateCompanionBuilder,
      (TvSeriesGenreRow, $$TvSeriesGenresTableReferences),
      TvSeriesGenreRow,
      PrefetchHooks Function({bool seriesId, bool genreId})
    >;
typedef $$PhysicalEditionMoviesTableCreateCompanionBuilder =
    PhysicalEditionMoviesCompanion Function({
      required int editionId,
      required int movieId,
      Value<int> rowid,
    });
typedef $$PhysicalEditionMoviesTableUpdateCompanionBuilder =
    PhysicalEditionMoviesCompanion Function({
      Value<int> editionId,
      Value<int> movieId,
      Value<int> rowid,
    });

final class $$PhysicalEditionMoviesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PhysicalEditionMoviesTable,
          PhysicalEditionMovieRow
        > {
  $$PhysicalEditionMoviesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PhysicalEditionsTable _editionIdTable(_$AppDatabase db) =>
      db.physicalEditions.createAlias(
        $_aliasNameGenerator(
          db.physicalEditionMovies.editionId,
          db.physicalEditions.id,
        ),
      );

  $$PhysicalEditionsTableProcessedTableManager get editionId {
    final $_column = $_itemColumn<int>('edition_id')!;

    final manager = $$PhysicalEditionsTableTableManager(
      $_db,
      $_db.physicalEditions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_editionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MoviesTable _movieIdTable(_$AppDatabase db) => db.movies.createAlias(
    $_aliasNameGenerator(db.physicalEditionMovies.movieId, db.movies.id),
  );

  $$MoviesTableProcessedTableManager get movieId {
    final $_column = $_itemColumn<int>('movie_id')!;

    final manager = $$MoviesTableTableManager(
      $_db,
      $_db.movies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PhysicalEditionMoviesTableFilterComposer
    extends Composer<_$AppDatabase, $PhysicalEditionMoviesTable> {
  $$PhysicalEditionMoviesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PhysicalEditionsTableFilterComposer get editionId {
    final $$PhysicalEditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.physicalEditions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhysicalEditionsTableFilterComposer(
            $db: $db,
            $table: $db.physicalEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MoviesTableFilterComposer get movieId {
    final $$MoviesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoviesTableFilterComposer(
            $db: $db,
            $table: $db.movies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhysicalEditionMoviesTableOrderingComposer
    extends Composer<_$AppDatabase, $PhysicalEditionMoviesTable> {
  $$PhysicalEditionMoviesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PhysicalEditionsTableOrderingComposer get editionId {
    final $$PhysicalEditionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.physicalEditions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhysicalEditionsTableOrderingComposer(
            $db: $db,
            $table: $db.physicalEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MoviesTableOrderingComposer get movieId {
    final $$MoviesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoviesTableOrderingComposer(
            $db: $db,
            $table: $db.movies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhysicalEditionMoviesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhysicalEditionMoviesTable> {
  $$PhysicalEditionMoviesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PhysicalEditionsTableAnnotationComposer get editionId {
    final $$PhysicalEditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.physicalEditions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhysicalEditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.physicalEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MoviesTableAnnotationComposer get movieId {
    final $$MoviesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoviesTableAnnotationComposer(
            $db: $db,
            $table: $db.movies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhysicalEditionMoviesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhysicalEditionMoviesTable,
          PhysicalEditionMovieRow,
          $$PhysicalEditionMoviesTableFilterComposer,
          $$PhysicalEditionMoviesTableOrderingComposer,
          $$PhysicalEditionMoviesTableAnnotationComposer,
          $$PhysicalEditionMoviesTableCreateCompanionBuilder,
          $$PhysicalEditionMoviesTableUpdateCompanionBuilder,
          (PhysicalEditionMovieRow, $$PhysicalEditionMoviesTableReferences),
          PhysicalEditionMovieRow,
          PrefetchHooks Function({bool editionId, bool movieId})
        > {
  $$PhysicalEditionMoviesTableTableManager(
    _$AppDatabase db,
    $PhysicalEditionMoviesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhysicalEditionMoviesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PhysicalEditionMoviesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PhysicalEditionMoviesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> editionId = const Value.absent(),
                Value<int> movieId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhysicalEditionMoviesCompanion(
                editionId: editionId,
                movieId: movieId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int editionId,
                required int movieId,
                Value<int> rowid = const Value.absent(),
              }) => PhysicalEditionMoviesCompanion.insert(
                editionId: editionId,
                movieId: movieId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PhysicalEditionMoviesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({editionId = false, movieId = false}) {
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
                    if (editionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.editionId,
                                referencedTable:
                                    $$PhysicalEditionMoviesTableReferences
                                        ._editionIdTable(db),
                                referencedColumn:
                                    $$PhysicalEditionMoviesTableReferences
                                        ._editionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (movieId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.movieId,
                                referencedTable:
                                    $$PhysicalEditionMoviesTableReferences
                                        ._movieIdTable(db),
                                referencedColumn:
                                    $$PhysicalEditionMoviesTableReferences
                                        ._movieIdTable(db)
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

typedef $$PhysicalEditionMoviesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhysicalEditionMoviesTable,
      PhysicalEditionMovieRow,
      $$PhysicalEditionMoviesTableFilterComposer,
      $$PhysicalEditionMoviesTableOrderingComposer,
      $$PhysicalEditionMoviesTableAnnotationComposer,
      $$PhysicalEditionMoviesTableCreateCompanionBuilder,
      $$PhysicalEditionMoviesTableUpdateCompanionBuilder,
      (PhysicalEditionMovieRow, $$PhysicalEditionMoviesTableReferences),
      PhysicalEditionMovieRow,
      PrefetchHooks Function({bool editionId, bool movieId})
    >;
typedef $$PhysicalEditionTvSeasonsTableCreateCompanionBuilder =
    PhysicalEditionTvSeasonsCompanion Function({
      required int editionId,
      required int seasonId,
      Value<int> rowid,
    });
typedef $$PhysicalEditionTvSeasonsTableUpdateCompanionBuilder =
    PhysicalEditionTvSeasonsCompanion Function({
      Value<int> editionId,
      Value<int> seasonId,
      Value<int> rowid,
    });

final class $$PhysicalEditionTvSeasonsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PhysicalEditionTvSeasonsTable,
          PhysicalEditionTvSeasonRow
        > {
  $$PhysicalEditionTvSeasonsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PhysicalEditionsTable _editionIdTable(_$AppDatabase db) =>
      db.physicalEditions.createAlias(
        $_aliasNameGenerator(
          db.physicalEditionTvSeasons.editionId,
          db.physicalEditions.id,
        ),
      );

  $$PhysicalEditionsTableProcessedTableManager get editionId {
    final $_column = $_itemColumn<int>('edition_id')!;

    final manager = $$PhysicalEditionsTableTableManager(
      $_db,
      $_db.physicalEditions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_editionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TvSeasonsTableTable _seasonIdTable(_$AppDatabase db) =>
      db.tvSeasonsTable.createAlias(
        $_aliasNameGenerator(
          db.physicalEditionTvSeasons.seasonId,
          db.tvSeasonsTable.id,
        ),
      );

  $$TvSeasonsTableTableProcessedTableManager get seasonId {
    final $_column = $_itemColumn<int>('season_id')!;

    final manager = $$TvSeasonsTableTableTableManager(
      $_db,
      $_db.tvSeasonsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seasonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PhysicalEditionTvSeasonsTableFilterComposer
    extends Composer<_$AppDatabase, $PhysicalEditionTvSeasonsTable> {
  $$PhysicalEditionTvSeasonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PhysicalEditionsTableFilterComposer get editionId {
    final $$PhysicalEditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.physicalEditions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhysicalEditionsTableFilterComposer(
            $db: $db,
            $table: $db.physicalEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TvSeasonsTableTableFilterComposer get seasonId {
    final $$TvSeasonsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.tvSeasonsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeasonsTableTableFilterComposer(
            $db: $db,
            $table: $db.tvSeasonsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhysicalEditionTvSeasonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PhysicalEditionTvSeasonsTable> {
  $$PhysicalEditionTvSeasonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PhysicalEditionsTableOrderingComposer get editionId {
    final $$PhysicalEditionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.physicalEditions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhysicalEditionsTableOrderingComposer(
            $db: $db,
            $table: $db.physicalEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TvSeasonsTableTableOrderingComposer get seasonId {
    final $$TvSeasonsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.tvSeasonsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeasonsTableTableOrderingComposer(
            $db: $db,
            $table: $db.tvSeasonsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhysicalEditionTvSeasonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhysicalEditionTvSeasonsTable> {
  $$PhysicalEditionTvSeasonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PhysicalEditionsTableAnnotationComposer get editionId {
    final $$PhysicalEditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.physicalEditions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhysicalEditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.physicalEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TvSeasonsTableTableAnnotationComposer get seasonId {
    final $$TvSeasonsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seasonId,
      referencedTable: $db.tvSeasonsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TvSeasonsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tvSeasonsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhysicalEditionTvSeasonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhysicalEditionTvSeasonsTable,
          PhysicalEditionTvSeasonRow,
          $$PhysicalEditionTvSeasonsTableFilterComposer,
          $$PhysicalEditionTvSeasonsTableOrderingComposer,
          $$PhysicalEditionTvSeasonsTableAnnotationComposer,
          $$PhysicalEditionTvSeasonsTableCreateCompanionBuilder,
          $$PhysicalEditionTvSeasonsTableUpdateCompanionBuilder,
          (
            PhysicalEditionTvSeasonRow,
            $$PhysicalEditionTvSeasonsTableReferences,
          ),
          PhysicalEditionTvSeasonRow,
          PrefetchHooks Function({bool editionId, bool seasonId})
        > {
  $$PhysicalEditionTvSeasonsTableTableManager(
    _$AppDatabase db,
    $PhysicalEditionTvSeasonsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhysicalEditionTvSeasonsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PhysicalEditionTvSeasonsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PhysicalEditionTvSeasonsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> editionId = const Value.absent(),
                Value<int> seasonId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhysicalEditionTvSeasonsCompanion(
                editionId: editionId,
                seasonId: seasonId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int editionId,
                required int seasonId,
                Value<int> rowid = const Value.absent(),
              }) => PhysicalEditionTvSeasonsCompanion.insert(
                editionId: editionId,
                seasonId: seasonId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PhysicalEditionTvSeasonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({editionId = false, seasonId = false}) {
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
                    if (editionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.editionId,
                                referencedTable:
                                    $$PhysicalEditionTvSeasonsTableReferences
                                        ._editionIdTable(db),
                                referencedColumn:
                                    $$PhysicalEditionTvSeasonsTableReferences
                                        ._editionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (seasonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.seasonId,
                                referencedTable:
                                    $$PhysicalEditionTvSeasonsTableReferences
                                        ._seasonIdTable(db),
                                referencedColumn:
                                    $$PhysicalEditionTvSeasonsTableReferences
                                        ._seasonIdTable(db)
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

typedef $$PhysicalEditionTvSeasonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhysicalEditionTvSeasonsTable,
      PhysicalEditionTvSeasonRow,
      $$PhysicalEditionTvSeasonsTableFilterComposer,
      $$PhysicalEditionTvSeasonsTableOrderingComposer,
      $$PhysicalEditionTvSeasonsTableAnnotationComposer,
      $$PhysicalEditionTvSeasonsTableCreateCompanionBuilder,
      $$PhysicalEditionTvSeasonsTableUpdateCompanionBuilder,
      (PhysicalEditionTvSeasonRow, $$PhysicalEditionTvSeasonsTableReferences),
      PhysicalEditionTvSeasonRow,
      PrefetchHooks Function({bool editionId, bool seasonId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MoviesTableTableManager get movies =>
      $$MoviesTableTableManager(_db, _db.movies);
  $$GenresTableTableManager get genres =>
      $$GenresTableTableManager(_db, _db.genres);
  $$MovieGenresTableTableManager get movieGenres =>
      $$MovieGenresTableTableManager(_db, _db.movieGenres);
  $$PhysicalEditionsTableTableManager get physicalEditions =>
      $$PhysicalEditionsTableTableManager(_db, _db.physicalEditions);
  $$BarcodesTableTableManager get barcodes =>
      $$BarcodesTableTableManager(_db, _db.barcodes);
  $$CollectionsTableTableManager get collections =>
      $$CollectionsTableTableManager(_db, _db.collections);
  $$CollectionMoviesTableTableManager get collectionMovies =>
      $$CollectionMoviesTableTableManager(_db, _db.collectionMovies);
  $$TvSeriesTableTableTableManager get tvSeriesTable =>
      $$TvSeriesTableTableTableManager(_db, _db.tvSeriesTable);
  $$TvSeasonsTableTableTableManager get tvSeasonsTable =>
      $$TvSeasonsTableTableTableManager(_db, _db.tvSeasonsTable);
  $$TvSeriesGenresTableTableManager get tvSeriesGenres =>
      $$TvSeriesGenresTableTableManager(_db, _db.tvSeriesGenres);
  $$PhysicalEditionMoviesTableTableManager get physicalEditionMovies =>
      $$PhysicalEditionMoviesTableTableManager(_db, _db.physicalEditionMovies);
  $$PhysicalEditionTvSeasonsTableTableManager get physicalEditionTvSeasons =>
      $$PhysicalEditionTvSeasonsTableTableManager(
        _db,
        _db.physicalEditionTvSeasons,
      );
}
