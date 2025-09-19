import 'package:equatable/equatable.dart';

class OrderState extends Equatable {
  final int selectedTabIndex;
  const OrderState({this.selectedTabIndex = 0});

  OrderState copyWith({int? selectedTabIndex}) {
    return OrderState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [selectedTabIndex];
}
