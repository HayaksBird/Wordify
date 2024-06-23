import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: DoubleClickChooseBox(),
        ),
      ),
    );
  }
}

class DoubleClickChooseBox extends StatefulWidget {
  @override
  _DoubleClickChooseBoxState createState() => _DoubleClickChooseBoxState();
}

class _DoubleClickChooseBoxState extends State<DoubleClickChooseBox> {
  OverlayEntry? _overlayEntry;

  void _showChooseBox(BuildContext context, Offset position) {
    _overlayEntry = _createOverlayEntry(context, position);
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry(BuildContext context, Offset position) {
    List<String> texts = ['Option ssssss1', 'Option 2', 'Option 3'];

    return OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + 10, // Just to the right of the cursor
        top: position.dy, // Slightly below the cursor
        child: Material(
          elevation: 4.0,
          child: IntrinsicWidth(
            child: Container(
              //width: calculateMaxWidth(context, texts),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(texts[0]),
                    onTap: () {
                      _overlayEntry?.remove();
                      // Handle Option 1 tap
                    },
                  ),
                  ListTile(
                    title: Text(texts[1]),
                    onTap: () {
                      _overlayEntry?.remove();
                      // Handle Option 2 tap
                    },
                  ),
                  ListTile(
                    title: Text(texts[2]),
                    onTap: () {
                      _overlayEntry?.remove();
                      // Handle Option 3 tap
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  double calculateMaxWidth(BuildContext context, List<String> strings, {double padding = 16.0}) {
    double maxWidth = 0;

    for (String text in strings) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: Theme.of(context).textTheme.bodyMedium),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: double.infinity);

      if (textPainter.size.width > maxWidth) {
        maxWidth = textPainter.size.width;
      }
    }

    return maxWidth + padding; // Add padding/margin as needed
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) {
        _showChooseBox(context, details.globalPosition);
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.amber,
        child: Text('Double-tap me'),
      ),
    );
  }
}
