import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/theme/theme_bloc/theme_bloc.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/widgets/custom_app_bar.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/labels.dart';

class CardInfoAddScreen extends StatefulWidget {
  const CardInfoAddScreen({super.key});

  @override
  State<StatefulWidget> createState() => CardInfoAddScreenState();
}

class CardInfoAddScreenState extends State<CardInfoAddScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;

  bool useFloatingAnimation = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Labels.addNewCard),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            height: context.heightPct(1),
            width: context.widthPct(1),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage(
                  context.read<ThemeBloc>().state.themeMode ==
                          AppThemeMode.light
                      ? AppImages.cardBgLight
                      : AppImages.cardBgDark,

                ),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      CreditCardWidget(
                        enableFloatingCard: useFloatingAnimation,
                        glassmorphismConfig: _getGlassmorphismConfig(),
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        bankName: 'Axis Bank',
                        frontCardBorder:
                            useGlassMorphism
                                ? null
                                : Border.all(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                        backCardBorder:
                            useGlassMorphism
                                ? null
                                : Border.all(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                        showBackView: isCvvFocused,
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        isHolderNameVisible: true,

                        backgroundImage: AppImages.cardBg,
                        isSwipeGestureEnabled: true,
                        onCreditCardWidgetChange:
                            (CreditCardBrand creditCardBrand) {},
                        customCardTypeIcons: <CustomCardTypeIcon>[
                          CustomCardTypeIcon(
                            cardType: CardType.mastercard,
                            cardImage: Image.asset(
                              AppImages.cardMastercard,
                              height: 48,
                              width: 48,
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            CreditCardForm(
                              formKey: formKey,
                              obscureCvv: false,
                              obscureNumber: true,
                              cardNumber: cardNumber,
                              cvvCode: cvvCode,
                              isHolderNameVisible: true,
                              isCardHolderNameUpperCase: true,
                              isCardNumberVisible: true,
                              isExpiryDateVisible: true,
                              cardHolderName: cardHolderName,
                              expiryDate: expiryDate,
                              inputConfiguration: InputConfiguration(
                                cardNumberDecoration: InputDecoration(
                                  labelText: Labels.number,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary
                                          .withValues(alpha: .7),
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                  hintStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),

                                  hintText: 'XXXX XXXX XXXX XXXX',
                                ),
                                expiryDateDecoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary
                                          .withValues(alpha: .7),
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  labelText: Labels.expiredDate,
                                  labelStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                  hintStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                  hintText: 'XX/XX',
                                ),
                                cvvCodeDecoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary
                                          .withValues(alpha: .7),
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  labelText: Labels.cvv,
                                  labelStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                  hintStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                  hintText: 'XXX',
                                ),
                                cardHolderDecoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary
                                          .withValues(alpha: .7),
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  labelText: Labels.holderName,
                                  labelStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                  hintStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                  // hintText: 'Card Holder',
                                ),
                              ),
                              onCreditCardModelChange: onCreditCardModelChange,
                            ),
                            SizedBox(height: context.heightPct(0.02)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    Labels.glassmorphism,
                                    style: TextStyle(
                                      fontFamily:
                                          FontFamily.fontsPoppinsSemiBold,
                                      fontSize: context.scaledFont(13),
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Switch(
                                    value: useGlassMorphism,
                                    inactiveTrackColor:
                                        Theme.of(context).colorScheme.outline,
                                    inactiveThumbColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    activeColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    activeTrackColor:
                                        Theme.of(context).colorScheme.primary,
                                    onChanged:
                                        (bool value) => setState(() {
                                          useGlassMorphism = value;
                                        }),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    Labels.floatingCard,
                                    style: TextStyle(
                                      fontFamily:
                                          FontFamily.fontsPoppinsSemiBold,
                                      fontSize: context.scaledFont(13),
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Switch(
                                    value: useFloatingAnimation,
                                    inactiveTrackColor:
                                        Theme.of(context).colorScheme.outline,
                                    inactiveThumbColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    activeColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    activeTrackColor:
                                        Theme.of(context).colorScheme.primary,
                                    onChanged:
                                        (bool value) => setState(() {
                                          useFloatingAnimation = value;
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: context.heightPct(0.04)),
                            SizedBox(
                              width: context.widthPct(0.8),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    // horizontal: 50,
                                    vertical: 13,
                                  ),

                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: _onValidate,
                                child: Text(
                                  Labels.save,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: context.scaledFont(13),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');
      print(cardNumber);
      print(expiryDate);
      print(cardHolderName);
      print(cvvCode);
    } else {
      print('invalid!');
    }
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.red.withAlpha(5000), Colors.red.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return context.read<ThemeBloc>().state.themeMode == AppThemeMode.light
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
