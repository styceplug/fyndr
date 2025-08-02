import 'package:flutter/material.dart';

import '../models/merchant_model.dart';

Widget buildRatingRow(Rating? rating) {
  final average = rating?.average ?? 0.0;
  final count = rating?.count ?? 0;
  final fullStars = average.floor();
  final hasHalfStar = (average - fullStars) >= 0.5;
  final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ...List.generate(fullStars, (index) => const Icon(Icons.star, color: Colors.amber, size: 18)),
      if (hasHalfStar)
        const Icon(Icons.star_half, color: Colors.amber, size: 18),
      ...List.generate(emptyStars, (index) => const Icon(Icons.star_border, color: Colors.amber, size: 18)),
      const SizedBox(width: 6),
      Text(
        '(${count.toString()})',
        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
      ),
    ],
  );
}