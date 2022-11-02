import 'package:flutter/material.dart';

class ButtonsWidget extends StatelessWidget {
  final String image;
  final String title;

  ButtonsWidget(this.image, this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.shade100,
          ),
          child: Image.asset(
            image,
            scale: 15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
