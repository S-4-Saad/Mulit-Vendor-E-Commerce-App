import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speezu/models/search_product_model.dart';
import 'package:speezu/presentation/search_products/bloc/search_product_state.dart';
import 'package:speezu/presentation/search_products/bloc/search_products_event.dart';

import '../../../core/services/api_services.dart';
import '../../../core/services/urls.dart';

class SearchProductsBloc
    extends Bloc<SearchProductsEvent, SearchProductsState> {
  SearchProductsBloc() : super(SearchProductsState()) {
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<SearchProducts>(_searchProductsViaApi);
    on<AddSearchQuery>(_onAddSearchQuery);
    on<ClearSearchHistory>(_onClearSearchHistory);
    on<LoadCategoryNamesEvent>(_loadCategoryNames);
    on<LoadTagNamesEvent>(_loadTagNames);
  }
void _loadCategoryNames(
    LoadCategoryNamesEvent event,
    Emitter<SearchProductsState> emit,
  ) {
    // Simulated category names
    final categories = [
      'Food',
      'Supermarket',
      'Retail Store',
      'Pharmacy'
    ];
    emit(state.copyWith(categoryNames: categories));
  }
void _loadTagNames(
    LoadTagNamesEvent event,
    Emitter<SearchProductsState> emit,
  ) {
    // Simulated tag names
  final tags = [
    // 🍔 Food
    'Fresh Meals',
    'Best Taste',
    'Chef’s Special',
    'Hot Deals',
    'New Recipes',

    // 🏪 Supermarket
    'Daily Essentials',
    'Top Discounts',
    'Weekend Offer',
    'Value Pack',
    'Budget Buy',

    // 🛍️ Retail Store
    'New Arrival',
    'Trending Now',
    'Exclusive Collection',
    'Best Seller',
    'Limited Edition',

    // 💊 Pharmacy
    'Health First',
    'Trusted Brands',
    'Wellness Picks',
    'Prescription Ready',
    'Top Rated',
  ];

  emit(state.copyWith(searchTags: tags));
  }
  Future<void> _onLoadSearchHistory(
    LoadSearchHistory event,
    Emitter<SearchProductsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _onAddSearchQuery(
    AddSearchQuery event,
    Emitter<SearchProductsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final updated = [...state.searchHistory];

    updated.remove(event.query); // prevent duplicates
    updated.insert(0, event.query); // add at the top
    if (updated.length > 10) updated.removeLast();

    await prefs.setStringList('search_history', updated);
    emit(state.copyWith(searchHistory: updated));
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistory event,
    Emitter<SearchProductsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    emit(state.copyWith(searchHistory: []));
  }

  Future<void> _searchProductsViaApi(SearchProducts event, Emitter<SearchProductsState> emit) async {
    emit(state.copyWith(searchProductsStatus: SearchProductsStatus.loading));

    await ApiService.getMethod(
      queryParameters: {'query': event.query},
      apiUrl: searchProductsViaApiUrl,
      executionMethod: (bool success, dynamic responseData) {
        if (success) {
          try {
            final searchModel = SearchModel.fromJson(responseData);
            final products = searchModel.data?.products ?? [];
            final stores = searchModel.data?.stores ?? [];

            emit(state.copyWith(
              searchProductsStatus: SearchProductsStatus.success,
              searchModel: searchModel,
              searchProducts: products,
              searchStores: stores,
              message: searchModel.message ?? 'Products fetched successfully',
            ));
          } catch (e) {
            emit(state.copyWith(
              searchProductsStatus: SearchProductsStatus.error,
              message: 'Data parsing error: $e',
            ));
          }
        } else {
          emit(state.copyWith(
            searchProductsStatus: SearchProductsStatus.error,
            message: 'Failed to fetch products from server',
          ));
        }
      },
    );
  }
}
