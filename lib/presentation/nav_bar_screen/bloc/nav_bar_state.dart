import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NavBarState extends Equatable {
  final int currentTab;
  final Widget currentPage;

  const NavBarState({
    required this.currentTab,
    required this.currentPage,

  });

  NavBarState copyWith({
    int? currentTab,
    Widget? currentPage,
  }) {
    return NavBarState(
      currentTab: currentTab ?? this.currentTab,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [currentTab, currentPage];
}
