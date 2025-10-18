import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:speezu/core/assets/app_images.dart';
import 'package:speezu/core/utils/labels.dart';
import 'package:speezu/presentation/search_products/bloc/search_products_bloc.dart';
import 'package:speezu/presentation/search_products/search_result_screen.dart';

import '../../core/assets/font_family.dart';
import 'bloc/search_product_state.dart';
import 'bloc/search_products_event.dart';

class SearchPromptScreen extends StatefulWidget {
  const SearchPromptScreen({super.key});

  @override
  State<SearchPromptScreen> createState() => _SearchPromptScreenState();
}

class _SearchPromptScreenState extends State<SearchPromptScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> categorySuggestions = [
    {'name': 'Food', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'name': 'Supermarket', 'icon': Icons.shopping_cart, 'color': Colors.green},
    {'name': 'Retail Store', 'icon': Icons.store, 'color': Colors.blue},
    {'name': 'Pharmacy', 'icon': Icons.medical_services, 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    context.read<SearchProductsBloc>().add(LoadSearchHistory());
    context.read<SearchProductsBloc>().add(LoadTagNamesEvent());
    context.read<SearchProductsBloc>().add(LoadCategoryNamesEvent());

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSearch(String query) async {
    if (query.trim().isEmpty) return;
    context.read<SearchProductsBloc>().add(AddSearchQuery(query.trim()));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(searchQuery: query.trim()),
      ),
    );
  }

  Widget _buildChipButton({
    required String text,
    required VoidCallback onTap,
    IconData? icon,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.03),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: iconColor ?? Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                text,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsMedium,
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryChip(String text) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _controller.text = text.trim();
          _handleSearch(text.trim());
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.onSecondary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSecondary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                size: 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSecondary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsRegular,
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _controller.text = category['name'];
          _handleSearch(category['name']);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (category['color'] as Color).withValues(alpha: 0.1),
                (category['color'] as Color).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (category['color'] as Color).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (category['color'] as Color).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category['icon'],
                  size: 28,
                  color: category['color'],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                category['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.fontsPoppinsMedium,
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onClearTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 18,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontFamily: FontFamily.fontsPoppinsSemiBold,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
        if (onClearTap != null)
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onClearTap,
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 14,
                  color: Colors.red.shade400,
                ),
                const SizedBox(width: 4),
                Text(
                  Labels.clearAll,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: FontFamily.fontsPoppinsMedium,
                    color: Colors.red.shade400,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSecondary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.onSecondary,
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        title: Image.asset(AppImages.speezuLogo, width: 110),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: BlocBuilder<SearchProductsBloc, SearchProductsState>(
              builder: (context, state) {
                final allSuggestions =
                    [
                      ...?state.productNames,
                      ...?state.categoryNames,
                      ...?state.searchTags,
                    ].toSet().toList();

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TypeAheadField<String>(
                    controller: _controller,
                    focusNode: _focusNode,
                    hideOnEmpty: true,
                    hideWithKeyboard: false,
                    hideOnUnfocus: false,
                    suggestionsCallback: (pattern) {
                      if (pattern.isEmpty) return [];
                      return allSuggestions
                          .where(
                            (item) => item.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                          )
                          .toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: 0.05),
                              width: 1,
                            ),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: Icon(
                            Icons.search,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.6),
                            size: 20,
                          ),
                          trailing: Transform.rotate(
                            angle: -0.785398,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: 0.3),
                              size: 18,
                            ),
                          ),
                          title: Text(
                            suggestion,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: FontFamily.fontsPoppinsRegular,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      );
                    },
                    onSelected: (suggestion) {
                      _controller.text = suggestion;
                      _handleSearch(suggestion);
                    },
                    builder: (context, controller, focusNode) {
                      return TextField(
                        cursorColor: Theme.of(context).colorScheme.primary,
                        controller: controller,
                        focusNode: focusNode,
                        onSubmitted: _handleSearch,
                        style: TextStyle(
                          fontFamily: FontFamily.fontsPoppinsRegular,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onPrimary,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondary.withValues(alpha: 0.15),
                              width: 1.5,
                            ),
                          ),
                          hintText: Labels.searchProducts,
                          hintStyle: TextStyle(
                            fontFamily: FontFamily.fontsPoppinsRegular,
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary.withValues(alpha: 0.4),
                          ),
                          suffixIcon:
                              controller.text.isNotEmpty
                                  ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary
                                              .withValues(alpha: 0.4),
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          controller.clear();
                                          setState(() {});
                                        },
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        child: Material(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: InkWell(
                                            onTap:
                                                () => _handleSearch(
                                                  controller.text,
                                                ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 10,
                                                  ),
                                              child: Text(
                                                Labels.search,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily
                                                          .fontsPoppinsMedium,
                                                  fontSize: 13,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.onPrimary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  : null,
                          border: InputBorder.none,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent Searches Section
              BlocBuilder<SearchProductsBloc, SearchProductsState>(
                builder: (context, state) {
                  if (state.searchHistory.isEmpty) {
                    return Column(
                      children: [
                        _buildSectionHeader(Labels.recentSearches),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.shade200.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.history_rounded,
                                color: Colors.red.shade400,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  Labels.noRecentSearches,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: FontFamily.fontsPoppinsRegular,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        Labels.recentSearches,
                        onClearTap: () {
                          context.read<SearchProductsBloc>().add(
                            ClearSearchHistory(),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            state.searchHistory.map(_buildHistoryChip).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),

              // Browse Categories Section
              // _buildSectionHeader(Labels.browseCategories),
              // const SizedBox(height: 16),
              // GridView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     crossAxisSpacing: 12,
              //     mainAxisSpacing: 12,
              //     childAspectRatio: 1.3,
              //   ),
              //   itemCount: categorySuggestions.length,
              //   itemBuilder: (context, index) {
              //     return _buildCategoryCard(categorySuggestions[index]);
              //   },
              // ),
              const SizedBox(height: 1),

              // Browse Tags Section
              BlocBuilder<SearchProductsBloc, SearchProductsState>(
                builder: (context, state) {
                  if (state.searchTags == null || state.searchTags!.isEmpty) {
                    return const SizedBox();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(Labels.browseTags),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            state.searchTags!
                                .map(
                                  (tag) => _buildChipButton(
                                    text: tag,
                                    onTap: () {
                                      _controller.text = tag;
                                      _handleSearch(tag);
                                    },
                                    icon: Icons.local_offer_outlined,
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
