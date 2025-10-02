import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/models/card_details_model.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/routes/route_names.dart';

class SavedCardSelectionWidget extends StatefulWidget {
  final Function(CardDetailsModel?) onCardSelected;
  final CardDetailsModel? selectedCard;

  const SavedCardSelectionWidget({
    super.key,
    required this.onCardSelected,
    this.selectedCard,
  });

  @override
  State<SavedCardSelectionWidget> createState() => _SavedCardSelectionWidgetState();
}

class _SavedCardSelectionWidgetState extends State<SavedCardSelectionWidget> {
  final UserRepository _userRepository = UserRepository();
  CardDetailsModel? _savedCard;

  @override
  void initState() {
    super.initState();
    _loadSavedCard();
  }

  void _loadSavedCard() {
    _savedCard = _userRepository.cardDetails;
    if (_savedCard != null) {
      // Auto-select saved card if available
      // Defer the callback to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onCardSelected(_savedCard);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Payment Method',
          style: TextStyle(
            fontFamily: FontFamily.fontsPoppinsSemiBold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        const SizedBox(height: 12),

        // Card Details Display (if saved card exists)
        if (_savedCard != null) ...[
          _buildCardDetails(),
        ],

        // No saved card message (if no card exists)
        if (_savedCard == null) ...[
          _buildNoCardMessage(),
        ],
      ],
    );
  }

  Widget _buildCardDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header with Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _getCardIcon(_savedCard!.cardType ?? ''),
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Saved Card',
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  // Navigate to edit card screen
                  Navigator.pushNamed(context, RouteNames.cardInfoAddScreen);
                },
                icon: Icon(
                  Icons.edit,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  'Edit',
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsMedium,
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Card Number
          Row(
            children: [
              Icon(
                Icons.credit_card,
                color: Theme.of(context).colorScheme.outline,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                _savedCard!.getMaskedCardNumber(),
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsMedium,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Card Holder and Expiry
          Row(
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.outline,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                _savedCard!.cardHolderName ?? 'Card Holder',
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.calendar_today,
                color: Theme.of(context).colorScheme.outline,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Expires ${_savedCard!.getFormattedExpiry()}',
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoCardMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.credit_card_off,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'No Saved Card',
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsSemiBold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add a card to proceed with payment',
            style: TextStyle(
              fontFamily: FontFamily.fontsPoppinsRegular,
              fontSize: 14,
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add card screen
              Navigator.pushNamed(context, RouteNames.cardInfoAddScreen);
            },
            icon: Icon(
              Icons.add_card,
              size: 18,
              color: Colors.white,
            ),
            label: Text(
              'Add Card',
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsMedium,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCardIcon(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Icons.credit_card; // You can replace with Visa icon
      case 'mastercard':
        return Icons.credit_card; // You can replace with Mastercard icon
      case 'american express':
        return Icons.credit_card; // You can replace with Amex icon
      default:
        return Icons.credit_card;
    }
  }
}
