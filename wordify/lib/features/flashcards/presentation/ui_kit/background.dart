import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';

///
class Background extends StatelessWidget {
  final Widget child;

  const Background({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkerVariant,
      child: child,
    );
  }
}