import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';

///Folder name tile show at a create word template.
class ChooseFolderTileWidget extends StatelessWidget {
  final String name;


  const ChooseFolderTileWidget({
    super.key,
    required this.name
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 9.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.text,
                ),
              ),
            ),
          ),
      
          const Divider(
            color: AppColors.navigationSecondary,
            height: 0,
            thickness: 0.2,
          )
        ],
      ),
    );
  }
}