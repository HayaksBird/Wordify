import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';

class FolderListTemplateWidget extends StatelessWidget {
  final Widget child;


  const FolderListTemplateWidget({
    super.key,
    required this.child
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.navigationSecondary, width: 0.3),
        ),
        color: AppColors.primary
      ),
      child: child
    );
  }
}