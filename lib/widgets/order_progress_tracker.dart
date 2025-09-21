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

  // Map order status to step index (0-based)
  // int _getStepIndex(String status) {
  //   switch (status.toLowerCase()) {
  //     case 'order_placed':
  //       return 0;
  //     case 'packaging':
  //       return 1;
  //     case 'shipped':
  //       return 2;
  //     case 'out for delivery':
  //       return 3;
  //     case 'delivered':
  //       return 4;
  //     default:
  //       return 0; // Default to "Order Placed" if status is unknown
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final int currentStep = currentStep;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EasyStepper(
        activeStep: currentStep,

        activeStepBackgroundColor:
            Theme.of(
              context,
            ).colorScheme.primary, // Blue fill for active step
        finishedStepBackgroundColor:
            Theme.of(
              context,
            ).colorScheme.primary, // Blue fill for completed steps
        internalPadding: 0.0, // No padding between steps
        stepShape: StepShape.circle, // Circular steps
        stepBorderRadius: 20, // Rounded circles
        stepRadius: 10, // Size of the step circles
        lineStyle: LineStyle(
          lineThickness: 3.0, // Thin line for a clean look
          lineType: LineType.normal, // Straight line
          lineLength: 70.0, // Adjust line length for responsiveness
          defaultLineColor: Theme.of(context).colorScheme.primary.withValues(
            alpha: 0.2,
          ), // Light blue for uncompleted steps
          finishedLineColor:
              Theme.of(
                context,
              ).colorScheme.primary, // Blue for completed steps
        ),
        finishedStepBorderType:
            BorderType
                .normal, // Circular border for completed steps (no border needed since filled)
        steps: [
          EasyStep(
            icon:
                currentStep >= 0
                    ? Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ) // Check icon for completed
                    : null, // No icon for unactive (handled by default styling)
            customStep:
                currentStep >= 0
                    ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.primary, // Blue fill for completed
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                    : Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              Theme.of(context)
                                  .colorScheme
                                  .primary, // Blue border for unactive
                          width: 2.0,
                        ),
                      ),
                    ),
            customTitle: Column(
              children: [
                SizedBox(height: 5.0),
                SvgPicture.asset(
                  AppImages.noteBookIcon,
                  height: 25,
                  width: 25,
                  color:
                      currentStep >= 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 18.0),
                    Text(
                      Labels.orderPlaced,
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsMedium,
                        fontSize: 8,
                        color:
                            currentStep >= 0
                                ? Theme.of(context).colorScheme.onSecondary
                                : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          EasyStep(
            icon:
                currentStep >= 1
                    ? Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ) // Check icon for completed
                    : null,
            customStep:
                currentStep >= 1
                    ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.primary, // Blue fill for completed
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                    : Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              Theme.of(context)
                                  .colorScheme
                                  .primary, // Blue border for unactive
                          width: 2.0,
                        ),
                      ),
                    ),
            customTitle: Column(
              children: [
                SizedBox(height: 5.0),
                SvgPicture.asset(
                  isFoodOrder ? AppImages.foodPreparingIcon :
                  AppImages.packageIcon,
                  height: 25,
                  width: 30,
                  color:
                      currentStep >= 1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                ),
                SizedBox(height: 5.0),
                Text(
                  isFoodOrder ? Labels.foodPreparation :
                  Labels.packaging,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsMedium,
                    fontSize: 8,
                    color:
                        currentStep >= 1
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          EasyStep(
            icon:
                currentStep >= 2
                    ? Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ) // Check icon for completed
                    : null,
            customStep:
                currentStep >= 2
                    ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.primary, // Blue fill for completed
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                    : Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              Theme.of(context)
                                  .colorScheme
                                  .primary, // Blue border for unactive
                          width: 2.0,
                        ),
                      ),
                    ),
            customTitle: Column(
              children: [
                SizedBox(height: 5.0),
                SvgPicture.asset(
                  AppImages.pickedByRiderIcon,
                  height: 25,
                  width: 25,
                  color:
                      currentStep >= 2
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                ),
                SizedBox(height: 5.0),
                Text(
                  Labels.pickedByRider,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsMedium,
                    fontSize: 8,
                    color:
                        currentStep >= 2
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          EasyStep(
            icon:
                currentStep >= 3
                    ? Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ) // Check icon for completed
                    : null,
            customStep:
                currentStep >= 3
                    ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.primary, // Blue fill for completed
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                    : Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              Theme.of(context)
                                  .colorScheme
                                  .primary, // Blue border for unactive
                          width: 2.0,
                        ),
                      ),
                    ),
            customTitle: Column(
              children: [
                SizedBox(height: 5.0),
                SvgPicture.asset(
                  AppImages.cycleIcon,
                  height: 25,
                  width: 25,
                  color:
                      currentStep >= 3
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                ),
                SizedBox(height: 5.0),
                Text(
                  Labels.outForDelivery,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsMedium,
                    fontSize: 8,
                    color:
                        currentStep >= 3
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          EasyStep(
            icon:
                currentStep >= 4
                    ? Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ) // Check icon for completed
                    : null,
            customStep:
                currentStep >= 4
                    ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.primary, // Blue fill for completed
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                    : Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              Theme.of(context)
                                  .colorScheme
                                  .primary, // Blue border for unactive
                          width: 2.0,
                        ),
                      ),
                    ),
            customTitle: Column(
              children: [
                SizedBox(height: 5.0),
                SvgPicture.asset(
                  AppImages.handshakeIcon,
                  height: 25,
                  width: 25,
                  color:
                      currentStep >= 4
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                ),
                SizedBox(height: 5.0),
                Text(
                  Labels.delivered,
                  style: TextStyle(
                    fontFamily: FontFamily.fontsPoppinsMedium,
                    fontSize: 8,
                    color:
                        currentStep >= 4
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
        stepAnimationCurve:
            Easing.standard, // Smooth animation for active steps
        showLoadingAnimation: false, // No loading animation
        showStepBorder: true, // No step numbers, just icons
      ),
    );
  }
}
