import 'package:equatable/equatable.dart';

abstract class NavBarEvent extends Equatable {
  const NavBarEvent();

  @override
  List<Object?> get props => [];
}

class InitPage extends NavBarEvent {
  final dynamic tab; // can be int or RouteArgument
  const InitPage(this.tab);

  @override
  List<Object?> get props => [tab];
}

class SelectTab extends NavBarEvent {
  final int tabIndex;

  const SelectTab(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}
