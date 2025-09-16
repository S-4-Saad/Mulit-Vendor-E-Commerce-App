import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NavBarState extends Equatable {
  final int currentTab;
  final Widget currentPage;
  final Widget shopCurrentPage;
  final int shopCurrentTab;

  const NavBarState({
    required this.currentTab,
    required this.currentPage,
    required this.shopCurrentTab,
    required this.shopCurrentPage
  });

  NavBarState copyWith({
    int? currentTab,
    Widget? currentPage,
    int? shopCurrentTab,
    Widget? shopCurrentPage
  }) {
    return NavBarState(
      currentTab: currentTab ?? this.currentTab,
      currentPage: currentPage ?? this.currentPage,
      shopCurrentTab: shopCurrentTab ?? this.shopCurrentTab,
      shopCurrentPage: shopCurrentPage ?? this.shopCurrentPage
    );
  }

  @override
  List<Object?> get props => [currentTab, currentPage, shopCurrentTab, shopCurrentPage];
}
