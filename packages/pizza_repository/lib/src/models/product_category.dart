enum ProductCategory {
  pizza,
  snacks,
  drinks;

  String get displayName {
    switch (this) {
      case ProductCategory.pizza:
        return 'Pizza';
      case ProductCategory.snacks:
        return 'Đồ ăn nhẹ';
      case ProductCategory.drinks:
        return 'Nước uống';
    }
  }

  String get icon {
    switch (this) {
      case ProductCategory.pizza:
        return '🍕';
      case ProductCategory.snacks:
        return '🍟';
      case ProductCategory.drinks:
        return '🥤';
    }
  }

  static ProductCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'pizza':
        return ProductCategory.pizza;
      case 'snacks':
        return ProductCategory.snacks;
      case 'drinks':
        return ProductCategory.drinks;
      default:
        return ProductCategory.pizza;
    }
  }
}
