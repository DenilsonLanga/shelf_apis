
class SupplierNearbyDto {
  final int id;
  final String nome;
  final String? logo;
  final double distancia;
  final int categoryId;

  SupplierNearbyDto({required this.id, required this.nome, this.logo, required this.distancia, required this.categoryId,});
}