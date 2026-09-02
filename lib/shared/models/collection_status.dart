enum CollectionStatus {
  owned,
  wishlist,
  open;

  String get germanLabel => switch (this) {
    CollectionStatus.owned => 'Gekauft',
    CollectionStatus.wishlist => 'Wunschliste',
    CollectionStatus.open => 'Offen',
  };

  int get rank => switch (this) {
    CollectionStatus.owned => 2,
    CollectionStatus.wishlist => 1,
    CollectionStatus.open => 0,
  };

  CollectionStatus mergePreferringStronger(CollectionStatus incoming) {
    return incoming.rank > rank ? incoming : this;
  }

  static CollectionStatus? mergeNullable(
    CollectionStatus? existing,
    CollectionStatus? incoming,
  ) {
    if (incoming == null) return existing;
    if (existing == null) return incoming;
    return existing.mergePreferringStronger(incoming);
  }

  static CollectionStatus fromName(String name) => CollectionStatus.values
      .firstWhere((s) => s.name == name, orElse: () => CollectionStatus.open);
}
