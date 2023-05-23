import 'package:user_shop/domain/repositories/product_repository.dart';
import 'package:user_shop/presentation/Bloc/events/product_events.dart';
import 'package:bloc/bloc.dart';

class ProductBloc extends Bloc<ProductEvents, Map> {
  // final Product product = Product('', '', '', 0, 0, '');
  ProductBloc(product) : super(product) {
    on<GetProductEvent>((event, emit) async {
      final data = await ProductRepository.getProduct(event.id);
      emit(data);
    });

    on<AddReviewEvent>((event, emit) async {
      final data = await ProductRepository.addReview(event.prodId, event.name, event.rating, event.review);
      emit(data);
    });
  }
}

class ProductListBloc extends Bloc<ProductEvents, Map> {
  ProductListBloc() : super({}) {
    on<GetAllProductsEvent>((event, emit) async {
      final data = await ProductRepository.getAllProducts(event.page, event.limit, event.category);
      emit(data);
    });
  }
}

class SearchProductsBloc extends Bloc<ProductEvents, Map> {
  SearchProductsBloc() : super({'data': [], 'status': 0}) {
    on<SearchProductsEvent>((event, emit) async {
      final data = await ProductRepository.searchProducts(event.search);
      emit(data);
    });

    on<ResetSearchProductsEvent>((event, emit) {
      emit({'data': [], 'status': 0});
    });
  }
}
