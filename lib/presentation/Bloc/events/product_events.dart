abstract class ProductEvents {}

class GetProductEvent extends ProductEvents {
  String id;
  GetProductEvent(this.id);
}

class GetAllProductsEvent extends ProductEvents {
  int page;
  int limit;
  String category;
  GetAllProductsEvent({required this.page, required this.limit, required this.category});
}

class SearchProductsEvent extends ProductEvents {
  String search;
  SearchProductsEvent({required this.search});
}

class ResetSearchProductsEvent extends ProductEvents {}

class AddReviewEvent extends ProductEvents {
  String prodId;
  String name;
  double rating;
  String review;
  AddReviewEvent({required this.prodId, required this.name, required this.rating, required this.review});
}
