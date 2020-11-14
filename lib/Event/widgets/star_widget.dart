import 'package:flutter/material.dart';

class StarWidget extends StatelessWidget {
  final double stars;
  StarWidget({@required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
            stars >= 1
                ? Icons.star
                : stars >= 0.5 ? Icons.star_half : Icons.star_border,
            color: Colors.purpleAccent[100]),
        Icon(
            stars >= 2
                ? Icons.star
                : stars >= 1.5 ? Icons.star_half : Icons.star_border,
            color: Colors.purpleAccent[100]),
        Icon(
            stars >= 3
                ? Icons.star
                : stars >= 2.5 ? Icons.star_half : Icons.star_border,
            color: Colors.purpleAccent[100]),
        Icon(
            stars >= 4
                ? Icons.star
                : stars >= 3.5 ? Icons.star_half : Icons.star_border,
            color: Colors.purpleAccent[100]),
        Icon(
            stars >= 5
                ? Icons.star
                : stars >= 4.5 ? Icons.star_half : Icons.star_border,
            color: Colors.purpleAccent[100]),
      ],
    );
  }
}
