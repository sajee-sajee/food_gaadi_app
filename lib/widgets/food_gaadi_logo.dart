// File: lib/widgets/food_gaadi_logo.dart
import 'package:flutter/material.dart';

class FoodGaadiLogo extends StatelessWidget {
  final double size;
  const FoodGaadiLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.withOpacity(0.05),
            ),
          ),
          Container(
            width: size * 0.75,
            height: size * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.withOpacity(0.1),
            ),
          ),
          Container(
            width: size * 0.6,
            height: size * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
              border: Border.all(color: Colors.orange.shade100, width: 2),
            ),
            child: Icon(
              Icons.local_shipping_outlined,
              size: size * 0.25,
              color: Colors.orange,
            ),
          ),
          Positioned(
            top: size * 0.2,
            right: size * 0.22,
            child: Icon(Icons.location_on, color: Colors.orange, size: size * 0.1),
          ),
        ],
      ),
    );
  }
}