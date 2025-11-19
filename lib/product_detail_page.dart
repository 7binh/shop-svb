import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailPage extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final bool isLimited;

  const ProductDetailPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.isLimited,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  int _selectedSize = 0;
  int _selectedColor = 0;
  bool _isFavorite = false;
  bool _showSizeColorPopup = false;
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  late AnimationController _popupAnimationController;
  late Animation<double> _popupAnimation;

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final List<Color> _colors = [
    Colors.black,
    Colors.blue.shade700,
    Colors.grey.shade600,
    Colors.brown.shade600,
  ];

  @override
  void initState() {
    super.initState();
    _popupAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _popupAnimation = CurvedAnimation(
      parent: _popupAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _popupAnimationController.dispose();
    super.dispose();
  }

  void _openSizeColorPopup() {
    setState(() {
      _showSizeColorPopup = true;
    });
    _popupAnimationController.forward();
  }

  void _closeSizeColorPopup() {
    _popupAnimationController.reverse().then((_) {
      setState(() {
        _showSizeColorPopup = false;
      });
    });
  }

  void _confirmAddToCart() {
    _closeSizeColorPopup();
    Future.delayed(const Duration(milliseconds: 300), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.title} added to cart',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CustomScrollView(
        slivers: [
          // Image Gallery
          SliverToBoxAdapter(
            child: SizedBox(
              height: 400,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: const Color(0xFFE8E8E8)),
                      );
                    },
                  ),
                  
                  // Image Indicators
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Colors.black
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Limited Badge
                  if (widget.isLimited)
                    Positioned(
                      top: 60,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(18),
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
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Product Info
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Text(
                          widget.price,
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Rating & Reviews
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 18,
                            color: index < 4
                                ? Colors.amber
                                : Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '4.0 (120 reviews)',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Description
                    Text(
                      'Description',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Premium quality ${widget.title.toLowerCase()} made from the finest materials. Perfect for any occasion, combining style and comfort in one elegant piece.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Size Selection
                    Text(
                      'Size',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(
                        _sizes.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSize = index;
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 50,
                            margin: EdgeInsets.only(
                              right: index < _sizes.length - 1 ? 12 : 0,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedSize == index
                                  ? Colors.black
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedSize == index
                                    ? Colors.black
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _sizes[index],
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: _selectedSize == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Color Selection
                    Text(
                      'Color',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(
                        _colors.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = index;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(
                              right: index < _colors.length - 1 ? 12 : 0,
                            ),
                            decoration: BoxDecoration(
                              color: _colors[index],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == index
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: _selectedColor == index
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
          ),

          // Gradient overlay for AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 22),
                          color: Colors.black,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.black,
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Fixed Add to Cart Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
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
                child: Container(
                  width: double.infinity,
                  height: 60,
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _openSizeColorPopup,
                      borderRadius: BorderRadius.circular(30),
                      child: Center(
                        child: Text(
                          'Add to Cart',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Blur overlay when popup is open
          AnimatedBuilder(
            animation: _popupAnimation,
            builder: (context, child) {
              if (!_showSizeColorPopup && _popupAnimation.value == 0) {
                return const SizedBox.shrink();
              }
              return Positioned.fill(
                child: GestureDetector(
                  onTap: _closeSizeColorPopup,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5.0 * _popupAnimation.value,
                      sigmaY: 5.0 * _popupAnimation.value,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.3 * _popupAnimation.value),
                    ),
                  ),
                ),
              );
            },
          ),

          // Size & Color Selection Popup
          AnimatedBuilder(
            animation: _popupAnimation,
            builder: (context, child) {
              if (!_showSizeColorPopup && _popupAnimation.value == 0) {
                return const SizedBox.shrink();
              }
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Transform.translate(
                  offset: Offset(0, (1 - _popupAnimation.value) * 500),
                  child: SafeArea(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select Options',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _closeSizeColorPopup,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F0F0),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.close, size: 18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Size Selection
                            Text(
                              'Size',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: List.generate(
                                _sizes.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedSize = index;
                                    });
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 50,
                                    margin: EdgeInsets.only(
                                      right: index < _sizes.length - 1 ? 12 : 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _selectedSize == index
                                          ? Colors.black
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _selectedSize == index
                                            ? Colors.black
                                            : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _sizes[index],
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: _selectedSize == index
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Color Selection
                            Text(
                              'Color',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: List.generate(
                                _colors.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = index;
                                    });
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    margin: EdgeInsets.only(
                                      right: index < _colors.length - 1 ? 12 : 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _colors[index],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _selectedColor == index
                                            ? Colors.black
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: _selectedColor == index
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 24,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Confirm Button
                            Container(
                              width: double.infinity,
                              height: 60,
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
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _confirmAddToCart,
                                  borderRadius: BorderRadius.circular(30),
                                  child: Center(
                                    child: Text(
                                      'Add to Cart',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

