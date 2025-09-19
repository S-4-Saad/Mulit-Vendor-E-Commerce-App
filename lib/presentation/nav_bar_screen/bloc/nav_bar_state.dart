import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NavBarState extends Equatable {
  final int currentTab;
  final Widget currentPage;
  final Widget shopCurrentPage;
  final int shopCurrentTab;
  final int? storeId;

  const NavBarState({
    required this.currentTab,
    required this.currentPage,
    required this.shopCurrentTab,
    required this.shopCurrentPage,
    this.storeId,
  });

  NavBarState copyWith({
    int? currentTab,
    Widget? currentPage,
    int? shopCurrentTab,
    Widget? shopCurrentPage,
    int? storeId,
  }) {
    return NavBarState(
      currentTab: currentTab ?? this.currentTab,
      currentPage: currentPage ?? this.currentPage,
      shopCurrentTab: shopCurrentTab ?? this.shopCurrentTab,
      shopCurrentPage: shopCurrentPage ?? this.shopCurrentPage,
      storeId: storeId ?? this.storeId,
    );
  }

  @override
  List<Object?> get props => [currentTab, currentPage, shopCurrentTab, shopCurrentPage, storeId];
}
