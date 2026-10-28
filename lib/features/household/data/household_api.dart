class HouseholdMember {
  const HouseholdMember({
    required this.id,
    required this.name,
    required this.owner,
    required this.you,
  });

  factory HouseholdMember.fromJson(Map<String, dynamic> json) =>
      HouseholdMember(
        id: json['id'] as int,
        name: json['name'] as String,
        owner: json['owner'] as bool,
        you: json['you'] as bool,
      );

  final int id;
  final String name;
  final bool owner;
  final bool you;
}

class Household {
  const Household({required this.isOwner, required this.members});

  factory Household.fromJson(Map<String, dynamic> json) => Household(
    isOwner: json['isOwner'] as bool,
    members: [
      for (final m in json['members'] as List)
        HouseholdMember.fromJson(m as Map<String, dynamic>),
    ],
  );

  final bool isOwner;
  final List<HouseholdMember> members;

  /// Others use this collection, or this account uses someone else's.
  bool get shared => members.length > 1;
}

class HouseholdInvite {
  const HouseholdInvite({required this.code, required this.expiresAt});

  factory HouseholdInvite.fromJson(Map<String, dynamic> json) =>
      HouseholdInvite(
        code: json['code'] as String,
        expiresAt: DateTime.parse(json['expiresAt'] as String).toLocal(),
      );

  final String code;
  final DateTime expiresAt;
}

/// People who share one collection, on the home server or in Movie Shelf
/// Cloud. Both offer the same endpoints.
class HouseholdApi {
  HouseholdApi({
    required Future<dynamic> Function(String path) get,
    required Future<dynamic> Function(String path, Object? body) post,
    required Future<dynamic> Function(String path) delete,
  }) : _get = get,
       _post = post,
       _delete = delete;

  final Future<dynamic> Function(String path) _get;
  final Future<dynamic> Function(String path, Object? body) _post;
  final Future<dynamic> Function(String path) _delete;

  Future<Household> load() async =>
      Household.fromJson(await _get('/api/household') as Map<String, dynamic>);

  Future<HouseholdInvite> invite() async => HouseholdInvite.fromJson(
    await _post('/api/household/invites', null) as Map<String, dynamic>,
  );

  Future<void> join(String code) =>
      _post('/api/household/join', {'code': code.trim()});

  Future<void> leave() => _post('/api/household/leave', null);

  Future<void> remove(int memberId) =>
      _delete('/api/household/members/$memberId');
}
