List<T> sortByCreatedAt<T>(
    List<T> list, String Function(T) getCreatedAt, bool newestFirst) {
  list.sort((a, b) {
    DateTime dateA = DateTime.parse(getCreatedAt(a));
    DateTime dateB = DateTime.parse(getCreatedAt(b));
    return newestFirst ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
  return list;
}