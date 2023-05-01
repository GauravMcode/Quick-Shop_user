abstract class ProductEvents {}

class GetProductEvent extends ProductEvents {
  String id;
  GetProductEvent(this.id);
}

class GetAllProductsEvent extends ProductEvents {
  int page;
  int limit;
  GetAllProductsEvent({required this.page, required this.limit});
}
