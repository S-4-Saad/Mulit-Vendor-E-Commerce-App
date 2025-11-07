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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth >= 600;
        final isLargeTablet = screenWidth >= 900;

        // Responsive values
        final labelFontSize = isLargeTablet ? 17.0 : (isTablet ? 16.0 : 15.0);
        final optionFontSize = isLargeTablet ? 15.0 : (isTablet ? 14.0 : 13.0);
        final horizontalPadding = isLargeTablet ? 18.0 : (isTablet ? 16.0 : 14.0);
        final verticalPadding = isLargeTablet ? 10.0 : (isTablet ? 9.0 : 8.0);
        final spacing = isTablet ? 12.0 : 10.0;
        final runSpacing = isTablet ? 12.0 : 10.0;
        final borderRadius = isTablet ? 12.0 : 10.0;
        final labelSpacing = isTablet ? 12.0 : 10.0;
        final checkIconSize = isTablet ? 16.0 : 14.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$name:',
              style: TextStyle(
                fontSize: labelFontSize,
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                color: Theme.of(context).colorScheme.onSecondary,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: labelSpacing),
            Expanded(
              child: Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: options.map((option) {
                  final isSelected = selectedOption == option;

                  return GestureDetector(
                    onTap: () => onSelect(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic,
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        color: isSelected
                            ? null
                            : Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                              : Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withValues(alpha: 0.2),
                          width: isSelected ? 2.0 : 1.5,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.4),
                              blurRadius: isTablet ? 12 : 10,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          if (!isSelected)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: isTablet ? 6 : 4,
                              offset: const Offset(0, 2),
                              spreadRadius: 0,
                            ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected) ...[
                            AnimatedScale(
                              scale: isSelected ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.check_circle,
                                size: checkIconSize,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(width: isTablet ? 6 : 5),
                          ],
                          Text(
                            option,
                            style: TextStyle(
                              fontSize: optionFontSize,
                              fontFamily: isSelected
                                  ? FontFamily.fontsPoppinsSemiBold
                                  : FontFamily.fontsPoppinsRegular,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withValues(alpha: .7),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}