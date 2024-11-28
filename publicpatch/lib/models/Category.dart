class Category {
  final int id;
  final String name;
  final String description;
  final String? icon;

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      icon: map['icon'],
    );
  }
  @override
  String toString() {
    return 'Category{id: $id, name: $name, icon: $description $icon}';
  }
}
