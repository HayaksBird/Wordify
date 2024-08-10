import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';

///The main (root) frame for the word template screen (both create & update).
class TemplateFrame extends StatelessWidget {
  final Widget child;


  const TemplateFrame({
    super.key,
    required this.child
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkerVariant,
      padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 0), // Top and horizontal padding
      child: child
    );
  }
}