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
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: SyncIds.random,
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
    defaultValue: Constant(CollectionStatus.open.name),
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
    uuid,
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
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
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
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
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

  /// Sync identity of movies without a TMDB id. Movies with one use
  /// SyncIds.movie(tmdbId) so every device agrees on it.
  final String? uuid;
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

  /// Derived from copies and personal state by OwnershipService. Do not write directly.
  final CollectionStatus userStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastMetadataSyncAt;
  const MovieRow({
    required this.id,
    this.tmdbId,
    this.uuid,
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
    if (!nullToAbsent || uuid != null) {
      map['uuid'] = Variable<String>(uuid);
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
      uuid: uuid == null && nullToAbsent ? const Value.absent() : Value(uuid),
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
      uuid: serializer.fromJson<String?>(json['uuid']),
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
      'uuid': serializer.toJson<String?>(uuid),
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
    Value<String?> uuid = const Value.absent(),
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
    uuid: uuid.present ? uuid.value : this.uuid,
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
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
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
          ..write('uuid: $uuid, ')
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
    uuid,
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
          other.uuid == this.uuid &&
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
  final Value<String?> uuid;
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
    this.uuid = const Value.absent(),
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
    this.uuid = const Value.absent(),
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
    Expression<String>? uuid,
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
      if (uuid != null) 'uuid': uuid,
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
    Value<String?>? uuid,
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
      uuid: uuid ?? this.uuid,
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
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
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
          ..write('uuid: $uuid, ')
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
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: SyncIds.random,
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
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseCountryMeta = const VerificationMeta(
    'releaseCountry',
  );
  @override
  late final GeneratedColumn<String> releaseCountry = GeneratedColumn<String>(
    'release_country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioLanguagesMeta = const VerificationMeta(
    'audioLanguages',
  );
  @override
  late final GeneratedColumn<String> audioLanguages = GeneratedColumn<String>(
    'audio_languages',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtitleLanguagesMeta = const VerificationMeta(
    'subtitleLanguages',
  );
  @override
  late final GeneratedColumn<String> subtitleLanguages =
      GeneratedColumn<String>(
        'subtitle_languages',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
    uuid,
    productTitle,
    editionName,
    mediaKind,
    tmdbCollectionId,
    tmdbTvSeriesId,
    format,
    region,
    releaseCountry,
    audioLanguages,
    subtitleLanguages,
    publisher,
    notes,
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
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
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
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('release_country')) {
      context.handle(
        _releaseCountryMeta,
        releaseCountry.isAcceptableOrUnknown(
          data['release_country']!,
          _releaseCountryMeta,
        ),
      );
    }
    if (data.containsKey('audio_languages')) {
      context.handle(
        _audioLanguagesMeta,
        audioLanguages.isAcceptableOrUnknown(
          data['audio_languages']!,
          _audioLanguagesMeta,
        ),
      );
    }
    if (data.containsKey('subtitle_languages')) {
      context.handle(
        _subtitleLanguagesMeta,
        subtitleLanguages.isAcceptableOrUnknown(
          data['subtitle_languages']!,
          _subtitleLanguagesMeta,
        ),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      ),
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
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      releaseCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}release_country'],
      ),
      audioLanguages: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_languages'],
      ),
      subtitleLanguages: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle_languages'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
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

  /// Sync identity. Unique through an index created in AppDatabase.
  final String? uuid;
  final String? productTitle;
  final String? editionName;
  final String mediaKind;
  final int? tmdbCollectionId;
  final int? tmdbTvSeriesId;

  /// A MediaFormat name: dvd, bluray, uhd4k, vhs, digital or unknown.
  final String format;
  final String? region;
  final String? releaseCountry;

  /// Comma separated language codes, for example "de,en".
  final String? audioLanguages;
  final String? subtitleLanguages;
  final String? publisher;
  final String? notes;
  final DateTime createdAt;
  const PhysicalEditionRow({
    required this.id,
    this.uuid,
    this.productTitle,
    this.editionName,
    required this.mediaKind,
    this.tmdbCollectionId,
    this.tmdbTvSeriesId,
    required this.format,
    this.region,
    this.releaseCountry,
    this.audioLanguages,
    this.subtitleLanguages,
    this.publisher,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || uuid != null) {
      map['uuid'] = Variable<String>(uuid);
    }
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
    map['format'] = Variable<String>(format);
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    if (!nullToAbsent || releaseCountry != null) {
      map['release_country'] = Variable<String>(releaseCountry);
    }
    if (!nullToAbsent || audioLanguages != null) {
      map['audio_languages'] = Variable<String>(audioLanguages);
    }
    if (!nullToAbsent || subtitleLanguages != null) {
      map['subtitle_languages'] = Variable<String>(subtitleLanguages);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PhysicalEditionsCompanion toCompanion(bool nullToAbsent) {
    return PhysicalEditionsCompanion(
      id: Value(id),
      uuid: uuid == null && nullToAbsent ? const Value.absent() : Value(uuid),
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
      format: Value(format),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      releaseCountry: releaseCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseCountry),
      audioLanguages: audioLanguages == null && nullToAbsent
          ? const Value.absent()
          : Value(audioLanguages),
      subtitleLanguages: subtitleLanguages == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitleLanguages),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
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
      uuid: serializer.fromJson<String?>(json['uuid']),
      productTitle: serializer.fromJson<String?>(json['productTitle']),
      editionName: serializer.fromJson<String?>(json['editionName']),
      mediaKind: serializer.fromJson<String>(json['mediaKind']),
      tmdbCollectionId: serializer.fromJson<int?>(json['tmdbCollectionId']),
      tmdbTvSeriesId: serializer.fromJson<int?>(json['tmdbTvSeriesId']),
      format: serializer.fromJson<String>(json['format']),
      region: serializer.fromJson<String?>(json['region']),
      releaseCountry: serializer.fromJson<String?>(json['releaseCountry']),
      audioLanguages: serializer.fromJson<String?>(json['audioLanguages']),
      subtitleLanguages: serializer.fromJson<String?>(
        json['subtitleLanguages'],
      ),
      publisher: serializer.fromJson<String?>(json['publisher']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String?>(uuid),
      'productTitle': serializer.toJson<String?>(productTitle),
      'editionName': serializer.toJson<String?>(editionName),
      'mediaKind': serializer.toJson<String>(mediaKind),
      'tmdbCollectionId': serializer.toJson<int?>(tmdbCollectionId),
      'tmdbTvSeriesId': serializer.toJson<int?>(tmdbTvSeriesId),
      'format': serializer.toJson<String>(format),
      'region': serializer.toJson<String?>(region),
      'releaseCountry': serializer.toJson<String?>(releaseCountry),
      'audioLanguages': serializer.toJson<String?>(audioLanguages),
      'subtitleLanguages': serializer.toJson<String?>(subtitleLanguages),
      'publisher': serializer.toJson<String?>(publisher),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PhysicalEditionRow copyWith({
    int? id,
    Value<String?> uuid = const Value.absent(),
    Value<String?> productTitle = const Value.absent(),
    Value<String?> editionName = const Value.absent(),
    String? mediaKind,
    Value<int?> tmdbCollectionId = const Value.absent(),
    Value<int?> tmdbTvSeriesId = const Value.absent(),
    String? format,
    Value<String?> region = const Value.absent(),
    Value<String?> releaseCountry = const Value.absent(),
    Value<String?> audioLanguages = const Value.absent(),
    Value<String?> subtitleLanguages = const Value.absent(),
    Value<String?> publisher = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => PhysicalEditionRow(
    id: id ?? this.id,
    uuid: uuid.present ? uuid.value : this.uuid,
    productTitle: productTitle.present ? productTitle.value : this.productTitle,
    editionName: editionName.present ? editionName.value : this.editionName,
    mediaKind: mediaKind ?? this.mediaKind,
    tmdbCollectionId: tmdbCollectionId.present
        ? tmdbCollectionId.value
        : this.tmdbCollectionId,
    tmdbTvSeriesId: tmdbTvSeriesId.present
        ? tmdbTvSeriesId.value
        : this.tmdbTvSeriesId,
    format: format ?? this.format,
    region: region.present ? region.value : this.region,
    releaseCountry: releaseCountry.present
        ? releaseCountry.value
        : this.releaseCountry,
    audioLanguages: audioLanguages.present
        ? audioLanguages.value
        : this.audioLanguages,
    subtitleLanguages: subtitleLanguages.present
        ? subtitleLanguages.value
        : this.subtitleLanguages,
    publisher: publisher.present ? publisher.value : this.publisher,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  PhysicalEditionRow copyWithCompanion(PhysicalEditionsCompanion data) {
    return PhysicalEditionRow(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
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
      format: data.format.present ? data.format.value : this.format,
      region: data.region.present ? data.region.value : this.region,
      releaseCountry: data.releaseCountry.present
          ? data.releaseCountry.value
          : this.releaseCountry,
      audioLanguages: data.audioLanguages.present
          ? data.audioLanguages.value
          : this.audioLanguages,
      subtitleLanguages: data.subtitleLanguages.present
          ? data.subtitleLanguages.value
          : this.subtitleLanguages,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhysicalEditionRow(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('productTitle: $productTitle, ')
          ..write('editionName: $editionName, ')
          ..write('mediaKind: $mediaKind, ')
          ..write('tmdbCollectionId: $tmdbCollectionId, ')
          ..write('tmdbTvSeriesId: $tmdbTvSeriesId, ')
          ..write('format: $format, ')
          ..write('region: $region, ')
          ..write('releaseCountry: $releaseCountry, ')
          ..write('audioLanguages: $audioLanguages, ')
          ..write('subtitleLanguages: $subtitleLanguages, ')
          ..write('publisher: $publisher, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    productTitle,
    editionName,
    mediaKind,
    tmdbCollectionId,
    tmdbTvSeriesId,
    format,
    region,
    releaseCountry,
    audioLanguages,
    subtitleLanguages,
    publisher,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhysicalEditionRow &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.productTitle == this.productTitle &&
          other.editionName == this.editionName &&
          other.mediaKind == this.mediaKind &&
          other.tmdbCollectionId == this.tmdbCollectionId &&
          other.tmdbTvSeriesId == this.tmdbTvSeriesId &&
          other.format == this.format &&
          other.region == this.region &&
          other.releaseCountry == this.releaseCountry &&
          other.audioLanguages == this.audioLanguages &&
          other.subtitleLanguages == this.subtitleLanguages &&
          other.publisher == this.publisher &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class PhysicalEditionsCompanion extends UpdateCompanion<PhysicalEditionRow> {
  final Value<int> id;
  final Value<String?> uuid;
  final Value<String?> productTitle;
  final Value<String?> editionName;
  final Value<String> mediaKind;
  final Value<int?> tmdbCollectionId;
  final Value<int?> tmdbTvSeriesId;
  final Value<String> format;
  final Value<String?> region;
  final Value<String?> releaseCountry;
  final Value<String?> audioLanguages;
  final Value<String?> subtitleLanguages;
  final Value<String?> publisher;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const PhysicalEditionsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.productTitle = const Value.absent(),
    this.editionName = const Value.absent(),
    this.mediaKind = const Value.absent(),
    this.tmdbCollectionId = const Value.absent(),
    this.tmdbTvSeriesId = const Value.absent(),
    this.format = const Value.absent(),
    this.region = const Value.absent(),
    this.releaseCountry = const Value.absent(),
    this.audioLanguages = const Value.absent(),
    this.subtitleLanguages = const Value.absent(),
    this.publisher = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PhysicalEditionsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.productTitle = const Value.absent(),
    this.editionName = const Value.absent(),
    required String mediaKind,
    this.tmdbCollectionId = const Value.absent(),
    this.tmdbTvSeriesId = const Value.absent(),
    this.format = const Value.absent(),
    this.region = const Value.absent(),
    this.releaseCountry = const Value.absent(),
    this.audioLanguages = const Value.absent(),
    this.subtitleLanguages = const Value.absent(),
    this.publisher = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : mediaKind = Value(mediaKind);
  static Insertable<PhysicalEditionRow> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? productTitle,
    Expression<String>? editionName,
    Expression<String>? mediaKind,
    Expression<int>? tmdbCollectionId,
    Expression<int>? tmdbTvSeriesId,
    Expression<String>? format,
    Expression<String>? region,
    Expression<String>? releaseCountry,
    Expression<String>? audioLanguages,
    Expression<String>? subtitleLanguages,
    Expression<String>? publisher,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (productTitle != null) 'product_title': productTitle,
      if (editionName != null) 'edition_name': editionName,
      if (mediaKind != null) 'media_kind': mediaKind,
      if (tmdbCollectionId != null) 'tmdb_collection_id': tmdbCollectionId,
      if (tmdbTvSeriesId != null) 'tmdb_tv_series_id': tmdbTvSeriesId,
      if (format != null) 'format': format,
      if (region != null) 'region': region,
      if (releaseCountry != null) 'release_country': releaseCountry,
      if (audioLanguages != null) 'audio_languages': audioLanguages,
      if (subtitleLanguages != null) 'subtitle_languages': subtitleLanguages,
      if (publisher != null) 'publisher': publisher,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PhysicalEditionsCompanion copyWith({
    Value<int>? id,
    Value<String?>? uuid,
    Value<String?>? productTitle,
    Value<String?>? editionName,
    Value<String>? mediaKind,
    Value<int?>? tmdbCollectionId,
    Value<int?>? tmdbTvSeriesId,
    Value<String>? format,
    Value<String?>? region,
    Value<String?>? releaseCountry,
    Value<String?>? audioLanguages,
    Value<String?>? subtitleLanguages,
    Value<String?>? publisher,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return PhysicalEditionsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      productTitle: productTitle ?? this.productTitle,
      editionName: editionName ?? this.editionName,
      mediaKind: mediaKind ?? this.mediaKind,
      tmdbCollectionId: tmdbCollectionId ?? this.tmdbCollectionId,
      tmdbTvSeriesId: tmdbTvSeriesId ?? this.tmdbTvSeriesId,
      format: format ?? this.format,
      region: region ?? this.region,
      releaseCountry: releaseCountry ?? this.releaseCountry,
      audioLanguages: audioLanguages ?? this.audioLanguages,
      subtitleLanguages: subtitleLanguages ?? this.subtitleLanguages,
      publisher: publisher ?? this.publisher,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
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
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (releaseCountry.present) {
      map['release_country'] = Variable<String>(releaseCountry.value);
    }
    if (audioLanguages.present) {
      map['audio_languages'] = Variable<String>(audioLanguages.value);
    }
    if (subtitleLanguages.present) {
      map['subtitle_languages'] = Variable<String>(subtitleLanguages.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
          ..write('uuid: $uuid, ')
          ..write('productTitle: $productTitle, ')
          ..write('editionName: $editionName, ')
          ..write('mediaKind: $mediaKind, ')
          ..write('tmdbCollectionId: $tmdbCollectionId, ')
          ..write('tmdbTvSeriesId: $tmdbTvSeriesId, ')
          ..write('format: $format, ')
          ..write('region: $region, ')
          ..write('releaseCountry: $releaseCountry, ')
          ..write('audioLanguages: $audioLanguages, ')
          ..write('subtitleLanguages: $subtitleLanguages, ')
          ..write('publisher: $publisher, ')
          ..write('notes: $notes, ')
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
  static const VerificationMeta _physicalFormatMeta = const VerificationMeta(
    'physicalFormat',
  );
  @override
  late final GeneratedColumn<String> physicalFormat = GeneratedColumn<String>(
    'physical_format',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imdbIdMeta = const VerificationMeta('imdbId');
  @override
  late final GeneratedColumn<String> imdbId = GeneratedColumn<String>(
    'imdb_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verifiedMeta = const VerificationMeta(
    'verified',
  );
  @override
  late final GeneratedColumn<bool> verified = GeneratedColumn<bool>(
    'verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    physicalFormat,
    region,
    imdbId,
    source,
    verified,
    createdAt,
    updatedAt,
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
    if (data.containsKey('physical_format')) {
      context.handle(
        _physicalFormatMeta,
        physicalFormat.isAcceptableOrUnknown(
          data['physical_format']!,
          _physicalFormatMeta,
        ),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('imdb_id')) {
      context.handle(
        _imdbIdMeta,
        imdbId.isAcceptableOrUnknown(data['imdb_id']!, _imdbIdMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('verified')) {
      context.handle(
        _verifiedMeta,
        verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta),
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
      physicalFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}physical_format'],
      ),
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      imdbId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imdb_id'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      verified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}verified'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
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
  final String? physicalFormat;
  final String? region;
  final String? imdbId;
  final String? source;
  final bool verified;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const BarcodeRow({
    required this.id,
    this.movieId,
    this.physicalEditionId,
    required this.barcode,
    required this.barcodeType,
    this.productTitle,
    this.editionName,
    this.physicalFormat,
    this.region,
    this.imdbId,
    this.source,
    required this.verified,
    required this.createdAt,
    this.updatedAt,
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
    if (!nullToAbsent || physicalFormat != null) {
      map['physical_format'] = Variable<String>(physicalFormat);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    if (!nullToAbsent || imdbId != null) {
      map['imdb_id'] = Variable<String>(imdbId);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['verified'] = Variable<bool>(verified);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
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
      physicalFormat: physicalFormat == null && nullToAbsent
          ? const Value.absent()
          : Value(physicalFormat),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      imdbId: imdbId == null && nullToAbsent
          ? const Value.absent()
          : Value(imdbId),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      verified: Value(verified),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
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
      physicalFormat: serializer.fromJson<String?>(json['physicalFormat']),
      region: serializer.fromJson<String?>(json['region']),
      imdbId: serializer.fromJson<String?>(json['imdbId']),
      source: serializer.fromJson<String?>(json['source']),
      verified: serializer.fromJson<bool>(json['verified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
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
      'physicalFormat': serializer.toJson<String?>(physicalFormat),
      'region': serializer.toJson<String?>(region),
      'imdbId': serializer.toJson<String?>(imdbId),
      'source': serializer.toJson<String?>(source),
      'verified': serializer.toJson<bool>(verified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
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
    Value<String?> physicalFormat = const Value.absent(),
    Value<String?> region = const Value.absent(),
    Value<String?> imdbId = const Value.absent(),
    Value<String?> source = const Value.absent(),
    bool? verified,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
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
    physicalFormat: physicalFormat.present
        ? physicalFormat.value
        : this.physicalFormat,
    region: region.present ? region.value : this.region,
    imdbId: imdbId.present ? imdbId.value : this.imdbId,
    source: source.present ? source.value : this.source,
    verified: verified ?? this.verified,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
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
      physicalFormat: data.physicalFormat.present
          ? data.physicalFormat.value
          : this.physicalFormat,
      region: data.region.present ? data.region.value : this.region,
      imdbId: data.imdbId.present ? data.imdbId.value : this.imdbId,
      source: data.source.present ? data.source.value : this.source,
      verified: data.verified.present ? data.verified.value : this.verified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
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
          ..write('physicalFormat: $physicalFormat, ')
          ..write('region: $region, ')
          ..write('imdbId: $imdbId, ')
          ..write('source: $source, ')
          ..write('verified: $verified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
    physicalFormat,
    region,
    imdbId,
    source,
    verified,
    createdAt,
    updatedAt,
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
          other.physicalFormat == this.physicalFormat &&
          other.region == this.region &&
          other.imdbId == this.imdbId &&
          other.source == this.source &&
          other.verified == this.verified &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BarcodesCompanion extends UpdateCompanion<BarcodeRow> {
  final Value<int> id;
  final Value<int?> movieId;
  final Value<int?> physicalEditionId;
  final Value<String> barcode;
  final Value<String> barcodeType;
  final Value<String?> productTitle;
  final Value<String?> editionName;
  final Value<String?> physicalFormat;
  final Value<String?> region;
  final Value<String?> imdbId;
  final Value<String?> source;
  final Value<bool> verified;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const BarcodesCompanion({
    this.id = const Value.absent(),
    this.movieId = const Value.absent(),
    this.physicalEditionId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.barcodeType = const Value.absent(),
    this.productTitle = const Value.absent(),
    this.editionName = const Value.absent(),
    this.physicalFormat = const Value.absent(),
    this.region = const Value.absent(),
    this.imdbId = const Value.absent(),
    this.source = const Value.absent(),
    this.verified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BarcodesCompanion.insert({
    this.id = const Value.absent(),
    this.movieId = const Value.absent(),
    this.physicalEditionId = const Value.absent(),
    required String barcode,
    required String barcodeType,
    this.productTitle = const Value.absent(),
    this.editionName = const Value.absent(),
    this.physicalFormat = const Value.absent(),
    this.region = const Value.absent(),
    this.imdbId = const Value.absent(),
    this.source = const Value.absent(),
    this.verified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
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
    Expression<String>? physicalFormat,
    Expression<String>? region,
    Expression<String>? imdbId,
    Expression<String>? source,
    Expression<bool>? verified,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (movieId != null) 'movie_id': movieId,
      if (physicalEditionId != null) 'physical_edition_id': physicalEditionId,
      if (barcode != null) 'barcode': barcode,
      if (barcodeType != null) 'barcode_type': barcodeType,
      if (productTitle != null) 'product_title': productTitle,
      if (editionName != null) 'edition_name': editionName,
      if (physicalFormat != null) 'physical_format': physicalFormat,
      if (region != null) 'region': region,
      if (imdbId != null) 'imdb_id': imdbId,
      if (source != null) 'source': source,
      if (verified != null) 'verified': verified,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
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
    Value<String?>? physicalFormat,
    Value<String?>? region,
    Value<String?>? imdbId,
    Value<String?>? source,
    Value<bool>? verified,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return BarcodesCompanion(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      physicalEditionId: physicalEditionId ?? this.physicalEditionId,
      barcode: barcode ?? this.barcode,
      barcodeType: barcodeType ?? this.barcodeType,
      productTitle: productTitle ?? this.productTitle,
      editionName: editionName ?? this.editionName,
      physicalFormat: physicalFormat ?? this.physicalFormat,
      region: region ?? this.region,
      imdbId: imdbId ?? this.imdbId,
      source: source ?? this.source,
      verified: verified ?? this.verified,
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
    if (physicalFormat.present) {
      map['physical_format'] = Variable<String>(physicalFormat.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (imdbId.present) {
      map['imdb_id'] = Variable<String>(imdbId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (verified.present) {
      map['verified'] = Variable<bool>(verified.value);
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
    return (StringBuffer('BarcodesCompanion(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('physicalEditionId: $physicalEditionId, ')
          ..write('barcode: $barcode, ')
          ..write('barcodeType: $barcodeType, ')
          ..write('productTitle: $productTitle, ')
          ..write('editionName: $editionName, ')
          ..write('physicalFormat: $physicalFormat, ')
          ..write('region: $region, ')
          ..write('imdbId: $imdbId, ')
          ..write('source: $source, ')
          ..write('verified: $verified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BarcodeLookupCacheTable extends BarcodeLookupCache
    with TableInfo<$BarcodeLookupCacheTable, BarcodeLookupCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BarcodeLookupCacheTable(this.attachedDatabase, [this._alias]);
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
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    barcode,
    provider,
    outcome,
    payload,
    fetchedAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'barcode_lookup_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<BarcodeLookupCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {barcode, provider},
  ];
  @override
  BarcodeLookupCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BarcodeLookupCacheRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
    );
  }

  @override
  $BarcodeLookupCacheTable createAlias(String alias) {
    return $BarcodeLookupCacheTable(attachedDatabase, alias);
  }
}

class BarcodeLookupCacheRow extends DataClass
    implements Insertable<BarcodeLookupCacheRow> {
  final int id;
  final String barcode;
  final String provider;
  final String outcome;
  final String? payload;
  final DateTime fetchedAt;
  final DateTime expiresAt;
  const BarcodeLookupCacheRow({
    required this.id,
    required this.barcode,
    required this.provider,
    required this.outcome,
    this.payload,
    required this.fetchedAt,
    required this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['barcode'] = Variable<String>(barcode);
    map['provider'] = Variable<String>(provider);
    map['outcome'] = Variable<String>(outcome);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  BarcodeLookupCacheCompanion toCompanion(bool nullToAbsent) {
    return BarcodeLookupCacheCompanion(
      id: Value(id),
      barcode: Value(barcode),
      provider: Value(provider),
      outcome: Value(outcome),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      fetchedAt: Value(fetchedAt),
      expiresAt: Value(expiresAt),
    );
  }

  factory BarcodeLookupCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BarcodeLookupCacheRow(
      id: serializer.fromJson<int>(json['id']),
      barcode: serializer.fromJson<String>(json['barcode']),
      provider: serializer.fromJson<String>(json['provider']),
      outcome: serializer.fromJson<String>(json['outcome']),
      payload: serializer.fromJson<String?>(json['payload']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'barcode': serializer.toJson<String>(barcode),
      'provider': serializer.toJson<String>(provider),
      'outcome': serializer.toJson<String>(outcome),
      'payload': serializer.toJson<String?>(payload),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  BarcodeLookupCacheRow copyWith({
    int? id,
    String? barcode,
    String? provider,
    String? outcome,
    Value<String?> payload = const Value.absent(),
    DateTime? fetchedAt,
    DateTime? expiresAt,
  }) => BarcodeLookupCacheRow(
    id: id ?? this.id,
    barcode: barcode ?? this.barcode,
    provider: provider ?? this.provider,
    outcome: outcome ?? this.outcome,
    payload: payload.present ? payload.value : this.payload,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  BarcodeLookupCacheRow copyWithCompanion(BarcodeLookupCacheCompanion data) {
    return BarcodeLookupCacheRow(
      id: data.id.present ? data.id.value : this.id,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      provider: data.provider.present ? data.provider.value : this.provider,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      payload: data.payload.present ? data.payload.value : this.payload,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeLookupCacheRow(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('provider: $provider, ')
          ..write('outcome: $outcome, ')
          ..write('payload: $payload, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    barcode,
    provider,
    outcome,
    payload,
    fetchedAt,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BarcodeLookupCacheRow &&
          other.id == this.id &&
          other.barcode == this.barcode &&
          other.provider == this.provider &&
          other.outcome == this.outcome &&
          other.payload == this.payload &&
          other.fetchedAt == this.fetchedAt &&
          other.expiresAt == this.expiresAt);
}

class BarcodeLookupCacheCompanion
    extends UpdateCompanion<BarcodeLookupCacheRow> {
  final Value<int> id;
  final Value<String> barcode;
  final Value<String> provider;
  final Value<String> outcome;
  final Value<String?> payload;
  final Value<DateTime> fetchedAt;
  final Value<DateTime> expiresAt;
  const BarcodeLookupCacheCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.provider = const Value.absent(),
    this.outcome = const Value.absent(),
    this.payload = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });
  BarcodeLookupCacheCompanion.insert({
    this.id = const Value.absent(),
    required String barcode,
    required String provider,
    required String outcome,
    this.payload = const Value.absent(),
    required DateTime fetchedAt,
    required DateTime expiresAt,
  }) : barcode = Value(barcode),
       provider = Value(provider),
       outcome = Value(outcome),
       fetchedAt = Value(fetchedAt),
       expiresAt = Value(expiresAt);
  static Insertable<BarcodeLookupCacheRow> custom({
    Expression<int>? id,
    Expression<String>? barcode,
    Expression<String>? provider,
    Expression<String>? outcome,
    Expression<String>? payload,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? expiresAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (provider != null) 'provider': provider,
      if (outcome != null) 'outcome': outcome,
      if (payload != null) 'payload': payload,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
    });
  }

  BarcodeLookupCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? barcode,
    Value<String>? provider,
    Value<String>? outcome,
    Value<String?>? payload,
    Value<DateTime>? fetchedAt,
    Value<DateTime>? expiresAt,
  }) {
    return BarcodeLookupCacheCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      provider: provider ?? this.provider,
      outcome: outcome ?? this.outcome,
      payload: payload ?? this.payload,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeLookupCacheCompanion(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('provider: $provider, ')
          ..write('outcome: $outcome, ')
          ..write('payload: $payload, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('expiresAt: $expiresAt')
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

  /// Derived from copies and personal state by OwnershipService. Do not write directly.
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

class $OwnedCopiesTable extends OwnedCopies
    with TableInfo<$OwnedCopiesTable, OwnedCopyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnedCopiesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: SyncIds.random,
  );
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
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
    'purchase_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storageLocationMeta = const VerificationMeta(
    'storageLocation',
  );
  @override
  late final GeneratedColumn<String> storageLocation = GeneratedColumn<String>(
    'storage_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    editionId,
    quantity,
    condition,
    purchaseDate,
    purchasePrice,
    storageLocation,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owned_copies';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnedCopyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_editionIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('storage_location')) {
      context.handle(
        _storageLocationMeta,
        storageLocation.isAcceptableOrUnknown(
          data['storage_location']!,
          _storageLocationMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
  OwnedCopyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnedCopyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}edition_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      ),
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_price'],
      ),
      storageLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_location'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
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
  $OwnedCopiesTable createAlias(String alias) {
    return $OwnedCopiesTable(attachedDatabase, alias);
  }
}

class OwnedCopyRow extends DataClass implements Insertable<OwnedCopyRow> {
  final int id;
  final String uuid;
  final int editionId;
  final int quantity;
  final String? condition;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String? storageLocation;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OwnedCopyRow({
    required this.id,
    required this.uuid,
    required this.editionId,
    required this.quantity,
    this.condition,
    this.purchaseDate,
    this.purchasePrice,
    this.storageLocation,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['edition_id'] = Variable<int>(editionId);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || condition != null) {
      map['condition'] = Variable<String>(condition);
    }
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<double>(purchasePrice);
    }
    if (!nullToAbsent || storageLocation != null) {
      map['storage_location'] = Variable<String>(storageLocation);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OwnedCopiesCompanion toCompanion(bool nullToAbsent) {
    return OwnedCopiesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      editionId: Value(editionId),
      quantity: Value(quantity),
      condition: condition == null && nullToAbsent
          ? const Value.absent()
          : Value(condition),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      storageLocation: storageLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(storageLocation),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OwnedCopyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnedCopyRow(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      editionId: serializer.fromJson<int>(json['editionId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      condition: serializer.fromJson<String?>(json['condition']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      purchasePrice: serializer.fromJson<double?>(json['purchasePrice']),
      storageLocation: serializer.fromJson<String?>(json['storageLocation']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'editionId': serializer.toJson<int>(editionId),
      'quantity': serializer.toJson<int>(quantity),
      'condition': serializer.toJson<String?>(condition),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'purchasePrice': serializer.toJson<double?>(purchasePrice),
      'storageLocation': serializer.toJson<String?>(storageLocation),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OwnedCopyRow copyWith({
    int? id,
    String? uuid,
    int? editionId,
    int? quantity,
    Value<String?> condition = const Value.absent(),
    Value<DateTime?> purchaseDate = const Value.absent(),
    Value<double?> purchasePrice = const Value.absent(),
    Value<String?> storageLocation = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OwnedCopyRow(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    editionId: editionId ?? this.editionId,
    quantity: quantity ?? this.quantity,
    condition: condition.present ? condition.value : this.condition,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    purchasePrice: purchasePrice.present
        ? purchasePrice.value
        : this.purchasePrice,
    storageLocation: storageLocation.present
        ? storageLocation.value
        : this.storageLocation,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OwnedCopyRow copyWithCompanion(OwnedCopiesCompanion data) {
    return OwnedCopyRow(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      condition: data.condition.present ? data.condition.value : this.condition,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      storageLocation: data.storageLocation.present
          ? data.storageLocation.value
          : this.storageLocation,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnedCopyRow(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('editionId: $editionId, ')
          ..write('quantity: $quantity, ')
          ..write('condition: $condition, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('storageLocation: $storageLocation, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    editionId,
    quantity,
    condition,
    purchaseDate,
    purchasePrice,
    storageLocation,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnedCopyRow &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.editionId == this.editionId &&
          other.quantity == this.quantity &&
          other.condition == this.condition &&
          other.purchaseDate == this.purchaseDate &&
          other.purchasePrice == this.purchasePrice &&
          other.storageLocation == this.storageLocation &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OwnedCopiesCompanion extends UpdateCompanion<OwnedCopyRow> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> editionId;
  final Value<int> quantity;
  final Value<String?> condition;
  final Value<DateTime?> purchaseDate;
  final Value<double?> purchasePrice;
  final Value<String?> storageLocation;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const OwnedCopiesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.editionId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.condition = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.storageLocation = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OwnedCopiesCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required int editionId,
    this.quantity = const Value.absent(),
    this.condition = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.storageLocation = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : editionId = Value(editionId);
  static Insertable<OwnedCopyRow> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? editionId,
    Expression<int>? quantity,
    Expression<String>? condition,
    Expression<DateTime>? purchaseDate,
    Expression<double>? purchasePrice,
    Expression<String>? storageLocation,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (editionId != null) 'edition_id': editionId,
      if (quantity != null) 'quantity': quantity,
      if (condition != null) 'condition': condition,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (storageLocation != null) 'storage_location': storageLocation,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OwnedCopiesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? editionId,
    Value<int>? quantity,
    Value<String?>? condition,
    Value<DateTime?>? purchaseDate,
    Value<double?>? purchasePrice,
    Value<String?>? storageLocation,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return OwnedCopiesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      editionId: editionId ?? this.editionId,
      quantity: quantity ?? this.quantity,
      condition: condition ?? this.condition,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      storageLocation: storageLocation ?? this.storageLocation,
      notes: notes ?? this.notes,
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
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (editionId.present) {
      map['edition_id'] = Variable<int>(editionId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (storageLocation.present) {
      map['storage_location'] = Variable<String>(storageLocation.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('OwnedCopiesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('editionId: $editionId, ')
          ..write('quantity: $quantity, ')
          ..write('condition: $condition, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('storageLocation: $storageLocation, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PersonalStatesTable extends PersonalStates
    with TableInfo<$PersonalStatesTable, PersonalStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalStatesTable(this.attachedDatabase, [this._alias]);
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
      'UNIQUE REFERENCES movies (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<int> seriesId = GeneratedColumn<int>(
    'series_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES tv_series (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
    'season_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES tv_seasons (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _onWishlistMeta = const VerificationMeta(
    'onWishlist',
  );
  @override
  late final GeneratedColumn<bool> onWishlist = GeneratedColumn<bool>(
    'on_wishlist',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("on_wishlist" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _maxPriceMeta = const VerificationMeta(
    'maxPrice',
  );
  @override
  late final GeneratedColumn<double> maxPrice = GeneratedColumn<double>(
    'max_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _watchStatusMeta = const VerificationMeta(
    'watchStatus',
  );
  @override
  late final GeneratedColumn<String> watchStatus = GeneratedColumn<String>(
    'watch_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _watchCountMeta = const VerificationMeta(
    'watchCount',
  );
  @override
  late final GeneratedColumn<int> watchCount = GeneratedColumn<int>(
    'watch_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastWatchedAtMeta = const VerificationMeta(
    'lastWatchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastWatchedAt =
      GeneratedColumn<DateTime>(
        'last_watched_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favouriteMeta = const VerificationMeta(
    'favourite',
  );
  @override
  late final GeneratedColumn<bool> favourite = GeneratedColumn<bool>(
    'favourite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favourite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredEditionUuidMeta =
      const VerificationMeta('preferredEditionUuid');
  @override
  late final GeneratedColumn<String> preferredEditionUuid =
      GeneratedColumn<String>(
        'preferred_edition_uuid',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
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
    movieId,
    seriesId,
    seasonId,
    onWishlist,
    maxPrice,
    watchStatus,
    watchCount,
    lastWatchedAt,
    rating,
    favourite,
    tags,
    preferredEditionUuid,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalStateRow> instance, {
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
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    }
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    }
    if (data.containsKey('on_wishlist')) {
      context.handle(
        _onWishlistMeta,
        onWishlist.isAcceptableOrUnknown(data['on_wishlist']!, _onWishlistMeta),
      );
    }
    if (data.containsKey('max_price')) {
      context.handle(
        _maxPriceMeta,
        maxPrice.isAcceptableOrUnknown(data['max_price']!, _maxPriceMeta),
      );
    }
    if (data.containsKey('watch_status')) {
      context.handle(
        _watchStatusMeta,
        watchStatus.isAcceptableOrUnknown(
          data['watch_status']!,
          _watchStatusMeta,
        ),
      );
    }
    if (data.containsKey('watch_count')) {
      context.handle(
        _watchCountMeta,
        watchCount.isAcceptableOrUnknown(data['watch_count']!, _watchCountMeta),
      );
    }
    if (data.containsKey('last_watched_at')) {
      context.handle(
        _lastWatchedAtMeta,
        lastWatchedAt.isAcceptableOrUnknown(
          data['last_watched_at']!,
          _lastWatchedAtMeta,
        ),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('favourite')) {
      context.handle(
        _favouriteMeta,
        favourite.isAcceptableOrUnknown(data['favourite']!, _favouriteMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('preferred_edition_uuid')) {
      context.handle(
        _preferredEditionUuidMeta,
        preferredEditionUuid.isAcceptableOrUnknown(
          data['preferred_edition_uuid']!,
          _preferredEditionUuidMeta,
        ),
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
  PersonalStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      ),
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series_id'],
      ),
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_id'],
      ),
      onWishlist: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}on_wishlist'],
      )!,
      maxPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_price'],
      ),
      watchStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}watch_status'],
      ),
      watchCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}watch_count'],
      )!,
      lastWatchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_watched_at'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      favourite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favourite'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      preferredEditionUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_edition_uuid'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PersonalStatesTable createAlias(String alias) {
    return $PersonalStatesTable(attachedDatabase, alias);
  }
}

class PersonalStateRow extends DataClass
    implements Insertable<PersonalStateRow> {
  final int id;
  final int? movieId;
  final int? seriesId;
  final int? seasonId;
  final bool onWishlist;
  final double? maxPrice;

  /// unwatched, watching or watched.
  final String? watchStatus;
  final int watchCount;
  final DateTime? lastWatchedAt;

  /// 1 to 10.
  final int? rating;
  final bool favourite;
  final String? tags;
  final String? preferredEditionUuid;
  final DateTime updatedAt;
  const PersonalStateRow({
    required this.id,
    this.movieId,
    this.seriesId,
    this.seasonId,
    required this.onWishlist,
    this.maxPrice,
    this.watchStatus,
    required this.watchCount,
    this.lastWatchedAt,
    this.rating,
    required this.favourite,
    this.tags,
    this.preferredEditionUuid,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || movieId != null) {
      map['movie_id'] = Variable<int>(movieId);
    }
    if (!nullToAbsent || seriesId != null) {
      map['series_id'] = Variable<int>(seriesId);
    }
    if (!nullToAbsent || seasonId != null) {
      map['season_id'] = Variable<int>(seasonId);
    }
    map['on_wishlist'] = Variable<bool>(onWishlist);
    if (!nullToAbsent || maxPrice != null) {
      map['max_price'] = Variable<double>(maxPrice);
    }
    if (!nullToAbsent || watchStatus != null) {
      map['watch_status'] = Variable<String>(watchStatus);
    }
    map['watch_count'] = Variable<int>(watchCount);
    if (!nullToAbsent || lastWatchedAt != null) {
      map['last_watched_at'] = Variable<DateTime>(lastWatchedAt);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    map['favourite'] = Variable<bool>(favourite);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || preferredEditionUuid != null) {
      map['preferred_edition_uuid'] = Variable<String>(preferredEditionUuid);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PersonalStatesCompanion toCompanion(bool nullToAbsent) {
    return PersonalStatesCompanion(
      id: Value(id),
      movieId: movieId == null && nullToAbsent
          ? const Value.absent()
          : Value(movieId),
      seriesId: seriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesId),
      seasonId: seasonId == null && nullToAbsent
          ? const Value.absent()
          : Value(seasonId),
      onWishlist: Value(onWishlist),
      maxPrice: maxPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPrice),
      watchStatus: watchStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(watchStatus),
      watchCount: Value(watchCount),
      lastWatchedAt: lastWatchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastWatchedAt),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      favourite: Value(favourite),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      preferredEditionUuid: preferredEditionUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredEditionUuid),
      updatedAt: Value(updatedAt),
    );
  }

  factory PersonalStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalStateRow(
      id: serializer.fromJson<int>(json['id']),
      movieId: serializer.fromJson<int?>(json['movieId']),
      seriesId: serializer.fromJson<int?>(json['seriesId']),
      seasonId: serializer.fromJson<int?>(json['seasonId']),
      onWishlist: serializer.fromJson<bool>(json['onWishlist']),
      maxPrice: serializer.fromJson<double?>(json['maxPrice']),
      watchStatus: serializer.fromJson<String?>(json['watchStatus']),
      watchCount: serializer.fromJson<int>(json['watchCount']),
      lastWatchedAt: serializer.fromJson<DateTime?>(json['lastWatchedAt']),
      rating: serializer.fromJson<int?>(json['rating']),
      favourite: serializer.fromJson<bool>(json['favourite']),
      tags: serializer.fromJson<String?>(json['tags']),
      preferredEditionUuid: serializer.fromJson<String?>(
        json['preferredEditionUuid'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'movieId': serializer.toJson<int?>(movieId),
      'seriesId': serializer.toJson<int?>(seriesId),
      'seasonId': serializer.toJson<int?>(seasonId),
      'onWishlist': serializer.toJson<bool>(onWishlist),
      'maxPrice': serializer.toJson<double?>(maxPrice),
      'watchStatus': serializer.toJson<String?>(watchStatus),
      'watchCount': serializer.toJson<int>(watchCount),
      'lastWatchedAt': serializer.toJson<DateTime?>(lastWatchedAt),
      'rating': serializer.toJson<int?>(rating),
      'favourite': serializer.toJson<bool>(favourite),
      'tags': serializer.toJson<String?>(tags),
      'preferredEditionUuid': serializer.toJson<String?>(preferredEditionUuid),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PersonalStateRow copyWith({
    int? id,
    Value<int?> movieId = const Value.absent(),
    Value<int?> seriesId = const Value.absent(),
    Value<int?> seasonId = const Value.absent(),
    bool? onWishlist,
    Value<double?> maxPrice = const Value.absent(),
    Value<String?> watchStatus = const Value.absent(),
    int? watchCount,
    Value<DateTime?> lastWatchedAt = const Value.absent(),
    Value<int?> rating = const Value.absent(),
    bool? favourite,
    Value<String?> tags = const Value.absent(),
    Value<String?> preferredEditionUuid = const Value.absent(),
    DateTime? updatedAt,
  }) => PersonalStateRow(
    id: id ?? this.id,
    movieId: movieId.present ? movieId.value : this.movieId,
    seriesId: seriesId.present ? seriesId.value : this.seriesId,
    seasonId: seasonId.present ? seasonId.value : this.seasonId,
    onWishlist: onWishlist ?? this.onWishlist,
    maxPrice: maxPrice.present ? maxPrice.value : this.maxPrice,
    watchStatus: watchStatus.present ? watchStatus.value : this.watchStatus,
    watchCount: watchCount ?? this.watchCount,
    lastWatchedAt: lastWatchedAt.present
        ? lastWatchedAt.value
        : this.lastWatchedAt,
    rating: rating.present ? rating.value : this.rating,
    favourite: favourite ?? this.favourite,
    tags: tags.present ? tags.value : this.tags,
    preferredEditionUuid: preferredEditionUuid.present
        ? preferredEditionUuid.value
        : this.preferredEditionUuid,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PersonalStateRow copyWithCompanion(PersonalStatesCompanion data) {
    return PersonalStateRow(
      id: data.id.present ? data.id.value : this.id,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      onWishlist: data.onWishlist.present
          ? data.onWishlist.value
          : this.onWishlist,
      maxPrice: data.maxPrice.present ? data.maxPrice.value : this.maxPrice,
      watchStatus: data.watchStatus.present
          ? data.watchStatus.value
          : this.watchStatus,
      watchCount: data.watchCount.present
          ? data.watchCount.value
          : this.watchCount,
      lastWatchedAt: data.lastWatchedAt.present
          ? data.lastWatchedAt.value
          : this.lastWatchedAt,
      rating: data.rating.present ? data.rating.value : this.rating,
      favourite: data.favourite.present ? data.favourite.value : this.favourite,
      tags: data.tags.present ? data.tags.value : this.tags,
      preferredEditionUuid: data.preferredEditionUuid.present
          ? data.preferredEditionUuid.value
          : this.preferredEditionUuid,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalStateRow(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('seriesId: $seriesId, ')
          ..write('seasonId: $seasonId, ')
          ..write('onWishlist: $onWishlist, ')
          ..write('maxPrice: $maxPrice, ')
          ..write('watchStatus: $watchStatus, ')
          ..write('watchCount: $watchCount, ')
          ..write('lastWatchedAt: $lastWatchedAt, ')
          ..write('rating: $rating, ')
          ..write('favourite: $favourite, ')
          ..write('tags: $tags, ')
          ..write('preferredEditionUuid: $preferredEditionUuid, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    movieId,
    seriesId,
    seasonId,
    onWishlist,
    maxPrice,
    watchStatus,
    watchCount,
    lastWatchedAt,
    rating,
    favourite,
    tags,
    preferredEditionUuid,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalStateRow &&
          other.id == this.id &&
          other.movieId == this.movieId &&
          other.seriesId == this.seriesId &&
          other.seasonId == this.seasonId &&
          other.onWishlist == this.onWishlist &&
          other.maxPrice == this.maxPrice &&
          other.watchStatus == this.watchStatus &&
          other.watchCount == this.watchCount &&
          other.lastWatchedAt == this.lastWatchedAt &&
          other.rating == this.rating &&
          other.favourite == this.favourite &&
          other.tags == this.tags &&
          other.preferredEditionUuid == this.preferredEditionUuid &&
          other.updatedAt == this.updatedAt);
}

class PersonalStatesCompanion extends UpdateCompanion<PersonalStateRow> {
  final Value<int> id;
  final Value<int?> movieId;
  final Value<int?> seriesId;
  final Value<int?> seasonId;
  final Value<bool> onWishlist;
  final Value<double?> maxPrice;
  final Value<String?> watchStatus;
  final Value<int> watchCount;
  final Value<DateTime?> lastWatchedAt;
  final Value<int?> rating;
  final Value<bool> favourite;
  final Value<String?> tags;
  final Value<String?> preferredEditionUuid;
  final Value<DateTime> updatedAt;
  const PersonalStatesCompanion({
    this.id = const Value.absent(),
    this.movieId = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.onWishlist = const Value.absent(),
    this.maxPrice = const Value.absent(),
    this.watchStatus = const Value.absent(),
    this.watchCount = const Value.absent(),
    this.lastWatchedAt = const Value.absent(),
    this.rating = const Value.absent(),
    this.favourite = const Value.absent(),
    this.tags = const Value.absent(),
    this.preferredEditionUuid = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PersonalStatesCompanion.insert({
    this.id = const Value.absent(),
    this.movieId = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.onWishlist = const Value.absent(),
    this.maxPrice = const Value.absent(),
    this.watchStatus = const Value.absent(),
    this.watchCount = const Value.absent(),
    this.lastWatchedAt = const Value.absent(),
    this.rating = const Value.absent(),
    this.favourite = const Value.absent(),
    this.tags = const Value.absent(),
    this.preferredEditionUuid = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<PersonalStateRow> custom({
    Expression<int>? id,
    Expression<int>? movieId,
    Expression<int>? seriesId,
    Expression<int>? seasonId,
    Expression<bool>? onWishlist,
    Expression<double>? maxPrice,
    Expression<String>? watchStatus,
    Expression<int>? watchCount,
    Expression<DateTime>? lastWatchedAt,
    Expression<int>? rating,
    Expression<bool>? favourite,
    Expression<String>? tags,
    Expression<String>? preferredEditionUuid,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (movieId != null) 'movie_id': movieId,
      if (seriesId != null) 'series_id': seriesId,
      if (seasonId != null) 'season_id': seasonId,
      if (onWishlist != null) 'on_wishlist': onWishlist,
      if (maxPrice != null) 'max_price': maxPrice,
      if (watchStatus != null) 'watch_status': watchStatus,
      if (watchCount != null) 'watch_count': watchCount,
      if (lastWatchedAt != null) 'last_watched_at': lastWatchedAt,
      if (rating != null) 'rating': rating,
      if (favourite != null) 'favourite': favourite,
      if (tags != null) 'tags': tags,
      if (preferredEditionUuid != null)
        'preferred_edition_uuid': preferredEditionUuid,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PersonalStatesCompanion copyWith({
    Value<int>? id,
    Value<int?>? movieId,
    Value<int?>? seriesId,
    Value<int?>? seasonId,
    Value<bool>? onWishlist,
    Value<double?>? maxPrice,
    Value<String?>? watchStatus,
    Value<int>? watchCount,
    Value<DateTime?>? lastWatchedAt,
    Value<int?>? rating,
    Value<bool>? favourite,
    Value<String?>? tags,
    Value<String?>? preferredEditionUuid,
    Value<DateTime>? updatedAt,
  }) {
    return PersonalStatesCompanion(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      seriesId: seriesId ?? this.seriesId,
      seasonId: seasonId ?? this.seasonId,
      onWishlist: onWishlist ?? this.onWishlist,
      maxPrice: maxPrice ?? this.maxPrice,
      watchStatus: watchStatus ?? this.watchStatus,
      watchCount: watchCount ?? this.watchCount,
      lastWatchedAt: lastWatchedAt ?? this.lastWatchedAt,
      rating: rating ?? this.rating,
      favourite: favourite ?? this.favourite,
      tags: tags ?? this.tags,
      preferredEditionUuid: preferredEditionUuid ?? this.preferredEditionUuid,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (seriesId.present) {
      map['series_id'] = Variable<int>(seriesId.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (onWishlist.present) {
      map['on_wishlist'] = Variable<bool>(onWishlist.value);
    }
    if (maxPrice.present) {
      map['max_price'] = Variable<double>(maxPrice.value);
    }
    if (watchStatus.present) {
      map['watch_status'] = Variable<String>(watchStatus.value);
    }
    if (watchCount.present) {
      map['watch_count'] = Variable<int>(watchCount.value);
    }
    if (lastWatchedAt.present) {
      map['last_watched_at'] = Variable<DateTime>(lastWatchedAt.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (favourite.present) {
      map['favourite'] = Variable<bool>(favourite.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (preferredEditionUuid.present) {
      map['preferred_edition_uuid'] = Variable<String>(
        preferredEditionUuid.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalStatesCompanion(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('seriesId: $seriesId, ')
          ..write('seasonId: $seasonId, ')
          ..write('onWishlist: $onWishlist, ')
          ..write('maxPrice: $maxPrice, ')
          ..write('watchStatus: $watchStatus, ')
          ..write('watchCount: $watchCount, ')
          ..write('lastWatchedAt: $lastWatchedAt, ')
          ..write('rating: $rating, ')
          ..write('favourite: $favourite, ')
          ..write('tags: $tags, ')
          ..write('preferredEditionUuid: $preferredEditionUuid, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SyncShadowTable extends SyncShadow
    with TableInfo<$SyncShadowTable, SyncShadowRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncShadowTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseSeqMeta = const VerificationMeta(
    'baseSeq',
  );
  @override
  late final GeneratedColumn<int> baseSeq = GeneratedColumn<int>(
    'base_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldsJsonMeta = const VerificationMeta(
    'fieldsJson',
  );
  @override
  late final GeneratedColumn<String> fieldsJson = GeneratedColumn<String>(
    'fields_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [uuid, entityType, baseSeq, fieldsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_shadow';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncShadowRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('base_seq')) {
      context.handle(
        _baseSeqMeta,
        baseSeq.isAcceptableOrUnknown(data['base_seq']!, _baseSeqMeta),
      );
    } else if (isInserting) {
      context.missing(_baseSeqMeta);
    }
    if (data.containsKey('fields_json')) {
      context.handle(
        _fieldsJsonMeta,
        fieldsJson.isAcceptableOrUnknown(data['fields_json']!, _fieldsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  SyncShadowRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncShadowRow(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      baseSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_seq'],
      )!,
      fieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fields_json'],
      )!,
    );
  }

  @override
  $SyncShadowTable createAlias(String alias) {
    return $SyncShadowTable(attachedDatabase, alias);
  }
}

class SyncShadowRow extends DataClass implements Insertable<SyncShadowRow> {
  final String uuid;
  final String entityType;
  final int baseSeq;
  final String fieldsJson;
  const SyncShadowRow({
    required this.uuid,
    required this.entityType,
    required this.baseSeq,
    required this.fieldsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['entity_type'] = Variable<String>(entityType);
    map['base_seq'] = Variable<int>(baseSeq);
    map['fields_json'] = Variable<String>(fieldsJson);
    return map;
  }

  SyncShadowCompanion toCompanion(bool nullToAbsent) {
    return SyncShadowCompanion(
      uuid: Value(uuid),
      entityType: Value(entityType),
      baseSeq: Value(baseSeq),
      fieldsJson: Value(fieldsJson),
    );
  }

  factory SyncShadowRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncShadowRow(
      uuid: serializer.fromJson<String>(json['uuid']),
      entityType: serializer.fromJson<String>(json['entityType']),
      baseSeq: serializer.fromJson<int>(json['baseSeq']),
      fieldsJson: serializer.fromJson<String>(json['fieldsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'entityType': serializer.toJson<String>(entityType),
      'baseSeq': serializer.toJson<int>(baseSeq),
      'fieldsJson': serializer.toJson<String>(fieldsJson),
    };
  }

  SyncShadowRow copyWith({
    String? uuid,
    String? entityType,
    int? baseSeq,
    String? fieldsJson,
  }) => SyncShadowRow(
    uuid: uuid ?? this.uuid,
    entityType: entityType ?? this.entityType,
    baseSeq: baseSeq ?? this.baseSeq,
    fieldsJson: fieldsJson ?? this.fieldsJson,
  );
  SyncShadowRow copyWithCompanion(SyncShadowCompanion data) {
    return SyncShadowRow(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      baseSeq: data.baseSeq.present ? data.baseSeq.value : this.baseSeq,
      fieldsJson: data.fieldsJson.present
          ? data.fieldsJson.value
          : this.fieldsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncShadowRow(')
          ..write('uuid: $uuid, ')
          ..write('entityType: $entityType, ')
          ..write('baseSeq: $baseSeq, ')
          ..write('fieldsJson: $fieldsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uuid, entityType, baseSeq, fieldsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncShadowRow &&
          other.uuid == this.uuid &&
          other.entityType == this.entityType &&
          other.baseSeq == this.baseSeq &&
          other.fieldsJson == this.fieldsJson);
}

class SyncShadowCompanion extends UpdateCompanion<SyncShadowRow> {
  final Value<String> uuid;
  final Value<String> entityType;
  final Value<int> baseSeq;
  final Value<String> fieldsJson;
  final Value<int> rowid;
  const SyncShadowCompanion({
    this.uuid = const Value.absent(),
    this.entityType = const Value.absent(),
    this.baseSeq = const Value.absent(),
    this.fieldsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncShadowCompanion.insert({
    required String uuid,
    required String entityType,
    required int baseSeq,
    required String fieldsJson,
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       entityType = Value(entityType),
       baseSeq = Value(baseSeq),
       fieldsJson = Value(fieldsJson);
  static Insertable<SyncShadowRow> custom({
    Expression<String>? uuid,
    Expression<String>? entityType,
    Expression<int>? baseSeq,
    Expression<String>? fieldsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (entityType != null) 'entity_type': entityType,
      if (baseSeq != null) 'base_seq': baseSeq,
      if (fieldsJson != null) 'fields_json': fieldsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncShadowCompanion copyWith({
    Value<String>? uuid,
    Value<String>? entityType,
    Value<int>? baseSeq,
    Value<String>? fieldsJson,
    Value<int>? rowid,
  }) {
    return SyncShadowCompanion(
      uuid: uuid ?? this.uuid,
      entityType: entityType ?? this.entityType,
      baseSeq: baseSeq ?? this.baseSeq,
      fieldsJson: fieldsJson ?? this.fieldsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (baseSeq.present) {
      map['base_seq'] = Variable<int>(baseSeq.value);
    }
    if (fieldsJson.present) {
      map['fields_json'] = Variable<String>(fieldsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncShadowCompanion(')
          ..write('uuid: $uuid, ')
          ..write('entityType: $entityType, ')
          ..write('baseSeq: $baseSeq, ')
          ..write('fieldsJson: $fieldsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncConflictsTable extends SyncConflicts
    with TableInfo<$SyncConflictsTable, SyncConflictRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncConflictsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityUuidMeta = const VerificationMeta(
    'entityUuid',
  );
  @override
  late final GeneratedColumn<String> entityUuid = GeneratedColumn<String>(
    'entity_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldMeta = const VerificationMeta('field');
  @override
  late final GeneratedColumn<String> field = GeneratedColumn<String>(
    'field',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localJsonMeta = const VerificationMeta(
    'localJson',
  );
  @override
  late final GeneratedColumn<String> localJson = GeneratedColumn<String>(
    'local_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverJsonMeta = const VerificationMeta(
    'serverJson',
  );
  @override
  late final GeneratedColumn<String> serverJson = GeneratedColumn<String>(
    'server_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    entityType,
    entityUuid,
    field,
    localJson,
    serverJson,
    serverSeq,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_conflicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncConflictRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_uuid')) {
      context.handle(
        _entityUuidMeta,
        entityUuid.isAcceptableOrUnknown(data['entity_uuid']!, _entityUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_entityUuidMeta);
    }
    if (data.containsKey('field')) {
      context.handle(
        _fieldMeta,
        field.isAcceptableOrUnknown(data['field']!, _fieldMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldMeta);
    }
    if (data.containsKey('local_json')) {
      context.handle(
        _localJsonMeta,
        localJson.isAcceptableOrUnknown(data['local_json']!, _localJsonMeta),
      );
    }
    if (data.containsKey('server_json')) {
      context.handle(
        _serverJsonMeta,
        serverJson.isAcceptableOrUnknown(data['server_json']!, _serverJsonMeta),
      );
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
      );
    } else if (isInserting) {
      context.missing(_serverSeqMeta);
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {entityUuid, field},
  ];
  @override
  SyncConflictRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncConflictRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_uuid'],
      )!,
      field: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field'],
      )!,
      localJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_json'],
      ),
      serverJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_json'],
      ),
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncConflictsTable createAlias(String alias) {
    return $SyncConflictsTable(attachedDatabase, alias);
  }
}

class SyncConflictRow extends DataClass implements Insertable<SyncConflictRow> {
  final int id;
  final String entityType;
  final String entityUuid;
  final String field;
  final String? localJson;
  final String? serverJson;
  final int serverSeq;
  final DateTime createdAt;
  const SyncConflictRow({
    required this.id,
    required this.entityType,
    required this.entityUuid,
    required this.field,
    this.localJson,
    this.serverJson,
    required this.serverSeq,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_uuid'] = Variable<String>(entityUuid);
    map['field'] = Variable<String>(field);
    if (!nullToAbsent || localJson != null) {
      map['local_json'] = Variable<String>(localJson);
    }
    if (!nullToAbsent || serverJson != null) {
      map['server_json'] = Variable<String>(serverJson);
    }
    map['server_seq'] = Variable<int>(serverSeq);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncConflictsCompanion toCompanion(bool nullToAbsent) {
    return SyncConflictsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityUuid: Value(entityUuid),
      field: Value(field),
      localJson: localJson == null && nullToAbsent
          ? const Value.absent()
          : Value(localJson),
      serverJson: serverJson == null && nullToAbsent
          ? const Value.absent()
          : Value(serverJson),
      serverSeq: Value(serverSeq),
      createdAt: Value(createdAt),
    );
  }

  factory SyncConflictRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncConflictRow(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityUuid: serializer.fromJson<String>(json['entityUuid']),
      field: serializer.fromJson<String>(json['field']),
      localJson: serializer.fromJson<String?>(json['localJson']),
      serverJson: serializer.fromJson<String?>(json['serverJson']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityUuid': serializer.toJson<String>(entityUuid),
      'field': serializer.toJson<String>(field),
      'localJson': serializer.toJson<String?>(localJson),
      'serverJson': serializer.toJson<String?>(serverJson),
      'serverSeq': serializer.toJson<int>(serverSeq),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncConflictRow copyWith({
    int? id,
    String? entityType,
    String? entityUuid,
    String? field,
    Value<String?> localJson = const Value.absent(),
    Value<String?> serverJson = const Value.absent(),
    int? serverSeq,
    DateTime? createdAt,
  }) => SyncConflictRow(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityUuid: entityUuid ?? this.entityUuid,
    field: field ?? this.field,
    localJson: localJson.present ? localJson.value : this.localJson,
    serverJson: serverJson.present ? serverJson.value : this.serverJson,
    serverSeq: serverSeq ?? this.serverSeq,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncConflictRow copyWithCompanion(SyncConflictsCompanion data) {
    return SyncConflictRow(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityUuid: data.entityUuid.present
          ? data.entityUuid.value
          : this.entityUuid,
      field: data.field.present ? data.field.value : this.field,
      localJson: data.localJson.present ? data.localJson.value : this.localJson,
      serverJson: data.serverJson.present
          ? data.serverJson.value
          : this.serverJson,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictRow(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityUuid: $entityUuid, ')
          ..write('field: $field, ')
          ..write('localJson: $localJson, ')
          ..write('serverJson: $serverJson, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityUuid,
    field,
    localJson,
    serverJson,
    serverSeq,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncConflictRow &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityUuid == this.entityUuid &&
          other.field == this.field &&
          other.localJson == this.localJson &&
          other.serverJson == this.serverJson &&
          other.serverSeq == this.serverSeq &&
          other.createdAt == this.createdAt);
}

class SyncConflictsCompanion extends UpdateCompanion<SyncConflictRow> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityUuid;
  final Value<String> field;
  final Value<String?> localJson;
  final Value<String?> serverJson;
  final Value<int> serverSeq;
  final Value<DateTime> createdAt;
  const SyncConflictsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityUuid = const Value.absent(),
    this.field = const Value.absent(),
    this.localJson = const Value.absent(),
    this.serverJson = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncConflictsCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityUuid,
    required String field,
    this.localJson = const Value.absent(),
    this.serverJson = const Value.absent(),
    required int serverSeq,
    this.createdAt = const Value.absent(),
  }) : entityType = Value(entityType),
       entityUuid = Value(entityUuid),
       field = Value(field),
       serverSeq = Value(serverSeq);
  static Insertable<SyncConflictRow> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityUuid,
    Expression<String>? field,
    Expression<String>? localJson,
    Expression<String>? serverJson,
    Expression<int>? serverSeq,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityUuid != null) 'entity_uuid': entityUuid,
      if (field != null) 'field': field,
      if (localJson != null) 'local_json': localJson,
      if (serverJson != null) 'server_json': serverJson,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncConflictsCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<String>? entityUuid,
    Value<String>? field,
    Value<String?>? localJson,
    Value<String?>? serverJson,
    Value<int>? serverSeq,
    Value<DateTime>? createdAt,
  }) {
    return SyncConflictsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityUuid: entityUuid ?? this.entityUuid,
      field: field ?? this.field,
      localJson: localJson ?? this.localJson,
      serverJson: serverJson ?? this.serverJson,
      serverSeq: serverSeq ?? this.serverSeq,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityUuid.present) {
      map['entity_uuid'] = Variable<String>(entityUuid.value);
    }
    if (field.present) {
      map['field'] = Variable<String>(field.value);
    }
    if (localJson.present) {
      map['local_json'] = Variable<String>(localJson.value);
    }
    if (serverJson.present) {
      map['server_json'] = Variable<String>(serverJson.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityUuid: $entityUuid, ')
          ..write('field: $field, ')
          ..write('localJson: $localJson, ')
          ..write('serverJson: $serverJson, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaRow extends DataClass implements Insertable<SyncMetaRow> {
  final String key;
  final String value;
  const SyncMetaRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(key: Value(key), value: Value(value));
  }

  factory SyncMetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncMetaRow copyWith({String? key, String? value}) =>
      SyncMetaRow(key: key ?? this.key, value: value ?? this.value);
  SyncMetaRow copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncMetaRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingScansTable extends PendingScans
    with TableInfo<$PendingScansTable, PendingScanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingScansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _scannedAtMeta = const VerificationMeta(
    'scannedAt',
  );
  @override
  late final GeneratedColumn<DateTime> scannedAt = GeneratedColumn<DateTime>(
    'scanned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    scannedAt,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_scans';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingScanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('scanned_at')) {
      context.handle(
        _scannedAtMeta,
        scannedAt.isAcceptableOrUnknown(data['scanned_at']!, _scannedAtMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingScanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingScanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      scannedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scanned_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $PendingScansTable createAlias(String alias) {
    return $PendingScansTable(attachedDatabase, alias);
  }
}

class PendingScanRow extends DataClass implements Insertable<PendingScanRow> {
  final int id;
  final String code;
  final DateTime scannedAt;
  final int attempts;
  final String? lastError;
  const PendingScanRow({
    required this.id,
    required this.code,
    required this.scannedAt,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['scanned_at'] = Variable<DateTime>(scannedAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  PendingScansCompanion toCompanion(bool nullToAbsent) {
    return PendingScansCompanion(
      id: Value(id),
      code: Value(code),
      scannedAt: Value(scannedAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory PendingScanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingScanRow(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      scannedAt: serializer.fromJson<DateTime>(json['scannedAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'scannedAt': serializer.toJson<DateTime>(scannedAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  PendingScanRow copyWith({
    int? id,
    String? code,
    DateTime? scannedAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => PendingScanRow(
    id: id ?? this.id,
    code: code ?? this.code,
    scannedAt: scannedAt ?? this.scannedAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  PendingScanRow copyWithCompanion(PendingScansCompanion data) {
    return PendingScanRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      scannedAt: data.scannedAt.present ? data.scannedAt.value : this.scannedAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingScanRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('scannedAt: $scannedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, scannedAt, attempts, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingScanRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.scannedAt == this.scannedAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class PendingScansCompanion extends UpdateCompanion<PendingScanRow> {
  final Value<int> id;
  final Value<String> code;
  final Value<DateTime> scannedAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  const PendingScansCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.scannedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  PendingScansCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    this.scannedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  }) : code = Value(code);
  static Insertable<PendingScanRow> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<DateTime>? scannedAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (scannedAt != null) 'scanned_at': scannedAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
    });
  }

  PendingScansCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<DateTime>? scannedAt,
    Value<int>? attempts,
    Value<String?>? lastError,
  }) {
    return PendingScansCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      scannedAt: scannedAt ?? this.scannedAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (scannedAt.present) {
      map['scanned_at'] = Variable<DateTime>(scannedAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingScansCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('scannedAt: $scannedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

class $ScanHistoryTable extends ScanHistory
    with TableInfo<$ScanHistoryTable, ScanHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verdictMeta = const VerificationMeta(
    'verdict',
  );
  @override
  late final GeneratedColumn<String> verdict = GeneratedColumn<String>(
    'verdict',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  );
  static const VerificationMeta _scannedAtMeta = const VerificationMeta(
    'scannedAt',
  );
  @override
  late final GeneratedColumn<DateTime> scannedAt = GeneratedColumn<DateTime>(
    'scanned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    title,
    verdict,
    movieId,
    scannedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('verdict')) {
      context.handle(
        _verdictMeta,
        verdict.isAcceptableOrUnknown(data['verdict']!, _verdictMeta),
      );
    } else if (isInserting) {
      context.missing(_verdictMeta);
    }
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    }
    if (data.containsKey('scanned_at')) {
      context.handle(
        _scannedAtMeta,
        scannedAt.isAcceptableOrUnknown(data['scanned_at']!, _scannedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      verdict: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verdict'],
      )!,
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      ),
      scannedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scanned_at'],
      )!,
    );
  }

  @override
  $ScanHistoryTable createAlias(String alias) {
    return $ScanHistoryTable(attachedDatabase, alias);
  }
}

class ScanHistoryRow extends DataClass implements Insertable<ScanHistoryRow> {
  final int id;
  final String code;
  final String? title;

  /// A ScanVerdict name.
  final String verdict;
  final int? movieId;
  final DateTime scannedAt;
  const ScanHistoryRow({
    required this.id,
    required this.code,
    this.title,
    required this.verdict,
    this.movieId,
    required this.scannedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['verdict'] = Variable<String>(verdict);
    if (!nullToAbsent || movieId != null) {
      map['movie_id'] = Variable<int>(movieId);
    }
    map['scanned_at'] = Variable<DateTime>(scannedAt);
    return map;
  }

  ScanHistoryCompanion toCompanion(bool nullToAbsent) {
    return ScanHistoryCompanion(
      id: Value(id),
      code: Value(code),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      verdict: Value(verdict),
      movieId: movieId == null && nullToAbsent
          ? const Value.absent()
          : Value(movieId),
      scannedAt: Value(scannedAt),
    );
  }

  factory ScanHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanHistoryRow(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      title: serializer.fromJson<String?>(json['title']),
      verdict: serializer.fromJson<String>(json['verdict']),
      movieId: serializer.fromJson<int?>(json['movieId']),
      scannedAt: serializer.fromJson<DateTime>(json['scannedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'title': serializer.toJson<String?>(title),
      'verdict': serializer.toJson<String>(verdict),
      'movieId': serializer.toJson<int?>(movieId),
      'scannedAt': serializer.toJson<DateTime>(scannedAt),
    };
  }

  ScanHistoryRow copyWith({
    int? id,
    String? code,
    Value<String?> title = const Value.absent(),
    String? verdict,
    Value<int?> movieId = const Value.absent(),
    DateTime? scannedAt,
  }) => ScanHistoryRow(
    id: id ?? this.id,
    code: code ?? this.code,
    title: title.present ? title.value : this.title,
    verdict: verdict ?? this.verdict,
    movieId: movieId.present ? movieId.value : this.movieId,
    scannedAt: scannedAt ?? this.scannedAt,
  );
  ScanHistoryRow copyWithCompanion(ScanHistoryCompanion data) {
    return ScanHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      title: data.title.present ? data.title.value : this.title,
      verdict: data.verdict.present ? data.verdict.value : this.verdict,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      scannedAt: data.scannedAt.present ? data.scannedAt.value : this.scannedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanHistoryRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('verdict: $verdict, ')
          ..write('movieId: $movieId, ')
          ..write('scannedAt: $scannedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, title, verdict, movieId, scannedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanHistoryRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.title == this.title &&
          other.verdict == this.verdict &&
          other.movieId == this.movieId &&
          other.scannedAt == this.scannedAt);
}

class ScanHistoryCompanion extends UpdateCompanion<ScanHistoryRow> {
  final Value<int> id;
  final Value<String> code;
  final Value<String?> title;
  final Value<String> verdict;
  final Value<int?> movieId;
  final Value<DateTime> scannedAt;
  const ScanHistoryCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.title = const Value.absent(),
    this.verdict = const Value.absent(),
    this.movieId = const Value.absent(),
    this.scannedAt = const Value.absent(),
  });
  ScanHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    this.title = const Value.absent(),
    required String verdict,
    this.movieId = const Value.absent(),
    this.scannedAt = const Value.absent(),
  }) : code = Value(code),
       verdict = Value(verdict);
  static Insertable<ScanHistoryRow> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? title,
    Expression<String>? verdict,
    Expression<int>? movieId,
    Expression<DateTime>? scannedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (title != null) 'title': title,
      if (verdict != null) 'verdict': verdict,
      if (movieId != null) 'movie_id': movieId,
      if (scannedAt != null) 'scanned_at': scannedAt,
    });
  }

  ScanHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String?>? title,
    Value<String>? verdict,
    Value<int?>? movieId,
    Value<DateTime>? scannedAt,
  }) {
    return ScanHistoryCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      verdict: verdict ?? this.verdict,
      movieId: movieId ?? this.movieId,
      scannedAt: scannedAt ?? this.scannedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (verdict.present) {
      map['verdict'] = Variable<String>(verdict.value);
    }
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (scannedAt.present) {
      map['scanned_at'] = Variable<DateTime>(scannedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanHistoryCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('verdict: $verdict, ')
          ..write('movieId: $movieId, ')
          ..write('scannedAt: $scannedAt')
          ..write(')'))
        .toString();
  }
}

class $StreamingOffersTable extends StreamingOffers
    with TableInfo<$StreamingOffersTable, StreamingOfferRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreamingOffersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
    'tmdb_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<int> providerId = GeneratedColumn<int>(
    'provider_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerNameMeta = const VerificationMeta(
    'providerName',
  );
  @override
  late final GeneratedColumn<String> providerName = GeneratedColumn<String>(
    'provider_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _offerTypeMeta = const VerificationMeta(
    'offerType',
  );
  @override
  late final GeneratedColumn<String> offerType = GeneratedColumn<String>(
    'offer_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
    'link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkedAtMeta = const VerificationMeta(
    'checkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
    'checked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    mediaType,
    tmdbId,
    region,
    providerId,
    providerName,
    logoPath,
    offerType,
    link,
    checkedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaming_offers';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreamingOfferRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(
        _tmdbIdMeta,
        tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    } else if (isInserting) {
      context.missing(_regionMeta);
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_providerIdMeta);
    }
    if (data.containsKey('provider_name')) {
      context.handle(
        _providerNameMeta,
        providerName.isAcceptableOrUnknown(
          data['provider_name']!,
          _providerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerNameMeta);
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('offer_type')) {
      context.handle(
        _offerTypeMeta,
        offerType.isAcceptableOrUnknown(data['offer_type']!, _offerTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_offerTypeMeta);
    }
    if (data.containsKey('link')) {
      context.handle(
        _linkMeta,
        link.isAcceptableOrUnknown(data['link']!, _linkMeta),
      );
    }
    if (data.containsKey('checked_at')) {
      context.handle(
        _checkedAtMeta,
        checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_checkedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    mediaType,
    tmdbId,
    region,
    providerId,
    offerType,
  };
  @override
  StreamingOfferRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreamingOfferRow(
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      tmdbId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_id'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      )!,
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}provider_id'],
      )!,
      providerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_name'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      offerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}offer_type'],
      )!,
      link: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link'],
      ),
      checkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_at'],
      )!,
    );
  }

  @override
  $StreamingOffersTable createAlias(String alias) {
    return $StreamingOffersTable(attachedDatabase, alias);
  }
}

class StreamingOfferRow extends DataClass
    implements Insertable<StreamingOfferRow> {
  /// movie or tv.
  final String mediaType;
  final int tmdbId;
  final String region;
  final int providerId;
  final String providerName;
  final String? logoPath;

  /// An OfferType name: flatrate, free, ads, rent or buy.
  final String offerType;

  /// The TMDB page that lists the offers; TMDB gives no per-provider links.
  final String? link;
  final DateTime checkedAt;
  const StreamingOfferRow({
    required this.mediaType,
    required this.tmdbId,
    required this.region,
    required this.providerId,
    required this.providerName,
    this.logoPath,
    required this.offerType,
    this.link,
    required this.checkedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_type'] = Variable<String>(mediaType);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['region'] = Variable<String>(region);
    map['provider_id'] = Variable<int>(providerId);
    map['provider_name'] = Variable<String>(providerName);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['offer_type'] = Variable<String>(offerType);
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    map['checked_at'] = Variable<DateTime>(checkedAt);
    return map;
  }

  StreamingOffersCompanion toCompanion(bool nullToAbsent) {
    return StreamingOffersCompanion(
      mediaType: Value(mediaType),
      tmdbId: Value(tmdbId),
      region: Value(region),
      providerId: Value(providerId),
      providerName: Value(providerName),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      offerType: Value(offerType),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      checkedAt: Value(checkedAt),
    );
  }

  factory StreamingOfferRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreamingOfferRow(
      mediaType: serializer.fromJson<String>(json['mediaType']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      region: serializer.fromJson<String>(json['region']),
      providerId: serializer.fromJson<int>(json['providerId']),
      providerName: serializer.fromJson<String>(json['providerName']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      offerType: serializer.fromJson<String>(json['offerType']),
      link: serializer.fromJson<String?>(json['link']),
      checkedAt: serializer.fromJson<DateTime>(json['checkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaType': serializer.toJson<String>(mediaType),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'region': serializer.toJson<String>(region),
      'providerId': serializer.toJson<int>(providerId),
      'providerName': serializer.toJson<String>(providerName),
      'logoPath': serializer.toJson<String?>(logoPath),
      'offerType': serializer.toJson<String>(offerType),
      'link': serializer.toJson<String?>(link),
      'checkedAt': serializer.toJson<DateTime>(checkedAt),
    };
  }

  StreamingOfferRow copyWith({
    String? mediaType,
    int? tmdbId,
    String? region,
    int? providerId,
    String? providerName,
    Value<String?> logoPath = const Value.absent(),
    String? offerType,
    Value<String?> link = const Value.absent(),
    DateTime? checkedAt,
  }) => StreamingOfferRow(
    mediaType: mediaType ?? this.mediaType,
    tmdbId: tmdbId ?? this.tmdbId,
    region: region ?? this.region,
    providerId: providerId ?? this.providerId,
    providerName: providerName ?? this.providerName,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    offerType: offerType ?? this.offerType,
    link: link.present ? link.value : this.link,
    checkedAt: checkedAt ?? this.checkedAt,
  );
  StreamingOfferRow copyWithCompanion(StreamingOffersCompanion data) {
    return StreamingOfferRow(
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      region: data.region.present ? data.region.value : this.region,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      providerName: data.providerName.present
          ? data.providerName.value
          : this.providerName,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      offerType: data.offerType.present ? data.offerType.value : this.offerType,
      link: data.link.present ? data.link.value : this.link,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreamingOfferRow(')
          ..write('mediaType: $mediaType, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('region: $region, ')
          ..write('providerId: $providerId, ')
          ..write('providerName: $providerName, ')
          ..write('logoPath: $logoPath, ')
          ..write('offerType: $offerType, ')
          ..write('link: $link, ')
          ..write('checkedAt: $checkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    mediaType,
    tmdbId,
    region,
    providerId,
    providerName,
    logoPath,
    offerType,
    link,
    checkedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreamingOfferRow &&
          other.mediaType == this.mediaType &&
          other.tmdbId == this.tmdbId &&
          other.region == this.region &&
          other.providerId == this.providerId &&
          other.providerName == this.providerName &&
          other.logoPath == this.logoPath &&
          other.offerType == this.offerType &&
          other.link == this.link &&
          other.checkedAt == this.checkedAt);
}

class StreamingOffersCompanion extends UpdateCompanion<StreamingOfferRow> {
  final Value<String> mediaType;
  final Value<int> tmdbId;
  final Value<String> region;
  final Value<int> providerId;
  final Value<String> providerName;
  final Value<String?> logoPath;
  final Value<String> offerType;
  final Value<String?> link;
  final Value<DateTime> checkedAt;
  final Value<int> rowid;
  const StreamingOffersCompanion({
    this.mediaType = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.region = const Value.absent(),
    this.providerId = const Value.absent(),
    this.providerName = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.offerType = const Value.absent(),
    this.link = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StreamingOffersCompanion.insert({
    required String mediaType,
    required int tmdbId,
    required String region,
    required int providerId,
    required String providerName,
    this.logoPath = const Value.absent(),
    required String offerType,
    this.link = const Value.absent(),
    required DateTime checkedAt,
    this.rowid = const Value.absent(),
  }) : mediaType = Value(mediaType),
       tmdbId = Value(tmdbId),
       region = Value(region),
       providerId = Value(providerId),
       providerName = Value(providerName),
       offerType = Value(offerType),
       checkedAt = Value(checkedAt);
  static Insertable<StreamingOfferRow> custom({
    Expression<String>? mediaType,
    Expression<int>? tmdbId,
    Expression<String>? region,
    Expression<int>? providerId,
    Expression<String>? providerName,
    Expression<String>? logoPath,
    Expression<String>? offerType,
    Expression<String>? link,
    Expression<DateTime>? checkedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaType != null) 'media_type': mediaType,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (region != null) 'region': region,
      if (providerId != null) 'provider_id': providerId,
      if (providerName != null) 'provider_name': providerName,
      if (logoPath != null) 'logo_path': logoPath,
      if (offerType != null) 'offer_type': offerType,
      if (link != null) 'link': link,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StreamingOffersCompanion copyWith({
    Value<String>? mediaType,
    Value<int>? tmdbId,
    Value<String>? region,
    Value<int>? providerId,
    Value<String>? providerName,
    Value<String?>? logoPath,
    Value<String>? offerType,
    Value<String?>? link,
    Value<DateTime>? checkedAt,
    Value<int>? rowid,
  }) {
    return StreamingOffersCompanion(
      mediaType: mediaType ?? this.mediaType,
      tmdbId: tmdbId ?? this.tmdbId,
      region: region ?? this.region,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      logoPath: logoPath ?? this.logoPath,
      offerType: offerType ?? this.offerType,
      link: link ?? this.link,
      checkedAt: checkedAt ?? this.checkedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (providerId.present) {
      map['provider_id'] = Variable<int>(providerId.value);
    }
    if (providerName.present) {
      map['provider_name'] = Variable<String>(providerName.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (offerType.present) {
      map['offer_type'] = Variable<String>(offerType.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreamingOffersCompanion(')
          ..write('mediaType: $mediaType, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('region: $region, ')
          ..write('providerId: $providerId, ')
          ..write('providerName: $providerName, ')
          ..write('logoPath: $logoPath, ')
          ..write('offerType: $offerType, ')
          ..write('link: $link, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StreamingChecksTable extends StreamingChecks
    with TableInfo<$StreamingChecksTable, StreamingCheckRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreamingChecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
    'tmdb_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkedAtMeta = const VerificationMeta(
    'checkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
    'checked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [mediaType, tmdbId, region, checkedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaming_checks';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreamingCheckRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(
        _tmdbIdMeta,
        tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    } else if (isInserting) {
      context.missing(_regionMeta);
    }
    if (data.containsKey('checked_at')) {
      context.handle(
        _checkedAtMeta,
        checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_checkedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaType, tmdbId, region};
  @override
  StreamingCheckRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreamingCheckRow(
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      tmdbId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tmdb_id'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      )!,
      checkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_at'],
      )!,
    );
  }

  @override
  $StreamingChecksTable createAlias(String alias) {
    return $StreamingChecksTable(attachedDatabase, alias);
  }
}

class StreamingCheckRow extends DataClass
    implements Insertable<StreamingCheckRow> {
  final String mediaType;
  final int tmdbId;
  final String region;
  final DateTime checkedAt;
  const StreamingCheckRow({
    required this.mediaType,
    required this.tmdbId,
    required this.region,
    required this.checkedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_type'] = Variable<String>(mediaType);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['region'] = Variable<String>(region);
    map['checked_at'] = Variable<DateTime>(checkedAt);
    return map;
  }

  StreamingChecksCompanion toCompanion(bool nullToAbsent) {
    return StreamingChecksCompanion(
      mediaType: Value(mediaType),
      tmdbId: Value(tmdbId),
      region: Value(region),
      checkedAt: Value(checkedAt),
    );
  }

  factory StreamingCheckRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreamingCheckRow(
      mediaType: serializer.fromJson<String>(json['mediaType']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      region: serializer.fromJson<String>(json['region']),
      checkedAt: serializer.fromJson<DateTime>(json['checkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaType': serializer.toJson<String>(mediaType),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'region': serializer.toJson<String>(region),
      'checkedAt': serializer.toJson<DateTime>(checkedAt),
    };
  }

  StreamingCheckRow copyWith({
    String? mediaType,
    int? tmdbId,
    String? region,
    DateTime? checkedAt,
  }) => StreamingCheckRow(
    mediaType: mediaType ?? this.mediaType,
    tmdbId: tmdbId ?? this.tmdbId,
    region: region ?? this.region,
    checkedAt: checkedAt ?? this.checkedAt,
  );
  StreamingCheckRow copyWithCompanion(StreamingChecksCompanion data) {
    return StreamingCheckRow(
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      region: data.region.present ? data.region.value : this.region,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreamingCheckRow(')
          ..write('mediaType: $mediaType, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('region: $region, ')
          ..write('checkedAt: $checkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mediaType, tmdbId, region, checkedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreamingCheckRow &&
          other.mediaType == this.mediaType &&
          other.tmdbId == this.tmdbId &&
          other.region == this.region &&
          other.checkedAt == this.checkedAt);
}

class StreamingChecksCompanion extends UpdateCompanion<StreamingCheckRow> {
  final Value<String> mediaType;
  final Value<int> tmdbId;
  final Value<String> region;
  final Value<DateTime> checkedAt;
  final Value<int> rowid;
  const StreamingChecksCompanion({
    this.mediaType = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.region = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StreamingChecksCompanion.insert({
    required String mediaType,
    required int tmdbId,
    required String region,
    required DateTime checkedAt,
    this.rowid = const Value.absent(),
  }) : mediaType = Value(mediaType),
       tmdbId = Value(tmdbId),
       region = Value(region),
       checkedAt = Value(checkedAt);
  static Insertable<StreamingCheckRow> custom({
    Expression<String>? mediaType,
    Expression<int>? tmdbId,
    Expression<String>? region,
    Expression<DateTime>? checkedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaType != null) 'media_type': mediaType,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (region != null) 'region': region,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StreamingChecksCompanion copyWith({
    Value<String>? mediaType,
    Value<int>? tmdbId,
    Value<String>? region,
    Value<DateTime>? checkedAt,
    Value<int>? rowid,
  }) {
    return StreamingChecksCompanion(
      mediaType: mediaType ?? this.mediaType,
      tmdbId: tmdbId ?? this.tmdbId,
      region: region ?? this.region,
      checkedAt: checkedAt ?? this.checkedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreamingChecksCompanion(')
          ..write('mediaType: $mediaType, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('region: $region, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StreamingSubscriptionsTable extends StreamingSubscriptions
    with TableInfo<$StreamingSubscriptionsTable, StreamingSubscriptionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreamingSubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<int> providerId = GeneratedColumn<int>(
    'provider_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _providerNameMeta = const VerificationMeta(
    'providerName',
  );
  @override
  late final GeneratedColumn<String> providerName = GeneratedColumn<String>(
    'provider_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [providerId, providerName, logoPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaming_subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreamingSubscriptionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    }
    if (data.containsKey('provider_name')) {
      context.handle(
        _providerNameMeta,
        providerName.isAcceptableOrUnknown(
          data['provider_name']!,
          _providerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerNameMeta);
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {providerId};
  @override
  StreamingSubscriptionRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreamingSubscriptionRow(
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}provider_id'],
      )!,
      providerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_name'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
    );
  }

  @override
  $StreamingSubscriptionsTable createAlias(String alias) {
    return $StreamingSubscriptionsTable(attachedDatabase, alias);
  }
}

class StreamingSubscriptionRow extends DataClass
    implements Insertable<StreamingSubscriptionRow> {
  final int providerId;
  final String providerName;
  final String? logoPath;
  const StreamingSubscriptionRow({
    required this.providerId,
    required this.providerName,
    this.logoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['provider_id'] = Variable<int>(providerId);
    map['provider_name'] = Variable<String>(providerName);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    return map;
  }

  StreamingSubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return StreamingSubscriptionsCompanion(
      providerId: Value(providerId),
      providerName: Value(providerName),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
    );
  }

  factory StreamingSubscriptionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreamingSubscriptionRow(
      providerId: serializer.fromJson<int>(json['providerId']),
      providerName: serializer.fromJson<String>(json['providerName']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'providerId': serializer.toJson<int>(providerId),
      'providerName': serializer.toJson<String>(providerName),
      'logoPath': serializer.toJson<String?>(logoPath),
    };
  }

  StreamingSubscriptionRow copyWith({
    int? providerId,
    String? providerName,
    Value<String?> logoPath = const Value.absent(),
  }) => StreamingSubscriptionRow(
    providerId: providerId ?? this.providerId,
    providerName: providerName ?? this.providerName,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
  );
  StreamingSubscriptionRow copyWithCompanion(
    StreamingSubscriptionsCompanion data,
  ) {
    return StreamingSubscriptionRow(
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      providerName: data.providerName.present
          ? data.providerName.value
          : this.providerName,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreamingSubscriptionRow(')
          ..write('providerId: $providerId, ')
          ..write('providerName: $providerName, ')
          ..write('logoPath: $logoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(providerId, providerName, logoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreamingSubscriptionRow &&
          other.providerId == this.providerId &&
          other.providerName == this.providerName &&
          other.logoPath == this.logoPath);
}

class StreamingSubscriptionsCompanion
    extends UpdateCompanion<StreamingSubscriptionRow> {
  final Value<int> providerId;
  final Value<String> providerName;
  final Value<String?> logoPath;
  const StreamingSubscriptionsCompanion({
    this.providerId = const Value.absent(),
    this.providerName = const Value.absent(),
    this.logoPath = const Value.absent(),
  });
  StreamingSubscriptionsCompanion.insert({
    this.providerId = const Value.absent(),
    required String providerName,
    this.logoPath = const Value.absent(),
  }) : providerName = Value(providerName);
  static Insertable<StreamingSubscriptionRow> custom({
    Expression<int>? providerId,
    Expression<String>? providerName,
    Expression<String>? logoPath,
  }) {
    return RawValuesInsertable({
      if (providerId != null) 'provider_id': providerId,
      if (providerName != null) 'provider_name': providerName,
      if (logoPath != null) 'logo_path': logoPath,
    });
  }

  StreamingSubscriptionsCompanion copyWith({
    Value<int>? providerId,
    Value<String>? providerName,
    Value<String?>? logoPath,
  }) {
    return StreamingSubscriptionsCompanion(
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      logoPath: logoPath ?? this.logoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (providerId.present) {
      map['provider_id'] = Variable<int>(providerId.value);
    }
    if (providerName.present) {
      map['provider_name'] = Variable<String>(providerName.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreamingSubscriptionsCompanion(')
          ..write('providerId: $providerId, ')
          ..write('providerName: $providerName, ')
          ..write('logoPath: $logoPath')
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
  late final $BarcodeLookupCacheTable barcodeLookupCache =
      $BarcodeLookupCacheTable(this);
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
  late final $OwnedCopiesTable ownedCopies = $OwnedCopiesTable(this);
  late final $PersonalStatesTable personalStates = $PersonalStatesTable(this);
  late final $SyncShadowTable syncShadow = $SyncShadowTable(this);
  late final $SyncConflictsTable syncConflicts = $SyncConflictsTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  late final $PendingScansTable pendingScans = $PendingScansTable(this);
  late final $ScanHistoryTable scanHistory = $ScanHistoryTable(this);
  late final $StreamingOffersTable streamingOffers = $StreamingOffersTable(
    this,
  );
  late final $StreamingChecksTable streamingChecks = $StreamingChecksTable(
    this,
  );
  late final $StreamingSubscriptionsTable streamingSubscriptions =
      $StreamingSubscriptionsTable(this);
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
    barcodeLookupCache,
    collections,
    collectionMovies,
    tvSeriesTable,
    tvSeasonsTable,
    tvSeriesGenres,
    physicalEditionMovies,
    physicalEditionTvSeasons,
    ownedCopies,
    personalStates,
    syncShadow,
    syncConflicts,
    syncMeta,
    pendingScans,
    scanHistory,
    streamingOffers,
    streamingChecks,
    streamingSubscriptions,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'physical_editions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('owned_copies', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('personal_states', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tv_series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('personal_states', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tv_seasons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('personal_states', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$MoviesTableCreateCompanionBuilder =
    MoviesCompanion Function({
      Value<int> id,
      Value<int?> tmdbId,
      Value<String?> uuid,
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
      Value<String?> uuid,
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

  static MultiTypedResultKey<$PersonalStatesTable, List<PersonalStateRow>>
  _personalStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.personalStates,
    aliasName: $_aliasNameGenerator(db.movies.id, db.personalStates.movieId),
  );

  $$PersonalStatesTableProcessedTableManager get personalStatesRefs {
    final manager = $$PersonalStatesTableTableManager(
      $_db,
      $_db.personalStates,
    ).filter((f) => f.movieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_personalStatesRefsTable($_db));
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

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
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

  Expression<bool> personalStatesRefs(
    Expression<bool> Function($$PersonalStatesTableFilterComposer f) f,
  ) {
    final $$PersonalStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalStates,
      getReferencedColumn: (t) => t.movieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalStatesTableFilterComposer(
            $db: $db,
            $table: $db.personalStates,
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

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
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

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

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

  Expression<T> personalStatesRefs<T extends Object>(
    Expression<T> Function($$PersonalStatesTableAnnotationComposer a) f,
  ) {
    final $$PersonalStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalStates,
      getReferencedColumn: (t) => t.movieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.personalStates,
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
            bool personalStatesRefs,
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
                Value<String?> uuid = const Value.absent(),
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
                uuid: uuid,
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
                Value<String?> uuid = const Value.absent(),
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
                uuid: uuid,
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
                personalStatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movieGenresRefs) db.movieGenres,
                    if (barcodesRefs) db.barcodes,
                    if (physicalEditionMoviesRefs) db.physicalEditionMovies,
                    if (personalStatesRefs) db.personalStates,
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
                      if (personalStatesRefs)
                        await $_getPrefetchedData<
                          MovieRow,
                          $MoviesTable,
                          PersonalStateRow
                        >(
                          currentTable: table,
                          referencedTable: $$MoviesTableReferences
                              ._personalStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MoviesTableReferences(
                                db,
                                table,
                                p0,
                              ).personalStatesRefs,
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
        bool personalStatesRefs,
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
      Value<String?> uuid,
      Value<String?> productTitle,
      Value<String?> editionName,
      required String mediaKind,
      Value<int?> tmdbCollectionId,
      Value<int?> tmdbTvSeriesId,
      Value<String> format,
      Value<String?> region,
      Value<String?> releaseCountry,
      Value<String?> audioLanguages,
      Value<String?> subtitleLanguages,
      Value<String?> publisher,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$PhysicalEditionsTableUpdateCompanionBuilder =
    PhysicalEditionsCompanion Function({
      Value<int> id,
      Value<String?> uuid,
      Value<String?> productTitle,
      Value<String?> editionName,
      Value<String> mediaKind,
      Value<int?> tmdbCollectionId,
      Value<int?> tmdbTvSeriesId,
      Value<String> format,
      Value<String?> region,
      Value<String?> releaseCountry,
      Value<String?> audioLanguages,
      Value<String?> subtitleLanguages,
      Value<String?> publisher,
      Value<String?> notes,
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

  static MultiTypedResultKey<$OwnedCopiesTable, List<OwnedCopyRow>>
  _ownedCopiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ownedCopies,
    aliasName: $_aliasNameGenerator(
      db.physicalEditions.id,
      db.ownedCopies.editionId,
    ),
  );

  $$OwnedCopiesTableProcessedTableManager get ownedCopiesRefs {
    final manager = $$OwnedCopiesTableTableManager(
      $_db,
      $_db.ownedCopies,
    ).filter((f) => f.editionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ownedCopiesRefsTable($_db));
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

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
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

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get releaseCountry => $composableBuilder(
    column: $table.releaseCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioLanguages => $composableBuilder(
    column: $table.audioLanguages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitleLanguages => $composableBuilder(
    column: $table.subtitleLanguages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  Expression<bool> ownedCopiesRefs(
    Expression<bool> Function($$OwnedCopiesTableFilterComposer f) f,
  ) {
    final $$OwnedCopiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ownedCopies,
      getReferencedColumn: (t) => t.editionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnedCopiesTableFilterComposer(
            $db: $db,
            $table: $db.ownedCopies,
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

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
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

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get releaseCountry => $composableBuilder(
    column: $table.releaseCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioLanguages => $composableBuilder(
    column: $table.audioLanguages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitleLanguages => $composableBuilder(
    column: $table.subtitleLanguages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

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

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get releaseCountry => $composableBuilder(
    column: $table.releaseCountry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioLanguages => $composableBuilder(
    column: $table.audioLanguages,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subtitleLanguages => $composableBuilder(
    column: $table.subtitleLanguages,
    builder: (column) => column,
  );

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

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

  Expression<T> ownedCopiesRefs<T extends Object>(
    Expression<T> Function($$OwnedCopiesTableAnnotationComposer a) f,
  ) {
    final $$OwnedCopiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ownedCopies,
      getReferencedColumn: (t) => t.editionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnedCopiesTableAnnotationComposer(
            $db: $db,
            $table: $db.ownedCopies,
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
            bool ownedCopiesRefs,
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
                Value<String?> uuid = const Value.absent(),
                Value<String?> productTitle = const Value.absent(),
                Value<String?> editionName = const Value.absent(),
                Value<String> mediaKind = const Value.absent(),
                Value<int?> tmdbCollectionId = const Value.absent(),
                Value<int?> tmdbTvSeriesId = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> releaseCountry = const Value.absent(),
                Value<String?> audioLanguages = const Value.absent(),
                Value<String?> subtitleLanguages = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PhysicalEditionsCompanion(
                id: id,
                uuid: uuid,
                productTitle: productTitle,
                editionName: editionName,
                mediaKind: mediaKind,
                tmdbCollectionId: tmdbCollectionId,
                tmdbTvSeriesId: tmdbTvSeriesId,
                format: format,
                region: region,
                releaseCountry: releaseCountry,
                audioLanguages: audioLanguages,
                subtitleLanguages: subtitleLanguages,
                publisher: publisher,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> uuid = const Value.absent(),
                Value<String?> productTitle = const Value.absent(),
                Value<String?> editionName = const Value.absent(),
                required String mediaKind,
                Value<int?> tmdbCollectionId = const Value.absent(),
                Value<int?> tmdbTvSeriesId = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> releaseCountry = const Value.absent(),
                Value<String?> audioLanguages = const Value.absent(),
                Value<String?> subtitleLanguages = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PhysicalEditionsCompanion.insert(
                id: id,
                uuid: uuid,
                productTitle: productTitle,
                editionName: editionName,
                mediaKind: mediaKind,
                tmdbCollectionId: tmdbCollectionId,
                tmdbTvSeriesId: tmdbTvSeriesId,
                format: format,
                region: region,
                releaseCountry: releaseCountry,
                audioLanguages: audioLanguages,
                subtitleLanguages: subtitleLanguages,
                publisher: publisher,
                notes: notes,
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
                ownedCopiesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (barcodesRefs) db.barcodes,
                    if (physicalEditionMoviesRefs) db.physicalEditionMovies,
                    if (physicalEditionTvSeasonsRefs)
                      db.physicalEditionTvSeasons,
                    if (ownedCopiesRefs) db.ownedCopies,
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
                      if (ownedCopiesRefs)
                        await $_getPrefetchedData<
                          PhysicalEditionRow,
                          $PhysicalEditionsTable,
                          OwnedCopyRow
                        >(
                          currentTable: table,
                          referencedTable: $$PhysicalEditionsTableReferences
                              ._ownedCopiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PhysicalEditionsTableReferences(
                                db,
                                table,
                                p0,
                              ).ownedCopiesRefs,
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
        bool ownedCopiesRefs,
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
      Value<String?> physicalFormat,
      Value<String?> region,
      Value<String?> imdbId,
      Value<String?> source,
      Value<bool> verified,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
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
      Value<String?> physicalFormat,
      Value<String?> region,
      Value<String?> imdbId,
      Value<String?> source,
      Value<bool> verified,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
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

  ColumnFilters<String> get physicalFormat => $composableBuilder(
    column: $table.physicalFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imdbId => $composableBuilder(
    column: $table.imdbId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get verified => $composableBuilder(
    column: $table.verified,
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

  ColumnOrderings<String> get physicalFormat => $composableBuilder(
    column: $table.physicalFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imdbId => $composableBuilder(
    column: $table.imdbId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get verified => $composableBuilder(
    column: $table.verified,
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

  GeneratedColumn<String> get physicalFormat => $composableBuilder(
    column: $table.physicalFormat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get imdbId =>
      $composableBuilder(column: $table.imdbId, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

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
                Value<String?> physicalFormat = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> imdbId = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => BarcodesCompanion(
                id: id,
                movieId: movieId,
                physicalEditionId: physicalEditionId,
                barcode: barcode,
                barcodeType: barcodeType,
                productTitle: productTitle,
                editionName: editionName,
                physicalFormat: physicalFormat,
                region: region,
                imdbId: imdbId,
                source: source,
                verified: verified,
                createdAt: createdAt,
                updatedAt: updatedAt,
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
                Value<String?> physicalFormat = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> imdbId = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => BarcodesCompanion.insert(
                id: id,
                movieId: movieId,
                physicalEditionId: physicalEditionId,
                barcode: barcode,
                barcodeType: barcodeType,
                productTitle: productTitle,
                editionName: editionName,
                physicalFormat: physicalFormat,
                region: region,
                imdbId: imdbId,
                source: source,
                verified: verified,
                createdAt: createdAt,
                updatedAt: updatedAt,
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
typedef $$BarcodeLookupCacheTableCreateCompanionBuilder =
    BarcodeLookupCacheCompanion Function({
      Value<int> id,
      required String barcode,
      required String provider,
      required String outcome,
      Value<String?> payload,
      required DateTime fetchedAt,
      required DateTime expiresAt,
    });
typedef $$BarcodeLookupCacheTableUpdateCompanionBuilder =
    BarcodeLookupCacheCompanion Function({
      Value<int> id,
      Value<String> barcode,
      Value<String> provider,
      Value<String> outcome,
      Value<String?> payload,
      Value<DateTime> fetchedAt,
      Value<DateTime> expiresAt,
    });

class $$BarcodeLookupCacheTableFilterComposer
    extends Composer<_$AppDatabase, $BarcodeLookupCacheTable> {
  $$BarcodeLookupCacheTableFilterComposer({
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

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BarcodeLookupCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $BarcodeLookupCacheTable> {
  $$BarcodeLookupCacheTableOrderingComposer({
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

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BarcodeLookupCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $BarcodeLookupCacheTable> {
  $$BarcodeLookupCacheTableAnnotationComposer({
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

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$BarcodeLookupCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BarcodeLookupCacheTable,
          BarcodeLookupCacheRow,
          $$BarcodeLookupCacheTableFilterComposer,
          $$BarcodeLookupCacheTableOrderingComposer,
          $$BarcodeLookupCacheTableAnnotationComposer,
          $$BarcodeLookupCacheTableCreateCompanionBuilder,
          $$BarcodeLookupCacheTableUpdateCompanionBuilder,
          (
            BarcodeLookupCacheRow,
            BaseReferences<
              _$AppDatabase,
              $BarcodeLookupCacheTable,
              BarcodeLookupCacheRow
            >,
          ),
          BarcodeLookupCacheRow,
          PrefetchHooks Function()
        > {
  $$BarcodeLookupCacheTableTableManager(
    _$AppDatabase db,
    $BarcodeLookupCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BarcodeLookupCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BarcodeLookupCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BarcodeLookupCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
              }) => BarcodeLookupCacheCompanion(
                id: id,
                barcode: barcode,
                provider: provider,
                outcome: outcome,
                payload: payload,
                fetchedAt: fetchedAt,
                expiresAt: expiresAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String barcode,
                required String provider,
                required String outcome,
                Value<String?> payload = const Value.absent(),
                required DateTime fetchedAt,
                required DateTime expiresAt,
              }) => BarcodeLookupCacheCompanion.insert(
                id: id,
                barcode: barcode,
                provider: provider,
                outcome: outcome,
                payload: payload,
                fetchedAt: fetchedAt,
                expiresAt: expiresAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BarcodeLookupCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BarcodeLookupCacheTable,
      BarcodeLookupCacheRow,
      $$BarcodeLookupCacheTableFilterComposer,
      $$BarcodeLookupCacheTableOrderingComposer,
      $$BarcodeLookupCacheTableAnnotationComposer,
      $$BarcodeLookupCacheTableCreateCompanionBuilder,
      $$BarcodeLookupCacheTableUpdateCompanionBuilder,
      (
        BarcodeLookupCacheRow,
        BaseReferences<
          _$AppDatabase,
          $BarcodeLookupCacheTable,
          BarcodeLookupCacheRow
        >,
      ),
      BarcodeLookupCacheRow,
      PrefetchHooks Function()
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

  static MultiTypedResultKey<$PersonalStatesTable, List<PersonalStateRow>>
  _personalStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.personalStates,
    aliasName: $_aliasNameGenerator(
      db.tvSeriesTable.id,
      db.personalStates.seriesId,
    ),
  );

  $$PersonalStatesTableProcessedTableManager get personalStatesRefs {
    final manager = $$PersonalStatesTableTableManager(
      $_db,
      $_db.personalStates,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_personalStatesRefsTable($_db));
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

  Expression<bool> personalStatesRefs(
    Expression<bool> Function($$PersonalStatesTableFilterComposer f) f,
  ) {
    final $$PersonalStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalStates,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalStatesTableFilterComposer(
            $db: $db,
            $table: $db.personalStates,
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

  Expression<T> personalStatesRefs<T extends Object>(
    Expression<T> Function($$PersonalStatesTableAnnotationComposer a) f,
  ) {
    final $$PersonalStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalStates,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.personalStates,
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
            bool personalStatesRefs,
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
              ({
                tvSeasonsTableRefs = false,
                tvSeriesGenresRefs = false,
                personalStatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tvSeasonsTableRefs) db.tvSeasonsTable,
                    if (tvSeriesGenresRefs) db.tvSeriesGenres,
                    if (personalStatesRefs) db.personalStates,
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
                      if (personalStatesRefs)
                        await $_getPrefetchedData<
                          TvSeriesRow,
                          $TvSeriesTableTable,
                          PersonalStateRow
                        >(
                          currentTable: table,
                          referencedTable: $$TvSeriesTableTableReferences
                              ._personalStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TvSeriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).personalStatesRefs,
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
      PrefetchHooks Function({
        bool tvSeasonsTableRefs,
        bool tvSeriesGenresRefs,
        bool personalStatesRefs,
      })
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

  static MultiTypedResultKey<$PersonalStatesTable, List<PersonalStateRow>>
  _personalStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.personalStates,
    aliasName: $_aliasNameGenerator(
      db.tvSeasonsTable.id,
      db.personalStates.seasonId,
    ),
  );

  $$PersonalStatesTableProcessedTableManager get personalStatesRefs {
    final manager = $$PersonalStatesTableTableManager(
      $_db,
      $_db.personalStates,
    ).filter((f) => f.seasonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_personalStatesRefsTable($_db));
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

  Expression<bool> personalStatesRefs(
    Expression<bool> Function($$PersonalStatesTableFilterComposer f) f,
  ) {
    final $$PersonalStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalStates,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalStatesTableFilterComposer(
            $db: $db,
            $table: $db.personalStates,
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

  Expression<T> personalStatesRefs<T extends Object>(
    Expression<T> Function($$PersonalStatesTableAnnotationComposer a) f,
  ) {
    final $$PersonalStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalStates,
      getReferencedColumn: (t) => t.seasonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.personalStates,
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
            bool personalStatesRefs,
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
              ({
                seriesId = false,
                physicalEditionTvSeasonsRefs = false,
                personalStatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (physicalEditionTvSeasonsRefs)
                      db.physicalEditionTvSeasons,
                    if (personalStatesRefs) db.personalStates,
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
                      if (personalStatesRefs)
                        await $_getPrefetchedData<
                          TvSeasonRow,
                          $TvSeasonsTableTable,
                          PersonalStateRow
                        >(
                          currentTable: table,
                          referencedTable: $$TvSeasonsTableTableReferences
                              ._personalStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TvSeasonsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).personalStatesRefs,
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
      PrefetchHooks Function({
        bool seriesId,
        bool physicalEditionTvSeasonsRefs,
        bool personalStatesRefs,
      })
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
typedef $$OwnedCopiesTableCreateCompanionBuilder =
    OwnedCopiesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      required int editionId,
      Value<int> quantity,
      Value<String?> condition,
      Value<DateTime?> purchaseDate,
      Value<double?> purchasePrice,
      Value<String?> storageLocation,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$OwnedCopiesTableUpdateCompanionBuilder =
    OwnedCopiesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<int> editionId,
      Value<int> quantity,
      Value<String?> condition,
      Value<DateTime?> purchaseDate,
      Value<double?> purchasePrice,
      Value<String?> storageLocation,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$OwnedCopiesTableReferences
    extends BaseReferences<_$AppDatabase, $OwnedCopiesTable, OwnedCopyRow> {
  $$OwnedCopiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PhysicalEditionsTable _editionIdTable(_$AppDatabase db) =>
      db.physicalEditions.createAlias(
        $_aliasNameGenerator(db.ownedCopies.editionId, db.physicalEditions.id),
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
}

class $$OwnedCopiesTableFilterComposer
    extends Composer<_$AppDatabase, $OwnedCopiesTable> {
  $$OwnedCopiesTableFilterComposer({
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

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storageLocation => $composableBuilder(
    column: $table.storageLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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
}

class $$OwnedCopiesTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnedCopiesTable> {
  $$OwnedCopiesTableOrderingComposer({
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

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storageLocation => $composableBuilder(
    column: $table.storageLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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
}

class $$OwnedCopiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnedCopiesTable> {
  $$OwnedCopiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storageLocation => $composableBuilder(
    column: $table.storageLocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

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
}

class $$OwnedCopiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnedCopiesTable,
          OwnedCopyRow,
          $$OwnedCopiesTableFilterComposer,
          $$OwnedCopiesTableOrderingComposer,
          $$OwnedCopiesTableAnnotationComposer,
          $$OwnedCopiesTableCreateCompanionBuilder,
          $$OwnedCopiesTableUpdateCompanionBuilder,
          (OwnedCopyRow, $$OwnedCopiesTableReferences),
          OwnedCopyRow,
          PrefetchHooks Function({bool editionId})
        > {
  $$OwnedCopiesTableTableManager(_$AppDatabase db, $OwnedCopiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnedCopiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnedCopiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnedCopiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> editionId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> condition = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<double?> purchasePrice = const Value.absent(),
                Value<String?> storageLocation = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OwnedCopiesCompanion(
                id: id,
                uuid: uuid,
                editionId: editionId,
                quantity: quantity,
                condition: condition,
                purchaseDate: purchaseDate,
                purchasePrice: purchasePrice,
                storageLocation: storageLocation,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                required int editionId,
                Value<int> quantity = const Value.absent(),
                Value<String?> condition = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<double?> purchasePrice = const Value.absent(),
                Value<String?> storageLocation = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OwnedCopiesCompanion.insert(
                id: id,
                uuid: uuid,
                editionId: editionId,
                quantity: quantity,
                condition: condition,
                purchaseDate: purchaseDate,
                purchasePrice: purchasePrice,
                storageLocation: storageLocation,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OwnedCopiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({editionId = false}) {
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
                                referencedTable: $$OwnedCopiesTableReferences
                                    ._editionIdTable(db),
                                referencedColumn: $$OwnedCopiesTableReferences
                                    ._editionIdTable(db)
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

typedef $$OwnedCopiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnedCopiesTable,
      OwnedCopyRow,
      $$OwnedCopiesTableFilterComposer,
      $$OwnedCopiesTableOrderingComposer,
      $$OwnedCopiesTableAnnotationComposer,
      $$OwnedCopiesTableCreateCompanionBuilder,
      $$OwnedCopiesTableUpdateCompanionBuilder,
      (OwnedCopyRow, $$OwnedCopiesTableReferences),
      OwnedCopyRow,
      PrefetchHooks Function({bool editionId})
    >;
typedef $$PersonalStatesTableCreateCompanionBuilder =
    PersonalStatesCompanion Function({
      Value<int> id,
      Value<int?> movieId,
      Value<int?> seriesId,
      Value<int?> seasonId,
      Value<bool> onWishlist,
      Value<double?> maxPrice,
      Value<String?> watchStatus,
      Value<int> watchCount,
      Value<DateTime?> lastWatchedAt,
      Value<int?> rating,
      Value<bool> favourite,
      Value<String?> tags,
      Value<String?> preferredEditionUuid,
      Value<DateTime> updatedAt,
    });
typedef $$PersonalStatesTableUpdateCompanionBuilder =
    PersonalStatesCompanion Function({
      Value<int> id,
      Value<int?> movieId,
      Value<int?> seriesId,
      Value<int?> seasonId,
      Value<bool> onWishlist,
      Value<double?> maxPrice,
      Value<String?> watchStatus,
      Value<int> watchCount,
      Value<DateTime?> lastWatchedAt,
      Value<int?> rating,
      Value<bool> favourite,
      Value<String?> tags,
      Value<String?> preferredEditionUuid,
      Value<DateTime> updatedAt,
    });

final class $$PersonalStatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $PersonalStatesTable, PersonalStateRow> {
  $$PersonalStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MoviesTable _movieIdTable(_$AppDatabase db) => db.movies.createAlias(
    $_aliasNameGenerator(db.personalStates.movieId, db.movies.id),
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

  static $TvSeriesTableTable _seriesIdTable(_$AppDatabase db) =>
      db.tvSeriesTable.createAlias(
        $_aliasNameGenerator(db.personalStates.seriesId, db.tvSeriesTable.id),
      );

  $$TvSeriesTableTableProcessedTableManager? get seriesId {
    final $_column = $_itemColumn<int>('series_id');
    if ($_column == null) return null;
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

  static $TvSeasonsTableTable _seasonIdTable(_$AppDatabase db) =>
      db.tvSeasonsTable.createAlias(
        $_aliasNameGenerator(db.personalStates.seasonId, db.tvSeasonsTable.id),
      );

  $$TvSeasonsTableTableProcessedTableManager? get seasonId {
    final $_column = $_itemColumn<int>('season_id');
    if ($_column == null) return null;
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

class $$PersonalStatesTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalStatesTable> {
  $$PersonalStatesTableFilterComposer({
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

  ColumnFilters<bool> get onWishlist => $composableBuilder(
    column: $table.onWishlist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxPrice => $composableBuilder(
    column: $table.maxPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get watchStatus => $composableBuilder(
    column: $table.watchStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get watchCount => $composableBuilder(
    column: $table.watchCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastWatchedAt => $composableBuilder(
    column: $table.lastWatchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favourite => $composableBuilder(
    column: $table.favourite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredEditionUuid => $composableBuilder(
    column: $table.preferredEditionUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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

class $$PersonalStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalStatesTable> {
  $$PersonalStatesTableOrderingComposer({
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

  ColumnOrderings<bool> get onWishlist => $composableBuilder(
    column: $table.onWishlist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxPrice => $composableBuilder(
    column: $table.maxPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get watchStatus => $composableBuilder(
    column: $table.watchStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get watchCount => $composableBuilder(
    column: $table.watchCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastWatchedAt => $composableBuilder(
    column: $table.lastWatchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favourite => $composableBuilder(
    column: $table.favourite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredEditionUuid => $composableBuilder(
    column: $table.preferredEditionUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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

class $$PersonalStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalStatesTable> {
  $$PersonalStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get onWishlist => $composableBuilder(
    column: $table.onWishlist,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxPrice =>
      $composableBuilder(column: $table.maxPrice, builder: (column) => column);

  GeneratedColumn<String> get watchStatus => $composableBuilder(
    column: $table.watchStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get watchCount => $composableBuilder(
    column: $table.watchCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastWatchedAt => $composableBuilder(
    column: $table.lastWatchedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get favourite =>
      $composableBuilder(column: $table.favourite, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get preferredEditionUuid => $composableBuilder(
    column: $table.preferredEditionUuid,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

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

class $$PersonalStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalStatesTable,
          PersonalStateRow,
          $$PersonalStatesTableFilterComposer,
          $$PersonalStatesTableOrderingComposer,
          $$PersonalStatesTableAnnotationComposer,
          $$PersonalStatesTableCreateCompanionBuilder,
          $$PersonalStatesTableUpdateCompanionBuilder,
          (PersonalStateRow, $$PersonalStatesTableReferences),
          PersonalStateRow,
          PrefetchHooks Function({bool movieId, bool seriesId, bool seasonId})
        > {
  $$PersonalStatesTableTableManager(
    _$AppDatabase db,
    $PersonalStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> movieId = const Value.absent(),
                Value<int?> seriesId = const Value.absent(),
                Value<int?> seasonId = const Value.absent(),
                Value<bool> onWishlist = const Value.absent(),
                Value<double?> maxPrice = const Value.absent(),
                Value<String?> watchStatus = const Value.absent(),
                Value<int> watchCount = const Value.absent(),
                Value<DateTime?> lastWatchedAt = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<bool> favourite = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> preferredEditionUuid = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PersonalStatesCompanion(
                id: id,
                movieId: movieId,
                seriesId: seriesId,
                seasonId: seasonId,
                onWishlist: onWishlist,
                maxPrice: maxPrice,
                watchStatus: watchStatus,
                watchCount: watchCount,
                lastWatchedAt: lastWatchedAt,
                rating: rating,
                favourite: favourite,
                tags: tags,
                preferredEditionUuid: preferredEditionUuid,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> movieId = const Value.absent(),
                Value<int?> seriesId = const Value.absent(),
                Value<int?> seasonId = const Value.absent(),
                Value<bool> onWishlist = const Value.absent(),
                Value<double?> maxPrice = const Value.absent(),
                Value<String?> watchStatus = const Value.absent(),
                Value<int> watchCount = const Value.absent(),
                Value<DateTime?> lastWatchedAt = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<bool> favourite = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> preferredEditionUuid = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PersonalStatesCompanion.insert(
                id: id,
                movieId: movieId,
                seriesId: seriesId,
                seasonId: seasonId,
                onWishlist: onWishlist,
                maxPrice: maxPrice,
                watchStatus: watchStatus,
                watchCount: watchCount,
                lastWatchedAt: lastWatchedAt,
                rating: rating,
                favourite: favourite,
                tags: tags,
                preferredEditionUuid: preferredEditionUuid,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersonalStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({movieId = false, seriesId = false, seasonId = false}) {
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
                                    referencedTable:
                                        $$PersonalStatesTableReferences
                                            ._movieIdTable(db),
                                    referencedColumn:
                                        $$PersonalStatesTableReferences
                                            ._movieIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (seriesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.seriesId,
                                    referencedTable:
                                        $$PersonalStatesTableReferences
                                            ._seriesIdTable(db),
                                    referencedColumn:
                                        $$PersonalStatesTableReferences
                                            ._seriesIdTable(db)
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
                                        $$PersonalStatesTableReferences
                                            ._seasonIdTable(db),
                                    referencedColumn:
                                        $$PersonalStatesTableReferences
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

typedef $$PersonalStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalStatesTable,
      PersonalStateRow,
      $$PersonalStatesTableFilterComposer,
      $$PersonalStatesTableOrderingComposer,
      $$PersonalStatesTableAnnotationComposer,
      $$PersonalStatesTableCreateCompanionBuilder,
      $$PersonalStatesTableUpdateCompanionBuilder,
      (PersonalStateRow, $$PersonalStatesTableReferences),
      PersonalStateRow,
      PrefetchHooks Function({bool movieId, bool seriesId, bool seasonId})
    >;
typedef $$SyncShadowTableCreateCompanionBuilder =
    SyncShadowCompanion Function({
      required String uuid,
      required String entityType,
      required int baseSeq,
      required String fieldsJson,
      Value<int> rowid,
    });
typedef $$SyncShadowTableUpdateCompanionBuilder =
    SyncShadowCompanion Function({
      Value<String> uuid,
      Value<String> entityType,
      Value<int> baseSeq,
      Value<String> fieldsJson,
      Value<int> rowid,
    });

class $$SyncShadowTableFilterComposer
    extends Composer<_$AppDatabase, $SyncShadowTable> {
  $$SyncShadowTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseSeq => $composableBuilder(
    column: $table.baseSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncShadowTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncShadowTable> {
  $$SyncShadowTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseSeq => $composableBuilder(
    column: $table.baseSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncShadowTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncShadowTable> {
  $$SyncShadowTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseSeq =>
      $composableBuilder(column: $table.baseSeq, builder: (column) => column);

  GeneratedColumn<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => column,
  );
}

class $$SyncShadowTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncShadowTable,
          SyncShadowRow,
          $$SyncShadowTableFilterComposer,
          $$SyncShadowTableOrderingComposer,
          $$SyncShadowTableAnnotationComposer,
          $$SyncShadowTableCreateCompanionBuilder,
          $$SyncShadowTableUpdateCompanionBuilder,
          (
            SyncShadowRow,
            BaseReferences<_$AppDatabase, $SyncShadowTable, SyncShadowRow>,
          ),
          SyncShadowRow,
          PrefetchHooks Function()
        > {
  $$SyncShadowTableTableManager(_$AppDatabase db, $SyncShadowTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncShadowTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncShadowTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncShadowTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> baseSeq = const Value.absent(),
                Value<String> fieldsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncShadowCompanion(
                uuid: uuid,
                entityType: entityType,
                baseSeq: baseSeq,
                fieldsJson: fieldsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String entityType,
                required int baseSeq,
                required String fieldsJson,
                Value<int> rowid = const Value.absent(),
              }) => SyncShadowCompanion.insert(
                uuid: uuid,
                entityType: entityType,
                baseSeq: baseSeq,
                fieldsJson: fieldsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncShadowTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncShadowTable,
      SyncShadowRow,
      $$SyncShadowTableFilterComposer,
      $$SyncShadowTableOrderingComposer,
      $$SyncShadowTableAnnotationComposer,
      $$SyncShadowTableCreateCompanionBuilder,
      $$SyncShadowTableUpdateCompanionBuilder,
      (
        SyncShadowRow,
        BaseReferences<_$AppDatabase, $SyncShadowTable, SyncShadowRow>,
      ),
      SyncShadowRow,
      PrefetchHooks Function()
    >;
typedef $$SyncConflictsTableCreateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<int> id,
      required String entityType,
      required String entityUuid,
      required String field,
      Value<String?> localJson,
      Value<String?> serverJson,
      required int serverSeq,
      Value<DateTime> createdAt,
    });
typedef $$SyncConflictsTableUpdateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<String> entityUuid,
      Value<String> field,
      Value<String?> localJson,
      Value<String?> serverJson,
      Value<int> serverSeq,
      Value<DateTime> createdAt,
    });

class $$SyncConflictsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableFilterComposer({
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

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityUuid => $composableBuilder(
    column: $table.entityUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get field => $composableBuilder(
    column: $table.field,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localJson => $composableBuilder(
    column: $table.localJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverJson => $composableBuilder(
    column: $table.serverJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncConflictsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableOrderingComposer({
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

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityUuid => $composableBuilder(
    column: $table.entityUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get field => $composableBuilder(
    column: $table.field,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localJson => $composableBuilder(
    column: $table.localJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverJson => $composableBuilder(
    column: $table.serverJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncConflictsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityUuid => $composableBuilder(
    column: $table.entityUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get field =>
      $composableBuilder(column: $table.field, builder: (column) => column);

  GeneratedColumn<String> get localJson =>
      $composableBuilder(column: $table.localJson, builder: (column) => column);

  GeneratedColumn<String> get serverJson => $composableBuilder(
    column: $table.serverJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncConflictsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncConflictsTable,
          SyncConflictRow,
          $$SyncConflictsTableFilterComposer,
          $$SyncConflictsTableOrderingComposer,
          $$SyncConflictsTableAnnotationComposer,
          $$SyncConflictsTableCreateCompanionBuilder,
          $$SyncConflictsTableUpdateCompanionBuilder,
          (
            SyncConflictRow,
            BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflictRow>,
          ),
          SyncConflictRow,
          PrefetchHooks Function()
        > {
  $$SyncConflictsTableTableManager(_$AppDatabase db, $SyncConflictsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncConflictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncConflictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncConflictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityUuid = const Value.absent(),
                Value<String> field = const Value.absent(),
                Value<String?> localJson = const Value.absent(),
                Value<String?> serverJson = const Value.absent(),
                Value<int> serverSeq = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncConflictsCompanion(
                id: id,
                entityType: entityType,
                entityUuid: entityUuid,
                field: field,
                localJson: localJson,
                serverJson: serverJson,
                serverSeq: serverSeq,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required String entityUuid,
                required String field,
                Value<String?> localJson = const Value.absent(),
                Value<String?> serverJson = const Value.absent(),
                required int serverSeq,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncConflictsCompanion.insert(
                id: id,
                entityType: entityType,
                entityUuid: entityUuid,
                field: field,
                localJson: localJson,
                serverJson: serverJson,
                serverSeq: serverSeq,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncConflictsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncConflictsTable,
      SyncConflictRow,
      $$SyncConflictsTableFilterComposer,
      $$SyncConflictsTableOrderingComposer,
      $$SyncConflictsTableAnnotationComposer,
      $$SyncConflictsTableCreateCompanionBuilder,
      $$SyncConflictsTableUpdateCompanionBuilder,
      (
        SyncConflictRow,
        BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflictRow>,
      ),
      SyncConflictRow,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableCreateCompanionBuilder =
    SyncMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SyncMetaTableUpdateCompanionBuilder =
    SyncMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTable,
          SyncMetaRow,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (
            SyncMetaRow,
            BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>,
          ),
          SyncMetaRow,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTable,
      SyncMetaRow,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (SyncMetaRow, BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>),
      SyncMetaRow,
      PrefetchHooks Function()
    >;
typedef $$PendingScansTableCreateCompanionBuilder =
    PendingScansCompanion Function({
      Value<int> id,
      required String code,
      Value<DateTime> scannedAt,
      Value<int> attempts,
      Value<String?> lastError,
    });
typedef $$PendingScansTableUpdateCompanionBuilder =
    PendingScansCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<DateTime> scannedAt,
      Value<int> attempts,
      Value<String?> lastError,
    });

class $$PendingScansTableFilterComposer
    extends Composer<_$AppDatabase, $PendingScansTable> {
  $$PendingScansTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingScansTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingScansTable> {
  $$PendingScansTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingScansTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingScansTable> {
  $$PendingScansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<DateTime> get scannedAt =>
      $composableBuilder(column: $table.scannedAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$PendingScansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingScansTable,
          PendingScanRow,
          $$PendingScansTableFilterComposer,
          $$PendingScansTableOrderingComposer,
          $$PendingScansTableAnnotationComposer,
          $$PendingScansTableCreateCompanionBuilder,
          $$PendingScansTableUpdateCompanionBuilder,
          (
            PendingScanRow,
            BaseReferences<_$AppDatabase, $PendingScansTable, PendingScanRow>,
          ),
          PendingScanRow,
          PrefetchHooks Function()
        > {
  $$PendingScansTableTableManager(_$AppDatabase db, $PendingScansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingScansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingScansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingScansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<DateTime> scannedAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => PendingScansCompanion(
                id: id,
                code: code,
                scannedAt: scannedAt,
                attempts: attempts,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                Value<DateTime> scannedAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => PendingScansCompanion.insert(
                id: id,
                code: code,
                scannedAt: scannedAt,
                attempts: attempts,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingScansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingScansTable,
      PendingScanRow,
      $$PendingScansTableFilterComposer,
      $$PendingScansTableOrderingComposer,
      $$PendingScansTableAnnotationComposer,
      $$PendingScansTableCreateCompanionBuilder,
      $$PendingScansTableUpdateCompanionBuilder,
      (
        PendingScanRow,
        BaseReferences<_$AppDatabase, $PendingScansTable, PendingScanRow>,
      ),
      PendingScanRow,
      PrefetchHooks Function()
    >;
typedef $$ScanHistoryTableCreateCompanionBuilder =
    ScanHistoryCompanion Function({
      Value<int> id,
      required String code,
      Value<String?> title,
      required String verdict,
      Value<int?> movieId,
      Value<DateTime> scannedAt,
    });
typedef $$ScanHistoryTableUpdateCompanionBuilder =
    ScanHistoryCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String?> title,
      Value<String> verdict,
      Value<int?> movieId,
      Value<DateTime> scannedAt,
    });

class $$ScanHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ScanHistoryTable> {
  $$ScanHistoryTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verdict => $composableBuilder(
    column: $table.verdict,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScanHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ScanHistoryTable> {
  $$ScanHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verdict => $composableBuilder(
    column: $table.verdict,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScanHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScanHistoryTable> {
  $$ScanHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get verdict =>
      $composableBuilder(column: $table.verdict, builder: (column) => column);

  GeneratedColumn<int> get movieId =>
      $composableBuilder(column: $table.movieId, builder: (column) => column);

  GeneratedColumn<DateTime> get scannedAt =>
      $composableBuilder(column: $table.scannedAt, builder: (column) => column);
}

class $$ScanHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScanHistoryTable,
          ScanHistoryRow,
          $$ScanHistoryTableFilterComposer,
          $$ScanHistoryTableOrderingComposer,
          $$ScanHistoryTableAnnotationComposer,
          $$ScanHistoryTableCreateCompanionBuilder,
          $$ScanHistoryTableUpdateCompanionBuilder,
          (
            ScanHistoryRow,
            BaseReferences<_$AppDatabase, $ScanHistoryTable, ScanHistoryRow>,
          ),
          ScanHistoryRow,
          PrefetchHooks Function()
        > {
  $$ScanHistoryTableTableManager(_$AppDatabase db, $ScanHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> verdict = const Value.absent(),
                Value<int?> movieId = const Value.absent(),
                Value<DateTime> scannedAt = const Value.absent(),
              }) => ScanHistoryCompanion(
                id: id,
                code: code,
                title: title,
                verdict: verdict,
                movieId: movieId,
                scannedAt: scannedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                Value<String?> title = const Value.absent(),
                required String verdict,
                Value<int?> movieId = const Value.absent(),
                Value<DateTime> scannedAt = const Value.absent(),
              }) => ScanHistoryCompanion.insert(
                id: id,
                code: code,
                title: title,
                verdict: verdict,
                movieId: movieId,
                scannedAt: scannedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScanHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScanHistoryTable,
      ScanHistoryRow,
      $$ScanHistoryTableFilterComposer,
      $$ScanHistoryTableOrderingComposer,
      $$ScanHistoryTableAnnotationComposer,
      $$ScanHistoryTableCreateCompanionBuilder,
      $$ScanHistoryTableUpdateCompanionBuilder,
      (
        ScanHistoryRow,
        BaseReferences<_$AppDatabase, $ScanHistoryTable, ScanHistoryRow>,
      ),
      ScanHistoryRow,
      PrefetchHooks Function()
    >;
typedef $$StreamingOffersTableCreateCompanionBuilder =
    StreamingOffersCompanion Function({
      required String mediaType,
      required int tmdbId,
      required String region,
      required int providerId,
      required String providerName,
      Value<String?> logoPath,
      required String offerType,
      Value<String?> link,
      required DateTime checkedAt,
      Value<int> rowid,
    });
typedef $$StreamingOffersTableUpdateCompanionBuilder =
    StreamingOffersCompanion Function({
      Value<String> mediaType,
      Value<int> tmdbId,
      Value<String> region,
      Value<int> providerId,
      Value<String> providerName,
      Value<String?> logoPath,
      Value<String> offerType,
      Value<String?> link,
      Value<DateTime> checkedAt,
      Value<int> rowid,
    });

class $$StreamingOffersTableFilterComposer
    extends Composer<_$AppDatabase, $StreamingOffersTable> {
  $$StreamingOffersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tmdbId => $composableBuilder(
    column: $table.tmdbId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get offerType => $composableBuilder(
    column: $table.offerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreamingOffersTableOrderingComposer
    extends Composer<_$AppDatabase, $StreamingOffersTable> {
  $$StreamingOffersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tmdbId => $composableBuilder(
    column: $table.tmdbId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get offerType => $composableBuilder(
    column: $table.offerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreamingOffersTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreamingOffersTable> {
  $$StreamingOffersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<int> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get offerType =>
      $composableBuilder(column: $table.offerType, builder: (column) => column);

  GeneratedColumn<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);
}

class $$StreamingOffersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreamingOffersTable,
          StreamingOfferRow,
          $$StreamingOffersTableFilterComposer,
          $$StreamingOffersTableOrderingComposer,
          $$StreamingOffersTableAnnotationComposer,
          $$StreamingOffersTableCreateCompanionBuilder,
          $$StreamingOffersTableUpdateCompanionBuilder,
          (
            StreamingOfferRow,
            BaseReferences<
              _$AppDatabase,
              $StreamingOffersTable,
              StreamingOfferRow
            >,
          ),
          StreamingOfferRow,
          PrefetchHooks Function()
        > {
  $$StreamingOffersTableTableManager(
    _$AppDatabase db,
    $StreamingOffersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreamingOffersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreamingOffersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreamingOffersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> mediaType = const Value.absent(),
                Value<int> tmdbId = const Value.absent(),
                Value<String> region = const Value.absent(),
                Value<int> providerId = const Value.absent(),
                Value<String> providerName = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String> offerType = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<DateTime> checkedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StreamingOffersCompanion(
                mediaType: mediaType,
                tmdbId: tmdbId,
                region: region,
                providerId: providerId,
                providerName: providerName,
                logoPath: logoPath,
                offerType: offerType,
                link: link,
                checkedAt: checkedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String mediaType,
                required int tmdbId,
                required String region,
                required int providerId,
                required String providerName,
                Value<String?> logoPath = const Value.absent(),
                required String offerType,
                Value<String?> link = const Value.absent(),
                required DateTime checkedAt,
                Value<int> rowid = const Value.absent(),
              }) => StreamingOffersCompanion.insert(
                mediaType: mediaType,
                tmdbId: tmdbId,
                region: region,
                providerId: providerId,
                providerName: providerName,
                logoPath: logoPath,
                offerType: offerType,
                link: link,
                checkedAt: checkedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreamingOffersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreamingOffersTable,
      StreamingOfferRow,
      $$StreamingOffersTableFilterComposer,
      $$StreamingOffersTableOrderingComposer,
      $$StreamingOffersTableAnnotationComposer,
      $$StreamingOffersTableCreateCompanionBuilder,
      $$StreamingOffersTableUpdateCompanionBuilder,
      (
        StreamingOfferRow,
        BaseReferences<_$AppDatabase, $StreamingOffersTable, StreamingOfferRow>,
      ),
      StreamingOfferRow,
      PrefetchHooks Function()
    >;
typedef $$StreamingChecksTableCreateCompanionBuilder =
    StreamingChecksCompanion Function({
      required String mediaType,
      required int tmdbId,
      required String region,
      required DateTime checkedAt,
      Value<int> rowid,
    });
typedef $$StreamingChecksTableUpdateCompanionBuilder =
    StreamingChecksCompanion Function({
      Value<String> mediaType,
      Value<int> tmdbId,
      Value<String> region,
      Value<DateTime> checkedAt,
      Value<int> rowid,
    });

class $$StreamingChecksTableFilterComposer
    extends Composer<_$AppDatabase, $StreamingChecksTable> {
  $$StreamingChecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tmdbId => $composableBuilder(
    column: $table.tmdbId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreamingChecksTableOrderingComposer
    extends Composer<_$AppDatabase, $StreamingChecksTable> {
  $$StreamingChecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tmdbId => $composableBuilder(
    column: $table.tmdbId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreamingChecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreamingChecksTable> {
  $$StreamingChecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);
}

class $$StreamingChecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreamingChecksTable,
          StreamingCheckRow,
          $$StreamingChecksTableFilterComposer,
          $$StreamingChecksTableOrderingComposer,
          $$StreamingChecksTableAnnotationComposer,
          $$StreamingChecksTableCreateCompanionBuilder,
          $$StreamingChecksTableUpdateCompanionBuilder,
          (
            StreamingCheckRow,
            BaseReferences<
              _$AppDatabase,
              $StreamingChecksTable,
              StreamingCheckRow
            >,
          ),
          StreamingCheckRow,
          PrefetchHooks Function()
        > {
  $$StreamingChecksTableTableManager(
    _$AppDatabase db,
    $StreamingChecksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreamingChecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreamingChecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreamingChecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> mediaType = const Value.absent(),
                Value<int> tmdbId = const Value.absent(),
                Value<String> region = const Value.absent(),
                Value<DateTime> checkedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StreamingChecksCompanion(
                mediaType: mediaType,
                tmdbId: tmdbId,
                region: region,
                checkedAt: checkedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String mediaType,
                required int tmdbId,
                required String region,
                required DateTime checkedAt,
                Value<int> rowid = const Value.absent(),
              }) => StreamingChecksCompanion.insert(
                mediaType: mediaType,
                tmdbId: tmdbId,
                region: region,
                checkedAt: checkedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreamingChecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreamingChecksTable,
      StreamingCheckRow,
      $$StreamingChecksTableFilterComposer,
      $$StreamingChecksTableOrderingComposer,
      $$StreamingChecksTableAnnotationComposer,
      $$StreamingChecksTableCreateCompanionBuilder,
      $$StreamingChecksTableUpdateCompanionBuilder,
      (
        StreamingCheckRow,
        BaseReferences<_$AppDatabase, $StreamingChecksTable, StreamingCheckRow>,
      ),
      StreamingCheckRow,
      PrefetchHooks Function()
    >;
typedef $$StreamingSubscriptionsTableCreateCompanionBuilder =
    StreamingSubscriptionsCompanion Function({
      Value<int> providerId,
      required String providerName,
      Value<String?> logoPath,
    });
typedef $$StreamingSubscriptionsTableUpdateCompanionBuilder =
    StreamingSubscriptionsCompanion Function({
      Value<int> providerId,
      Value<String> providerName,
      Value<String?> logoPath,
    });

class $$StreamingSubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $StreamingSubscriptionsTable> {
  $$StreamingSubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreamingSubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StreamingSubscriptionsTable> {
  $$StreamingSubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreamingSubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreamingSubscriptionsTable> {
  $$StreamingSubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);
}

class $$StreamingSubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreamingSubscriptionsTable,
          StreamingSubscriptionRow,
          $$StreamingSubscriptionsTableFilterComposer,
          $$StreamingSubscriptionsTableOrderingComposer,
          $$StreamingSubscriptionsTableAnnotationComposer,
          $$StreamingSubscriptionsTableCreateCompanionBuilder,
          $$StreamingSubscriptionsTableUpdateCompanionBuilder,
          (
            StreamingSubscriptionRow,
            BaseReferences<
              _$AppDatabase,
              $StreamingSubscriptionsTable,
              StreamingSubscriptionRow
            >,
          ),
          StreamingSubscriptionRow,
          PrefetchHooks Function()
        > {
  $$StreamingSubscriptionsTableTableManager(
    _$AppDatabase db,
    $StreamingSubscriptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreamingSubscriptionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StreamingSubscriptionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StreamingSubscriptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> providerId = const Value.absent(),
                Value<String> providerName = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
              }) => StreamingSubscriptionsCompanion(
                providerId: providerId,
                providerName: providerName,
                logoPath: logoPath,
              ),
          createCompanionCallback:
              ({
                Value<int> providerId = const Value.absent(),
                required String providerName,
                Value<String?> logoPath = const Value.absent(),
              }) => StreamingSubscriptionsCompanion.insert(
                providerId: providerId,
                providerName: providerName,
                logoPath: logoPath,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreamingSubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreamingSubscriptionsTable,
      StreamingSubscriptionRow,
      $$StreamingSubscriptionsTableFilterComposer,
      $$StreamingSubscriptionsTableOrderingComposer,
      $$StreamingSubscriptionsTableAnnotationComposer,
      $$StreamingSubscriptionsTableCreateCompanionBuilder,
      $$StreamingSubscriptionsTableUpdateCompanionBuilder,
      (
        StreamingSubscriptionRow,
        BaseReferences<
          _$AppDatabase,
          $StreamingSubscriptionsTable,
          StreamingSubscriptionRow
        >,
      ),
      StreamingSubscriptionRow,
      PrefetchHooks Function()
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
  $$BarcodeLookupCacheTableTableManager get barcodeLookupCache =>
      $$BarcodeLookupCacheTableTableManager(_db, _db.barcodeLookupCache);
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
  $$OwnedCopiesTableTableManager get ownedCopies =>
      $$OwnedCopiesTableTableManager(_db, _db.ownedCopies);
  $$PersonalStatesTableTableManager get personalStates =>
      $$PersonalStatesTableTableManager(_db, _db.personalStates);
  $$SyncShadowTableTableManager get syncShadow =>
      $$SyncShadowTableTableManager(_db, _db.syncShadow);
  $$SyncConflictsTableTableManager get syncConflicts =>
      $$SyncConflictsTableTableManager(_db, _db.syncConflicts);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
  $$PendingScansTableTableManager get pendingScans =>
      $$PendingScansTableTableManager(_db, _db.pendingScans);
  $$ScanHistoryTableTableManager get scanHistory =>
      $$ScanHistoryTableTableManager(_db, _db.scanHistory);
  $$StreamingOffersTableTableManager get streamingOffers =>
      $$StreamingOffersTableTableManager(_db, _db.streamingOffers);
  $$StreamingChecksTableTableManager get streamingChecks =>
      $$StreamingChecksTableTableManager(_db, _db.streamingChecks);
  $$StreamingSubscriptionsTableTableManager get streamingSubscriptions =>
      $$StreamingSubscriptionsTableTableManager(
        _db,
        _db.streamingSubscriptions,
      );
}
