import 'package:flutter/material.dart';

import '../core/assets/font_family.dart';

class OptionSelectorWidget extends StatelessWidget {
  final String name;
  final List<dynamic> options;
  final String? selectedOption;
  final void Function(String?) onSelect;

  const OptionSelectorWidget({
    super.key,
    required this.name,
    required this.options,
    required this.selectedOption,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$name:',
          style: TextStyle(
            fontSize: 15,
            fontFamily: FontFamily.fontsPoppinsSemiBold,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
            options.map((option) {
              return GestureDetector(
                onTap: () => onSelect(option),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                    selectedOption == option
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color:
                      selectedOption == option
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSecondary
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color:
                      selectedOption == option
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSecondary
                          .withValues(alpha: .6),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
