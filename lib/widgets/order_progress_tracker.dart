import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:svg_flutter/svg.dart';

import '../core/assets/font_family.dart';
import '../core/utils/labels.dart';

class OrderProgressTracker extends StatelessWidget {
  final bool isFoodOrder;
  final int currentStep;

  const OrderProgressTracker({
    super.key,
    required this.currentStep,
    this.isFoodOrder = false,
  });

  Color _getStepColor(BuildContext context, int stepIndex) {
    if (currentStep >= stepIndex) {
      return Theme.of(context).colorScheme.primary;
    }
    return Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.2);
  }

  Widget _buildStepCircle(
      BuildContext context,
      int stepIndex,
      bool isMobile,
      bool isTablet,
      ) {
    final isCompleted = currentStep > stepIndex;
    final isActive = currentStep == stepIndex;
    final isPending = currentStep < stepIndex;

    final double circleSize = isMobile ? 32 : (isTablet ? 36 : 40);
    final double iconSize = isMobile ? 14 : (isTablet ? 16 : 18);
    final double innerCircleSize = isMobile ? 12 : (isTablet ? 14 : 16);

    if (isCompleted) {
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
              blurRadius: isMobile ? 8 : 12,
              spreadRadius: isMobile ? 1 : 2,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              blurRadius: isMobile ? 4 : 6,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          Icons.check_rounded,
          size: iconSize,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    } else if (isActive) {
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: isMobile ? 3.0 : 3.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
              blurRadius: isMobile ? 12 : 16,
              spreadRadius: isMobile ? 2 : 3,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              blurRadius: isMobile ? 6 : 8,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: innerCircleSize,
            height: innerCircleSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.15),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStepIcon(
      BuildContext context,
      String iconPath,
      int stepIndex,
      bool isMobile,
      bool isTablet,
      ) {
    final isActive = currentStep >= stepIndex;
    final double iconSize = isMobile ? 22 : (isTablet ? 26 : 30);
    final double padding = isMobile ? 8 : (isTablet ? 10 : 12);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: isActive
            ? null
            : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        border: Border.all(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: isActive
            ? [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : [],
      ),
      child: SvgPicture.asset(
        iconPath,
        height: iconSize,
        width: iconSize,
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildStepLabel(
      BuildContext context,
      String label,
      int stepIndex,
      bool isMobile,
      bool isTablet,
      ) {
    final isActive = currentStep >= stepIndex;
    final double fontSize = isMobile ? 9 : (isTablet ? 10 : 11);

    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: isActive
            ? FontFamily.fontsPoppinsSemiBold
            : FontFamily.fontsPoppinsRegular,
        fontSize: fontSize,
        color: isActive
            ? Theme.of(context).colorScheme.onSecondary
            : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.5),
        height: 1.3,
        letterSpacing: 0.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define breakpoints
        final screenWidth = MediaQuery.of(context).size.width;
        final bool isMobile = screenWidth < 600;
        final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
        final bool isLargeTablet = screenWidth >= 1024;

        // Responsive values
        final double horizontalPadding = isMobile ? 8 : (isTablet ? 12 : 16);
        final double verticalPadding = isMobile ? 1 : (isTablet ? 2 : 4);
        final double lineLength = isMobile ? 40 : (isTablet ? 55 : 70);
        final double lineThickness = isMobile ? 3.0 : (isTablet ? 3.5 : 4.0);
        final double labelWidth = isMobile ? 60 : (isTablet ? 70 : 80);
        final double stepSpacing = isMobile ? 8 : (isTablet ? 10 : 12);

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.02),
                Colors.transparent,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.02),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
          ),
          child: EasyStepper(
            activeStep: currentStep,
            activeStepBackgroundColor: Theme.of(context).colorScheme.primary,
            finishedStepBackgroundColor: Theme.of(context).colorScheme.primary,
            unreachedStepBackgroundColor: Theme.of(context).colorScheme.onPrimary,
            internalPadding: 0.0,
            stepShape: StepShape.circle,
            stepBorderRadius: isMobile ? 10 : 12,
            stepRadius: isMobile ? 10 : 12,
            lineStyle: LineStyle(
              lineThickness: lineThickness,
              lineType: LineType.normal,
              lineLength: lineLength,
              defaultLineColor: Theme.of(context)
                  .colorScheme
                  .onSecondary
                  .withValues(alpha: 0.12),
              finishedLineColor: Theme.of(context).colorScheme.primary,
              activeLineColor: Theme.of(context).colorScheme.primary,
              unreachedLineColor: Theme.of(context)
                  .colorScheme
                  .onSecondary
                  .withValues(alpha: 0.12),
            ),
            finishedStepBorderType: BorderType.normal,
            borderThickness: 2,
            steps: [
              EasyStep(
                customStep: _buildStepCircle(context, 0, isMobile, isTablet),
                customTitle: Column(
                  children: [
                    SizedBox(height: stepSpacing),
                    _buildStepIcon(
                      context,
                      AppImages.noteBookIcon,
                      0,
                      isMobile,
                      isTablet,
                    ),
                    SizedBox(height: isMobile ? 6 : 8),
                    SizedBox(
                      width: labelWidth,
                      child: _buildStepLabel(
                        context,
                        Labels.orderPlaced,
                        0,
                        isMobile,
                        isTablet,
                      ),
                    ),
                  ],
                ),
              ),
              EasyStep(
                customStep: _buildStepCircle(context, 1, isMobile, isTablet),
                customTitle: Column(
                  children: [
                    SizedBox(height: stepSpacing),
                    _buildStepIcon(
                      context,
                      isFoodOrder
                          ? AppImages.foodPreparingIcon
                          : AppImages.packageIcon,
                      1,
                      isMobile,
                      isTablet,
                    ),
                    SizedBox(height: isMobile ? 6 : 8),
                    SizedBox(
                      width: labelWidth,
                      child: _buildStepLabel(
                        context,
                        isFoodOrder
                            ? Labels.foodPreparation
                            : Labels.packaging,
                        1,
                        isMobile,
                        isTablet,
                      ),
                    ),
                  ],
                ),
              ),
              EasyStep(
                customStep: _buildStepCircle(context, 2, isMobile, isTablet),
                customTitle: Column(
                  children: [
                    SizedBox(height: stepSpacing),
                    _buildStepIcon(
                      context,
                      AppImages.pickedByRiderIcon,
                      2,
                      isMobile,
                      isTablet,
                    ),
                    SizedBox(height: isMobile ? 6 : 8),
                    SizedBox(
                      width: labelWidth,
                      child: _buildStepLabel(
                        context,
                        Labels.pickedByRider,
                        2,
                        isMobile,
                        isTablet,
                      ),
                    ),
                  ],
                ),
              ),
              EasyStep(
                customStep: _buildStepCircle(context, 3, isMobile, isTablet),
                customTitle: Column(
                  children: [
                    SizedBox(height: stepSpacing),
                    _buildStepIcon(
                      context,
                      AppImages.cycleIcon,
                      3,
                      isMobile,
                      isTablet,
                    ),
                    SizedBox(height: isMobile ? 6 : 8),
                    SizedBox(
                      width: labelWidth,
                      child: _buildStepLabel(
                        context,
                        Labels.outForDelivery,
                        3,
                        isMobile,
                        isTablet,
                      ),
                    ),
                  ],
                ),
              ),
              EasyStep(
                customStep: _buildStepCircle(context, 4, isMobile, isTablet),
                customTitle: Column(
                  children: [
                    SizedBox(height: stepSpacing),
                    _buildStepIcon(
                      context,
                      AppImages.handshakeIcon,
                      4,
                      isMobile,
                      isTablet,
                    ),
                    SizedBox(height: isMobile ? 6 : 8),
                    SizedBox(
                      width: labelWidth,
                      child: _buildStepLabel(
                        context,
                        Labels.delivered,
                        4,
                        isMobile,
                        isTablet,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            stepAnimationCurve: Curves.easeInOut,
            showLoadingAnimation: false,
            showStepBorder: true,
          ),
        );
      },
    );
  }
}