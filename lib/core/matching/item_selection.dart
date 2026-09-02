class ItemSelection {
  ItemSelection([Iterable<int> selected = const []]) : selected = {...selected};

  final Set<int> selected;

  int get count => selected.length;

  bool contains(int id) => selected.contains(id);

  void toggle(int id) {
    if (!selected.add(id)) selected.remove(id);
  }

  void selectAll(Iterable<int> ids) {
    selected
      ..clear()
      ..addAll(ids);
  }

  void deselectAll() => selected.clear();

  void selectRegular(Iterable<int> ids) {
    selected
      ..clear()
      ..addAll(ids.where((id) => id > 0));
  }

  int countOf(Iterable<int> ids) => ids.where(selected.contains).length;
}
