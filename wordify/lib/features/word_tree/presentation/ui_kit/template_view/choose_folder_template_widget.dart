import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/ui_kit/buttons.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';

///Template for a path choice.
class ChooseFolderTemplateWidget extends StatelessWidget {
  final Widget folders;
  final VoidCallback goBack;
  final String path;
  final String pathMessage;


  const ChooseFolderTemplateWidget({
    super.key,
    required this.folders,
    required this.goBack,
    required path,
    this.pathMessage = 'Saving to'
  }): path = '$pathMessage: $path';


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(  //Header
            color: AppColors.secondary1,
            child: Row(
              children: [
                NavigationBackButton(
                  text: 'Back',
                  goBack: goBack,
                ),
                const SizedBox(width: 4.0),
                _path(),
                const SizedBox(width: 15.0),
              ],
            ),
          ),
      
          const Divider(
            color: AppColors.navigationSecondary,
            height: 0,
            thickness: 0.2,
          ),
      
          Container(
            color: AppColors.primary,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 170.0,
              ),
              child: folders
            ),
          )
        ],
      ),
    );
  }


  ///
  Widget _path() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          path,
          style: const TextStyle(
            fontSize: 14.0,
            color: AppColors.navigation
          ),
        )
      ),
    );
  }
}