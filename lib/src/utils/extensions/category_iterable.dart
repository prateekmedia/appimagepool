extension CategoryIterable<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(List<K> Function(E) keyFunction) {
    return fold(
      {},
      (Map<K, List<E>> map, E element) {
        for (var el in keyFunction(element)) {
          map.putIfAbsent(el, () => <E>[]).add(element);
        }
        return map;
      },
    );
  }
}
