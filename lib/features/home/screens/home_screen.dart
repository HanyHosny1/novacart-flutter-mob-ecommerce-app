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
      'title': '50% OFF SALE',
      'subtitle': 'All Electronics & Gadgets',
      'color': Colors.red,
    },
    {
      'title': 'BEST SELLERS',
      'subtitle': 'Top 10 items this week',
      'color': Colors.deepPurple,
    },
    {
      'title': 'FREE SHIPPING',
      'subtitle': 'On orders over \$100',
      'color': Colors.green,
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
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
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

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildOfferCarousel(),
          _buildPaginationDots(),

          // --- NEW: Added Category Section here ---
          const SizedBox(height: 10),
          _buildCategorySection(),

          // ----------------------------------------
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

          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                final products = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: products.length,
                  itemBuilder: (ctx, i) {
                    return ProductCard(product: products[i]);
                  },
                );
              },
            ),
          ),
        ],
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 145, // Increased height to provide room for text
          child: FutureBuilder<List<String>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
                      width: 95,
                      margin: const EdgeInsets.only(
                        right: 5,
                        bottom: 8,
                        top: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        // CHANGED: Use start alignment so images all sit at the same top position
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ), // Fixed top spacing for all images
                          SizedBox(
                            width: 65,
                            height: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                _getCategoryImage(cat),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ), // Spacing between image and text
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              cat.toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.7,
                                height:
                                    1.2, // Improves readability for 2-line text
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
