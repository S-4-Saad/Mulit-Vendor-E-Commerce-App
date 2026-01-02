import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/presentation/product_detail/bloc/product_detail_event.dart';
import 'package:speezu/presentation/product_detail/bloc/product_detail_state.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'dart:convert';

import '../../../core/services/api_services.dart';
import '../../../core/services/urls.dart';
import '../../../core/utils/category_mapper.dart';
import '../../../models/product_detail_model.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(const ProductDetailState()) {
    on<ShowBottomBar>((event, emit) {
      emit(state.copyWith(isBottomSheetVisible: true));
    });

    on<HideBottomBar>((event, emit) {
      emit(state.copyWith(isBottomSheetVisible: false));
    });

    on<IncrementQuantity>((event, emit) {
      emit(state.copyWith(quantity: state.quantity + 1));
    });

    on<DecrementQuantity>((event, emit) {
      if (state.quantity > 1) {
        emit(state.copyWith(quantity: state.quantity - 1));
      }
    });
    on<UpdateFavouriteStatusEvent>((event, emit) {
      if (state.productDetail != null &&
          state.productDetail!.id == event.productId) {
        final updatedProduct = state.productDetail!.copyWith(
          isFavourite: event.isFavourite,
        );

        emit(state.copyWith(productDetail: updatedProduct));
      }
    });

    on<LoadProductDetail>((event, emit) async {
      emit(state.copyWith(status: ProductDetailStatus.loading, quantity: 1));

      try {
        await ApiService.getMethod(
          apiUrl:
              '$productDetailUrl${event.productId}?user_id=${UserRepository().currentUser?.userData?.id ?? ''}',
          authHeader: true,
          executionMethod: (bool success, dynamic responseData) async {
            if (success && responseData != null) {
              try {
                ProductDetail productDetail = _mapResponseToProductDetail(
                  responseData,
                );
                emit(
                  state.copyWith(
                    status: ProductDetailStatus.success,
                    productDetail: productDetail,
                  ),
                );
              } catch (e) {
                emit(
                  state.copyWith(
                    status: ProductDetailStatus.error,
                    errorMessage:
                        'Failed to parse product data: ${e.toString()}',
                  ),
                );
              }
            } else {
              emit(
                state.copyWith(
                  status: ProductDetailStatus.error,
                  errorMessage: 'Failed to load product details',
                ),
              );
            }
          },
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.error,
            errorMessage: 'Network error: ${e.toString()}',
          ),
        );
      }
    });
  }

  ProductDetail _mapResponseToProductDetail(dynamic responseData) {
    final data = responseData['data'];

    // Parse product images
    List<String> productImages = [];
    if (data['product_more_images'] != null) {
      try {
        final moreImagesJson = json.decode(data['product_more_images']);
        if (moreImagesJson is List) {
          productImages =
              moreImagesJson
                  .map((img) => '$imageBaseUrl${img.toString()}')
                  .toList();
        }
      } catch (e) {
        // If parsing fails, use empty list
        productImages = [];
      }
    }

    // Add main product image to the beginning of the list
    if (data['product_image'] != null) {
      productImages.insert(0, '$imageBaseUrl${data['product_image']}');
    }

    // Calculate discount percentage
    final originalPrice =
        double.tryParse(data['product_price']?.toString() ?? '0') ?? 0.0;
    final discountedPrice =
        double.tryParse(data['product_discounted_price']?.toString() ?? '0') ??
        0.0;
    final discountPercentage =
        originalPrice > 0
            ? ((originalPrice - discountedPrice) / originalPrice) * 100
            : 0.0;

    // Get category name from mapper
    final storeCategoryId =
        int.tryParse(data['store']?['store_category_id']?.toString() ?? '1') ??
        1;
    final categoryName = CategoryMapper.getCategoryName(storeCategoryId);

    // Get subcategory name
    final subCategoryName = data['category']?['name']?.toString() ?? '';

    // Map variations
    List<ProductVariation> variations = [];
    if (data['variations'] != null && data['variations'] is List) {
      variations =
          (data['variations'] as List).map((variation) {
            List<ProductSubVariation> children = [];
            if (variation['children'] != null &&
                variation['children'] is List) {
              children =
                  (variation['children'] as List).map((child) {
                    return ProductSubVariation(
                      id: child['id']?.toString() ?? '',
                      name: child['name']?.toString() ?? '',
                      childOptionName:
                          child['childOptionName']?.toString() ?? '',
                      price:
                          double.tryParse(
                            child['discountedPrice']?.toString() ?? '0',
                          ) ??
                          0.0,
                      originalPrice:
                          double.tryParse(child['price']?.toString() ?? '0') ??
                          0.0,
                      discountPercentage:
                          double.tryParse(
                            child['discountPercentage']?.toString() ?? '0',
                          ) ??
                          0.0,
                      stock: 10, // Default stock since not provided in API
                      stockTotal:
                          20, // Default stock total since not provided in API
                    );
                  }).toList();
            }

            return ProductVariation(
              id: variation['id']?.toString() ?? '',
              parentName: variation['parentName']?.toString() ?? '',
              parentOptionName: variation['parentOptionName']?.toString() ?? '',
              parentPrice:
                  double.tryParse(
                    variation['parentPrice']?.toString() ?? '0',
                  ) ??
                  0.0,
              parentOriginalPrice:
                  double.tryParse(
                    variation['parentOriginalPrice']?.toString() ?? '0',
                  ) ??
                  0.0,
              parentDiscountPercentage:
                  double.tryParse(
                    variation['parentDiscountPercentage']?.toString() ?? '0',
                  ) ??
                  0.0,
              children: children,
            );
          }).toList();
    }

    // Map related products
    List<RelatedProduct> relatedProducts = [];
    if (data['relatedProducts'] != null && data['relatedProducts'] is List) {
      relatedProducts =
          (data['relatedProducts'] as List).map((relatedProduct) {
            final originalPrice =
                double.tryParse(
                  relatedProduct['product_price']?.toString() ?? '0',
                ) ??
                0.0;
            final discountedPrice =
                double.tryParse(
                  relatedProduct['product_discounted_price']?.toString() ?? '0',
                ) ??
                0.0;
            final discountPercentage =
                originalPrice > 0
                    ? ((originalPrice - discountedPrice) / originalPrice) * 100
                    : 0.0;

            return RelatedProduct(
              isProductFavourite:
                  relatedProduct.containsKey('is_favourite')
                      ? relatedProduct['is_favourite'] == 1
                      : false,
              id: relatedProduct['id']?.toString() ?? '',
              name: relatedProduct['product_name']?.toString() ?? '',
              price: discountedPrice,
              originalPrice: originalPrice,
              discountPercentage: discountPercentage,
              imageUrl:
                  relatedProduct['product_image'] != null
                      ? '$imageBaseUrl${relatedProduct['product_image']}'
                      : '',
              categoryId: relatedProduct['category_id']?.toString() ?? '',
              categoryName:
                  relatedProduct['category']?['name']?.toString() ?? '',
            );
          }).toList();
    }

    // Create shop box model
    final shopBoxModel = ShopBoxModel(
      openTime: data['store']?['opening_time']?.toString() ?? '',
      closeTime: data['store']?['closing_time']?.toString() ?? '',
      categoryName: categoryName,
      name: data['store']?['name']?.toString() ?? '',
      imageUrl:
          data['store']?['image'] != null
              ? '$imageBaseUrl${data['store']['image']}'
              : '',
      rating:
          double.tryParse(data['store']?['rating']?.toString() ?? '0') ?? 0.0,
      id: data['store']?['id'] ?? 0,
    );

    return ProductDetail(
      id: data['id']?.toString() ?? '', // Real server product ID
      productDiscountPercentage: discountPercentage,
      isAvailable: (data['status']?.toString() ?? '1') == '1',
      isDeliveryAvailable: data['is_deliverable']?.toString() == 'true',

      price: discountedPrice,
      originalPrice: originalPrice,
      rating: double.tryParse(data['product_rating']?.toString() ?? '0') ?? 0.0,
      isFavourite: data['is_favorite'] == true || data['is_favorite'] == 1,
      name: data['product_name']?.toString() ?? '',
      thumbnail:
          data['product_image'] != null
              ? '$imageBaseUrl${data['product_image']}'
              : '',
      images: productImages,
      categoryName: categoryName,
      subCategoryName: subCategoryName,
      categoryId:
          data['category']?['id']?.toString() ?? '', // Real server category ID
      shopName: data['store']?['name']?.toString() ?? '',
      description: data['product_description']?.toString() ?? '',
      shop: shopBoxModel,
      variations: variations,
      relatedProducts: relatedProducts,
    );
  }
}
