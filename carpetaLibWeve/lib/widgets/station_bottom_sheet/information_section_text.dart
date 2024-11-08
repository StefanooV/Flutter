import 'package:flutter/material.dart';

class InformationSectionText extends StatelessWidget {
  const InformationSectionText({
    super.key,
    required this.title,
    this.text,
  });

  final String title;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: text,
          ),
        ],
      ),
    );
  }
}
