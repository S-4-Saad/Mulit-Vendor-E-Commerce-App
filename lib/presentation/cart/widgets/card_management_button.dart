import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/models/card_details_model.dart';
import 'package:speezu/repositories/user_repository.dart';
import 'package:speezu/presentation/settings/payment/card_info_add_screen.dart';

class CardManagementButton extends StatelessWidget {
  final VoidCallback? onCardChanged;

  const CardManagementButton({
    super.key,
    this.onCardChanged,
  });

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = UserRepository();
    final CardDetailsModel? savedCard = userRepository.cardDetails;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardInfoAddScreen(),
                  ),
                );
                
                if (result == true && onCardChanged != null) {
                  onCardChanged!();
                }
              },
              icon: Icon(
                savedCard != null ? Icons.edit : Icons.add,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                savedCard != null ? 'Edit Card' : 'Add Card',
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          if (savedCard != null) ...[
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () async {
                // Show confirmation dialog
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Remove Card'),
                    content: Text('Are you sure you want to remove your saved card?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Remove'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await userRepository.removeCard();
                  if (onCardChanged != null) {
                    onCardChanged!();
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Card removed successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.delete_outline,
                size: 16,
                color: Colors.red,
              ),
              label: Text(
                'Remove',
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
