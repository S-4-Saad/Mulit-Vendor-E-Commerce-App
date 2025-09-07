import 'package:equatable/equatable.dart';
import 'package:speezu/models/faqs_model.dart';

enum FaqsStatus { initial, loading, success, error }

class FaqsState extends Equatable {
  final String message;
  final FaqsStatus faqsStatus;
  final FaqsModel? faqsModel; // Store the full response here

  const FaqsState({
    this.message = '',
    this.faqsStatus = FaqsStatus.initial,
    this.faqsModel,
  });

  FaqsState copyWith({
    String? message,
    FaqsStatus? faqsStatus,
    FaqsModel? faqsModel,
  }) {
    return FaqsState(
      message: message ?? this.message,
      faqsStatus: faqsStatus ?? this.faqsStatus,
      faqsModel: faqsModel ?? this.faqsModel,
    );
  }

  @override
  String toString() {
    return 'FaqsState(message: $message, faqsStatus: $faqsStatus, faqsModel: $faqsModel)';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [message, faqsStatus, faqsModel];
}
