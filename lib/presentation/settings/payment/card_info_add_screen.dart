import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/theme/theme_bloc/theme_bloc.dart';
import 'package:speezu/core/utils/media_querry_extention.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/models/card_details_model.dart';
import 'package:speezu/repositories/user_repository.dart';

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
  
  bool _hasExistingCard = false;
  CardDetailsModel? _existingCard;
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadExistingCard();
  }

  void _loadExistingCard() {
    final existingCard = _userRepository.cardDetails;
    if (existingCard != null) {
      setState(() {
        _hasExistingCard = true;
        _existingCard = existingCard;
        _populateForm(existingCard);
      });
    }
  }

  void _populateForm(CardDetailsModel card) {
    cardNumber = card.cardNumber ?? '';
    cardHolderName = card.cardHolderName ?? '';
    cvvCode = card.cvv ?? '';
    
    // Format expiry date from month/year
    if (card.expiryMonth != null && card.expiryYear != null) {
      expiryDate = '${card.expiryMonth}/${card.expiryYear}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _hasExistingCard ? 'Edit Card' : Labels.addNewCard),
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
                                  _hasExistingCard ? 'Update Card' : Labels.save,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: context.scaledFont(13),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            
                            // Delete Card Button (only if card exists)
                            if (_hasExistingCard) ...[
                              SizedBox(height: context.heightPct(0.02)),
                              SizedBox(
                                width: context.widthPct(0.8),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    CardDialogs.showDeleteCardDialog(
                                      context: context,
                                      onDelete: () async {
                                        // Close dialog first
                                        Navigator.of(context).pop();
                                        // Then delete the card
                                        await _deleteCard();
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Delete Card',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: context.scaledFont(13),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  void _onValidate() async {
    if (formKey.currentState?.validate() ?? false) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        // Parse expiry date (MM/YY format)
        final expiryParts = expiryDate.split('/');
        final expiryMonth = expiryParts.isNotEmpty ? expiryParts[0] : '';
        final expiryYear = expiryParts.length > 1 ? expiryParts[1] : '';

        // Detect card type based on card number
        String cardType = 'visa'; // Default
        if (cardNumber.startsWith('4')) {
          cardType = 'visa';
        } else if (cardNumber.startsWith('5') || cardNumber.startsWith('2')) {
          cardType = 'mastercard';
        } else if (cardNumber.startsWith('3')) {
          cardType = 'american express';
        }

        // Create card model
        final card = CardDetailsModel(
          id: _existingCard?.id, // Keep existing ID if updating
          cardNumber: cardNumber.replaceAll(' ', ''),
          cardHolderName: cardHolderName.trim(),
          expiryMonth: expiryMonth,
          expiryYear: expiryYear,
          cvv: cvvCode.trim(),
          cardType: cardType,
          isDefault: true,
        );

        bool success;
        if (_hasExistingCard) {
          success = await _userRepository.updateCard(card);
        } else {
          success = await _userRepository.setCardAndSync(card);
        }

        // Close loading dialog
        Navigator.pop(context);

        if (success) {
          // Show success message and go back
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_hasExistingCard 
                  ? 'Card updated successfully!' 
                  : 'Card added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to ${_hasExistingCard ? 'update' : 'add'} card. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Close loading dialog
        Navigator.pop(context);

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  Future<void> _deleteCard() async {
    try {
      final success = await _userRepository.removeCard();
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Card deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to settings
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete card. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class CardDialogs {
  static void showDeleteCardDialog({
    required BuildContext context,
    required VoidCallback onDelete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Delete Card',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: FontFamily.fontsPoppinsSemiBold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
                // Message
                Text(
                  'Are you sure you want to delete this card? This action cannot be undone.',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: FontFamily.fontsPoppinsRegular,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        Labels.cancel,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    // Delete Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                      ),
                      onPressed: () {
                        onDelete();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
