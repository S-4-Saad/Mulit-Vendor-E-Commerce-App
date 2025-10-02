// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:speezu/core/assets/font_family.dart';
// import 'package:speezu/core/utils/labels.dart';
// import 'package:speezu/core/utils/media_querry_extention.dart';
// import 'package:speezu/presentation/faqs/bloc/faqs_bloc.dart';
// import 'package:speezu/presentation/faqs/bloc/faqs_event.dart';
// import 'package:speezu/presentation/faqs/bloc/faqs_state.dart';
// import 'package:speezu/widgets/custom_app_bar.dart';
//
// import '../../widgets/faqs_expention_tile.dart';
//
// class FaqsScreen extends StatelessWidget {
//   const FaqsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: Labels.helpAndSupport),
//       body: BlocProvider(
//         create: (context) => FaqsBloc()..add(FetchFaqsEvent()),
//         child: BlocBuilder<FaqsBloc, FaqsState>(
//           builder: (context, state) {
//             if (state.faqsStatus == FaqsStatus.loading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state.faqsStatus == FaqsStatus.success) {
//               final faqs = state.faqsModel?.data ?? [];
//               return ListView.builder(
//                 itemCount: faqs.length,
//                 itemBuilder: (context, index) {
//                   final faq = faqs[index];
//                   return FaqsExpansionTile(
//                     title: faq.question ?? '',
//                     answer: faq.answer ?? '',
//                   );
//                 },
//               );
//             } else if (state.faqsStatus == FaqsStatus.error) {
//               return Center(child: Text('Error: ${state.message}'));
//             }
//             return const Center(child: Text('No FAQs available.'));
//           },
//         ),
//       ),
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/presentation/faqs/bloc/faqs_bloc.dart';
import 'package:speezu/presentation/faqs/bloc/faqs_event.dart';
import 'package:speezu/presentation/faqs/bloc/faqs_state.dart';
import 'package:speezu/widgets/custom_app_bar.dart';

import '../../widgets/faqs_expention_tile.dart';

class FaqsScreen extends StatelessWidget {
   FaqsScreen({super.key});
   final List<Faq> faqs = [
     Faq(
       question: Labels.faqHowToOrder,
       answer: Labels.faqHowToOrderAnswer,
     ),
     Faq(
       question: Labels.faqTrackOrder,
       answer: Labels.faqTrackOrderAnswer,
     ),
     Faq(
       question: Labels.faqDeliveryTime,
       answer: Labels.faqDeliveryTimeAnswer,
     ),
     Faq(
       question: Labels.faqPaymentMethods,
       answer: Labels.faqPaymentMethodsAnswer,
     ),
     Faq(
       question: Labels.faqCancelOrder,
       answer: Labels.faqCancelOrderAnswer,
     ),
     Faq(
       question: Labels.faqWrongOrDamaged,
       answer: Labels.faqWrongOrDamagedAnswer,
     ),
     Faq(
       question: Labels.faqDeliveryCharges,
       answer: Labels.faqDeliveryChargesAnswer,
     ),
     Faq(
       question: Labels.faqUpdateAddress,
       answer: Labels.faqUpdateAddressAnswer,
     ),
     Faq(
       question: Labels.faqSecurePayments,
       answer: Labels.faqSecurePaymentsAnswer,
     ),
     Faq(
       question: Labels.faqDeliverToMyArea,
       answer: Labels.faqDeliverToMyAreaAnswer,
     ),
     Faq(
       question: Labels.faqCustomerSupport,
       answer: Labels.faqCustomerSupportAnswer,
     ),
   ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Labels.helpAndSupport),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return FaqsExpansionTile(
            title: faq.question ?? '',
            answer: faq.answer ?? '',
          );
        },
      )
    );
  }
}


class Faq {
  final String? question;
  final String? answer;

  Faq({this.question, this.answer});
}
