class MenuEntity {
  MenuEntity({
    required this.id,
    required this.icon,
    required this.name,
  });

  int id;

  dynamic icon; // This can be either svg, IconData, or image.

  String name;
}
