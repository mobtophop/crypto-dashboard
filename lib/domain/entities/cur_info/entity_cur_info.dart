class EntityCurInfo {
  EntityCurInfo({
    required this.name,
    required this.shortName,
    required this.iconUrl,
    required this.price,
    required this.delta,
    required this.graph,
  });

  String name;
  String shortName;
  String iconUrl;
  double price;
  double delta;
  List<double> graph;
}
