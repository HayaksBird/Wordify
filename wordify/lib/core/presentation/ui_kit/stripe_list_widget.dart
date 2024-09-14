import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';


///Create a stripe list of the file path.
class StripeListWidget extends StatelessWidget {
  final String path, delimiter;


  const StripeListWidget({
    super.key,
    required this.path,
    required this.delimiter
  });


  @override
  Widget build(BuildContext context) {
    final List<String> pathItems = path.split(delimiter);

    return Row(
      children: List.generate(pathItems.length, (index) {
        return Transform.translate(
          offset: Offset(-index * 13.0, 0), // Adjust this value to control the overlap amount
          child: StripeContainer(
            item: pathItems[index],
            color: StripeColors.next(),
          ),
        );
      }),
    );
  }
}



///Create a Stripe with a text.
class StripeContainer extends StatelessWidget {
  final String item;
  final Color color;


  const StripeContainer({
    super.key,
    required this.item,
    required this.color
  });


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BannerPainter(color),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 2.0),
        child: Text(
          item,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}



///Create a Stripe
class BannerPainter extends CustomPainter {
  final Color color;


  BannerPainter(this.color);


  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.height / 1.5, size.height / 2);
    path.lineTo(0, size.height);
    path.lineTo(size.width - size.height / 1.5, size.height);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - size.height / 1.5, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}



///Give the color for the stripe. The colors a given in a loop.
class StripeColors {
  static int _currentIndex = 0;
  static const List<Color> _colors = [Color(0xFF552A64), Color(0xFF652966), Color(0xFF70487E)];

  
  static Color next() {
    final item = _colors[_currentIndex];
    _currentIndex = (_currentIndex + 1) % _colors.length;
    return item;
  }
}