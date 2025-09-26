import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/image_type_extention.dart';
import '../../core/utils/currency_icon.dart';
import '../../core/utils/labels.dart';
import '../../routes/route_names.dart';
import '../settings/add_address_screen.dart';
import 'bloc/cart_bloc.dart';
import 'bloc/cart_state.dart';
import 'bloc/cart_event.dart';
import '../../models/address_model.dart';
import '../../models/card_details_model.dart';
import '../../repositories/user_repository.dart';
import '../../services/paystack_service.dart';
import '../../models/payment_model.dart';
import '../../core/config/paystack_config.dart' as config;
import 'widgets/saved_card_selection_widget.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final UserRepository _userRepository = UserRepository();
  final PaystackService _paystackService = PaystackService();
  final TextEditingController _deliveryInstructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePaystack();
    // Load addresses using CartBloc
    context.read<CartBloc>().loadAddresses();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment service initialization failed. Please restart the app.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  void _handlePickupOrder() {
    // Post order using CartBloc
    context.read<CartBloc>().add(PostOrder(
      paymentMethod: 'Store Payment',
      paymentResult: null,
      selectedCard: null,
    ));
  }

  void _handleDeliveryOrder(String paymentMethod, PaymentResult? paymentResult, CardDetailsModel? selectedCard) {
    // Post order using CartBloc
    context.read<CartBloc>().add(PostOrder(
      paymentMethod: paymentMethod,
      paymentResult: paymentResult,
      selectedCard: selectedCard,
    ));
  }

  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Order Successful'),
        content: Text('Your order has been placed successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        
        if (state.status == CartStatus.success && state.orderPlacedSuccessfully) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                RouteNames.navBarScreen,
                (Route<dynamic> route) => false,
              );
          _showOrderSuccessDialog();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(title: Labels.checkout),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                const SizedBox(height: 10),

                /// ---------- PICKUP ----------
                Row(
                  children: [
                    Icon(
                      Icons.store_mall_directory,
                      size: 30,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Labels.pickUp,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Labels.pickUpYouItemFromStore,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                ListTile(
                  onTap: () {
                    context.read<CartBloc>().add(SetCheckoutMethod(method: CheckoutMethod.pickup));
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  tileColor:
                      state.selectedMethod == CheckoutMethod.pickup
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: .05)
                          : Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color:
                          state.selectedMethod == CheckoutMethod.pickup
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: .1),
                      width: 1.5,
                    ),
                  ),
                  leading: CustomImageView(
                    imagePath: AppImages.storeImage,
                    radius: BorderRadius.circular(5),
                    height: 60,
                    width: 60,
                    fit: BoxFit.fill,
                  ),
                  title: Text(
                    Labels.pickUpFromStore,
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    Labels.youShouldPayAtTheStore,
                    style: TextStyle(
                      fontFamily: FontFamily.fontsPoppinsLight,
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Radio<CheckoutMethod>(
                    value: CheckoutMethod.pickup,
                    groupValue: state.selectedMethod,
                    onChanged: (value) => context.read<CartBloc>().add(SetCheckoutMethod(method: value!)),
                  ),
                ),

                const SizedBox(height: 20),

                /// ---------- DELIVERY ----------
                Row(
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 30,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Labels.delivery,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Labels.itemDeliverToYourAddress,
                          style: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => DeliveryAddressBottomSheet(
                            onAddressSelected: (address) {
                              context.read<CartBloc>().add(SetSelectedAddress(address: address));
                            },
                            currentAddress: state.selectedAddress,
                            addresses: state.addresses,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    context.read<CartBloc>().add(SetCheckoutMethod(method: CheckoutMethod.delivery));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          state.selectedMethod == CheckoutMethod.delivery
                              ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: .05)
                              : Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            state.selectedMethod == CheckoutMethod.delivery
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: .3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Address Information 🔹
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.selectedAddress?.title ?? "Delivery Address",
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                                  color: Theme.of(context).colorScheme.onSecondary,
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
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${state.selectedAddress!.customerName ?? ''} • ${state.selectedAddress!.primaryPhoneNumber ?? ''}',
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsRegular,
                                    color: Theme.of(context).colorScheme.outline,
                                    fontSize: 12,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  Labels.selectDeliveryAddress,
                                  style: TextStyle(
                                    fontFamily: FontFamily.fontsPoppinsRegular,
                                    color: Theme.of(context).colorScheme.outline,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Radio<CheckoutMethod>(
                          value: CheckoutMethod.delivery,
                          groupValue: state.selectedMethod,
                          onChanged: (value) => context.read<CartBloc>().add(SetCheckoutMethod(method: value!)),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Delivery Instructions Field (only show for delivery)
                if (state.selectedMethod == CheckoutMethod.delivery) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Delivery Instructions (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _deliveryInstructionsController,
                    maxLines: 3,
                    onChanged: (value) {
                      context.read<CartBloc>().add(SetDeliveryInstructions(instructions: value));
                    },
                    decoration: InputDecoration(
                      hintText: 'Add special instructions for delivery...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: FontFamily.fontsPoppinsRegular,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: .3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(2, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                Labels.summary,
                                style: TextStyle(
                                  fontFamily: FontFamily.fontsPoppinsSemiBold,
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${Labels.itemsTotal} ( ${state.totalItems} ${state.totalItems == 1 ? Labels.item : '${Labels.item}s'} )',
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsRegular,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${CurrencyIcon.currencyIcon} ${state.subtotal.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsRegular,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Labels.deliveryFee,
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsRegular,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${CurrencyIcon.currencyIcon} ${state.deliveryFee.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsRegular,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Labels.tax,
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsRegular,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${CurrencyIcon.currencyIcon} ${state.taxAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsRegular,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Labels.grandTotal,
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '${CurrencyIcon.currencyIcon} ${state.totalAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      state.selectedMethod != null
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.outline,
                                    ),
                                    minimumSize: MaterialStateProperty.all(
                                      Size(300, 50),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                  onPressed: state.selectedMethod != null && state.status != CartStatus.loading ? () {
                                    if (state.selectedMethod == CheckoutMethod.delivery) {
                                      // Show payment method bottom sheet for delivery
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (context) {
                                          return PaymentMethodBottomSheet(
                                            onOrderConfirmed: _handleDeliveryOrder,
                                            paystackService: _paystackService,
                                            totalAmount: state.totalAmount,
                                            userEmail: _userRepository.currentUser?.userData?.email ?? 'user@example.com',
                                          );
                                        },
                                      );
                                    } else if (state.selectedMethod == CheckoutMethod.pickup) {
                                      // Handle pickup order directly (no payment method needed)
                                      _handlePickupOrder();
                                    }
                                  } : null,
                                  child: state.status == CartStatus.loading
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Placing Order...',
                                              style: TextStyle(
                                                fontFamily: FontFamily.fontsPoppinsSemiBold,
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          Labels.placeOrder,
                                          style: TextStyle(
                                            fontFamily: FontFamily.fontsPoppinsSemiBold,
                                            color: Colors.white,
                                            fontSize: 15,
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
              ],
            ),
          ),
        );
      },
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
    print('Bottom sheet initState - currentAddress: ${widget.currentAddress?.title}');
    print('Bottom sheet initState - addresses count: ${widget.addresses.length}');
    
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
                    'No addresses found',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.fontsPoppinsSemiBold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add an address to continue',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.fontsPoppinsRegular,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewAddressScreen(),
                        ),
                      );
                    },
                    child: Text('Add Address'),
                  ),
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
                          ).colorScheme.primary.withOpacity(0.1)
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
                              color: Theme.of(context).colorScheme.onSecondary,
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
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddNewAddressScreen()),
              );
            },
            icon: Icon(
              Icons.add_location_alt,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            label: Text(
              Labels.addNewAddress,
              style: TextStyle(
                fontFamily: FontFamily.fontsPoppinsRegular,
                color: Theme.of(context).colorScheme.onPrimary,
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
        builder: (context) => AlertDialog(
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
        metadata: {
          'order_type': 'delivery',
          'app_name': 'Speezu',
        },
        savedCard: cartState.selectedCard,
        context: context,
      );

      // Store payment result in CartBloc
      context.read<CartBloc>().add(SetPaymentResult(paymentResult: result));

      // Close loading dialog
      Navigator.of(context).pop();

      if (result.success) {
        // Payment successful
        widget.onOrderConfirmed('${Labels.onlinePayment} (Paystack)', result, cartState.selectedCard);
        Navigator.pop(context);
      } else {
        // Payment failed
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Payment Failed'),
            content: Text(result.message ?? 'Payment could not be processed. Please try again.'),
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
        builder: (context) => AlertDialog(
          title: Text('Payment Error'),
          content: Text('An error occurred while processing payment: ${e.toString()}'),
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
                Labels.selectPaymentMethod,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                              ).colorScheme.primary.withOpacity(0.1)
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
                        Text(method["icon"]!, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method["title"]!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                method["subtitle"]!,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
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
                onPressed: _isProcessingPayment || selectedIndex == -1 || 
                    (selectedIndex == 1 && state.selectedCard == null)
                    ? null
                    : () async {
                        final selectedMethod = paymentMethods[selectedIndex]["title"]!;
                        
                        if (selectedMethod == Labels.onlinePayment) {
                          // Handle Paystack payment
                          await _handlePaystackPayment();
                    } else {
                      // Handle COD payment
                      widget.onOrderConfirmed(selectedMethod, null, null);
                      Navigator.pop(context);
                    }
                      },
                child: _isProcessingPayment
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Processing...'),
                        ],
                      )
                    : Text(Labels.confirmOrder),
              ),
            ],
          ),
        );
      },
    );
  }
}
