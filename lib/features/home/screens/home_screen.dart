import 'package:flutter/material.dart';
import 'package:novacart/core/models/product.dart';
import 'package:novacart/core/services/api_service.dart';
import 'package:novacart/core/services/cart_service.dart';
import 'package:novacart/features/home/widgets/product_card.dart';
import 'package:novacart/shared/widgets/main_drawer.dart';
import 'package:novacart/shared/widgets/product_search_delegate.dart';
import 'package:provider/provider.dart';
import 'package:novacart/features/home/widgets/offer_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:novacart/features/home/screens/category_products_screen.dart';
import 'package:novacart/shared/widgets/dynamic_searchBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> _categoriesFuture;
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  late Future<List<Product>> _productsFuture;

  final List<Map<String, dynamic>> _offerBanners = const [
    {
      'title': 'Mega Sale',
      'subtitle': 'Shopping Discounts',
      'color': Colors.blue,
      'image': 'assets/images/novacart-shoppingDiscounts.png',
    },
    {
      'title': 'Special Offer',
      'subtitle': 'Limited Time Only',
      'color': Colors.orange,
      'image': 'assets/images/novacart-offer.png',
    },
    {
      'title': 'New Arrivals',
      'subtitle': 'Premium Footwear',
      'color': Colors.red,
      'image': 'assets/images/novacart-shoes.jpeg',
    },
    {
      'title': 'Tech Savings',
      'subtitle': 'Smart Televisions',
      'color': Colors.deepPurple,
      'image': 'assets/images/novacart-television.jpeg',
    },
  ];

  String _getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case "electronics":
        return 'assets/images/electronics-category.jpg';
      case "jewelery":
        return 'assets/images/jewelery-category.jpg';
      case "men's clothing":
        return 'assets/images/mens-clothing-category.jpg';
      case "women's clothing":
        return 'assets/images/womens-clothing-category.jpg';
      default:
        // A fallback image if a new category is added to the API
        return 'assets/images/electronics-category.jpg';
    }
  }

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService().fetchAllProducts();
    _categoriesFuture = ApiService().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NovaCart'),
        actions: [
          Consumer<CartService>(
            builder: (_, cart, ch) => Badge(
              label: Text(cart.itemCount.toString()),
              isLabelVisible: cart.itemCount > 0,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.of(context).pushNamed('/cart');
                },
              ),
            ),
          ),
        ],
      ),
      drawer: const MainDrawer(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DynamicSearchBar(),
            const SizedBox(height: 10),
            _buildOfferCarousel(),
            _buildPaginationDots(),
            const SizedBox(height: 10),
            _buildCategorySection(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                'Featured Products',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            // 2. Remove Expanded and use FutureBuilder directly
            FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                if (!snapshot.hasData || snapshot.data!.isEmpty)
                  return const Center(child: Text('No products found.'));

                final products = snapshot.data!;

                // 3. GridView settings for whole-page scrolling
                return GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  shrinkWrap:
                      true, // Crucial: tells GridView to take only needed space
                  physics:
                      const NeverScrollableScrollPhysics(), // Crucial: disables Grid's own scrolling
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: products.length,
                  itemBuilder: (ctx, i) => ProductCard(product: products[i]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCarousel() {
    return CarouselSlider.builder(
      carouselController: _controller,
      itemCount: _offerBanners.length,
      options: CarouselOptions(
        height: 200.0,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
      itemBuilder: (context, index, realIndex) {
        final item = _offerBanners[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: OfferCard(
            title: item['title'] as String,
            subtitle: item['subtitle'] as String,
            backgroundColor: item['color'] as Color,
            imagePath: item['image'] as String, // Pass the image path here
          ),
        );
      },
    );
  }

  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _offerBanners.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _controller.jumpToPage(entry.key),
          child: Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Shop by Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 145,
          child: FutureBuilder<List<String>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, i) {
                  final cat = snapshot.data![i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryProductsScreen(categoryName: cat),
                        ),
                      );
                    },
                    child: Container(
                      width: 90,
                      margin: const EdgeInsets.only(
                        right: 10,
                        bottom: 8,
                        top: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                _getCategoryImage(cat),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              cat.toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize:
                                    9, // SLIGHTLY SMALLER: To fit narrower card
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
