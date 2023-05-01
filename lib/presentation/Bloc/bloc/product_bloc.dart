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
  }
}

class ProductListBloc extends Bloc<ProductEvents, Map> {
  ProductListBloc() : super({}) {
    on<GetAllProductsEvent>((event, emit) async {
      final data = await ProductRepository.getAllProducts(event.page, event.limit);
      emit(data);
    });
  }
}
