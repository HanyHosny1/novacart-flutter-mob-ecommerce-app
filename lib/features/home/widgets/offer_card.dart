import 'package:flutter/material.dart';
import 'package:novacart/shared/theme/colors.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;

  const OfferCard({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: kSurfaceColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: kSurfaceColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tapped on $title offer!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSurfaceColor,
                  foregroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                ),
                child: const Text('Shop Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
