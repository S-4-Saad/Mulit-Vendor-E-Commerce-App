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

  Widget _buildStepCircle(BuildContext context, int stepIndex) {
    final isCompleted = currentStep > stepIndex;
    final isActive = currentStep == stepIndex;
    final isPending = currentStep < stepIndex;

    if (isCompleted) {
      return Container(
        width: 32,
        height: 32,
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
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          Icons.check_rounded,
          size: 14,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    } else if (isActive) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 3.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.2),
            width: 2.0,
          ),
        ),
      );
    }
  }

  Widget _buildStepIcon(BuildContext context, String iconPath, int stepIndex) {
    final isActive = currentStep >= stepIndex;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        iconPath,
        height: 24,
        width: 24,
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildStepLabel(BuildContext context, String label, int stepIndex) {
    final isActive = currentStep >= stepIndex;

    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: isActive
            ? FontFamily.fontsPoppinsSemiBold
            : FontFamily.fontsPoppinsRegular,
        fontSize: 9,
        color: isActive
            ? Theme.of(context).colorScheme.onSecondary
            : Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.5),
        height: 1.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      child: EasyStepper(
        activeStep: currentStep,
        activeStepBackgroundColor: Theme.of(context).colorScheme.primary,
        finishedStepBackgroundColor: Theme.of(context).colorScheme.primary,
        unreachedStepBackgroundColor: Theme.of(context).colorScheme.onPrimary,
        internalPadding: 0.0,
        stepShape: StepShape.circle,
        stepBorderRadius: 10,
        stepRadius: 10,
        lineStyle: LineStyle(
          lineThickness: 3.0,
          lineType: LineType.normal,
          lineLength: 50.0,
          defaultLineColor: Theme.of(context)
              .colorScheme
              .onSecondary
              .withValues(alpha: 0.15),
          finishedLineColor: Theme.of(context).colorScheme.primary,
          activeLineColor: Theme.of(context).colorScheme.primary,
          unreachedLineColor: Theme.of(context)
              .colorScheme
              .onSecondary
              .withValues(alpha: 0.15),
        ),
        finishedStepBorderType: BorderType.normal,
        borderThickness: 2,
        steps: [
          EasyStep(
            customStep: _buildStepCircle(context, 0),
            customTitle: Column(
              children: [
                const SizedBox(height: 8),
                _buildStepIcon(context, AppImages.noteBookIcon, 0),
                const SizedBox(height: 6),
                SizedBox(
                  width: 60,
                  child: _buildStepLabel(context, Labels.orderPlaced, 0),
                ),
              ],
            ),
          ),
          EasyStep(
            customStep: _buildStepCircle(context, 1),
            customTitle: Column(
              children: [
                const SizedBox(height: 8),
                _buildStepIcon(
                  context,
                  isFoodOrder ? AppImages.foodPreparingIcon : AppImages.packageIcon,
                  1,
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 60,
                  child: _buildStepLabel(
                    context,
                    isFoodOrder ? Labels.foodPreparation : Labels.packaging,
                    1,
                  ),
                ),
              ],
            ),
          ),
          EasyStep(
            customStep: _buildStepCircle(context, 2),
            customTitle: Column(
              children: [
                const SizedBox(height: 8),
                _buildStepIcon(context, AppImages.pickedByRiderIcon, 2),
                const SizedBox(height: 6),
                SizedBox(
                  width: 60,
                  child: _buildStepLabel(context, Labels.pickedByRider, 2),
                ),
              ],
            ),
          ),
          EasyStep(
            customStep: _buildStepCircle(context, 3),
            customTitle: Column(
              children: [
                const SizedBox(height: 8),
                _buildStepIcon(context, AppImages.cycleIcon, 3),
                const SizedBox(height: 6),
                SizedBox(
                  width: 60,
                  child: _buildStepLabel(context, Labels.outForDelivery, 3),
                ),
              ],
            ),
          ),
          EasyStep(
            customStep: _buildStepCircle(context, 4),
            customTitle: Column(
              children: [
                const SizedBox(height: 8),
                _buildStepIcon(context, AppImages.handshakeIcon, 4),
                const SizedBox(height: 6),
                SizedBox(
                  width: 60,
                  child: _buildStepLabel(context, Labels.delivered, 4),
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
  }
}