import 'package:equatable/equatable.dart';

import '../../../models/dashboard_products_model.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final String message;
  final HomeStatus status;
  final DashboardProductsModel? dashboardProducts;

  const HomeState({
    this.message = '',
    this.status = HomeStatus.initial,
    this.dashboardProducts,
  });

  HomeState copyWith({
    String? message,
    HomeStatus? status,
    DashboardProductsModel? dashboardProducts,
  }) {
    return HomeState(
      message: message ?? this.message,
      status: status ?? this.status,
      dashboardProducts: dashboardProducts ?? this.dashboardProducts,
    );
  }

  @override
  List<Object?> get props => [message, status, dashboardProducts];
}
