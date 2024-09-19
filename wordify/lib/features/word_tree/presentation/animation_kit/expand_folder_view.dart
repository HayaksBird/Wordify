import 'package:flutter/material.dart';

class ExpandFolderView extends StatelessWidget {
  final double width;
  final Widget folderViewWidget;


  const ExpandFolderView({
    super.key,
    required this.width,
    required this.folderViewWidget
  });


  @override
  Widget build(BuildContext context) {
    return  AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      width: width,
      child: folderViewWidget,
    );
  }
}