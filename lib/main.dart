import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetDealsFromUSA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class CartItem {
  final String id;
  final String imageUrl;
  final String title;
  final String price;
  int quantity;

  CartItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isSearching = false;
  bool _isCartOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;
  late AnimationController _cartAnimationController;
  late Animation<double> _cartWidthAnimation;
  late Animation<double> _cartHeightAnimation;

  // Cart items
  List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      imageUrl:
          'https://images.unsplash.com/photo-1594633313593-bab3825d0caf?w=200',
      title: 'Tweed Waistcoat',
      price: '\$29.00',
      quantity: 1,
    ),
    CartItem(
      id: '2',
      imageUrl:
          'https://images.unsplash.com/photo-1551537482-f2075a1d41f2?w=200',
      title: 'Denim Jacket',
      price: '\$34.90',
      quantity: 2,
    ),
  ];

  String? _swipedItemId; // Track which item is swiped open

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );

    _cartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _cartWidthAnimation = CurvedAnimation(
      parent: _cartAnimationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    );

    _cartHeightAnimation = CurvedAnimation(
      parent: _cartAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _cartAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchAnimationController.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          _searchFocusNode.requestFocus();
        });
      } else {
        _searchAnimationController.reverse();
        _searchFocusNode.unfocus();
        _searchController.clear();
      }
    });
  }

  void _toggleCart() {
    setState(() {
      _isCartOpen = !_isCartOpen;
      if (_isCartOpen) {
        _cartAnimationController.forward();
      } else {
        _cartAnimationController.reverse();
      }
    });
  }

  void _deleteItem(CartItem item) {
    setState(() {
      _cartItems.removeWhere((cartItem) => cartItem.id == item.id);
      _swipedItemId = null; // Reset swipe state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            // Main Content
            CustomScrollView(
              slivers: [
                // Spacer for fixed header
                const SliverToBoxAdapter(child: SizedBox(height: 0)),

                // Hero Banner - starts from top
                SliverToBoxAdapter(
                  child: Container(
                    height: 340,
                    decoration: const BoxDecoration(color: Color(0xFFE8E8E8)),
                    child: Stack(
                      children: [
                        // Background Image
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: const Color(0xFFE8E8E8)),
                          ),
                        ),
                        // Gradient Overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.white.withOpacity(0.9),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Bottom rounded corner overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        // Content
                        Positioned(
                          left: 24,
                          bottom: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MEET THE NEW\nAUTUMN\nCOLLECTION',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Shop now',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Popular Categories
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular categories',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),

                // Categories List
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip('Women', true),
                        _buildCategoryChip('Men', false),
                        _buildCategoryChip('Kids', false),
                        _buildCategoryChip('Beauty', false),
                        _buildCategoryChip('Accessories', false),
                      ],
                    ),
                  ),
                ),

                // New Arrival
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New arrival',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),

                // Products Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildListDelegate([
                      _buildProductCard(
                        'https://images.unsplash.com/photo-1594633313593-bab3825d0caf?w=400',
                        'Tweed Waistcoat',
                        '\$29.00',
                        true,
                        true,
                      ),
                      _buildProductCard(
                        'https://images.unsplash.com/photo-1551537482-f2075a1d41f2?w=400',
                        'Denim Jacket',
                        '\$34.90',
                        false,
                        false,
                      ),
                      _buildProductCard(
                        'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=400',
                        'Casual Blazer',
                        '\$49.90',
                        false,
                        false,
                      ),
                      _buildProductCard(
                        'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
                        'Leather Jacket',
                        '\$89.90',
                        true,
                        false,
                      ),
                    ]),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),

            // Blur Overlay when searching - Covers everything except search bar
            if (_isSearching)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _toggleSearch,
                  child: AnimatedBuilder(
                    animation: _searchAnimation,
                    builder: (context, child) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8.0 * _searchAnimation.value,
                          sigmaY: 8.0 * _searchAnimation.value,
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(
                            0.5 * _searchAnimation.value,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Fixed Header on top - After blur so it stays on top and clear
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: _isSearching
                    ? null
                    : BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.95),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedBuilder(
                      animation: _searchAnimation,
                      builder: (context, child) {
                        final screenWidth =
                            MediaQuery.of(context).size.width - 32;
                        final searchWidth =
                            44 + (screenWidth - 44) * _searchAnimation.value;

                        return SizedBox(
                          height: 44,
                          child: Stack(
                            children: [
                              // Search Button/Bar - Animates from left
                              Positioned(
                                left: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: _isSearching ? null : _toggleSearch,
                                  child: Container(
                                    width: searchWidth,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 12),
                                        const Icon(Icons.search, size: 22),
                                        if (_searchAnimation.value > 0.3) ...[
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Opacity(
                                              opacity:
                                                  (_searchAnimation.value -
                                                      0.3) /
                                                  0.7,
                                              child: TextField(
                                                controller: _searchController,
                                                focusNode: _searchFocusNode,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Search products...',
                                                  hintStyle: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                ),
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Opacity(
                                            opacity:
                                                (_searchAnimation.value - 0.3) /
                                                0.7,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                size: 20,
                                              ),
                                              onPressed: _toggleSearch,
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(
                                                minWidth: 40,
                                                minHeight: 40,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Shop Name - Fades out and moves
                              if (_searchAnimation.value < 0.7)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  child: IgnorePointer(
                                    ignoring: _searchAnimation.value > 0,
                                    child: Opacity(
                                      opacity:
                                          1.0 -
                                          (_searchAnimation.value / 0.7).clamp(
                                            0.0,
                                            1.0,
                                          ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 44),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'GetDealsFromUSA',
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.3,
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 44),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              // Cart Button - Fades out
                              if (_searchAnimation.value < 0.7)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IgnorePointer(
                                    ignoring: _searchAnimation.value > 0,
                                    child: Opacity(
                                      opacity:
                                          1.0 -
                                          (_searchAnimation.value / 0.7).clamp(
                                            0.0,
                                            1.0,
                                          ),
                                      child: GestureDetector(
                                        onTap: _toggleCart,
                                        child: Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 10,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.shopping_bag_outlined,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Blur overlay when cart is open - BEFORE cart so cart is on top
            AnimatedBuilder(
              animation: _cartAnimationController,
              builder: (context, child) {
                if (_cartAnimationController.value == 0) {
                  return const SizedBox.shrink();
                }
                return Positioned.fill(
                  child: IgnorePointer(
                    ignoring: !_isCartOpen,
                    child: GestureDetector(
                      onTap: _toggleCart,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0 * _cartAnimationController.value,
                          sigmaY: 5.0 * _cartAnimationController.value,
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(
                            0.3 * _cartAnimationController.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Cart Popup Animation - AFTER blur so it's on top and clear
            AnimatedBuilder(
              animation: _cartAnimationController,
              builder: (context, child) {
                if (_cartAnimationController.value == 0) {
                  return const SizedBox.shrink();
                }
                return Positioned(
                  top: 0,
                  right: 0,
                  child: SafeArea(
                    child: Builder(
                      builder: (context) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        final screenHeight = MediaQuery.of(context).size.height;

                        // Phase 1: Width animation from right to left
                        final cartWidth =
                            44 +
                            (screenWidth - 44 - 32) * _cartWidthAnimation.value;

                        // Phase 2: Height animation from top to bottom
                        final cartHeight =
                            44 +
                            (screenHeight * 0.6) * _cartHeightAnimation.value;

                        return Padding(
                          padding: const EdgeInsets.only(top: 16, right: 16),
                          child: Container(
                            width: cartWidth,
                            height: cartHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _cartHeightAnimation.value > 0.3
                                ? Column(
                                    children: [
                                      // Header
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Shopping Cart',
                                              style: GoogleFonts.inter(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: _toggleCart,
                                              child: Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFF0F0F0,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.06),
                                                      blurRadius: 6,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Cart Items
                                      Expanded(
                                        child: Opacity(
                                          opacity:
                                              (_cartHeightAnimation.value -
                                                  0.3) /
                                              0.7,
                                          child: ListView.separated(
                                            padding: const EdgeInsets.all(16),
                                            itemCount: _cartItems.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(height: 12),
                                            itemBuilder: (context, index) {
                                              final item = _cartItems[index];
                                              final isOpen =
                                                  _swipedItemId == item.id;

                                              return GestureDetector(
                                                onHorizontalDragUpdate:
                                                    (details) {
                                                      if (details.delta.dx <
                                                          -5) {
                                                        // Swiping left
                                                        setState(() {
                                                          _swipedItemId =
                                                              item.id;
                                                        });
                                                      } else if (details
                                                                  .delta
                                                                  .dx >
                                                              5 &&
                                                          isOpen) {
                                                        // Swiping right when open
                                                        setState(() {
                                                          _swipedItemId = null;
                                                        });
                                                      }
                                                    },
                                                onTap: () {
                                                  // Close when tap on item
                                                  if (isOpen) {
                                                    setState(() {
                                                      _swipedItemId = null;
                                                    });
                                                  }
                                                },
                                                child: ClipRect(
                                                  child: Stack(
                                                    children: [
                                                      // Background delete button
                                                      Positioned.fill(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          padding:
                                                              const EdgeInsets.only(
                                                                right: 20,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  20,
                                                                ),
                                                          ),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              _deleteItem(item);
                                                            },
                                                            child: Container(
                                                              width: 80,
                                                              color: Colors
                                                                  .transparent,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 28,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                    'Delete',
                                                                    style: GoogleFonts.inter(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // Sliding item
                                                      AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 250,
                                                            ),
                                                        curve: Curves.easeOut,
                                                        transform:
                                                            Matrix4.translationValues(
                                                              isOpen ? -100 : 0,
                                                              0,
                                                              0,
                                                            ),
                                                        child: _buildCartItem(
                                                          item,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      // Checkout Button
                                      Opacity(
                                        opacity:
                                            (_cartHeightAnimation.value - 0.3) /
                                            0.7,
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8F8F8),
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  bottom: Radius.circular(22),
                                                ),
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey.shade200,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Total',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  Text(
                                                    '\$98.80',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Container(
                                                width: double.infinity,
                                                height: 56,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(28),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      blurRadius: 12,
                                                      offset: const Offset(
                                                        0,
                                                        4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Checkout',
                                                    style: GoogleFonts.inter(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_filled, 0),
                _buildNavItem(Icons.favorite_border, 1),
                _buildNavItem(Icons.shopping_bag_outlined, 2),
                _buildNavItem(Icons.person_outline, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(color: Colors.grey.shade200),
            ),
          ),
          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.price,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),

                // Quantity Controls
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.remove, size: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    String imageUrl,
    String title,
    String price,
    bool isLimited,
    bool isFavorite,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: const Color(0xFFE8E8E8)),
                  ),
                ),
                if (isLimited)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'limited edition',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: isFavorite ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}
