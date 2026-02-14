
class SupplierBid {
  final String name;
  final String image;
  final String? note;
  final String supplierPrice;
  final bool cancelled;

  SupplierBid({
    required this.name,
    required this.image,
    this.note,
    required this.supplierPrice,
    this.cancelled = false,
  });
}
