import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/assets/font_family.dart';
import 'package:speezu/widgets/custom_app_bar.dart';
import 'package:speezu/widgets/image_type_extention.dart';
import '../../core/utils/currency_icon.dart';
import '../../core/utils/labels.dart';
import '../settings/add_address_screen.dart';
import 'bloc/cart_bloc.dart';
import 'bloc/cart_state.dart';
import '../../models/address_model.dart';
import '../../repositories/user_repository.dart';

enum CheckoutMethod { pickup, delivery }

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  CheckoutMethod? selectedMethod;
  AddressModel? selectedAddress;
  final UserRepository _userRepository = UserRepository();
  List<AddressModel> _addresses = [];

  @override
  void initState() {
    super.initState();
    _initializeAddresses();
    // Listen to user changes to refresh addresses
    _userRepository.userStream.listen((user) {
      if (mounted) {
        _loadAddresses();
      }
    });
  }

  Future<void> _initializeAddresses() async {
    // Ensure UserRepository is initialized
    await _userRepository.init();
    _loadAddresses();
  }

  void _loadAddresses() {
    final addresses = _userRepository.deliveryAddresses ?? [];
    print('Loaded ${addresses.length} addresses from UserRepository');
    for (var address in addresses) {
      print('Address: ${address.title} - ${address.address}');
    }
    setState(() {
      _addresses = addresses;
      // Set default address if available
      selectedAddress = _userRepository.defaultAddress;
    });
  }

  void _handlePickupOrder() {
    // Print order details as JSON
    _printOrderDetails();
    
    // Handle pickup order - no payment method needed
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Pickup Order'),
        content: Text('Your pickup order has been placed successfully! You will pay at the store.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate back to home or show success screen
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _printOrderDetails() {
    final cartBloc = context.read<CartBloc>();
    final cartState = cartBloc.state;
    
    // Dynamic values based on order type selection
    final isPickup = selectedMethod == CheckoutMethod.pickup;
    final isDelivery = selectedMethod == CheckoutMethod.delivery;
    final orderType = isPickup ? 'pickup' : 'delivery';
    
    // Dynamic delivery fee (0 for pickup, actual fee for delivery)
    final dynamicDeliveryFee = isPickup ? 0.0 : cartState.deliveryFee;
    
    // Dynamic total amount calculation
    final dynamicTotalAmount = isPickup 
        ? cartState.subtotal + cartState.taxAmount  // No delivery fee for pickup
        : cartState.totalAmount;  // Include delivery fee for delivery
    
    // Create order details map for server (order_id, order_status, created_at will be managed by server)
    final orderDetails = {
      'order_type': orderType,
      'is_pickup': isPickup,
      'is_delivery': isDelivery,
      'is_cod': isDelivery, // Delivery orders are COD by default
      'payment_method': isPickup ? 'store_payment' : 'cod',
      'items': cartState.items.map((item) => {
        'product_id': item.productId,
        'variation_parent_id': item.variationParentId,
        'variation_child_id': item.variationChildId,
        'quantity': item.quantity,
        'store_id': item.storeId,
      }).toList(),
      'delivery_address': isDelivery && selectedAddress != null ? {
        'address_id': selectedAddress!.id,
        'title': selectedAddress!.title,
        'customer_name': selectedAddress!.customerName,
        'primary_phone': selectedAddress!.primaryPhoneNumber,
        'secondary_phone': selectedAddress!.secondaryPhoneNumber,
        'address': selectedAddress!.address,
      } : null,
      'pickup_location': isPickup ? {
        'store_id': cartState.currentStoreId ?? 'unknown',
        'store_name': cartState.items.isNotEmpty ? cartState.items.first.shopName : 'Unknown Store',
        'pickup_instructions': 'Please collect your order from the store counter',
      } : null,
      'order_summary': {
        'total_items': cartState.totalItems,
        'unique_products': cartState.items.length,
        'subtotal': cartState.subtotal,
        'delivery_fee': dynamicDeliveryFee,
        'tax_amount': cartState.taxAmount,
        'total_amount': dynamicTotalAmount,
      },
      'payment_details': null, // Will be handled in future
    };

    // Print formatted JSON
    print('=== ${orderType.toUpperCase()} ORDER REQUEST JSON ===');
    _printFormattedJson(orderDetails);
    print('=== END ${orderType.toUpperCase()} ORDER REQUEST ===');
  }

  void _printFormattedJson(Map<String, dynamic> data) {
    // Convert to properly formatted JSON
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(data);
    print(jsonString);
  }

  void _printDeliveryOrderDetails(String paymentMethod) {
    final cartBloc = context.read<CartBloc>();
    final cartState = cartBloc.state;
    
    // Dynamic values based on delivery order and payment method
    final isCod = paymentMethod.toLowerCase().contains('cash') || paymentMethod.toLowerCase().contains('cod');
    final paymentType = isCod ? 'cod' : 'online';
    
    // Create order details map for delivery (order_id, order_status, created_at will be managed by server)
    final orderDetails = {
      'order_type': 'delivery',
      'is_pickup': false,
      'is_delivery': true,
      'is_cod': isCod,
      'payment_method': paymentType,
      'items': cartState.items.map((item) => {
        'product_id': item.productId,
        'variation_parent_id': item.variationParentId,
        'variation_child_id': item.variationChildId,
        'quantity': item.quantity,
        'store_id': item.storeId,
      }).toList(),
      'delivery_address': selectedAddress != null ? {
        'address_id': selectedAddress!.id,
        'title': selectedAddress!.title,
        'customer_name': selectedAddress!.customerName,
        'primary_phone': selectedAddress!.primaryPhoneNumber,
        'secondary_phone': selectedAddress!.secondaryPhoneNumber,
        'address': selectedAddress!.address,
        'delivery_instructions': 'Please deliver to the main entrance',
      } : null,
      'order_summary': {
        'total_items': cartState.totalItems,
        'unique_products': cartState.items.length,
        'subtotal': cartState.subtotal,
        'delivery_fee': cartState.deliveryFee,
        'tax_amount': cartState.taxAmount,
        'total_amount': cartState.totalAmount,
      },
      'payment_details': isCod ? null : {
        'card_type': 'Will be implemented in future',
        'last_four_digits': '****',
        'expiry_date': 'MM/YY',
      },
    };

    // Print formatted JSON
    print('=== DELIVERY ORDER REQUEST JSON ===');
    _printFormattedJson(orderDetails);
    print('=== END DELIVERY ORDER REQUEST ===');
  }

  void _showDeliveryOrderConfirmation(String paymentMethod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delivery Order'),
        content: Text('Your delivery order has been placed successfully!\nPayment Method: $paymentMethod'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate back to home or show success screen
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
                setState(() => selectedMethod = CheckoutMethod.pickup);
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              tileColor:
                  selectedMethod == CheckoutMethod.pickup
                      ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .05)
                      : Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color:
                      selectedMethod == CheckoutMethod.pickup
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
                groupValue: selectedMethod,
                onChanged: (value) => setState(() => selectedMethod = value),
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
                          print('Address selected callback triggered: ${address.title}');
                          setState(() {
                            selectedAddress = address;
                          });
                        },
                        currentAddress: selectedAddress,
                        addresses: _addresses,
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
                setState(() => selectedMethod = CheckoutMethod.delivery);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      selectedMethod == CheckoutMethod.delivery
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: .05)
                          : Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        selectedMethod == CheckoutMethod.delivery
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
                            selectedAddress?.title ?? "Delivery Address",
                            style: TextStyle(
                              fontFamily: FontFamily.fontsPoppinsSemiBold,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 15,
                            ),
                          ),
                          if (selectedAddress != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              selectedAddress!.address ?? '',
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
                              '${selectedAddress!.customerName ?? ''} • ${selectedAddress!.primaryPhoneNumber ?? ''}',
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
                      groupValue: selectedMethod,
                      onChanged:
                          (value) => setState(() => selectedMethod = value),
                    ),
                  ],
                ),
              ),
            ),
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
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, cartState) {
                              final itemCount = cartState.totalItems;
                              final subtotal = cartState.subtotal;
                              final deliveryFee = cartState.deliveryFee;
                              final taxAmount = cartState.taxAmount;
                              final totalAmount = cartState.totalAmount;
                              
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${Labels.itemsTotal} ( $itemCount ${itemCount == 1 ? Labels.item : '${Labels.item}s'} )',
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsRegular,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${CurrencyIcon.currencyIcon} ${subtotal.toStringAsFixed(2)}',
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
                                        '${CurrencyIcon.currencyIcon} ${deliveryFee.toStringAsFixed(2)}',
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
                                        '${CurrencyIcon.currencyIcon} ${taxAmount.toStringAsFixed(2)}',
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
                                        '${CurrencyIcon.currencyIcon} ${totalAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: FontFamily.fontsPoppinsSemiBold,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  selectedMethod != null
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
                              onPressed: selectedMethod != null ? () {
                                if (selectedMethod == CheckoutMethod.delivery) {
                                  // Show payment method bottom sheet for delivery
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) => PaymentMethodBottomSheet(
                                      onOrderConfirmed: _printDeliveryOrderDetails,
                                      onShowConfirmation: _showDeliveryOrderConfirmation,
                                    ),
                                  );
                                } else if (selectedMethod == CheckoutMethod.pickup) {
                                  // Handle pickup order directly (no payment method needed)
                                  _handlePickupOrder();
                                }
                              } : null,
                              child: Text(
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
  final Function(String) onOrderConfirmed;
  final Function(String) onShowConfirmation;
  
  const PaymentMethodBottomSheet({
    super.key,
    required this.onOrderConfirmed,
    required this.onShowConfirmation,
  });

  @override
  State<PaymentMethodBottomSheet> createState() =>
      _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  int selectedIndex = -1;

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

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:
                selectedIndex == -1
                    ? null
                    : () {
                      // Print order details for delivery
                      widget.onOrderConfirmed(paymentMethods[selectedIndex]["title"]!);
                      
                      // Close payment method bottom sheet
                      Navigator.pop(context);
                      
                      // Show confirmation dialog
                      widget.onShowConfirmation(paymentMethods[selectedIndex]["title"]!);
                    },
            child: Text(Labels.confirmOrder),
          ),
        ],
      ),
    );
  }
}
