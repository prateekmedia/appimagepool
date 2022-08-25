class CategoryUtils {
  static bool doesContain(String any, List<String> val) {
    for (var item in val) {
      if (any.contains(item, 0)) return true;
    }
    return false;
  }
}
