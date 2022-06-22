import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../repositories/repositories.dart';
import '/models/models.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  final StorageRepository _storageRepository;
  StreamSubscription? _productSubscription;

  ProductBloc({
    required ProductRepository productRepository,
    required StorageRepository storageRepository,
  })  : _productRepository = productRepository,
        _storageRepository = storageRepository,
        super(ProductLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<UpdateProducts>(_onUpdateProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    // on<UpdateProductImages>(_onUpdateProductImages);
  }

  void _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts().listen(
          (products) => add(
            UpdateProducts(products),
          ),
        );
  }

  void _onUpdateProducts(
    UpdateProducts event,
    Emitter<ProductState> emit,
  ) {
    emit(ProductsLoaded(products: event.products));
  }

  void _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    final state = this.state;
    if (state is ProductsLoaded) {
      await _productRepository.createProduct(event.product).then(
        (productId) async {
          await _storageRepository.uploadImageProduct(event.images, productId);
          add(LoadProducts());
        },
      );
    }
  }

  void _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    final state = this.state;
    if (state is ProductsLoaded) {
      await _productRepository.updateProduct(event.product, '');
      add(LoadProducts());
    }
  }

  // void _onUpdateProductImages(
  //   UpdateProductImages event,
  //   Emitter<ProductState> emit,
  // ) async {
  //   if (state is ProductsLoaded) {
  //     print('ULTIMO');
  //     Product product = (state as ProductsLoaded).products.last;
  //     print(product);

  //     await _storageRepository.uploadImageProduct(event.image);

  //     _productRepository.getProduct(product.id!).listen((product) {
  //       add(UpdateProduct(product: product));
  //     });
  //   }
  // }
}
