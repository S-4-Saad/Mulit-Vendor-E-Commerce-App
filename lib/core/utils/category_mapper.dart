class CategoryMapper {
  static const Map<String, int> categoryMap = {
    'food': 1,
    'retailstore': 2,
    'supermarket': 3,
    'pharmacy': 4,
  };

  static int getCategoryId(String categoryName) {
    return categoryMap[categoryName.toLowerCase()] ?? 1;
  }

  static String getCategoryName(int categoryId) {
    for (var entry in categoryMap.entries) {
      if (entry.value == categoryId) {
        return entry.key;
      }
    }
    return 'food';
  }
}
