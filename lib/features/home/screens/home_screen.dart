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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService().fetchAllProducts();
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
}
