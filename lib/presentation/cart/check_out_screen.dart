import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/core/utils/snackbar_helper.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/image_type_extention.dart';
import '../../core/utils/currency_icon.dart';
import '../../core/utils/labels.dart';
import '../../routes/route_names.dart';
import '../../widgets/dialog_boxes/order_success_dialog.dart';
import '../../widgets/shimmer/address_shimmer.dart';
import '../settings/add_address_screen.dart';
import 'bloc/cart_bloc.dart';
import 'bloc/cart_state.dart';
import 'bloc/cart_event.dart';
import '../../models/address_model.dart';
import '../../models/card_details_model.dart';
import '../../repositories/user_repository.dart';
import '../../core/services/paystack_service.dart';
import '../../models/payment_model.dart';
import 'widgets/saved_card_selection_widget.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final UserRepository _userRepository = UserRepository();
  final PaystackService _paystackService = PaystackService();
  final TextEditingController _deliveryInstructionsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePaystack();
    // Load addresses using CartBloc
    context.read<CartBloc>().loadAddresses();
    context.read<CartBloc>().add(ResetCartStatus());
  }

  @override
  void dispose() {
    _deliveryInstructionsController.dispose();
    super.dispose();
  }

  Future<void> _initializePaystack() async {
    try {
      await _paystackService.initialize(PaystackConfig.defaultConfig);
      print('Paystack initialized successfully');
    } catch (e) {
      print('Failed to initialize Paystack: $e');
      // Show error to user if initialization fails
      if (mounted) {
        SnackBarHelper.showError(
          context,
          Labels.paymentIntegrationNotAvailable,
        );
      }
    }
  }

  void _handlePickupOrder() {
    // Post order using CartBloc
    context.read<CartBloc>().add(
      PostOrder(
        paymentMethod: 'Store Payment',
        paymentResult: null,
        selectedCard: null,
      ),
    );
  }

  void _handleDeliveryOrder(
    String paymentMethod,
    PaymentResult? paymentResult,
    CardDetailsModel? selectedCard,
  ) {
    // Post order using CartBloc
    context.read<CartBloc>().add(
      PostOrder(
        paymentMethod: paymentMethod,
        paymentResult: paymentResult,
        selectedCard: selectedCard,
      ),
    );
  }

  void _showOrderSuccessDialog(BuildContext context) {
    OrderSuccessDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state.status == CartStatus.success &&
            state.orderPlacedSuccessfully) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteNames.navBarScreen,
            (Route<dynamic> route) => false,
          );
          _showOrderSuccessDialog(context);
        } else if (state.status == CartStatus.error) {
          SnackBarHelper.showError(
            context,
            state.errorMessage ?? Labels.somethingWentWrongPleaseTryAgain,
          );
        }
      },
      builder: (context, state) {
        // Check if delivery is allowed based on cart contents
        final isDeliveryAllowed = state.cart.currentDeliveryStatus ?? true;

        // Auto-select pickup if cart has non-deliverable products and no method is selected
        if (!isDeliveryAllowed && state.selectedMethod == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.read<CartBloc>().add(
                SetCheckoutMethod(method: CheckoutMethod.pickup),
              );
            }
          });
        }

        // Force pickup if non-deliverable and delivery was somehow selected
        if (!isDeliveryAllowed &&
            state.selectedMethod == CheckoutMethod.delivery) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.read<CartBloc>().add(
                SetCheckoutMethod(method: CheckoutMethod.pickup),
              );
            }
          });
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(title: Labels.checkout),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// ---------- PICKUP SECTION ----------
                  _buildSectionHeader(
                    context,
                    icon: Icons.store_mall_directory_rounded,
                    title: Labels.pickUp,
                    subtitle: Labels.pickUpYouItemFromStore,
                  ),

                  const SizedBox(height: 12),

                  _buildPickupCard(context, state),

                  const SizedBox(height: 28),

                  /// ---------- DELIVERY SECTION ----------
                  _buildSectionHeader(
                    context,
                    icon: Icons.local_shipping_rounded,
                    title: Labels.delivery,
                    subtitle:
                        isDeliveryAllowed
                            ? Labels.itemDeliverToYourAddress
                            : Labels.notDeliverable,
                    trailing:
                        isDeliveryAllowed
                            ? IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder:
                                      (context) => DeliveryAddressBottomSheet(
                                        onAddressSelected: (address) {
                                          context.read<CartBloc>().add(
                                            SetSelectedAddress(
                                              address: address,
                                            ),
                                          );
                                        },
                                        currentAddress: state.selectedAddress,
                                        addresses: state.addresses,
                                      ),
                                );
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.edit_rounded,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                            : null,
                  ),

                  const SizedBox(height: 12),

                  // Show disabled message for non-deliverable products
                  if (!isDeliveryAllowed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'These products are only available for pickup',
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsRegular,
                                  color: Colors.orange.shade900,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  state.addressLoadStatus == AddressLoadStatus.loading
                      ? const Center(child: AddressShimmerTile())
                      : state.addresses.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              Labels.noAddressesFoundPleaseAddAnAddress,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      )
                      : _buildDeliveryCard(context, state, isDeliveryAllowed),

                  // Delivery Instructions Field
                  if (state.selectedMethod == CheckoutMethod.delivery &&
                      isDeliveryAllowed) ...[
                    const SizedBox(height: 20),
                    _buildDeliveryInstructions(context),
                  ],

                  SizedBox(height: 20),

                  /// ---------- SUMMARY & CHECKOUT BUTTON ----------
                  _buildCheckoutSummary(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  // Enhanced Pickup Card
  Widget _buildPickupCard(BuildContext context, CartState state) {
    final isSelected = state.selectedMethod == CheckoutMethod.pickup;

    return InkWell(
      onTap: () {
        context.read<CartBloc>().add(
          SetCheckoutMethod(method: CheckoutMethod.pickup),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.08)
                  : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        child: Row(
          children: [
            // Store Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageView(
                imagePath: AppImages.storeImage,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Labels.pickUpFromStore,
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Labels.youShouldPayAtTheStore,
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Radio Button
            Radio<CheckoutMethod>(
              value: CheckoutMethod.pickup,
              groupValue: state.selectedMethod,
              onChanged:
                  (value) => context.read<CartBloc>().add(
                    SetCheckoutMethod(method: value!),
                  ),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Delivery Card
  Widget _buildDeliveryCard(
    BuildContext context,
    CartState state,
    bool isDeliveryAllowed,
  ) {
    final isSelected = state.selectedMethod == CheckoutMethod.delivery;

    return Opacity(
      opacity: isDeliveryAllowed ? 1.0 : 0.5,
      child: InkWell(
        onTap:
            isDeliveryAllowed
                ? () {
                  context.read<CartBloc>().add(
                    SetCheckoutMethod(method: CheckoutMethod.delivery),
                  );
                }
                : null,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:
                isSelected && isDeliveryAllowed
                    ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.08)
                    : !isDeliveryAllowed
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isSelected && isDeliveryAllowed
                      ? Theme.of(context).colorScheme.primary
                      : !isDeliveryAllowed
                      ? Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.3)
                      : Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
              width: isSelected ? 2 : 1.5,
            ),
            boxShadow:
                isSelected && isDeliveryAllowed
                    ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15),
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
          ),
          child: Row(
            children: [
              // Address Icon
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:
                      isDeliveryAllowed
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.12)
                          : Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 28,
                  color:
                      isDeliveryAllowed
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(width: 14),

              // Address Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.selectedAddress?.title ?? "Delivery Address",
                      style: TextStyle(
                        fontFamily: FontFamily.fontsPoppinsSemiBold,
                        color:
                            isDeliveryAllowed
                                ? Theme.of(context).colorScheme.onSecondary
                                : Theme.of(context).colorScheme.outline,
                        fontSize: 15,
                      ),
                    ),
                    if (state.selectedAddress != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.selectedAddress!.address ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 14,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${state.selectedAddress!.customerName ?? ''} • ${state.selectedAddress!.primaryPhoneNumber ?? ''}',
                              style: TextStyle(
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(
                        Labels.selectDeliveryAddress,
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Radio Button
              Radio<CheckoutMethod>(
                value: CheckoutMethod.delivery,
                groupValue: state.selectedMethod,
                onChanged:
                    isDeliveryAllowed
                        ? (value) => context.read<CartBloc>().add(
                          SetCheckoutMethod(method: value!),
                        )
                        : null,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Delivery Instructions Field
  Widget _buildDeliveryInstructions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.note_alt_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              Labels.deliveryInstructionsOptional,
              style: TextStyle(
                fontSize: 15,
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _deliveryInstructionsController,
          maxLines: 3,
          onChanged: (value) {
            context.read<CartBloc>().add(
              SetDeliveryInstructions(instructions: value),
            );
          },
          style: TextStyle(
            fontSize: 14,
            fontFamily: FontFamily.fontsPoppinsRegular,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          decoration: InputDecoration(
            hintText: Labels.addSpecialInstructionsForDeliveryPerson,
            hintStyle: TextStyle(
              fontSize: 13,
              fontFamily: FontFamily.fontsPoppinsRegular,
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }

  // Enhanced Summary Section
  Widget _buildCheckoutSummary(BuildContext context, CartState state) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Labels.summary,
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.1),
            ),

            // Summary Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSummaryRow(
                    context,
                    label:
                        '${Labels.itemsTotal} (${state.totalItems} ${state.totalItems == 1 ? Labels.item : '${Labels.item}s'})',
                    value:
                        '${CurrencyIcon.currencyIcon}${state.subtotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 10),
                  _buildSummaryRow(
                    context,
                    label: Labels.deliveryFee,
                    value:
                        '${CurrencyIcon.currencyIcon} ${state.deliveryFee.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 10),
                  _buildSummaryRow(
                    context,
                    label: Labels.tax,
                    value:
                        '${CurrencyIcon.currencyIcon} ${state.taxAmount.toStringAsFixed(2)}',
                  ),
                  if (state.couponStatus == CouponStatus.success) ...[
                    const SizedBox(height: 10),
                    _buildSummaryRow(
                      context,
                      label: Labels.couponDiscount,
                      value:
                          '-${CurrencyIcon.currencyIcon}${state.couponModel?.data?.maxDiscount?.toStringAsFixed(2)}',
                      valueColor: Colors.green,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Divider
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
                  ),

                  const SizedBox(height: 12),

                  // Grand Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Labels.grandTotal,
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '${CurrencyIcon.currencyIcon} ${state.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsBold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Place Order Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            state.selectedMethod != null
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: 0.5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed:
                          state.selectedMethod != null &&
                                  state.status != CartStatus.loading
                              ? () {
                                if (state.selectedMethod ==
                                    CheckoutMethod.delivery) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return PaymentMethodBottomSheet(
                                        onOrderConfirmed: _handleDeliveryOrder,
                                        paystackService: _paystackService,
                                        totalAmount: state.totalAmount,
                                        userEmail:
                                            _userRepository
                                                .currentUser
                                                ?.userData
                                                ?.email ??
                                            'user@example.com',
                                      );
                                    },
                                  );
                                } else if (state.selectedMethod ==
                                    CheckoutMethod.pickup) {
                                  _handlePickupOrder();
                                }
                              }
                              : null,
                      child:
                          state.status == CartStatus.loading
                              ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    Labels.placingYourOrder,
                                    style: TextStyle(
                                      fontFamily:
                                          FontFamily.fontsPoppinsSemiBold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              )
                              : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    Labels.placeOrder,
                                    style: TextStyle(
                                      fontFamily:
                                          FontFamily.fontsPoppinsSemiBold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded, size: 20),
                                ],
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Summary Row Widget
  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.fontsPoppinsRegular,
            color: Theme.of(
              context,
            ).colorScheme.onSecondary.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: FontFamily.fontsPoppinsMedium,
            color: valueColor ?? Theme.of(context).colorScheme.onSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class DeliveryAddressBottomSheet extends StatefulWidget {
  final Function(AddressModel) onAddressSelected;
  final AddressModel? currentAddress;
  final List<AddressModel> addresses;

  const DeliveryAddressBottomSheet({
    super.key,
    required this.onAddressSelected,
    this.currentAddress,
    required this.addresses,
  });

  @override
  State<DeliveryAddressBottomSheet> createState() =>
      _DeliveryAddressBottomSheetState();
}

class _DeliveryAddressBottomSheetState
    extends State<DeliveryAddressBottomSheet> {
  int selectedIndex = -1; // no selection initially

  @override
  void initState() {
    super.initState();
    print(
      'Bottom sheet initState - currentAddress: ${widget.currentAddress?.title}',
    );
    print(
      'Bottom sheet initState - addresses count: ${widget.addresses.length}',
    );

    // Set selected index based on current address
    if (widget.currentAddress != null) {
      selectedIndex = widget.addresses.indexWhere(
        (address) => address.id == widget.currentAddress!.id,
      );
      print('Bottom sheet initState - selectedIndex: $selectedIndex');
      // If current address is not found in the list, set to -1 (no selection)
      if (selectedIndex == -1) {
        selectedIndex = -1;
        print('Current address not found in list, setting selectedIndex to -1');
      }
    } else {
      print('No current address provided');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Bottom sheet building with ${widget.addresses.length} addresses');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Labels.selectDeliveryAddress,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (widget.addresses.isEmpty) ...[
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.location_off,
                    size: 48,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Labels.noAddressesFound,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Labels.pleaseAddAnAddressToContinue,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ] else ...[
            ...List.generate(widget.addresses.length, (index) {
              final address = widget.addresses[index];
              final isSelected = selectedIndex == index;

              return GestureDetector(
                key: ValueKey('address_${address.id}_$index'),
                onTap: () {
                  print('Address tapped: ${address.title} at index $index');
                  setState(() {
                    selectedIndex = index;
                  });
                  // Call the callback with selected address and close bottom sheet
                  widget.onAddressSelected(address);
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1)
                            : Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.title ?? 'Address',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              address.address ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${address.customerName ?? ''} • ${address.primaryPhoneNumber ?? ''}',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: FontFamily.fontsPoppinsRegular,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewAddressScreen()),
              );
            },
            child: Text(
              Labels.addNewAddress,
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsRegular,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class PaymentMethodBottomSheet extends StatefulWidget {
  final Function(String, PaymentResult?, CardDetailsModel?) onOrderConfirmed;
  final PaystackService paystackService;
  final double totalAmount;
  final String userEmail;

  const PaymentMethodBottomSheet({
    super.key,
    required this.onOrderConfirmed,
    required this.paystackService,
    required this.totalAmount,
    required this.userEmail,
  });

  @override
  State<PaymentMethodBottomSheet> createState() =>
      _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  int selectedIndex = -1;
  bool _isProcessingPayment = false;

  final List<Map<String, String>> paymentMethods = [
    {
      "title": Labels.cashOnDelivery,
      "subtitle": Labels.payWhenYourOrderIsDeliveredToYou,
      "icon": "💵",
    },
    {
      "title": Labels.onlinePayment,
      "subtitle": Labels.paySecurelyWithYourCreditCard,
      "icon": "💳",
    },
  ];

  Future<void> _handlePaystackPayment() async {
    if (_isProcessingPayment) return;

    if (mounted) {
      setState(() {
        _isProcessingPayment = true;
      });
    }

    // Ensure app is in foreground before processing payment
    await Future.delayed(Duration(milliseconds: 100));

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text('Processing payment...'),
                ],
              ),
            ),
      );

      // Process payment with Paystack
      final cartState = context.read<CartBloc>().state;
      final result = await widget.paystackService.processPayment(
        email: widget.userEmail,
        amount: widget.totalAmount,
        currency: 'NGN',
        metadata: {'order_type': 'delivery', 'app_name': 'Speezu'},
        savedCard: cartState.selectedCard,
        context: context,
      );

      // Store payment result in CartBloc
      context.read<CartBloc>().add(SetPaymentResult(paymentResult: result));

      // Close loading dialog
      Navigator.of(context).pop();

      if (result.success) {
        // Payment successful
        widget.onOrderConfirmed(
          '${Labels.onlinePayment} (Paystack)',
          result,
          cartState.selectedCard,
        );
        Navigator.pop(context);
      } else {
        // Payment failed
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Payment Failed'),
                content: Text(
                  result.message ??
                      'Payment could not be processed. Please try again.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Show error dialog
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Payment Error'),
              content: Text(
                'An error occurred while processing payment: ${e.toString()}',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Labels.selectPaymentMethod,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(paymentMethods.length, (index) {
                  final method = paymentMethods[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    key: ValueKey('payment_method_${method['title']}_$index'),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1)
                                : Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            method["icon"]!,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method["title"]!,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  method["subtitle"]!,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color:
                                isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // Card Selection Widget (only show when online payment is selected)
                if (selectedIndex == 1) ...[
                  const SizedBox(height: 16),
                  SavedCardSelectionWidget(
                    onCardSelected: (card) {
                      context.read<CartBloc>().add(SetSelectedCard(card: card));
                    },
                    selectedCard: state.selectedCard,
                  ),
                ],

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      _isProcessingPayment ||
                              selectedIndex == -1 ||
                              (selectedIndex == 1 && state.selectedCard == null)
                          ? null
                          : () async {
                            final selectedMethod =
                                paymentMethods[selectedIndex]["title"]!;

                            if (selectedMethod == Labels.onlinePayment) {
                              // Handle Paystack payment
                              await _handlePaystackPayment();
                            } else {
                              // Handle COD payment
                              widget.onOrderConfirmed(
                                selectedMethod,
                                null,
                                null,
                              );
                              Navigator.pop(context);
                            }
                          },
                  child:
                      _isProcessingPayment
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Processing...',
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            Labels.confirmOrder,
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
